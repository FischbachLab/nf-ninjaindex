# Please see the submission examples in
```{bash}
submission-examples.md
```

# Procedure for building an ninja index directory for ninjaMap

0. Copy all genomes into a folder, e.g., fasta/

1. Build a binmap file in the db folder and rename it depending on your project, e.g., HCom2.ninjaIndex.binmap.csv

2. Create a bowtie2 index directory  

3. Index directory structure

 Database folder: HCom2_20221117
 Database prefix: HCom2
 Binmap file: HCom2.ninjaIndex.binmap.csv

```{bash}
HCom2_20221117/
├── db
│   ├── HCom2.db_metadata.tsv (not required)
│   ├── HCom2.fna (concatenated genome file)
│   ├── HCom2.ninjaIndex.binmap.csv (ninja index)
│   ├── HCom2.nm_mates_bin.tsv  (not required)
│   ├── HCom2.per_genome_metadata.tsv  (not required)
│   └── bowtie2_index  ( bowtie2 index of the concatenated genome file)
│       ├── HCom2.1.bt2
│       ├── HCom2.2.bt2
│       ├── HCom2.3.bt2
│       ├── HCom2.4.bt2
│       ├── HCom2.rev.1.bt2
│       └── HCom2.rev.2.bt2
└── fasta
    ├── Acidaminococcus-fermentans-DSM-20731-MAF-2.fna
    ├── Acidaminococcus-sp-D21-MAF-2.fna
    ├── Adlercreutzia-equolifaciens-DSM-19450.fna
    ├── Akkermansia-muciniphila-ATCC-BAA-835-MAF-2.fna
        ...............................................
```

# An example of ninjaMap Index (hCom2) is available at
```{bash}
https://zenodo.org/record/7872423/files/hCom2_20221117.ninjaIndex.tar.gz
```

## Nextflow Introduction
The pipeline is built using [Nextflow](https://www.nextflow.io), a workflow tool to run tasks across multiple compute infrastructures in a very portable manner. It comes with docker containers making installation trivial and results highly reproducible.
