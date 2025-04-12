process INFER_ASV {
    cpus 4
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/infer-asv", mode: "copy"

    input:
        tuple val(id), path(artifact)

    output:
        tuple val(id), path("${id}-table.qza"), emit: table
        tuple val(id), path("${id}-rep-seqs.qza"), emit: rep_seqs
        tuple val(id), path("${id}-stats.qza"), emit: stats

    script:
        """
        qiime dada2 denoise-ccs \
            --i-demultiplexed-seqs ${artifact} \
            --p-front ${params.front} \
            --p-adapter ${params.adapter} \
            --p-n-threads 4 \
            --p-min-len 1000 \
            --p-max-len 1600 \
            --o-table ${id}-table.qza \
            --o-representative-sequences ${id}-rep-seqs.qza \
            --o-denoising-stats ${id}-stats.qza
        """

}