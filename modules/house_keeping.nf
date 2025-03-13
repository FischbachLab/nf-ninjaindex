/*
 * Parse software version numbers
 */
process get_software_versions_index {

    container params.container_index
    errorStrategy 'ignore'
    //publishDir "${params.outdir}/pipeline_info", mode: 'copy',
    //saveAs: {filename ->
    //    if (filename.indexOf(".csv") > 0) filename
    //    else null
    //}

    output:
    file 'software_versions_index.yaml'
    //file "software_versions.csv"

    script:
    //  echo $workflow.manifest.version > v_pipeline.txt
    //echo $workflow.nextflow.version > v_nextflow.txt
    //scrape_software_versions.py &> software_versions_ninja.yaml
    """
    printf "nextflow_version: %s\n" ${workflow.nextflow.version} > software_versions_index.yaml
    printf "pipeline_version: %s\n" ${workflow.manifest.version} >> software_versions_index.yaml
    printf "python_version: %s\n" \$(python --version | awk '{print \$NF}') >> software_versions_index.yaml
    printf "biopython_version: %s\n" \$(python -c "import Bio; print(Bio.__version__)") >> software_versions_index.yaml
    """
}

process get_software_versions_art {

    container  params.container_art
    errorStrategy 'ignore'

    output:
    file 'software_versions_art.yaml'

    script:
    """
     printf "ART_version: %s\n" \$(/mnt/art_bin_MountRainier/art_illumina -h | grep "Q Version" | awk '{print \$3}') > software_versions_art.yaml
    """
}

process get_software_versions_bowtie2{

    container params.container_bowtie2
    errorStrategy 'ignore'

    output:
    file 'software_versions_bowtie2.yaml'

    script:
    """
     printf "bowtie2_version: %s\n" \$(bowtie2 --version | grep -a bowtie2-align-s | awk '{print \$NF}') > software_versions_bowtie2.yaml
    """
}



