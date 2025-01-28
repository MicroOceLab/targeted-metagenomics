process MAKE_ARTIFACT {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/1-data-prep"

    input:
        path ccs_manifest

    output:
        path "${ccs_read.baseName}.qza"

    script:
        """
        qiime tools import \
            --type SampleData[SequencesWithQuality] \
            --input-path ${ccs_manifest} \
            --output-path ${ccs_read.baseName}.qza \
            --input-format SingleEndFastqManifestPhred33V2
        """
}