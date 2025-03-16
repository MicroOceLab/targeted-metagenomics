process MAKE_MANIFEST {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/01-make-manifest", mode: "copy"

    input:
        tuple val(sample_id), val(reads)
    
    output:
        tuple val(sample_id), path("${sample_id}.tsv")

    script:
        sample_id = sample_id.replaceAll("\\s","")
    
        """
        make-ccs-manifest.py ${sample_id} ${reads}
        """


}