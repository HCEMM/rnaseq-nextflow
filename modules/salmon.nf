process SALMON_QUANT {
    tag "Salmon on $sample_id"
    publishDir "${params.outdir}/salmon", mode: 'copy'
    
    container "${params.container_dir}/salmon.sif"

    input:
    tuple val(sample_id), path(trimmed_reads)
    path transcriptome

    output:
    path "${sample_id}_quant", emit: quant_dirs

    script:
    """
    salmon index -t ${transcriptome} -i transcripts_index

    salmon quant -i transcripts_index -l A \
        -1 ${trimmed_reads[0]} \
        -2 ${trimmed_reads[1]} \
        -p ${task.cpus} \
        --validateMappings \
        -o ${sample_id}_quant
    """
}