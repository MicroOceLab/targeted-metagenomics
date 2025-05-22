// Default module imports
include { MERGE_TABLE                                      } from '../modules/merge-table'
include { MAKE_RAREFACTION_CURVE                           } from '../modules/make-rarefaction-curve'
include { EXPORT_VISUALIZATION as EXPORT_RAREFACTION_CURVE } from '../modules/export-visualization'
include { CALCULATE_PLATEAU                                } from '../modules/calculate-plateau'
include { RAREFY                                           } from '../modules/rarefy'
include { MERGE_TABLE as MERGE_RAREFIED_TABLE              } from '../modules/merge-table'
include { CALCULATE_ALPHA_DIV                              } from '../modules/calculate-alpha-div'
include { CALCULATE_PHYLOGENETIC_ALPHA_DIV                 } from '../modules/calculate-phylogenetic-alpha-div'
include { CALCULATE_BETA_DIV                               } from '../modules/calculate-beta-div'
include { CALCULATE_PHYLOGENETIC_BETA_DIV                  } from '../modules/calculate-phylogenetic-beta-div'
include { TEST_ALPHA_CORRELATION                           } from '../modules/test-alpha-correlation'
include { TEST_ALPHA_GROUP_SIGNIFICANCE                    } from '../modules/test-alpha-group-significance'
include { TEST_BETA_GROUP_SIGNIFICANCE                     } from '../modules/test-beta-group-significance'
include { VISUALIZE_PCOA                                   } from '../modules/visualize-pcoa'


workflow CALCULATE_DIVERSITY {
    take:
        ch_filtered_table
        ch_merged_phylogenetic_rooted_tree
        ch_metadata

    main:
        Channel.of("merged")
            .set {ch_merged_id}

        MERGE_TABLE(ch_merged_id
            .combine(ch_filtered_table
            .map {table -> table[1]}
            .reduce("") {table_1, table_2 -> "$table_1 $table_2"}))
            .set {ch_merged_table}
        
        MAKE_RAREFACTION_CURVE(ch_merged_table)       
            .set {ch_rarefaction_curve} 
        
        EXPORT_RAREFACTION_CURVE(ch_rarefaction_curve)
            .set {ch_rarefaction_curve_directory}
        
        CALCULATE_PLATEAU(ch_rarefaction_curve_directory)
            .set {ch_rarefaction_plateau}

        RAREFY(ch_filtered_table
            .combine(ch_rarefaction_plateau))
            .set {ch_rarefied}

        Channel.of("merged-rarefied")
            .set {ch_merged_rarefied_id}
        
        MERGE_RAREFIED_TABLE(ch_merged_rarefied_id
            .combine(ch_rarefied.table
            .map {table -> table[1]}
            .reduce("") {table_1, table_2 -> "$table_1 $table_2"}))
            .set {ch_merged_rarefied_table}

        CALCULATE_ALPHA_DIV(ch_merged_rarefied_table)
            .set {ch_alpha_div}
        
        CALCULATE_PHYLOGENETIC_ALPHA_DIV(ch_merged_rarefied_table
            .combine(ch_merged_phylogenetic_rooted_tree))
            .set {ch_phylogenetic_alpha_div}
        
        CALCULATE_BETA_DIV(ch_merged_rarefied_table)
            .set {ch_beta_div}

        CALCULATE_PHYLOGENETIC_BETA_DIV(ch_merged_rarefied_table
            .combine(ch_merged_phylogenetic_rooted_tree))
            .set {ch_phylogenetic_beta_div}
        
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
        
        Channel.of("${params.metadata_column}")
            .set {ch_metadata_column}
        
        ch_beta_div.bray_curtis
            .mix(ch_beta_div.jaccard)
            .combine(ch_beta_id)
            .mix(ch_phylogenetic_beta_div.unweighted_unifrac
            .mix(ch_phylogenetic_beta_div.weighted_unifrac)
            .combine(ch_phylogenetic_beta_id))
            .combine(ch_metadata_column)
            .combine(ch_metadata)
            .set {ch_combined_beta_div}

        TEST_BETA_GROUP_SIGNIFICANCE(ch_combined_beta_div)
            .set {ch_beta_group_significance}

        VISUALIZE_PCOA(ch_alpha_div.shannon
            .mix(ch_alpha_div.simpson)
            .mix(ch_phylogenetic_alpha_div.faith_pd)
            .mix(ch_beta_div.bray_curtis)
            .mix(ch_beta_div.jaccard)
            .mix(ch_phylogenetic_beta_div.weighted_unifrac)
            .mix(ch_phylogenetic_beta_div.unweighted_unifrac)
            .map {matrix -> matrix[1]}
            .combine(ch_metadata))
}