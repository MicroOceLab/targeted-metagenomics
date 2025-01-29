include { MAKE_MANIFEST } from '../modules/make-manifest'
include { MAKE_ARTIFACT } from '../modules/make-artifact'
include { INFER_ASV     } from '../modules/infer-asv'

workflow FULL_LENGTH_16S_METAGENOMICS {
    main:
        ch_ccs_reads     = Channel.fromPath('./data/*.fastq')
        ch_ccs_manifests = MAKE_MANIFEST(ch_ccs_reads)
        ch_ccs_artifacts = MAKE_ARTIFACT(ch_ccs_manifests)
        ch_asv_files     = INFER_ASV(ch_ccs_artifacts)
}