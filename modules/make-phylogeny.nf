process MAKE_PHYLOGENY {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/05-make-phylogeny"

    input:
        tuple val(sample_id), path(denoised_rep_seqs)

    output:
        tuple val(sample_id), path("${sample_id}-aligned-rep-seqs.qza"), emit: aligned_rep_seqs
        tuple val(sample_id), path("${sample_id}-masked-aligned-rep-seqs.qza"), emit: masked_aligned_rep_seqs
        tuple val(sample_id), path("${sample_id}-unrooted-tree.qza"), emit: unrooted_tree 
        tuple val(sample_id), path("${sample_id}-rooted-tree.qza"), emit: rooted_tree

    script:
        """          
        qiime phylogeny align-to-tree-mafft-fasttree \
            --i-sequences ${denoised_rep_seqs} \
            --o-alignment ${sample_id}-aligned-rep-seqs.qza \
            --o-masked-alignment ${sample_id}-masked-aligned-rep-seqs.qza \
            --o-tree ${sample_id}-unrooted-tree.qza \
            --o-rooted-tree ${sample_id}-rooted-tree.qza
        """

}