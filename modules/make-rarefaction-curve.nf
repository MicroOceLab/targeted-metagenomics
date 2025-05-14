process MAKE_RAREFACTION_CURVE {
    cpus 4
    memory "8 GB"
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/make-rarefaction-curve", mode: "copy"

    input:
        tuple val(id), path(merged_table)

    output:
        tuple val(id), path("${id}-rarefaction-curve.qzv")

    script:
        """          
        qiime diversity alpha-rarefaction \
            --i-table ${merged_table} \
            --p-max-depth 10000 \
            --p-metrics 'shannon' \
            --p-steps 41 \
            --o-visualization ${id}-rarefaction-curve.qzv
        """

}