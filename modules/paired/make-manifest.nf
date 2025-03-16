process MAKE_MANIFEST {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/01-make-manifest", mode: "copy"

    input:
        tuple val(sample_id), val(forward_reads), val(reverse_reads)
    
    output:
        tuple val(sample_id), path("${sample_id}.tsv")

    script:
        sample_id = sample_id.replaceAll("\\s","")

        """
        make-paired-manifest.py ${sample_id} ${forward_reads} ${reverse_reads}
        """


}