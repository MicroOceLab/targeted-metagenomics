process ASSIGN_TAXA {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/3-tax-assign"

    input:
        path ccs_artifact

    output:
        path "${ccs_artifact.baseName}-taxa.qza"

    script:
        """  
        qiime feature-classifier classify-sklearn \
            --i-reads results/2-asv-infer/${ccs_artifact.baseName}-rep-seqs.qza \
            --i-classifier ../assets/2024.09.backbone.full-length.nb.qza \
            --o-classification results/3-tax-assign/${ccs_artifact.baseName}-taxa.qza 
        """

}