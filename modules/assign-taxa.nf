process ASSIGN_TAXA {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/3-tax-assign"

    input:
        path ccs_denoised_rep_seqs

    output:
        path "${ccs_denoised_rep_seqs.baseName}-taxa.qza"

    script:
        """  
        qiime feature-classifier classify-sklearn \
            --i-reads ${ccs_denoised_rep_seqs} \
            --i-classifier assets/2024.09.backbone.full-length.nb.qza \
            --o-classification ${ccs_denoised_rep_seqs.baseName}-taxa.qza \
        """

}