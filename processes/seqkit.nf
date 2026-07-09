process SEQKIT_FQ2FA {
    tag "SeqKit fq2fa on $sample_id"
    publishDir "${params.outdir}/fasta", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("*.fasta"), emit: fasta

    script:
    """
    seqkit fq2fa ${reads[0]} -o ${sample_id}_1.fasta
    seqkit fq2fa ${reads[1]} -o ${sample_id}_2.fasta
    """
}
