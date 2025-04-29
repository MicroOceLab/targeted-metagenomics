process MERGE_REP_SEQS {
    cpus 4
    memory "8 GB"
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/merge-rep-seqs", mode: "copy"

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