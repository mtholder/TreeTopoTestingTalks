#!/bin/sh
set -x
if ! which paup > /dev/null
then
    echo "Adding bioware tools to path"
    module load bioware || exit 1
fi
if ! test -f algae.nex
then
    wget http://phylo.bio.ku.edu/slides/data/algae.nex || exit 1
fi
if ! test -f abconstraint.tre
then
    echo "#NEXUS
begin trees ;
    Tree ab = [&U](Anacystis_nidulans,Olithodiscus,(Euglena, Chlorella, Chlamydomonas, Marchantia, Rice, Tobacco));
end;
" > abconstraint.tre
fi

if ! test -f runrealdata.nex
then
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
    paup -n runrealdata.nex
    cat model.tre | grep PAUP_1 | awk '{print $5}' > model.txt
fi
