include { MAKE_MANIFEST } from '../modules/make-manifest'
include { MAKE_ARTIFACT } from '../modules/make-artifact'
include { INFER_ASV     } from '../modules/infer-asv'
include { ASSIGN_TAX    } from '../modules/assign-taxa'

workflow FULL_LENGTH_16S_METAGENOMICS {
    main:
        Channel.fromPath('./data/*.fastq')
            .set {ch_ccs_reads}

        MAKE_MANIFEST(ch_ccs_reads)
            .set {ch_ccs_manifests}

        MAKE_ARTIFACT(ch_ccs_manifests)
            .set {ch_ccs_artifacts}

        INFER_ASV(ch_ccs_artifacts)
            .branch{ ccs_artifact ->
                rep_seqs: ccs_artifact.baseName.tokenize("-")[-1] == "seqs"
                table: ccs_artifact.baseName.tokenize("-")[-1] == "table"
                stats: ccs_artifact.baseName.tokenize("-")[-1] == "stats"
            }.set {ch_ccs_denoised}

        ASSIGN_TAXA(ch_ccs_denoised.rep_seqs)
}