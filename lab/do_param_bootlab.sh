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
if ! test -f abconstraint.tre
then
    echo "Writing the constraint tree in abconstraint.tre file..."
    echo "#NEXUS
begin trees ;
    Tree ab = [&U](Anacystis_nidulans,Olithodiscus,(Euglena, Chlorella, Chlamydomonas, Marchantia, Rice, Tobacco));
end;
" > abconstraint.tre
fi

if ! test -f runrealdata.nex
then
    echo "Composing the runrealdata.nex command file..."
    echo "#NEXUS
Log start file=reallog.txt ; 
Execute algae.nex ; 
LoadConstr file=abconstraint.tre;
BAndB noenforce ; 
PScore;
BAndB enforce constraints=ab ; 
PScore ;
Set crit = like;
LSet nst=6 rmat=est basefreq=est rates = gamma shape = est pinv=est;
LScore / ScoreFile=modelparams.txt ;
SaveTrees file = model.tre brlens format=altnexus;
" > runrealdata.nex
fi

if ! test -f reallog.txt
then
    echo "Executing the runrealdata.nex command file in PAUP*..."
    paup -n runrealdata.nex
fi


if ! test -f model.txt
then
    echo "Grabbing the newick string for the tree out of the NEXUS file..."
    cat model.tre | grep PAUP_1 | awk '{print $5}' > model.txt
fi

if ! test -f defpaup.nex
then
    echo "Creating the defpaup.nex to be executed by every simulated data set ..."
    echo "
begin paup;
	execute run.nex;
end;
" > defpaup.nex
fi

if ! test -f parse-paup-grtig4seq-gen.py
then
    echo "Downloading parse-paup-grtig4seq-gen.py script"
    wget http://phylo.bio.ku.edu/slides/data/parse-paup-grtig4seq-gen.py || exit 1
fi

if ! test -f seqgen-command.sh
then
    echo "Composing a seqgen command for these data"
    python parse-paup-grtig4seq-gen.py reallog.txt -l920 -n1000 -on -xdefpaup.nex model.txt '>simdata.nex'> seqgen-command.sh || exit 1
fi

if ! test -f simdata.nex
then
    sh seqgen-command.sh || exit 1
fi


if ! test -f run.nex
then
    echo "Composing the run.nex file to be executed by each simulation replicate"
    echo "#NEXUS
BAndB;
[!****This is the best tree's score****]
PScore;
GetTrees file = model.tre;
[!####This is the true tree's score####]
PScore;" > run.nex

fi


if ! test -f master.nex
then
    echo "Composing the master.nex file to be launch the analyses of the simulated data"
    echo "#NEXUS
Log start replace file=sim.log;
Set noQueryBeep noerrorBeep  noWarnReset noWarnTree noWarnTSave;
Execute simdata.nex;
Log stop;
"> master.nex
fi

if ! test -f sim.log
then
    echo "Executing the master.nex command file in PAUP*..."
    paup -n master.nex
fi

if ! test -f summarizePaupLengthDiffs.py
then
    echo "Grab a python script to parse the output..."
    wget http://phylo.bio.ku.edu/slides/lab6-Simulation/summarizePaupLengthDiffs.py
fi

if ! test -f diffs.txt
then
    echo "Parse the output from running the simulations..."
    python summarizePaupLengthDiffs.py sim.log > diffs.txt
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
fi
