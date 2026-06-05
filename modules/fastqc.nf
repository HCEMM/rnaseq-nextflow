<<<<<<< HEAD:processes/fastqc.nf
<<<<<<< Updated upstream
process FASTQC {
    tag "FastQC on $sample_id"
    publishDir "${params.outdir}/qc", mode: 'copy'
    
    container "hcemm/bioinfo-workshop:fastqc"

    input:
    tuple val(sample_id), path(reads)

    output:
    path "*_fastqc.{zip,html}", emit: qc_results

    script:
    """
    fastqc -t ${task.cpus} ${reads[0]} ${reads[1]}
    """
=======
=======
>>>>>>> 9ad4557e807fb51ea178e537e2429a72be1ed16e:modules/fastqc.nf
process FASTQC {
    tag "FastQC on $sample_id"
    publishDir "${params.outdir}/qc", mode: 'copy'

    container "hcemm/bioinfo-workshop:fastqc"

    input:
    tuple val(sample_id), path(reads)

    output:
    path "*_fastqc.{zip,html}", emit: qc_results

    script:
    """
    fastqc -t ${task.cpus} ${reads[0]} ${reads[1]}
    """
<<<<<<< HEAD:processes/fastqc.nf
>>>>>>> Stashed changes
}
=======
}
>>>>>>> 9ad4557e807fb51ea178e537e2429a72be1ed16e:modules/fastqc.nf
