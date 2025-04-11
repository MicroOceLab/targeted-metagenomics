process ASSIGN_TAXA {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/assign-taxa", mode: "copy"

    input:
        tuple val(sample_id), path(filtered_rep_seqs)

    output:
        tuple val(sample_id), path("${sample_id}-taxa.qza")

    script:
        """  
        qiime feature-classifier classify-sklearn \
            --i-reads ${filtered_rep_seqs} \
            --i-classifier ${projectDir}/assets/${params.taxa_classifier} \
            --o-classification ${sample_id}-taxa.qza
        """

}