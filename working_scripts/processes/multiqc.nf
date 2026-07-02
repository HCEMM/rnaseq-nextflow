process MULTIQC {
    tag "MultiQC"
    publishDir "${params.outdir}/multiqc", mode: 'copy'

    container "hcemm/bioinfo-workshop:fastqc"

    input:
    path qc_results

    output:
    path "multiqc_report.html", emit: multiqc_report

    script:
    """
    multiqc ${qc_results} -o . -n multiqc_report.html

    #also possible to use only "multiqc . -o . -n multiqc_report.html"
    """
}
