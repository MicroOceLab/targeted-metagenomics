process CALCULATE_BETA_DIV {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/calculate-beta-div", mode: "copy"

    input:
        tuple val(id), path(merged_rarefied_table)

    output:
        tuple val(id), path("${id}-bray-curtis.qza"), emit: bray_curtis
        tuple val(id), path("${id}-jaccard.qza"), emit: jaccard

    script:
        """
        qiime diversity beta \
            --i-table ${merged_rarefied_table} \
            --p-metric braycurtis \
            --o-distance-matrix ${id}-bray-curtis.qza
        
        qiime diversity beta \
            --i-table ${merged_rarefied_table} \
            --p-metric jaccard \
            --o-distance-matrix ${id}-jaccard.qza
        """
}