process ASSIGN_TAXA {
    cpus 8
    memory "8 GB"
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/assign-taxa", mode: "copy"

    input:
        tuple val(id), path(filtered_rep_seqs)

    output:
        tuple val(id), path("${id}-taxa.qza")

    script:
        """  
        qiime feature-classifier classify-sklearn \
            --i-reads ${filtered_rep_seqs} \
            --i-classifier ${projectDir}/assets/${params.taxa_classifier} \
            --o-classification ${id}-taxa.qza
        """

}