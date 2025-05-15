process TEST_ALPHA_GROUP_SIGNIFICANCE {
    cpus 8
    memory "8 GB"
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/test-alpha-group-significance", mode: "copy"

    input:
        tuple val(id), path(alpha_div), val(type), path(metadata)

    output:
        tuple val(id), path("${id}-${type}-group-significance.qzv")

    script:
        """
        qiime diversity alpha-group-significance \
            --i-alpha-diversity ${alpha_div} \
            --m-metadata-file ${metadata} \
            --o-visualization ${id}-${type}-group-significance.qzv
        """
}