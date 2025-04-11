process INFER_ASV {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/infer-asv", mode: "copy"

    input:
        tuple val(sample_id), path(artifact)

    output:
        tuple val(sample_id), path("${sample_id}-trimmed-reads.qza"), emit: trimmed_reads
        tuple val(sample_id), path("${sample_id}-trimmed-reads.qzv"), emit: trimmed_reads_summary
        tuple val(sample_id), path("${sample_id}-table.qza"), emit: table
        tuple val(sample_id), path("${sample_id}-rep-seqs.qza"), emit: rep_seqs
        tuple val(sample_id), path("${sample_id}-stats.qza"), emit: stats
        path("${sample_id}-table.qza"), emit: squashed_table
        path("${sample_id}-rep-seqs.qza"), emit: squashed_rep_seqs

    script:
        """
        qiime cutadapt trim-paired \
            --i-demultiplexed-sequences ${artifact} \
            --p-front-f ${params.f_primer}  \
            --p-front-r ${params.r_primer} \
            --p-error-rate 0 \
            --p-discard-untrimmed \
            --o-trimmed-sequences ${sample_id}-trimmed-reads.qza
        
        qiime demux summarize \
            --i-data ${sample_id}-trimmed-reads.qza \
            --p-n 100000 \
            --o-visualization ${sample_id}-trimmed-reads.qzv

        qiime dada2 denoise-paired \
            --i-demultiplexed-seqs ${sample_id}-trimmed-reads.qza \
            --p-trunc-len-f ${params.f_trunc_len} \
            --p-trunc-len-r ${params.r_trunc_len} \
            --o-table ${sample_id}-table.qza \
            --o-representative-sequences ${sample_id}-rep-seqs.qza \
            --o-denoising-stats ${sample_id}-stats.qza \
            --p-n-threads 4
        """

}