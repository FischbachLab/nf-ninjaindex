/**
	STEP 1.0
    Concatenate the reference genomes into a single fasta file.
*/

/*
*
    STEP 1.1
    Run biogrinder on individual genomes to obtain fastq files with
    predetermined uniform coverage (usually 10x)
		Copy fastq files to S3 bucket
*/

/*process grinder_fastq {

  tag "$fna"
	publishDir "${params.outdir}/biogrinder_fastqs", mode:'copy'

  input:
  file fna from genomes_ch2
  output:
  */
  //set file ("tmp_*/Sync/paired_fastq/${fna.baseName}.R1.fastq.gz"), file ("tmp_*/Sync/paired_fastq/${fna.baseName}.R2.fastq.gz") into zipped_fq
  //file "${fna.baseName}.fq" into fastq_ch
/*
  script:
  """
  run_grinder.sh $fna
  """
}
*/

/*
STEP 1.2
ART generaes synthetic reads instead of grinder
generate reads in fastq with zero-sequencing errors for a paired-end read simulation
The 2nd parameter is used to change the coverage
*/

process art_fastq {

  errorStrategy 'retry' 
  maxRetries 2

  tag "$fna"
  container params.container_art
  publishDir "${params.outdir}/art_fastqs", mode:'copy'

  input:
  path fna
  output:
  tuple path("tmp_*/Sync/paired_fastq/${fna.baseName}.R1.fastq.gz"), path("tmp_*/Sync/paired_fastq/${fna.baseName}.R2.fastq.gz")

  script:
  """
  run_art.sh $fna 10
  """
}


/*
*
   STEP 2
   Generate the bowtie2 index for each filtered genome
	 and align each fastq PE file to the corresponding filtered genomes
     file filtered_fa from sorted_filtered_genome_ch
*/

process bowtie2_mapping {

    errorStrategy 'retry' 
    maxRetries 2

    container params.container_bowtie2
    cpus 16
    tag "$fq1"
    
	publishDir "${params.outdir}/bowtie2_mapping", mode:'copy'
    input:
    path all_genome
	tuple path(fq1), path(fq2)

    output:
    path "tmp_*/Sync/bowtie2/*.name_sorted.markdup.bam", emit: bam_ch
    path "tmp_*/Sync/bowtie2/*.name_sorted.markdup.bam.bai", emit: bai_ch

    script:
    """
    run_bowtie2_origin.sh $all_genome $fq1 $fq2 &> bowtie2.log
    """
}



/*
STEP 3
  		Generate final Ninja Index based on the merged bam file
      NinjaIndex need bam index in the same direcroty even though the script
      doesn't require the index as an input parameter
      This step may need more memory to process
*/
process generate_Ninja_Index {

  container params.container_index
  cpus 32
  memory { 250.GB * task.attempt }
  time { 4.hour * task.attempt }

  errorStrategy { task.exitStatus in 137..140 ? 'retry' : 'terminate' }
  maxRetries 2

  tag "${params.db}"
	publishDir "${params.outdir}/ninjaIndex", mode:'copy'
  // no permision to write to 
  //publishDir "s3://maf-versioned/ninjamap/Index/${params.db}/db", mode:'copy'

  input:
  path 'fasta-dir/*'
  path 'bam-dir/*'
  path 'bam-dir/*'

  output:
  path "*.ninjaIndex.binmap.csv"
  //path "tmp_*/Sync/ninjaIndex/*.ninjaIndex.binmap.csv"
  //path "tmp_*/Sync/ninjaIndex/*.ninjaIndex.fasta"

  script:
  """
	ninjaIndex_multiBams.sh fasta-dir bam-dir "${params.db}"
  mv tmp_*/Sync/ninjaIndex/*.ninjaIndex.binmap.csv .
  """
}


/*
 * STEP 6 - Output Description HTML
 */
/*
if [ -e bamfiles.list ]
then
  touch uniform.merged.bam

fi
process output_documentation {
    publishDir "${params.outdir}/pipeline_info", mode: 'copy'

    input:
    file output_docs from ch_output_docs

    output:
    file "results_description.html"

    script:
    """
    markdown_to_html.r $output_docs results_description.html
    """
}
*/