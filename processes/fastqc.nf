process FASTQC {
    tag "FastQC on $sample_id"
    _________ "${params.outdir}/qc", mode: '______'
    
    container "hcemm/bioinfo-workshop:fastqc"

    input:
    tuple val(______), path(______)

    output:
    path "*_fastqc.{____,______}", emit: _______

    script:
    """
    fastqc -t ${_______} ${reads[___]} ${reads[____]}
    """
}
