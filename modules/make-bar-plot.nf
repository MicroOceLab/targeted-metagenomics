process MAKE_BAR_PLOT {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/make-bar-plot", mode: "copy"

    input:
        tuple val(sample_id), path(table), path(taxa)

    output:
        tuple val(sample_id), path("${sample_id}-taxa-bar-plot.qzv")

    script:
        """  
        qiime taxa barplot \
            --i-table ${table} \
            --i-taxonomy ${taxa} \
            --o-visualization ${sample_id}-taxa-bar-plot.qzv
        """

}