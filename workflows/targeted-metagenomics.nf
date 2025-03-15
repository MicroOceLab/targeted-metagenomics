if (!params.mode) {
    error "ERROR: NGS platform (--mode) not specified"
}

if (params.mode == "ccs") {
    if (!params.front && !params.adapter) {
        error "ERROR: 5' (--front) and 3' (--adapter) CCS adapters not specified "
    } else if (!params.front) {
        error "ERROR: 5' (--front) CCS adapter not specified "
    } else if (!params.adapter) {
        error "ERROR: 3' (--adapter) CCS adapter not specified "
    }
}

include { PREPARE_SAMPLE_ID                     } from '../modules/prepare-sample-id'
include { MAKE_MANIFEST as MAKE_CCS_MANIFEST    } from '../modules/ccs/make-manifest'
include { MAKE_ARTIFACT as MAKE_CCS_ARTIFACT    } from '../modules/ccs/make-artifact'
include { INFER_ASV as INFER_CCS_ASV            } from '../modules/ccs/infer-asv'
include { FILTER_FEATURES                       } from '../modules/filter-features'
include { FILTER_REP_SEQS                       } from '../modules/filter-rep-seqs'
include { ASSIGN_TAXA                           } from '../modules/assign-taxa'
include { MAKE_BAR_PLOT                         } from '../modules/make-bar-plot'
include { MERGE_REP_SEQS                        } from '../modules/merge-rep-seqs'
include { MAKE_PHYLOGENY                        } from '../modules/make-phylogeny'
include { MERGE_TABLE                           } from '../modules/merge-table'
include { MAKE_RAREFACTION_CURVE                } from '../modules/make-rarefaction-curve'
include { EXPORT_RAREFACTION_CURVE              } from '../modules/export-rarefaction-curve'
include { CALCULATE_PLATEAU                     } from '../modules/calculate-plateau'
include { RAREFY                                } from '../modules/rarefy'
include { CALCULATE_ALPHA_DIV                   } from '../modules/calculate-alpha-div'
include { CALCULATE_PHYLOGENETIC_ALPHA_DIV      } from '../modules/calculate-phylogenetic-alpha-div'
include { MERGE_TABLE as MERGE_RAREFIED_TABLE   } from '../modules/merge-table'
include { CALCULATE_BETA_DIV                    } from '../modules/calculate-beta-div'
include { CALCULATE_PHYLOGENETIC_BETA_DIV       } from '../modules/calculate-phylogenetic-beta-div'


workflow TARGETED_METAGENOMICS {
    main:
        Channel.fromPath('./data/*.fastq')
            .set {ch_reads}

        PREPARE_SAMPLE_ID(ch_reads)
            .set {ch_reads_with_id}
        
        if (params.mode == "ccs") {
            MAKE_CCS_MANIFEST(ch_reads_with_id)
                .set {ch_manifests}

            MAKE_CCS_ARTIFACT(ch_manifests)
                .set {ch_artifacts}

            INFER_CCS_ASV(ch_artifacts)
                .set {ch_denoised}
        }

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

        MERGE_REP_SEQS(ch_denoised.squashed_rep_seqs
            .reduce("") {rep_seq_1, rep_seq_2 ->
                "$rep_seq_1 $rep_seq_2"})
            .set {ch_merged_rep_seqs}

        MAKE_PHYLOGENY(ch_merged_rep_seqs)
            .set {ch_merged_phylogenetic}

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

        CALCULATE_ALPHA_DIV(ch_rarefied.table)
            .set {ch_alpha_div}
        
        CALCULATE_PHYLOGENETIC_ALPHA_DIV(ch_rarefied.table
            .combine(ch_merged_phylogenetic.rooted_tree))
            .set {ch_phylogenetic_alpha_div}

        Channel.of("merged-rarefied")
            .set {ch_merged_rarefied_id}
        
        MERGE_RAREFIED_TABLE(ch_merged_rarefied_id
            .combine(ch_rarefied.squashed_table
            .reduce("") {table_1, table_2 ->
                "$table_1 $table_2"}))
            .set {ch_merged_rarefied_table}
        
        CALCULATE_BETA_DIV(ch_merged_rarefied_table)
            .set {ch_beta_div}

        CALCULATE_PHYLOGENETIC_BETA_DIV(ch_merged_rarefied_table
            .combine(ch_merged_phylogenetic.rooted_tree))
            .set {ch_phylogenetic_beta_div}
        
}