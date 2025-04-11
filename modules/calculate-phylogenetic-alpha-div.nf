process CALCULATE_PHYLOGENETIC_ALPHA_DIV {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/calculate-phylogenetic-alpha-div", mode: "copy"

    input:
        tuple val(sample_id), path(merged_rarefied_table), path(rooted_tree)

    output:
        tuple val(sample_id), path("${sample_id}-faith-pd.qza"), emit: faith_pd

    script:
        """
        qiime diversity alpha-phylogenetic \
            --i-table ${merged_rarefied_table} \
            --i-phylogeny ${rooted_tree} \
            --p-metric faith_pd \
            --o-alpha-diversity ${sample_id}-faith-pd.qza
        """
}