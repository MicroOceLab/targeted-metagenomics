process FILTER_FEATURES {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/4-filter-features"

    input:
        tuple val(sample_id), path(denoised_table), path(denoised_rep_seqs)
    
    output:
        tuple val(sample_id), path("${sample_id}-filtered-table.qza"), emit: table
        path("${sample_id}-filtered-table.qza"), emit: squashed_table

    script:
        """
        qiime feature-table filter-features \
            --i-table ${denoised_table} \
            --m-metadata-file ${denoised_rep_seqs} \
            --o-filtered-table ${sample_id}-filtered-table.qza
        """
}