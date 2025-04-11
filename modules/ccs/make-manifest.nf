process MAKE_MANIFEST {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/make-manifest", mode: "copy"

    input:
        tuple val(id), val(reads)
    
    output:
        tuple val(id), path("${id}.tsv")

    script:
        """
        make-ccs-manifest.py ${id} ${reads}
        """


}