process RAREFY {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/04-merge-table"

    input:
        path(denoised_table)
    
    output:
        path("merged-table.qza")

    script:
        """
        qiime feature-table merge \
            --i-table ${denoised_table} \
            --o-merged-table merged-table.qza
        """
}