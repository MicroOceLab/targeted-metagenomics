process MAKE_MANIFEST {
    cpus 1
    container "MicroOceLab/python:1.0"
    publishDir "${params.results}/make-manifest", mode: "copy"

    input:
        tuple val(id), val(reads)
    
    output:
        tuple val(id), path("${id}.tsv")

    script:
        """
        make-ccs-manifest.py ${id} ${reads}
        """


}