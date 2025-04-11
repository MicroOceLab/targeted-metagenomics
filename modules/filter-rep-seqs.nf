process FILTER_REP_SEQS {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/filter-rep-seqs", mode: "copy"

    input:
        tuple val(id), path(denoised_rep_seqs), val(table)
    
    output:
        tuple val(id), path("${id}-filtered-rep-seqs.qza")

    script:
        """
        qiime feature-table filter-seqs \
            --i-data ${denoised_rep_seqs} \
            --i-table ${table} \
            --o-filtered-data ${id}-filtered-rep-seqs.qza
        """
}