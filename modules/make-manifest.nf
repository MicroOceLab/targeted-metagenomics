process MAKE_MANIFEST {
    publishDir "${params.output}/tracy-align"

    input:
        path ccs_read
    
    output:
        path "${ccs_read.baseName}.fasta"

    script:
        """
        """


}