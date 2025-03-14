process PREPARE_SAMPLE_ID {
    input:
        val(reads)
    
    output:
        tuple val("${reads.baseName}"), val(reads)

    script:
        """
        """


}