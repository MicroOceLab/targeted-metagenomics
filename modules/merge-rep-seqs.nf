process MERGE_REP_SEQS {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/merge-rep-seqs", mode: "copy"

    input:
        val(denoised_rep_seqs)
    
    output:
        path("merged-rep-seqs.qza")

    script:
        """
        qiime feature-table merge-seqs \
            --i-data ${denoised_rep_seqs} \
            --o-merged-data merged-rep-seqs.qza
        """
}