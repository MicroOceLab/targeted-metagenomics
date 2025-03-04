process MAKE_RAREFACTION_CURVE {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/06-make-rarefaction-curve"

    input:
        tuple val(sample_id), val(denoised_table)

    output:
        tuple val(sample_id), path("${sample_id}-rarefaction-curve.qzv")

    script:
        """          
        qiime diversity alpha-rarefaction \
            --i-table ${denoised_table} \
            --p-max-depth 10000 \
            --p-metrics 'shannon' \
            --o-visualization ${sample_id}-rarefaction-curve.qzv
        """

}