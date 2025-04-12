process MAKE_MANIFEST {
    cpus 1
    container "MicroOceLab/python:1.0"
    publishDir "${params.results}/make-manifest", mode: "copy"

    input:
        tuple val(id), val(forward_reads), val(reverse_reads)
    
    output:
        tuple val(id), path("${id}.tsv")

    script:
        """
        make-paired-manifest.py ${id} ${forward_reads} ${reverse_reads}
        """


}