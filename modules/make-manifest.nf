process MAKE_MANIFEST {
    publishDir "${params.output}/1-data-prep"

    input:
        path ccs_read
    
    output:
        path "${ccs_read.baseName}.fasta"

    script:
        """
        """


}