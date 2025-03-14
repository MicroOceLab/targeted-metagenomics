process MAKE_BAR_PLOT {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/07-make-bar-plot"

    input:
        tuple val(sample_id), path(rarefied_table), path(taxa)

    output:
        tuple val(sample_id), path("${sample_id}-taxa-bar-plot.qza")

    script:
        """  
        qiime taxa barplot \
            --i-table ${rarefied_table} \
            --i-taxonomy ${taxa} \
            --o-visualization ${sample_id}-taxa-bar-plot.qza
        """

}