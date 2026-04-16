#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// --- PARAMETERS ---
params.reads         = "$projectDir/data/SRR10395*_{R1,R2}.fastq.gz"
params.transcriptome = "$projectDir/data/transcriptome.fasta"
params.adapters      = "$projectDir/data/adapters.fa"       // Added: Required for trimming
params.metadata      = "$projectDir/data/samples.txt"       // Added: Required for R (limma)
params.tx2gene       = "$projectDir/data/tx2gene.csv"       // Added: Required for R (tximport)
params.outdir        = "$projectDir/results"

// --- MODULE IMPORTS ---
include { FASTQC }       from './processes/fastqc.nf'
include { TRIMMOMATIC }  from './processes/trimming.nf'
include { SALMON_INDEX } from './processes/salmon.nf'       // Added: Salmon Indexing step
include { SALMON_QUANT } from './processes/salmon.nf'
include { MULTIQC }      from './processes/multiqc.nf'      // Added: MultiQC!
include { R_ANALYSIS }   from './processes/r_analysis.nf'

// --- WORKFLOW ---
workflow {
    // 1. Create channels from input data
    read_pairs_ch    = Channel.fromFilePairs(params.reads, checkIfExists: true)
    transcriptome_ch = file(params.transcriptome, checkIfExists: true)
    adapters_ch      = file(params.adapters, checkIfExists: true)
    metadata_ch      = file(params.metadata, checkIfExists: true)
    tx2gene_ch       = file(params.tx2gene, checkIfExists: true)

    // 2. Quality Control & Trimming
    FASTQC(read_pairs_ch)
    TRIMMOMATIC(read_pairs_ch, adapters_ch)

    // 3. Transcriptome Indexing & Quantification
    SALMON_INDEX(transcriptome_ch)
    
    // Pass the trimmed reads and the generated index into Salmon Quant
    SALMON_QUANT(TRIMMOMATIC.out.trimmed_reads, SALMON_INDEX.out.index)
    
    // 4. Summarize all Quality Control logs
    // We mix the outputs from FastQC, Trimmomatic, and Salmon into one channel for MultiQC
    MULTIQC(
        FASTQC.out.zip.collect().mix(
            TRIMMOMATIC.out.log.collect(),
            SALMON_QUANT.out.json.collect()
        )
    )

    // 5. Differential Expression in R
    // Pass the quantified directories, plus the necessary biological metadata
    R_ANALYSIS(
        SALMON_QUANT.out.quant_dirs.collect(),
        metadata_ch,
        tx2gene_ch
    )
}