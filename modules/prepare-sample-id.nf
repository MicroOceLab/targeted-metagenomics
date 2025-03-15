process PREPARE_SAMPLE_ID {
    input:
        val(reads)
    
    output:
        tuple stdout, val(reads)

    script:
        """
        echo `prepare-sample-id.py ${reads}`
        """
}