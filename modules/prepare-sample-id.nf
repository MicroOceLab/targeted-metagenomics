process PREPARE_SAMPLE_ID {
    input:
        val(reads)
    
    output:
        stdout, val(reads)

    script:
        """
        echo `prepare-sample-id.py ${reads}`
        """


}