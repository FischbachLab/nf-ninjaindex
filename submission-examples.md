# Run a updated ninjaIndex pipeline on a local machine

```{bash}
nextflow run -resume main.nf --genomes 's3://czbiohub-microbiome/test/3genomes/*.fna' \
--outdir 's3://czbiohub-microbiome/test10' \
-profile czbiohub_aws
```

# Run a test case on a local machine
```{bash}
nextflow run main.nf -profile test
```

# Run an aws batch job
```{bash}
aws batch submit-job \
    --job-name nf-ninjaIndex \
    --job-queue priority-maf-pipelines \
    --job-definition nextflow-production \
    --container-overrides command="FischbachLab/nf-ninjaindex,\
"--genomes", "s3://3genomes/*.fna", \
"--outdir","s3://genomics-workflow-core/Results/NinjaIndex/test-3genomes",\
"--db","test3" "
```

## Example path to the final ninjaIndex file on s3
```{bash}
s3://genomics-workflow-core/Results/NinjaIndex/test-3genomes/ninjaIndex/tmp_20230505_184742/Sync/ninjaIndex/test3.ninjaIndex.binmap.csv
```
