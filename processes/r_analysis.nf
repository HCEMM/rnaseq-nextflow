process R_ANALYSIS {
    tag "R Analysis"
    _________ "${params.outdir}/R_plots", mode: '______'
    
    container "hcemm/bioinfo-workshop:limma"

    input:
    _____ quant_dirs
    path ________
    path ________

    output:
    ______ "expression_summary.pdf"
    ______ "final_results.csv"

    script:
    """
    ________ ${projectDir}/scripts/limma_analysis.R --quant_dirs ${quant_dirs.join(',')} --tx2gene ${tx2gene} --metadata ${metadata}
    """
}