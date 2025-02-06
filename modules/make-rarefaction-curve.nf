process MAKE_RAREFACTION_CURVE {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/4-rarefy"

    input:
        path ccs_denoised_table

    output:
        path "${ccs_denoised_table.baseName[0..-7]}-rarefaction-curve.qzv"

    script:
        """          
        qiime diversity alpha-rarefaction \
            --i-table ${ccs_denoised_table} \
            --p-max-depth 10000 \
            --p-metrics 'shannon' \
            --o-visualization ${ccs_denoised_table.baseName[0..-7]}-rarefaction-curve.qzv
        """

}