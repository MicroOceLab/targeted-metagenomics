// Default module imports
include { FILTER_FEATURES                         } from '../modules/filter-features'
include { FILTER_REP_SEQS                         } from '../modules/filter-rep-seqs'
include { ASSIGN_TAXA                             } from '../modules/assign-taxa'
include { MAKE_BAR_PLOT                           } from '../modules/make-bar-plot'
include { EXPORT_VISUALIZATION as EXPORT_BAR_PLOT } from '../modules/export-visualization'
include { MERGE_REP_SEQS                          } from '../modules/merge-rep-seqs'
include { MAKE_PHYLOGENY                          } from '../modules/make-phylogeny'


workflow IDENTIFY_TAXA {
    take:
        ch_denoised_table
        ch_denoised_rep_seqs

    main:
        FILTER_FEATURES(ch_denoised_table
            .join(ch_denoised_rep_seqs))
            .set {ch_filtered}

        FILTER_REP_SEQS(ch_denoised_rep_seqs
            .join(ch_filtered.table))
            .set {ch_filtered_rep_seqs}
        
        ASSIGN_TAXA(ch_filtered_rep_seqs)
            .set {ch_taxa}
         
        MAKE_BAR_PLOT(ch_filtered.table
            .join(ch_taxa))
            .set {ch_bar_plot}

        EXPORT_BAR_PLOT(ch_bar_plot
            .map {bar_plot -> bar_plot[1]})
            .set {ch_bar_plot_directory}

        MERGE_REP_SEQS(ch_denoised_rep_seqs
            .map {rep_seq -> rep_seq[1]}
            .reduce("") {rep_seq_1, rep_seq_2 -> "$rep_seq_1 $rep_seq_2"})
            .set {ch_merged_rep_seqs}

        MAKE_PHYLOGENY(ch_merged_rep_seqs)
            .set {ch_merged_phylogenetic}

    emit:
        filtered_table = ch_filtered.table
        merged_phylogenetic_rooted_tree = ch_merged_phylogenetic.rooted_tree
}