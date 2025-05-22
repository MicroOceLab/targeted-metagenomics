process VISUALIZE_PCOA {
    cpus 8
    memory "8 GB"
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/visualize-pcoa", mode: "copy"

    input:
        tuple path(matrix), path(metadata)

    output:
        tuple path("${matrix.baseName}-pcoa.qza"), path("${matrix.baseName}-emperor-plot.qzv")

    script:
        """
        qiime diversity pcoa \
            --i-distance-matrix ${matrix} \
            --p-number-of-dimensions 2 \
            --o-pcoa ${matrix.baseName}-pcoa.qza

        qiime emperor plot \
            --i-pcoa ${matrix.baseName}-pcoa.qza \
            --m-metadata-file ${metadata} \
            --o-visualization ${matrix.baseName}-emperor-plot.qzv
        """
}