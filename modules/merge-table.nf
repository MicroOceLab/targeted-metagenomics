process MERGE_TABLE {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/06-merge-table"

    input:
        val(denoised_tables)
    
    output:
        path("merged-table.qza")

    script:
        """
        qiime feature-table merge \
            --i-table ${denoised_tables} \
            --o-merged-table merged-table.qza
        """
}