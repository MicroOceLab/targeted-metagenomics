process RAREFY {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/4-rarefy"

    input:
        tuple val(sample_id), path("${sample_id}-table.qza"), env("PLATEAU")
    
    output:
        tuple val(sample_id), path("${sample_id}-rarefied-table.qza")

    script:
        """
        qiime feature-table rarefy \
            --i-table \
            --p-sampling-depth $PLATEAU \
            --o-rarefied-table ${sample-id}-rarefied-table.qza
        """
}