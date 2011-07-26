1.  Downloaded fasta from entrez by searching for genera and "mitochondrion, complete genome" (without quotes).

2. Initial alignment revealed that the first ~570 bases of human are on the end
    of the other sequences. (wrapped around).  So the sequence:
    GATCACAGGTCTATCACCCTATTAACCACTCACGGGAGCTCTCCATGCATTTGGTATTTTCGTCTGGGGG
GTATGCACGCGATAGCATTGCGAGACGCTGGAGCCGGAGCACCCTATGTCGCAGTATCTGTCTTTGATTC
CTGCCTCATCCTATTATTTATCGCACCTACGTTCAATATTACAGGCGAACATACTTACTAAAGTGTGTTA
ATTAATTAATGCTTGTAGGACATAATAATAACAATTGAATGTCTGCACAGCCACTTTCCACACAGACATC
ATAACAAAAAATTTCCACCAAACCCCCCCTCCCCCGCTTCTGGCCACAGCACTTAAACACATCTCTGCCA
AACCCCAAAAACAAAGAACCCTAACACCAGCCTAACCAGATTTCAAATTTTATCTTTTGGCGGTATGCAC
TTTTAACAGTCACCCCCCAACTAACACATTATTTTCCCCTCCCACTCCCATACTACTAATCTCATCAATA
CAACCCCCGCCCATCCTACCCAGCACACACACACCGCTGCTAACCCCATACCCCGAACCAACCAAACCCC
AAAGACACCCCCCACA" 
    Was moved from the beginning of the Homo sapiens sequence to the end.

3. 
------------------------------------------------------------------------------
  MAFFT v6.815b (2010/07/21)
  http://mafft.cbrc.jp/alignment/software/
  NAR 30:3059-3066 (2002), Briefings in Bioinformatics 9:286-298 (2008)
------------------------------------------------------------------------------

mafft --auto primates.fasta > primates_mafft_auto.fasta
mafft --auto --ep 0.123 primates.fasta > primates_mafft_auto_ep.123.fasta

4. tried SuiteMSA comparator, but I think the sequences were too long for it (no
error but it did hang).

5.     Guidance: ran from http://guidance.tau.ac.il
    results: 
        http://guidance.tau.ac.il/results/13111837605667/output.php
    Running Parameters:
    
        Sequences File = primates.fasta
        MSA Algorithm: MAFFT
        Advanced Alignment Parameters: --reorder
        Number of bootstrap repeats: 100
        Method: GUIDANCE
    
    Running Messages:
    
        Generating the base alignment
        Constructing bootstrap guide-trees
        100 out of 100 alternative alignments were created
        Calculating GUIDANCE scores
        GUIDANCE calculation is finished:
        
    Results:
    
        MSA Colored according to the confidence score   (open with Jalview)
        GUIDANCE alignment score: 0.991237
        Output Files:
        
        MSA file
        GUIDANCE column scores
        GUIDANCE sequence scores
        GUIDANCE residue scores
        GUIDANCE residue pair scores
        Remove unreliable columns below confidence score   (see help)
        The MSA after the removal of unreliable columns (below 0.93) (see list of removed columns here)
        Remove unreliable sequences below confidence score   (see help)
        All sequences had score higher than 0.6


Saved "The MSA after the removal of unreliable columns" link as guidance_filtered.fasta 



6. $NCL_INSTALL_DIR/bin/NCLconverter guidance_filtered.fasta -enexus -fdnafasta -oguidance

    to create guidance.nex.  Removed .1 from each name and removed single-quotes 
    
7. added trees to guidance.nex 
