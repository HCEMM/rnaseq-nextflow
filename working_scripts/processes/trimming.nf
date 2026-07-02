process TRIMMOMATIC {
    tag "Trim $sample_id"
    publishDir "${params.outdir}/trimmed", mode: 'copy'

    container "hcemm/bioinfo-workshop:trimming"

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("*_trimmed.fastq.gz"), emit: trimmed_reads
    path "*_trimmomatic.log", emit: log

    script:
    """
    echo "Running Trimmomatic on sample ${sample_id} with reads: ${reads[0]} and ${reads[1]}"

    trimmomatic PE -threads ${task.cpus} \
        ${reads[0]} ${reads[1]} \
        ${sample_id}_1_trimmed.fastq.gz ${sample_id}_1_unpaired.fastq.gz \
        ${sample_id}_2_trimmed.fastq.gz ${sample_id}_2_unpaired.fastq.gz \
        ILLUMINACLIP:/usr/local/bin/adapters/TruSeq3-PE.fa:2:30:10 \
        LEADING:3 \
        TRAILING:3 \
        SLIDINGWINDOW:4:15 \
        MINLEN:36 > ${sample_id}_trimmomatic.log 2>&1
    """
}
