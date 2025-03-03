include { TARGETED_METAGENOMICS } from './workflows/targeted-metagenomics'

workflow {
    main:
        TARGETED_METAGENOMICS()
}