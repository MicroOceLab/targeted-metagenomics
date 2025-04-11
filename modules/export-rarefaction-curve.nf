process EXPORT_RAREFACTION_CURVE {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/export-rarefaction-curve"

    input:
        path(rarefaction_curve)

    output:
        path("${rarefaction_curve.baseName}/")

    script:
        """          
        qiime tools export \
            --input-path ${rarefaction_curve} \
            --output-path ${rarefaction_curve.baseName}/
        """

}