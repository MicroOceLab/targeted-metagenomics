process INFER_ASV {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/2-asv-infer"

    input:
        tuple val(sample_id), path(artifact)

    output:
        path "${artifact.baseName}-table.qza", emit: table
        path "${artifact.baseName}-rep-seqs.qza", emit: rep_seqs
        path "${artifact.baseName}-stats.qza", emit: stats

    script:
        """
        qiime dada2 denoise-ccs \
            --i-demultiplexed-seqs ${artifact} \
            --p-front ${params.front} \
            --p-adapter ${params.adapter} \
            --p-n-threads 4 \
            --p-min-len 1000 \
            --p-max-len 1600 \
            --o-table ${artifact.baseName}-table.qza \
            --o-representative-sequences ${artifact.baseName}-rep-seqs.qza \
            --o-denoising-stats ${artifact.baseName}-stats.qza
        """

}