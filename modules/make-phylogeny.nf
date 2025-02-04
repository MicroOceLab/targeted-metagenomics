process MAKE_PHYLOGENY {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/3-tax-assign"

    input:
        path ccs_denoised_rep_seqs

    output:
        path "${ccs_denoised_rep_seqs.baseName[0..-10]}-aligned-rep-seqs.qza", emit: aligned_rep_seqs
        path "${ccs_denoised_rep_seqs.baseName[0..-10]}-masked-aligned-rep-seqs.qza", emit: masked_aligned_rep_seqs
        path "${ccs_denoised_rep_seqs.baseName[0..-10]}-unrooted-tree.qza", emit: unrooted_tree 
        path "${ccs_denoised_rep_seqs.baseName[0..-10]}-rooted-tree.qza", emit: rooted_tree

    script:
        """          
        qiime phylogeny align-to-tree-mafft-fasttree \
            --i-sequences ${ccs_denoised_rep_seqs} \
            --o-alignment ${ccs_denoised_rep_seqs.baseName[0..-10]}-aligned-rep-seqs.qza \
            --o-masked-alignment ${ccs_denoised_rep_seqs.baseName[0..-10]}-masked-aligned-rep-seqs.qza \
            --o-tree ${ccs_denoised_rep_seqs.baseName[0..-10]}-unrooted-tree.qza \
            --o-rooted-tree ${ccs_denoised_rep_seqs.baseName[0..-10]}-rooted-tree.qza
        """

}