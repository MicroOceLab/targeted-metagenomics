include { MAKE_MANIFEST            } from '../modules/make-manifest'
include { MAKE_ARTIFACT            } from '../modules/make-artifact'
include { INFER_ASV                } from '../modules/infer-asv'
include { ASSIGN_TAXA              } from '../modules/assign-taxa'
include { MAKE_PHYLOGENY           } from '../modules/make-phylogeny'
include { MAKE_RAREFACTION_CURVE   } from '../modules/make-rarefaction-curve'
include { EXPORT_RAREFACTION_CURVE } from '../modules/export-rarefaction-curve'
include { CALCULATE_PLATEAU        } from '../modules/calculate-plateau'

workflow FULL_LENGTH_16S_METAGENOMICS {
    main:
        Channel.fromPath('./data/*.fastq')
            .set {ch_reads}

        MAKE_MANIFEST(ch_reads)
            .set {ch_manifests}

        MAKE_ARTIFACT(ch_manifests)
            .set {ch_artifacts}

        INFER_ASV(ch_artifacts)
            .set {ch_denoised}

        ASSIGN_TAXA(ch_denoised.rep_seqs)

        MAKE_PHYLOGENY(ch_denoised.rep_seqs)

        MAKE_RAREFACTION_CURVE(ch_denoised.table)       
            .set {ch_rarefaction_curve} 
        
        EXPORT_RAREFACTION_CURVE(ch_rarefaction_curve)
            .set {ch_rarefaction_curve_exported}
        
        CALCULATE_PLATEAU(ch_rarefaction_curve_exported)
            .set {ch_rarefaction_plateau}
}