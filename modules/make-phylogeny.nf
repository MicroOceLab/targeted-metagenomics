process MAKE_PHYLOGENY {
    cpus 8
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/make-phylogeny", mode: "copy"

    input:
        path(merged_rep_seqs)

    output:
        path("merged-aligned-rep-seqs.qza"), emit: aligned_rep_seqs
        path("merged-masked-aligned-rep-seqs.qza"), emit: masked_aligned_rep_seqs
        path("merged-unrooted-tree.qza"), emit: unrooted_tree 
        path("merged-rooted-tree.qza"), emit: rooted_tree

    script:
        """          
        qiime phylogeny align-to-tree-mafft-fasttree \
            --i-sequences ${merged_rep_seqs} \
            --o-alignment merged-aligned-rep-seqs.qza \
            --o-masked-alignment merged-masked-aligned-rep-seqs.qza \
            --o-tree merged-unrooted-tree.qza \
            --o-rooted-tree merged-rooted-tree.qza
        """

}