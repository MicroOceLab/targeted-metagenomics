process MAKE_MANIFEST {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/1-data-prep"

    input:
        val read
    
    output:
        tuple val("${read.baseName}"), path("${read.baseName}.tsv")

    script:
        """
        make-manifest.py ${read}
        """


}