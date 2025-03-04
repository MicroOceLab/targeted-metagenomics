process ASSIGN_TAXA {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/10-assign-taxa"

    input:
        tuple val(sample_id), path(denoised_rep_seqs)

    output:
        tuple val(sample_id), path("${sample_id}-taxa.qza")

    script:
        """  
        qiime feature-classifier classify-sklearn \
            --i-reads ${denoised_rep_seqs} \
            --i-classifier ${projectDir}/assets/2024.09.backbone.full-length.nb.qza \
            --o-classification ${sample_id}-taxa.qza
        """

}