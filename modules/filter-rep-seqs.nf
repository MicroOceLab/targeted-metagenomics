process FILTER_REP_SEQS {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/07-filter-rep-seqs"

    input:
        tuple val(sample_id), path(denoised_rep_seqs), val(rarefied_table)
    
    output:
        tuple val(sample_id), path("${sample_id}-filtered-rep-seqs.qza")

    script:
        """
        qiime feature-table filter-seqs \
            --i-data ${denoised_rep_seqs} \
            --i-table ${rarefied_table} \
            --o-filtered-data ${sample_id}-filtered-rep-seqs.qza
        """
}