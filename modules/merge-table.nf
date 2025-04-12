process MERGE_TABLE {
    cpus 4
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/merge-table", mode: "copy"

    input:
        tuple val(id), val(tables)
    
    output:
        tuple val(id), path("${id}-table.qza")

    script:
        """
        qiime feature-table merge \
            --i-tables ${tables} \
            --o-merged-table ${id}-table.qza
        """
}