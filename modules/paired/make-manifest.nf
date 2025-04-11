process MAKE_MANIFEST {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/make-manifest", mode: "copy"

    input:
        tuple val(sample_id), val(forward_reads), val(reverse_reads)
    
    output:
        tuple val(sample_id), path("${sample_id}.tsv")

    script:
        """
        make-paired-manifest.py ${sample_id} ${forward_reads} ${reverse_reads}
        """


}