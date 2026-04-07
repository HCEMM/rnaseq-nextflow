process R_ANALYSIS {
    tag "R Analysis"
    publishDir "${params.outdir}/R_plots", mode: 'copy'
    
    container "${params.container_dir}/custom_r.sif"

    input:
    path quant_dirs

    output:
    path "expression_summary.pdf"

    script:
    """
    #!/usr/bin/env Rscript
    library(ggplot2)
    
    pdf("expression_summary.pdf")
    plot(1:10, main="Modular Workshop Pipeline Complete!")
    dev.off()
    """
}