process MAKE_BAR_PLOT {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/make-bar-plot", mode: "copy"

    input:
        tuple val(id), path(table), path(taxa)

    output:
        tuple val(id), path("${id}-taxa-bar-plot.qzv")

    script:
        """  
        qiime taxa barplot \
            --i-table ${table} \
            --i-taxonomy ${taxa} \
            --o-visualization ${id}-taxa-bar-plot.qzv
        """

}