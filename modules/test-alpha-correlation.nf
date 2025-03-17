process TEST_ALPHA_CORRELATION {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/20-test-alpha-correlation", mode: "copy"

    input:
        tuple val(sample_id), path(alpha_div), path(metadata), path(type)

    output:
        tuple val(sample_id), path("${sample_id}-${type}-correlation.qzv")

    script:
        """
        qiime diversity alpha-correlation \
            --i-alpha-diversity ${alpha_div} \
            --m-metadata-file ${metadata} \
            --o-visualization ${sample_id}-${type}-correlation.qzv
        """
}