FROM continuumio/miniconda3:latest

# Pin the exact version of SeqKit you used earlier
RUN conda install -c bioconda seqkit=2.13.0 -y && \
    conda clean -a

WORKDIR /data
