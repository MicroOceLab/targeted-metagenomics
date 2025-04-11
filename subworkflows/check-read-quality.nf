// Default module imports
include { MAKE_FASTQC_REPORT  } from '../modules/make-fastqc-report'
include { MAKE_MULTIQC_REPORT } from '../modules/make-multiqc-report'


workflow CHECK_READ_QUALITY {
    take:
        reads
    
    main:
        MAKE_FASTQC_REPORT(reads)
            .set {ch_fastqc_report}
         
        MAKE_MULTIQC_REPORT(ch_fastqc_report)
            .set {ch_multiqc_report}
}