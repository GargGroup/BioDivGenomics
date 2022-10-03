#!/bin/bash

echo Estimation of genome characteristics starting...
./FASTK/FastK -v -t -p ./hifi_input.fastq -NTable
./FASTK/Logex -T4 '.trim=A[4-]' Table
./MERQURY.FK/PloidyPlot Table
./FASTK/Histex -G Table | ./GENESCOPE.FK/GeneScopeFK -o ./ -k 40

echo Genome assembly starting...
mkdir hifiasm
./hifiasm -o hifiasm/asm -t10 -z40 *.fastq > hifiasm/asm.log 2>&1;

mkdir pstools
## check if pstools in pstools_out directory and run these commands in pstools folder
awk '/^S/{print ">"$2;print $3}' hifiasm/asm.r_utg.gfa > hifiasm/asm.r_utg.fa
./pstools hic_mapping_unitig -t10 -o map.out hifiasm/asm.r_utg.fa <(zcat *R1*.fastq.gz) <(zcat *R2*.fastq.gz);
./pstools resolve_haplotypes -t10 map.out hifiasm/asm.r_utg.gfa ./;
./pstools hic_mapping_haplo -t10 pred_haplotypes.fa <(zcat *R1*.fastq.gz) <(zcat *R2*.fastq.gz) -o scaff_connections.txt;
./pstools haplotype_scaffold -t10 scaff_connections.txt pred_haplotypes.fa ./
cp pred_hap1.fa hap1.fa;
cat pred_hap2.fa pred_broken_nodes.fa > hap2.fa;

echo Using ONT Q20+ based assembly starting...
mkdir shasta
shasta-Linux-0.8.0 --input ./hifi_input.fastq --config Nanopore-Oct2021 --assemblyDirectory shasta --threads 10

mkdir pstools_ont
## check if pstools in pstools_out directory and run these commands in pstools folder
./pstools hic_mapping_unitig -t10 -o map.out shasta/Assembly.fasta <(zcat *R1*.fastq.gz) <(zcat *R2*.fastq.gz);
./pstools resolve_haplotypes -t10 map.out shasta/Assembly.gfa ./;
./pstools hic_mapping_haplo -t10 pred_haplotypes.fa <(zcat *R1*.fastq.gz) <(zcat *R2*.fastq.gz) -o scaff_connections.txt;
./pstools haplotype_scaffold -t10 scaff_connections.txt pred_haplotypes.fa ./
cp pred_hap1.fa hap1.fa;
cat pred_hap2.fa pred_broken_nodes.fa > hap2.fa;


echo mitochondrial assembly starting...

mkdir mitohifi
singularity exec --bind /path/on/disk/to/data/:/mitohifi/ /path/to/mitohifi-v2.2.sif  findMitoReference.py --species "human" --email shilpa.garg2k7@gmail.com --outfolder /mitohifi/ --min_length 16000 
singularity exec --bind /path/on/disk/to/data/:/mitohifi/ /path/to/mitohifi-v2.2.sif  mitohifi.py -r "/mitohifi/f1.fasta /mitohifi/f2.fasta /mitohifi/f3.fasta" -f /mitohifi/reference.fasta -g /mitohifi/reference.gb  -t 10 -o 2 

echo blobtoolkit running...

~/blobtoolkit/blobtools2/blobtools filter \
    --param length--Min=1000 \
    --fasta ~/BTK_TUTORIAL/FILES/ASSEMBLY_NAME.fasta \
    ~/BTK_TUTORIAL/DATASETS/ASSEMBLY_NAME
