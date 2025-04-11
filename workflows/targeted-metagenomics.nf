// Error checks
if (!params.mode) {
    error "ERROR: NGS platform (--mode) not specified"
}

if (params.mode == "ccs") {
    if (!params.front && !params.adapter) {
        error "ERROR: 5' (--front) and 3' (--adapter) CCS adapters not specified "
    } else if (!params.front) {
        error "ERROR: 5' (--front) CCS adapter not specified "
    } else if (!params.adapter) {
        error "ERROR: 3' (--adapter) CCS adapter not specified "
    }

} else if (params.mode == "paired") {
    if (!params.f_read) {
        error "ERROR: Forward read identifier (--f_read) not specified "
    } else if (!params.r_read) {
        error "ERROR: Reverse read identifier (--r_read) not specified "
    } else if (!params.f_primer) {
        error "ERROR: Forward primer (--f_primer) not specified "
    } else if (!params.r_primer) {
        error "ERROR: Reverse primer (--r_primer) not specified "
    }
}

if (!params.taxa_classifier) {
    error "ERROR: Naive Bayes classifier for taxonomic assignment not specified"
}


// Default module imports
include { PREPARE_ID      } from '../modules/prepare-id'
include { FILTER_FEATURES } from '../modules/filter-features'
include { FILTER_REP_SEQS } from '../modules/filter-rep-seqs'
include { ASSIGN_TAXA     } from '../modules/assign-taxa'
include { MAKE_BAR_PLOT   } from '../modules/make-bar-plot'
include { MERGE_REP_SEQS  } from '../modules/merge-rep-seqs'
include { MAKE_PHYLOGENY  } from '../modules/make-phylogeny'

// Module imports for params.mode: ccs
include { MAKE_MANIFEST as MAKE_CCS_MANIFEST } from '../modules/ccs/make-manifest'
include { MAKE_ARTIFACT as MAKE_CCS_ARTIFACT } from '../modules/ccs/make-artifact'
include { INFER_ASV as INFER_CCS_ASV         } from '../modules/ccs/infer-asv'

// Module imports for params.mode: paired
include { MAKE_MANIFEST as MAKE_PAIRED_MANIFEST } from '../modules/paired/make-manifest'
include { MAKE_ARTIFACT as MAKE_PAIRED_ARTIFACT } from '../modules/paired/make-artifact'
include { INFER_ASV as INFER_PAIRED_ASV         } from '../modules/paired/infer-asv'

// Default subworkflow imports
include { CHECK_READ_QUALITY  } from '../subworkflows/check-read-quality.nf'
include { CALCULATE_DIVERSITY } from '../subworkflows/calculate-diversity.nf'


workflow TARGETED_METAGENOMICS {
    main:
        Channel.fromPath("./${params.data}/*.fastq")
            .set {ch_reads}
        
        if (params.check_read_quality) {
            CHECK_READ_QUALITY(ch_reads
                .reduce("") {read_1, read_2 -> "$read_1 $read_2"})
        }

        PREPARE_ID(ch_reads)
            .set {ch_reads_with_id}
        
        if (params.mode == "ccs") {
            MAKE_CCS_MANIFEST(ch_reads_with_id)
                .set {ch_manifests}

            MAKE_CCS_ARTIFACT(ch_manifests)
                .set {ch_artifacts}

            INFER_CCS_ASV(ch_artifacts)
                .set {ch_denoised}

        } else if (params.mode == "paired") {
            ch_reads_with_id
                .branch { reads ->
                    forward_reads: reads[1] =~ /${params.f_read}/
                    reverse_reads: reads[1] =~ /${params.r_read}/
                    other: true}
                .set {ch_separated}

            MAKE_PAIRED_MANIFEST(ch_separated.forward_reads
                .join(ch_separated.reverse_reads))
                .set {ch_manifests}
            
            MAKE_PAIRED_ARTIFACT(ch_manifests)
                .set {ch_artifacts}

            INFER_PAIRED_ASV(ch_artifacts)
                .set {ch_denoised}       
        }

        FILTER_FEATURES(ch_denoised.table
            .join(ch_denoised.rep_seqs))
            .set {ch_filtered}

        FILTER_REP_SEQS(ch_denoised.rep_seqs
            .join(ch_filtered.table))
            .set {ch_filtered_rep_seqs}
        
        ASSIGN_TAXA(ch_filtered_rep_seqs)
            .set {ch_taxa}
         
        MAKE_BAR_PLOT(ch_filtered.table
            .join(ch_taxa))
            .set {ch_taxa_bar_plot}

        MERGE_REP_SEQS(ch_denoised.rep_seqs
            .map {rep_seq -> rep_seq[1]}
            .reduce("") {rep_seq_1, rep_seq_2 -> "$rep_seq_1 $rep_seq_2"})
            .set {ch_merged_rep_seqs}

        MAKE_PHYLOGENY(ch_merged_rep_seqs)
            .set {ch_merged_phylogenetic}

        if (params.calculate_div) {
            CALCULATE_DIVERSITY(ch_filtered, ch_merged_phylogenetic)
        }
}
