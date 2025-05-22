process TEST_ALPHA_CORRELATION {
    cpus 8
    memory "8 GB"
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/test-alpha-correlation", mode: "copy"

    input:
        tuple val(id), path(alpha_div), val(type), path(metadata)

    output:
        tuple val(id), path("${alpha_div.baseName}-correlation.qzv")

    script:
        """
        qiime diversity alpha-correlation \
            --i-alpha-diversity ${alpha_div} \
            --m-metadata-file ${metadata} \
            --o-visualization ${alpha_div.baseName}-correlation.qzv
        """
}