process MAKE_ARTIFACT {
    container "quay.io/qiime2/amplicon:2024.10"
    publishDir "${params.output}/make-artifact", mode: "copy"

    input:
        tuple val(sample_id), path(manifest)

    output:
        tuple val(sample_id), path("${sample_id}.qza")

    script:
        """
        qiime tools import \
            --type SampleData[SequencesWithQuality] \
            --input-path ${manifest} \
            --output-path ${sample_id}.qza \
            --input-format SingleEndFastqManifestPhred33V2
        """
}