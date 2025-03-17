process CALCULATE_PHYLOGENETIC_BETA_DIV {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/19-calculate-phylogenetic-beta-div", mode: "copy"

    input:
        tuple val(sample_id), path(merged_rarefied_table), path(rooted_tree)

    output:
        tuple val(sample_id), path("${sample_id}-unweighted-unifrac.qza"), emit: unweighted_unifrac
        tuple val(sample_id), path("${sample_id}-weighted-unifrac.qza"), emit: weighted_unifrac

    script:
        """
        qiime diversity beta-phylogenetic \
            --i-table ${merged_rarefied_table} \
            --i-phylogeny ${rooted_tree} \
            --p-metric unweighted_unifrac \
            --o-distance-matrix ${sample_id}-unweighted-unifrac.qza
        
        qiime diversity beta-phylogenetic \
            --i-table ${merged_rarefied_table} \
            --i-phylogeny ${rooted_tree} \
            --p-metric weighted_unifrac \
            --o-distance-matrix ${sample_id}-weighted-unifrac.qza
        """
}