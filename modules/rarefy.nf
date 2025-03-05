process RAREFY {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/10-rarefy"

    input:
        tuple val(sample_id), path(table), val(plateau)
    
    output:
        tuple val(sample_id), path("${sample_id}-rarefied-table.qza")

    script:
        """
        qiime feature-table rarefy \
            --i-table ${table} \
            --p-sampling-depth ${plateau} \
            --o-rarefied-table ${sample_id}-rarefied-table.qza
        """
}