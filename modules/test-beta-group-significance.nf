process TEST_BETA_GROUP_SIGNIFICANCE {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/test-beta-group-significance", mode: "copy"

    input:
        tuple val(id), path(alpha_div), path(type), path(column), path(metadata)

    output:
        tuple val(id), path("${id}-${type}-group-significance.qzv")

    script:
        """
        qiime diversity alpha-group-significance \
            --i-alpha-diversity ${alpha_div} \
            --m-metadata-file ${metadata} \
            --m-metadata-column ${column}
            --o-visualization ${id}-${type}-group-significance.qzv
        """
}