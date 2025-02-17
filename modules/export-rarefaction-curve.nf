process EXPORT_RAREFACTION_CURVE {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/4-rarefy"

    input:
        path ccs_rarefaction_curve

    output:
        path "${ccs_rarefaction_curve.baseName}/"

    script:
        """          
        qiime tools export \
            --input-path ${ccs_rarefaction_curve} \
            --output-path ${ccs_rarefaction_curve.baseName}/
        """

}