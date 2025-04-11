process FILTER_REP_SEQS {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/filter-rep-seqs", mode: "copy"

    input:
        tuple val(sample_id), path(denoised_rep_seqs), val(table)
    
    output:
        tuple val(sample_id), path("${sample_id}-filtered-rep-seqs.qza")

    script:
        """
        qiime feature-table filter-seqs \
            --i-data ${denoised_rep_seqs} \
            --i-table ${table} \
            --o-filtered-data ${sample_id}-filtered-rep-seqs.qza
        """
}