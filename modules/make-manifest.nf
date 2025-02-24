process MAKE_MANIFEST {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/1-data-prep"

    input:
        val ccs_read
    
    output:
        tuple val("${ccs_read.baseName}"), path("${ccs_read.baseName}.tsv")

    script:
        """
        make-manifest.py ${ccs_read}
        """


}