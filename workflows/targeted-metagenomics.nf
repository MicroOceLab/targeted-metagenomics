include { MAKE_MANIFEST            } from '../modules/make-manifest'
include { MAKE_ARTIFACT            } from '../modules/make-artifact'
include { INFER_ASV                } from '../modules/infer-asv'
include { MERGE_REP_SEQS           } from '../modules/merge-rep-seqs'
include { MAKE_PHYLOGENY           } from '../modules/make-phylogeny'
include { MERGE_TABLE              } from '../modules/merge-table'
include { MAKE_RAREFACTION_CURVE   } from '../modules/make-rarefaction-curve'
include { EXPORT_RAREFACTION_CURVE } from '../modules/export-rarefaction-curve'
include { CALCULATE_PLATEAU        } from '../modules/calculate-plateau'
include { RAREFY                   } from '../modules/rarefy'
include { ASSIGN_TAXA              } from '../modules/assign-taxa'

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
            .collect())
            .set {ch_merged_rep_seqs}

        MAKE_PHYLOGENY(ch_merged_rep_seqs)
            .set {ch_merged_phylogenetic}

        MERGE_TABLE(ch_denoised.squashed_table
            .collect())
            .set {ch_merged_table}
        
        MAKE_RAREFACTION_CURVE(ch_denoised.table)       
            .set {ch_rarefaction_curve} 
        
        EXPORT_RAREFACTION_CURVE(ch_rarefaction_curve)
            .set {ch_rarefaction_curve_directory}
        
        CALCULATE_PLATEAU(ch_rarefaction_curve_directory)
            .set {ch_rarefaction_plateau}

        RAREFY(ch_denoised.table
            .combine(ch_rarefaction_plateau))
            .set {ch_rarefied_tables}

        ASSIGN_TAXA(ch_denoised.rep_seqs)

        
}