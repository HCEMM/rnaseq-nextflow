FROM continuumio/miniconda3:latest

LABEL maintainer="sompaa" \
      description="Container for SeqKit fastq-to-fasta conversion"

RUN conda install -n base -c conda-forge -c bioconda seqkit=2.8.2 && \
    conda clean -afy

WORKDIR /data

ENTRYPOINT ["seqkit"]
