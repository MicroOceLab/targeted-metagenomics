process CALCULATE_PHYLOGENETIC_ALPHA_DIV {
    cpus 8
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/calculate-phylogenetic-alpha-div", mode: "copy"

    input:
        tuple val(id), path(merged_rarefied_table), path(rooted_tree)

    output:
        tuple val(id), path("${id}-faith-pd.qza"), emit: faith_pd

    script:
        """
        qiime diversity alpha-phylogenetic \
            --i-table ${merged_rarefied_table} \
            --i-phylogeny ${rooted_tree} \
            --p-metric faith_pd \
            --o-alpha-diversity ${id}-faith-pd.qza
        """
}