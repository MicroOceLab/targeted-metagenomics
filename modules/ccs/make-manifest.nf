process MAKE_MANIFEST {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/make-manifest", mode: "copy"

    input:
        tuple val(sample_id), val(reads)
    
    output:
        tuple val(sample_id), path("${sample_id}.tsv")

    script:
        """
        make-ccs-manifest.py ${sample_id} ${reads}
        """


}