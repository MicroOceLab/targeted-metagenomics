process EXPORT_VISUALIZATION {
    cpus 1
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/export-visualization", mode: "copy"

    input:
        tuple val(id), path(visualization)

    output:
        tuple val(id), path("${visualization.baseName}/")

    script:
        """          
        qiime tools export \
            --input-path ${visualization} \
            --output-path ${visualization.baseName}/
        """

}