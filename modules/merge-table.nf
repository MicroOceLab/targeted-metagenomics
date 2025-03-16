process MERGE_TABLE {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/10-merge-table", mode: "copy"

    input:
        tuple val(sample_id), val(tables)
    
    output:
        tuple val(sample_id), path("${sample_id}-table.qza")

    script:
        """
        qiime feature-table merge \
            --i-tables ${tables} \
            --o-merged-table ${sample_id}-table.qza
        """
}