process SEQKIT_FQ2FA {
    tag "SeqKit fq2fa on $sample_id"
    publishDir "${params.outdir}/seqkit", mode: 'copy'

    input:
    tuple val(sample_id), path(trimmed_reads)

    output:
    tuple val(sample_id), path("${sample_id}_*.fasta"), emit: fasta_reads

    script:
    """
    seqkit fq2fa ${trimmed_reads[0]} -o ${sample_id}_1.fasta
    seqkit fq2fa ${trimmed_reads[1]} -o ${sample_id}_2.fasta
    """
}
