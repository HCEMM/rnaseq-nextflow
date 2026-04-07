#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// --- PARAMETERS ---
params.reads = "$projectDir/data/sample_chunk_*_{R1,R2}.fastq.gz"
params.transcriptome = "$projectDir/data/transcriptome.fasta"
params.outdir = "$projectDir/results"
params.container_dir = "$projectDir/containers"

// --- MODULE IMPORTS ---
// This is where you pull in the separate files
include { FASTQC }       from './processes/fastqc.nf'
include { TRIMMOMATIC }  from './processes/trimming.nf'
include { SALMON_QUANT } from './processes/salmon.nf'
include { R_ANALYSIS }    from './processes/r_analysis.nf'

// --- WORKFLOW ---
workflow {
    // 1. Create channels from input data
    read_pairs_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)
    transcriptome_ch = file(params.transcriptome)

    // 2. Run the processes
    FASTQC(read_pairs_ch)
    TRIMMOMATIC(read_pairs_ch)
    SALMON_QUANT(TRIMMOMATIC.out.trimmed_reads, transcriptome_ch)
    
    // 3. Collect all Salmon outputs and pass them to the R script
    R_ANALYSIS(SALMON_QUANT.out.quant_dirs.collect())
}