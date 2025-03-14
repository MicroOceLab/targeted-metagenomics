process CALCULATE_ALPHA_DIV {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/15-calculate-alpha-div"

    input:
        tuple val(sample_id), path(rarefied_table)

    output:
        tuple val(sample_id), path("${sample_id}-shannon.qza"), path("${sample_id}-simpson.qza"), 

    script:
        """
        qiime diversity alpha \
            --i-table ${rarefied_table} \
            --p-metric shannon \
            --o-alpha-diversity ${sample_id}-shannon.qza
        
        qiime diversity alpha \
            --i-table ${rarefied_table} \
            --p-metric simpson \
            --o-alpha-diversity ${sample_id}-simpson.qza
        """
}