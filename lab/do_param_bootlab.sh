#!/bin/sh
if ! which paup > /dev/null
then
    echo "Adding bioware tools to path..."
    module load bioware || exit 1
fi
if ! test -f algae.nex
then
    echo "Downloading algae.nex..."
    wget http://phylo.bio.ku.edu/slides/data/algae.nex || exit 1
fi
if ! test -f step5.abconstraint.tre
then
    echo "Writing the constraint tree in step5a.abconstraint.tre file..."
    echo "#NEXUS
begin trees ;
    Tree ab = [&U](Anacystis_nidulans,Olithodiscus,(Euglena, Chlorella, Chlamydomonas, Marchantia, Rice, Tobacco));
end;
" > step5.abconstraint.tre
fi

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

if ! test -f steps7-11.realdatalog.nex
then
    echo "Executing the steps7-11.runrealdata.nex command file in PAUP*..."
    paup -n steps7-11.realdatacmds.nex
fi


if ! test -f step13.model.txt
then
    echo "Grabbing the newick string for the tree out of the NEXUS file..."
    cat step11.model.tre | grep PAUP_1 | awk '{print $5}' > step13.model.txt
fi

if ! test -f eachreppaup.nex
then
    echo "Creating the eachreppaup.nex to be executed by every simulated data set ..."
    echo "
begin paup;
	execute step18.run.nex;
end;
" > eachreppaup.nex
fi

if ! test -f parse-paup-grtig4seq-gen.py
then
    echo "Downloading parse-paup-grtig4seq-gen.py script"
    wget http://phylo.bio.ku.edu/slides/data/parse-paup-grtig4seq-gen.py || exit 1
fi

if ! test -f seqgen-command.sh
then
    echo "Composing a seqgen command for these data"
    python parse-paup-grtig4seq-gen.py steps7-11.realdatalog.txt -l920 -n1000 -on -xeachreppaup.nex step13.model.txt '>simdata.nex'> seqgen-command.sh || exit 1
fi

if ! test -f simdata.nex
then
    sh seqgen-command.sh || exit 1
fi


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

if ! test -f step19.sim.log
then
    echo "Executing the step19.master.nex command file in PAUP*..."
    paup -n step19.master.nex
fi


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
