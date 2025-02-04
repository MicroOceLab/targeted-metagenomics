include { MAKE_MANIFEST } from '../modules/make-manifest'
include { MAKE_ARTIFACT } from '../modules/make-artifact'
include { INFER_ASV     } from '../modules/infer-asv'
include { ASSIGN_TAXA   } from '../modules/assign-taxa'

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
}