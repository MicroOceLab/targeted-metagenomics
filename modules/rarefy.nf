process RAREFY {
    cpus 4
    memory "6 GB"
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/rarefy", mode: "copy"

    input:
        tuple val(id), path(table), val(plateau)
    
    output:
        tuple val(id), path("${id}-rarefied-table.qza"), emit: table

    script:
        """
        qiime feature-table rarefy \
            --i-table ${table} \
            --p-sampling-depth ${plateau} \
            --o-rarefied-table ${id}-rarefied-table.qza
        """
}