process TRIMMOMATIC {
    tag "Trim $sample_id"
    publishDir "${params.outdir}/trimmed", mode: 'copy'
    
    container "${params.container_dir}/trimmomatic.sif"

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("*_trimmed.fastq.gz"), emit: trimmed_reads

    script:
    """
    trimmomatic PE -threads ${task.cpus} \
        ${reads[0]} ${reads[1]} \
        ${sample_id}_R1_trimmed.fastq.gz ${sample_id}_R1_unpaired.fastq.gz \
        ${sample_id}_R2_trimmed.fastq.gz ${sample_id}_R2_unpaired.fastq.gz \
        ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    """
}