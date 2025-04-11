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

} else if (params.mode == "paired") {
    if (!params.f_read) {
        error "ERROR: Forward read identifier (--f_read) not specified "
    } else if (!params.r_read) {
        error "ERROR: Reverse read identifier (--r_read) not specified "
    } else if (!params.f_primer) {
        error "ERROR: Forward primer (--f_primer) not specified "
    } else if (!params.r_primer) {
        error "ERROR: Reverse primer (--r_primer) not specified "
    }
}

if (!params.taxa_classifier) {
    error "ERROR: Naive Bayes classifier for taxonomic assignment not specified"
}

include { PREPARE_ID                            } from '../modules/prepare-id'

include { MAKE_MANIFEST as MAKE_CCS_MANIFEST    } from '../modules/ccs/make-manifest'
include { MAKE_ARTIFACT as MAKE_CCS_ARTIFACT    } from '../modules/ccs/make-artifact'
include { INFER_ASV as INFER_CCS_ASV            } from '../modules/ccs/infer-asv'

include { MAKE_MANIFEST as MAKE_PAIRED_MANIFEST } from '../modules/paired/make-manifest'
include { MAKE_ARTIFACT as MAKE_PAIRED_ARTIFACT } from '../modules/paired/make-artifact'
include { INFER_ASV as INFER_PAIRED_ASV         } from '../modules/paired/infer-asv'

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
include { MERGE_TABLE as MERGE_RAREFIED_TABLE   } from '../modules/merge-table'
include { CALCULATE_ALPHA_DIV                   } from '../modules/calculate-alpha-div'
include { CALCULATE_PHYLOGENETIC_ALPHA_DIV      } from '../modules/calculate-phylogenetic-alpha-div'
include { CALCULATE_BETA_DIV                    } from '../modules/calculate-beta-div'
include { TEST_ALPHA_CORRELATION                } from '../modules/test-alpha-correlation'
include { TEST_ALPHA_GROUP_SIGNIFICANCE         } from '../modules/test-alpha-group-significance'
include { TEST_BETA_GROUP_SIGNIFICANCE          } from '../modules/test-beta-group-significance'



workflow TARGETED_METAGENOMICS {
    main:
        Channel.fromPath('./data/*.fastq')
            .set {ch_reads}

        PREPARE_ID(ch_reads)
            .set {ch_reads_with_id}
        
        if (params.mode == "ccs") {
            MAKE_CCS_MANIFEST(ch_reads_with_id)
                .set {ch_manifests}

            MAKE_CCS_ARTIFACT(ch_manifests)
                .set {ch_artifacts}

            INFER_CCS_ASV(ch_artifacts)
                .set {ch_denoised}

        } else if (params.mode == "paired") {
            ch_reads_with_id
                .branch { reads ->
                    forward_reads: reads[1] =~ /${params.f_read}/
                    reverse_reads: reads[1] =~ /${params.r_read}/
                    other: true}
                .set {ch_separated}

            MAKE_PAIRED_MANIFEST(ch_separated.forward_reads
                .join(ch_separated.reverse_reads))
                .set {ch_manifests}
            
            MAKE_PAIRED_ARTIFACT(ch_manifests)
                .set {ch_artifacts}

            INFER_PAIRED_ASV(ch_artifacts)
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

        MERGE_REP_SEQS(ch_denoised.rep_seqs
            .map {rep_seq -> rep_seq[1]}
            .reduce("") {rep_seq_1, rep_seq_2 ->
                "$rep_seq_1 $rep_seq_2"})
            .set {ch_merged_rep_seqs}

        MAKE_PHYLOGENY(ch_merged_rep_seqs)
            .set {ch_merged_phylogenetic}

        Channel.of("merged")
            .set {ch_merged_id}

        MERGE_TABLE(ch_merged_id
            .combine(ch_filtered.table
            .map {table -> table[1]}
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
            .combine(ch_rarefied.table
            .map {table -> table[1]}
            .reduce("") {table_1, table_2 ->
                "$table_1 $table_2"}))
            .set {ch_merged_rarefied_table}

        CALCULATE_ALPHA_DIV(ch_merged_rarefied_table)
            .set {ch_alpha_div}
        
        CALCULATE_PHYLOGENETIC_ALPHA_DIV(ch_merged_rarefied_table
            .combine(ch_merged_phylogenetic.rooted_tree))
            .set {ch_phylogenetic_alpha_div}
        
        CALCULATE_BETA_DIV(ch_merged_rarefied_table)
            .set {ch_beta_div}

        CALCULATE_PHYLOGENETIC_BETA_DIV(ch_merged_rarefied_table
            .combine(ch_merged_phylogenetic.rooted_tree))
            .set {ch_phylogenetic_beta_div}
        
        Channel.fromPath('./data/*.tsv')
            .set {ch_metadata}

        Channel.of("alpha")
            .set {ch_alpha_id}

        Channel.of("phylogenetic-alpha")
            .set {ch_phylogenetic_alpha_id}

        ch_alpha_div.shannon
            .mix(ch_alpha_div.simpson)
            .combine(ch_alpha_id)
            .mix(ch_phylogenetic_alpha_div.faith_pd
            .combine(ch_phylogenetic_alpha_id))
            .combine(ch_metadata)
            .set {ch_combined_alpha_div}
        
        TEST_ALPHA_CORRELATION(ch_combined_alpha_div)
            .set {ch_alpha_correlation}

        TEST_ALPHA_GROUP_SIGNIFICANCE(ch_combined_alpha_div)
            .set {ch_alpha_group_significance}
        
        Channel.of("beta")
            .set {ch_beta_id}

        Channel.of("phylogenetic-beta")
            .set {ch_phylogenetic_beta_id}
        
        Channel.of("sampleID")
            .set {ch_column_sample_id}
        
        ch_beta_div.bray_curtis
            .mix(ch_beta_div.jaccard)
            .combine(ch_beta_id)
            .mix(ch_phylogenetic_beta_div.unweighted_unifrac
            .mix(ch_phylogenetic_beta_div.weighted_unifrac)
            .combine(ch_phylogenetic_beta_id))
            .combine(ch_column_sample_id)
            .combine(ch_metadata)
            .set {ch_combined_beta_div}

        TEST_BETA_GROUP_SIGNIFICANCE(ch_combined_beta_div)
            .set {ch_beta_group_significance}
}
