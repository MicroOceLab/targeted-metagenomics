include { MAKE_MANIFEST                       } from '../modules/make-manifest'
include { MAKE_ARTIFACT                       } from '../modules/make-artifact'
include { INFER_ASV                           } from '../modules/infer-asv'
include { FILTER_FEATURES                     } from '../modules/filter-features'
include { MERGE_REP_SEQS                      } from '../modules/merge-rep-seqs'
include { MAKE_PHYLOGENY                      } from '../modules/make-phylogeny'
include { MERGE_TABLE                         } from '../modules/merge-table'
include { MAKE_RAREFACTION_CURVE              } from '../modules/make-rarefaction-curve'
include { EXPORT_RAREFACTION_CURVE            } from '../modules/export-rarefaction-curve'
include { CALCULATE_PLATEAU                   } from '../modules/calculate-plateau'
include { RAREFY                              } from '../modules/rarefy'
include { MERGE_TABLE as MERGE_RAREFIED_TABLE } from '../modules/merge-table'
include { FILTER_REP_SEQS                     } from '../modules/filter-rep-seqs'
include { ASSIGN_TAXA                         } from '../modules/assign-taxa'
include { MAKE_BAR_PLOT                       } from '../modules/make-bar-plot'

workflow TARGETED_METAGENOMICS {
    main:
        Channel.fromPath('./data/*.fastq')
            .set {ch_reads}

        MAKE_MANIFEST(ch_reads)
            .set {ch_manifests}

        MAKE_ARTIFACT(ch_manifests)
            .set {ch_artifacts}

        INFER_ASV(ch_artifacts)
            .set {ch_denoised}

        MERGE_REP_SEQS(ch_denoised.squashed_rep_seqs
            .reduce("") {rep_seq_1, rep_seq_2 ->
                "$rep_seq_1 $rep_seq_2"})
            .set {ch_merged_rep_seqs}

        MAKE_PHYLOGENY(ch_merged_rep_seqs)
            .set {ch_merged_phylogenetic}

        FILTER_FEATURES(ch_denoised.table
            .join(ch_denoised.rep_seqs))
            .set {ch_filtered}

        FILTER_REP_SEQS(ch_denoised.rep_seqs
            .join(ch_filtered.table))
            .set {ch_filtered_rep_seqs}
        
        ASSIGN_TAXA(ch_filtered_rep_seqs)
            .set {ch_taxa}
         
        MAKE_BAR_PLOT(ch_filtered.table
            .join(ch_taxa))
            .set {ch_taxa_bar_plot}

        Channel.of("merged")
            .set {ch_merged_id}

        MERGE_TABLE(ch_merged_id
            .combine(ch_filtered.squashed_table
            .reduce("") {table_1, table_2 ->
                "$table_1 $table_2"}))
            .set {ch_merged_table}
        
        MAKE_RAREFACTION_CURVE(ch_merged_table)       
            .set {ch_rarefaction_curve} 
        
        EXPORT_RAREFACTION_CURVE(ch_rarefaction_curve)
            .set {ch_rarefaction_curve_directory}
        
        CALCULATE_PLATEAU(ch_rarefaction_curve_directory)
            .set {ch_rarefaction_plateau}

        RAREFY(ch_filtered.table
            .combine(ch_rarefaction_plateau))
            .set {ch_rarefied}

        Channel.of("merged-rarefied")
            .set {ch_merged_rarefied_id}
        
        MERGE_RAREFIED_TABLE(ch_merged_rarefied_id
            .combine(ch_rarefied.squashed_table
            .reduce("") {table_1, table_2 ->
                "$table_1 $table_2"}))
            .set {ch_merged_rarefied_table}
        
        
}