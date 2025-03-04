process MAKE_MANIFEST {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/01-make-manifest"

    input:
        val reads
    
    output:
        tuple val("${reads.baseName}"), path("${reads.baseName}.tsv")

    script:
        """
        make-manifest.py ${reads}
        """


}