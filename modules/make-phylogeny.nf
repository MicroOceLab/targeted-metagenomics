process MAKE_PHYLOGENY {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/3-tax-assign"

    input:
        path denoised_rep_seqs

    output:
        path "${denoised_rep_seqs.baseName[0..-10]}-aligned-rep-seqs.qza", emit: aligned_rep_seqs
        path "${denoised_rep_seqs.baseName[0..-10]}-masked-aligned-rep-seqs.qza", emit: masked_aligned_rep_seqs
        path "${denoised_rep_seqs.baseName[0..-10]}-unrooted-tree.qza", emit: unrooted_tree 
        path "${denoised_rep_seqs.baseName[0..-10]}-rooted-tree.qza", emit: rooted_tree

    script:
        """          
        qiime phylogeny align-to-tree-mafft-fasttree \
            --i-sequences ${denoised_rep_seqs} \
            --o-alignment ${denoised_rep_seqs.baseName[0..-10]}-aligned-rep-seqs.qza \
            --o-masked-alignment ${denoised_rep_seqs.baseName[0..-10]}-masked-aligned-rep-seqs.qza \
            --o-tree ${denoised_rep_seqs.baseName[0..-10]}-unrooted-tree.qza \
            --o-rooted-tree ${denoised_rep_seqs.baseName[0..-10]}-rooted-tree.qza
        """

}