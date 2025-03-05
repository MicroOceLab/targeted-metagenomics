process MERGE_TABLE {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/06-merge-table"

    input:
        val(sample_id), val(tables)
    
    output:
        val(sample_id), path("${sample_id}-table.qza")

    script:
        """
        qiime feature-table merge \
            --i-table ${tables} \
            --o-merged-table ${sample_id}-table.qza
        """
}