process CALCULATE_ALPHA_DIV {
    cpus 8
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/calculate-alpha-div", mode: "copy"

    input:
        tuple val(id), path(merged_rarefied_table)

    output:
        tuple val(id), path("${id}-shannon.qza"), emit: shannon
        tuple val(id), path("${id}-simpson.qza"), emit: simpson

    script:
        """
        qiime diversity alpha \
            --i-table ${merged_rarefied_table} \
            --p-metric shannon \
            --o-alpha-diversity ${id}-shannon.qza
        
        qiime diversity alpha \
            --i-table ${merged_rarefied_table} \
            --p-metric simpson \
            --o-alpha-diversity ${id}-simpson.qza
        """
}