process MAKE_ARTIFACT {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.results}/make-artifact", mode: "copy"

    input:
        tuple val(id), path(manifest)

    output:
        tuple val(id), path("${id}.qza")

    script:
        """
        qiime tools import \
            --type SampleData[PairedEndSequencesWithQuality] \
            --input-path ${manifest} \
            --output-path ${id}.qza \
            --input-format PairedEndFastqManifestPhred33V2
        """
}