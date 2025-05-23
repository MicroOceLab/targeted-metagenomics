process FILTER_FEATURES {
    cpus 4
    memory "4 GB"
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/filter-features", mode: "copy"

    input:
        tuple val(id), path(denoised_table), path(denoised_rep_seqs)
    
    output:
        tuple val(id), path("${id}-filtered-table.qza"), emit: table

    script:
        """
        qiime feature-table filter-features \
            --i-table ${denoised_table} \
            --m-metadata-file ${denoised_rep_seqs} \
            --o-filtered-table ${id}-filtered-table.qza
        """
}