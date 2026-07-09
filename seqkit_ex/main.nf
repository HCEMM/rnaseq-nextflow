// Define where the output should go
params.outdir = "results"

// The Process Definition
process FASTQ_TO_FASTA {
    tag "SeqKit fq2fa"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path fastq_file

    output:
    path "*.fasta", emit: fasta

    script:
    """
    seqkit fq2fa ${fastq_file} -o ${fastq_file.simpleName}.fasta
    """
}

// The Main Workflow
workflow {
    // 1. Find a test fastq file in your current folder
    test_file_ch = Channel.fromPath("*.fastq*")
    
    // 2. Feed it into your process
    FASTQ_TO_FASTA(test_file_ch)
}
