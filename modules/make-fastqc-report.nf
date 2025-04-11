process MAKE_FASTQC_REPORT {
    cpus 2
    container "quay.io/biocontainers/fastqc:0.11.2--pl5.22.0_0"
    publishDir "${params.results}/make-fastqc-report", mode: "copy"

    input:
        tuple val(id), val(reads)

    output:
        tuple val(id), path("${id}-fastqc-report/")

    script:
        """
        mkdir ${id}-fastqc-report
        fastqc \
            -o ${id}-fastqc-report/ \
            ${reads}
        """

}