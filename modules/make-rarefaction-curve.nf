process MAKE_RAREFACTION_CURVE {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/08-make-rarefaction-curve"

    input:
        tuple val(sample_id), path(merged_table)

    output:
        path("rarefaction-curve.qzv")

    script:
        """          
        qiime diversity alpha-rarefaction \
            --i-table ${merged_table} \
            --p-max-depth 10000 \
            --p-metrics 'shannon' \
            --p-steps 41 \
            --o-visualization rarefaction-curve.qzv
        """

}