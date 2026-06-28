process TRIMMOMATIC {
    tag "Trim $sample_id"
    __________ "${params.outdir}/trimmed", mode: '________'
    
    __________ "hcemm/bioinfo-workshop:trimming"

    input:
    tuple val(________), path(________)

    output:
    tuple val(sample_id), path("*_trimmed.fastq.gz"), emit: _________
    _________ "*_trimmomatic.log", emit: log

    script:
    """
    echo "Running Trimmomatic on sample ${_________} with reads: ${reads[0]} and ${reads[1]}"

    ____________ PE -threads ${task.cpus} \
        ${reads[___]} ${reads[____]} \
        ${sample_id}_1_trimmed.fastq.gz ${sample_id}_1_unpaired.fastq.gz \
        ${sample_id}_2_trimmed.fastq.gz ${sample_id}_2_unpaired.fastq.gz \
        ILLUMINACLIP:/usr/local/bin/adapters/TruSeq3-PE.fa:2:30:10 \
        LEADING:3 \
        TRAILING:3 \
        SLIDINGWINDOW:4:15 \
        MINLEN:36 > ${sample_id}_trimmomatic.log 2>&1
    """
}