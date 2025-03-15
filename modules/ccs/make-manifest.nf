process MAKE_MANIFEST {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/01-make-manifest"

    input:
        tuple val(sample_id), val(reads)
    
    output:
        tuple val(sample_id), path("${reads.baseName}.tsv")

    script:
        """
        make-ccs-manifest.py ${reads}
        """


}