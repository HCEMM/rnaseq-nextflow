process ANNOTATION {
    tag "Annotation"
    publishDir "${params.outdir}/annotation", mode: 'copy'

    container "hcemm/bioinfo-workshop:diamond"

    input:
    path genome_fasta
    path genome_gff

    output:
    path "genome_annotation.tab"

    script:
    """
    diamond makedb --in ${genome_fasta} -d genome_annotation
    diamond blastx -d genome_annotation -q ${genome_fasta} -o genome_annotation.tab --outfmt 6
    """
}