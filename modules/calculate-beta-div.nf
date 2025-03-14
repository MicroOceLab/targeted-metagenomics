process CALCULATE_BETA_DIV {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/18-calculate-beta-div"

    input:
        tuple val(sample_id), path(merged_rarefied_table)

    output:
        tuple val(sample_id), path("${sample_id}-bray-curtis.qza"), path("${sample_id}-jaccard.qza"), 

    script:
        """
        qiime diversity beta \
            --i-table ${merged_rarefied_table} \
            --p-metric braycurtis \
            --o-alpha-diversity ${sample_id}-bray-curtis.qza
        
        qiime diversity beta \
            --i-table ${merged_rarefied_table} \
            --p-metric jaccard \
            --o-alpha-diversity ${sample_id}-jaccard.qza
        """
}