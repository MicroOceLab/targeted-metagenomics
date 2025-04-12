process INFER_ASV {
    cpus 4
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/infer-asv", mode: "copy"

    input:
        tuple val(id), path(artifact)

    output:
        tuple val(id), path("${id}-trimmed-reads.qza"), emit: trimmed_reads
        tuple val(id), path("${id}-trimmed-reads.qzv"), emit: trimmed_reads_summary
        tuple val(id), path("${id}-table.qza"), emit: table
        tuple val(id), path("${id}-rep-seqs.qza"), emit: rep_seqs
        tuple val(id), path("${id}-stats.qza"), emit: stats

    script:
        """
        qiime cutadapt trim-paired \
            --i-demultiplexed-sequences ${artifact} \
            --p-front-f ${params.f_primer}  \
            --p-front-r ${params.r_primer} \
            --p-error-rate 0 \
            --p-discard-untrimmed \
            --o-trimmed-sequences ${id}-trimmed-reads.qza
        
        qiime demux summarize \
            --i-data ${id}-trimmed-reads.qza \
            --p-n 100000 \
            --o-visualization ${id}-trimmed-reads.qzv

        qiime dada2 denoise-paired \
            --i-demultiplexed-seqs ${id}-trimmed-reads.qza \
            --p-trunc-len-f ${params.f_trunc_len} \
            --p-trunc-len-r ${params.r_trunc_len} \
            --o-table ${id}-table.qza \
            --o-representative-sequences ${id}-rep-seqs.qza \
            --o-denoising-stats ${id}-stats.qza \
            --p-n-threads 4
        """

}