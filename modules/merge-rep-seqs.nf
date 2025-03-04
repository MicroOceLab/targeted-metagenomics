process MERGE_REP_SEQS {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/04-merge-rep-seqs"

    input:
        path(denoised_rep_seqs)
    
    output:
        path("merged-rep-seqs.qza")

    script:
        """
        qiime feature-table merge-seqs \
            --i-table ${denoised_rep_seqs} \
            --o-merged-data merged-rep-seqs.qza
        """
}