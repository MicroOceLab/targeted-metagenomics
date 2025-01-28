include { FULL_LENGTH_16S_METAGENOMICS } from './workflows/full-length-16s-metagenomics'

workflow {
    main:
        FULL_LENGTH_16S_METAGENOMICS()
}