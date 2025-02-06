include { MAKE_MANIFEST            } from '../modules/make-manifest'
include { MAKE_ARTIFACT            } from '../modules/make-artifact'
include { INFER_ASV                } from '../modules/infer-asv'
include { ASSIGN_TAXA              } from '../modules/assign-taxa'
include { MAKE_PHYLOGENY           } from '../modules/make-phylogeny'
include { MAKE_RAREFACTION_CURVE   } from '../modules/make-rarefaction-curve'
include { EXPORT_RAREFACTION_CURVE } from '../modules/export-rarefaction-curve'

workflow FULL_LENGTH_16S_METAGENOMICS {
    main:
        Channel.fromPath('./data/*.fastq')
            .set {ch_ccs_reads}

        MAKE_MANIFEST(ch_ccs_reads)
            .set {ch_ccs_manifests}

        MAKE_ARTIFACT(ch_ccs_manifests)
            .set {ch_ccs_artifacts}

        INFER_ASV(ch_ccs_artifacts)
            .set {ch_ccs_denoised}

        ASSIGN_TAXA(ch_ccs_denoised.rep_seqs)

        MAKE_PHYLOGENY(ch_ccs_denoised.rep_seqs)

        MAKE_RAREFACTION_CURVE(ch_ccs_denoised.table)       
            .set {ch_ccs_rarefaction_curve} 
        
        EXPORT_RAREFACTION_CURVE(ccs_rarefaction_curve)
            .set {ch_ccs_rarefaction_curve_exported}
}