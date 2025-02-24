process INFER_ASV {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/2-asv-infer"

    input:
        tuple val(sample_id), path(artifact)

    output:
        tuple val(sample_id), path("${sample_id}-table.qza"), emit: table
        tuple val(sample_id), path("${sample_id}-rep-seqs.qza"), emit: rep_seqs
        tuple val(sample_id), path("${sample_id}-stats.qza"), emit: stats

    script:
        """
        qiime dada2 denoise-ccs \
            --i-demultiplexed-seqs ${artifact} \
            --p-front ${params.front} \
            --p-adapter ${params.adapter} \
            --p-n-threads 4 \
            --p-min-len 1000 \
            --p-max-len 1600 \
            --o-table ${sample_id}-table.qza \
            --o-representative-sequences ${sample_id}-rep-seqs.qza \
            --o-denoising-stats ${sample_id}-stats.qza
        """

}