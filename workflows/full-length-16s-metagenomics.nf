include { MAKE_MANIFEST } from '../modules/make-manifest'

workflow FULL_LENGTH_16S_METAGENOMICS {
    main:
        ch_ccs_reads = Channel.fromPath('./data/*.fastq')
        MAKE_MANIFEST(ch_ccs_reads)
}