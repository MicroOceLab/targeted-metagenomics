process CALCULATE_PHYLOGENETIC_ALPHA_DIV {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/16-calculate-phylogenetic-alpha-div"

    input:
        tuple val(sample_id), path(rarefied_table), path(rooted_tree)

    output:
        tuple val(sample_id), path("${sample_id}-faith-pd.qza")

    script:
        """
        qiime diversity alpha-phylogenetic \
            --i-table ${rarefied_table} \
            --i-phylogeny ${rooted_tree} \
            --p-metric faith_pd \
            --o-alpha-diversity ${sample_id}-faith-pd.qza
        """
}