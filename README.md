nf-ninjaIndex - Create an ninjaIndex for [nf-ninjaMap](https://github.com/FischbachLab/nf-ninjamap)
====================

# Procedure for building an ninja index directory for ninjaMap

0. Copy all genomes into a folder, e.g., genomes/, then the following script to create the required index files

```{bash}
python scripts/create_ninjamap_db.py -list HCom2.seedfile.csv -db HCom2
```
## The seedfile format
### Note that the seedfile is a CSV (comma-separated values) file with its header
### The format of the seedfile is Strain_Name,FTP_link

```{bash}
Strain_Name,FTP_link
Acidaminococcus-fermentans-DSM-20731-MAF-2,/path/to/HCom2_20221117/genomes/Acidaminococcus-fermentans-DSM-20731-MAF-2.fna
Acidaminococcus-sp-D21-MAF-2,path/to/HCom2_20221117/genomes/Acidaminococcus-sp-D21-MAF-2.fna
........
```
After running the above script successfully, you should see two folders, fasta and db. The former contains all the reformated strains, and the latter contains all the db related files.

1. Build a binmap file in the db folder and rename it depending on your project, e.g., HCom2.ninjaIndex.binmap.csv
Please see the job submission examples in [building ninjaIndex](submission-examples.md)

2. Create a bowtie2 index (prefix: HCom2) directory using the concatenated genome file (HCom2.fna)
```{bash}
docker container run --rm \
    --workdir $(pwd) \
    --volume $(pwd):$(pwd) \
    quay.io/biocontainers/bowtie2:2.4.1--py38he513fc3_0 \
        bowtie2-build \
        --threads 8 \
        --seed 1712 \
        -f HCom2.fna HCom2 && mkdir -p bowtie2_index

mkdir -p bowtie2_index
mv *bt2 bowtie2_index
```

3. Copy the Binmap file and bowtie2 index files to the database folder

# Index directory structure

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
