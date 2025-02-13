process MAKE_MANIFEST {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/1-data-prep"

    input:
        path ccs_read
    
    output:
        path "${ccs_read.baseName}.tsv"

    script:
        """
        make-manifest.py ${projectDir} ${ccs_read}
        """


}