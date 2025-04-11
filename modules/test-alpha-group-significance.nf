process TEST_ALPHA_GROUP_SIGNIFICANCE {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/test-alpha-group-significance", mode: "copy"

    input:
        tuple val(sample_id), path(alpha_div), path(type), path(metadata)

    output:
        tuple val(sample_id), path("${sample_id}-${type}-group-significance.qzv")

    script:
        """
        qiime diversity alpha-group-significance \
            --i-alpha-diversity ${alpha_div} \
            --m-metadata-file ${metadata} \
            --o-visualization ${sample_id}-${type}-group-significance.qzv
        """
}