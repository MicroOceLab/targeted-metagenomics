process RAREFY {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/04-merge-table"

    input:
        val(denoised_rep_seqs)
    
    output:
        path("merged-table.qza")

    script:
        """
        qiime feature-table merge \
            --i-table ${denoised_rep_seqs} \
            --o-merged-table merged-table.qza
        """
}