process RAREFY {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/4-rarefy"

    input:
        tuple val(sample_id), path("${sample_id}-table.qza"), val(plateau)
    
    output:
        tuple val(sample_id), path("${sample_id}-rarefied-table.qza"), emit: separated
        path("${sample_id}-rarefied-table.qza"), emit: squashed

    script:
        """
        qiime feature-table rarefy \
            --i-table \
            --p-sampling-depth ${plateau} \
            --o-rarefied-table ${sample_id}-rarefied-table.qza
        """
}