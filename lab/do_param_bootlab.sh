#!/bin/bash
################################################################################
# Set up the environment to know where paup, seg-gen, etc are.  (MBL computers only
##########
if ! which paup > /dev/null
then
    echo "Adding bioware tools to path..."
    module load bioware || exit 1
fi

################################################################################
# Get the dataset
##########
if ! test -f algae.nex
then
    echo "Downloading algae.nex..."
    wget http://phylo.bio.ku.edu/slides/data/algae.nex || exit 1
    if ! test -f algae.nex ; then echo "Failed to download the data set!" ; exit 1 ; fi
fi


################################################################################
# Write the constraint tree to a file
##########
if ! test -f step5.abconstraint.tre
then
    echo "Writing the constraint tree in step5a.abconstraint.tre file..."
    echo "#NEXUS
begin trees ;
    Tree ab = [&U](Anacystis_nidulans,Olithodiscus,(Euglena, Chlorella, Chlamydomonas, Marchantia, Rice, Tobacco));
end;
" > step5.abconstraint.tre
fi

################################################################################
# Compose a paup block that will find the best tree compatible with the null
#   hypothesis (in other words, compatible with the constraint tree) and save
#   this null tree to step11.model.tre
##########
if ! test -f step7-11.realdatacmds.nex
then
    echo "Composing the step7-11.realdatacmds.nex command file..."
    echo "#NEXUS
Log start file = 'steps7-11.realdatalog.txt' ; 
Execute algae.nex ; 
LoadConstr file=step5.abconstraint.tre;
BAndB noenforce ; 
PScore;
BAndB enforce constraints=ab ; 
PScore ;
Set crit = like;
LSet nst=6 rmat=est basefreq=est rates = gamma shape = est pinv=est;
LScore / ScoreFile=modelparams.txt ;
SaveTrees file = step11.model.tre brlens format=altnexus;
" > steps7-11.realdatacmds.nex
fi

################################################################################
# Run the command file through paup
##########
if ! test -f step11.model.tre
then
    echo "Executing the steps7-11.runrealdata.nex command file in PAUP*..."
    paup -n steps7-11.realdatacmds.nex
    if ! test -f step11.model.tre ; then echo "PAUP failed to produce the step11.model.tre tree file with the model tree!" ; exit 1 ; fi
fi


################################################################################
# grap just the newick string out of the step11.model.tre and put it into step13.model.txt
##########
if ! test -f step13.model.txt
then
    echo "Grabbing the newick string for the tree out of the NEXUS file..."
    cat step11.model.tre | grep PAUP_1 | awk '{print $5}' > step13.model.txt
fi

################################################################################
# Create a file with a few NEXUS commands that will be pasted (by seq-gen) in
#   between each simulated data set.
##########
if ! test -f eachreppaup.nex
then
    echo "Creating the eachreppaup.nex to be executed by every simulated data set ..."
    echo "
begin paup;
	execute step18.run.nex;
end;
" > eachreppaup.nex
fi

################################################################################
# Grab a script for parsing the GTR+I+G model parameters from PAUP output
#   and reformatting them in a form that seq-gen can understand.
##########
if ! test -f parse-paup-grtig4seq-gen.py
then
    echo "Downloading parse-paup-grtig4seq-gen.py script"
    wget http://phylo.bio.ku.edu/slides/data/parse-paup-grtig4seq-gen.py || exit 1
fi

################################################################################
# Use the script to compose a command that will run seq-gen
#   Every command line argument to the script after "steps7-11.realdatalog.txt"
#   below arguments that will be simply pasted on the end of the seq-gen
#   invocation.
##########
if ! test -f step16.seqgen-command.sh
then
    echo "Composing a seqgen command for these data"
    python parse-paup-grtig4seq-gen.py steps7-11.realdatalog.txt -l920 -n1000 -on -xeachreppaup.nex step13.model.txt '>simdata.nex'> step16.seqgen-command.sh || exit 1
fi

################################################################################
# Generate the simulated data sets by using the step16.seqgen-command.sh
#   command to launch seq-gen
##########
if ! test -f simdata.nex
then
    sh step16.seqgen-command.sh || exit 1
fi


################################################################################
# Create a file (step18.run.nex) with the PAUP commands that you would like to
#   run on each dataset. 
# In this case we just want do a branch-and-bound search on each dataset and
#   compare the score of the optimal tree to the true tree.
##########
if ! test -f step18.run.nex
then
    echo "Composing the step18.run.nex file to be executed by each simulation replicate"
    echo "#NEXUS
BAndB;
[!****This is the best tree's score****]
PScore;
GetTrees file = step11.model.tre;
[!####This is the true tree's score####]
PScore;" > step18.run.nex

fi


################################################################################
# Write a simple PAUP control file that turns of warnings and beeps, makes sure
#   that there is a LOG file open, and then executes the file containing the
#   simulated data.
##########
if ! test -f step19.master.nex
then
    echo "Composing the step19.master.nex file to be launch the analyses of the simulated data"
    echo "#NEXUS
Log start replace file=step19.sim.log;
Set noQueryBeep noerrorBeep  noWarnReset noWarnTree noWarnTSave;
Execute simdata.nex;
Log stop;
"> step19.master.nex
fi

################################################################################
# Tell PAUP to run this master control file. Because the dataset fit the NULL 
#   hypothesis. This PAUP analysis will be analyzing 1000 data sets and the 
#   difference in scores between the optimal and true tree will approximate
#   the NULL distribution of the length-difference test statistic.
##########
if ! test -f step19.sim.log
then
    echo "Executing the step19.master.nex command file in PAUP*..."
    paup -n step19.master.nex
fi


################################################################################
# We can use a simple python script to summarize the null distribution by reading
#    PAUP's log file...
##########
if ! test -f summarizePaupLengthDiffs.py
then
    echo "Grab a python script to parse the output..."
    wget http://phylo.bio.ku.edu/slides/lab6-Simulation/summarizePaupLengthDiffs.py
fi

if ! test -f step20.diffs.txt
then
    echo "Parse the output from running the simulations..."
    python summarizePaupLengthDiffs.py step19.sim.log > step20.diffs.txt
fi


################################################################################
# We can use R to plot the null distribution
##########
if ! test -f plot_diffs.R
then
    echo "Grab an R script to create a histogram of the ..."
    wget http://phylo.bio.ku.edu/slides/lab6-Simulation/plot_diffs.R
fi

if ! test -f null_distribution_pscore_diffs.pdf
then
    echo "Use R to create a histogram..."
    R --file=plot_diffs.R --args 4
    echo "The file null_distribution_pscore_diffs.pdf should contain a histogram of the null distribution"
fi

