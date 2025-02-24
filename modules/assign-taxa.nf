process ASSIGN_TAXA {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/3-tax-assign"

    input:
        path denoised_rep_seqs

    output:
        path "${denoised_rep_seqs.baseName[0..-10]}-taxa.qza"

    script:
        """  
        qiime feature-classifier classify-sklearn \
            --i-reads ${denoised_rep_seqs} \
            --i-classifier ${projectDir}/assets/2024.09.backbone.full-length.nb.qza \
            --o-classification ${denoised_rep_seqs.baseName[0..-10]}-taxa.qza
        """

}