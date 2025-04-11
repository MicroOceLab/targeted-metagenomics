process MAKE_MULTIQC_REPORT {
    cpus 2
    container "quay.io/biocontainers/multiqc:1.28--pyhdfd78af_0"
    publishDir "${params.output}/make-multiqc-report", mode: "copy"

    input:
        tuple val(id), val(fastqc_report_directory)

    output:
        path("${id}-multiqc-report/")

    script:
        """
        multiqc \
            -o ${id}-multiqc-report/ \
            ${fastqc_report_directory}
        """

}