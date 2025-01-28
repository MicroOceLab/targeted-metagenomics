process MAKE_MANIFEST {
    container "felixlohmeier/pandas:0.20.3"
    publishDir "${params.output}/1-data-prep"

    input:
        path ccs_read
    
    output:
        path "${ccs_read.baseName}.txt"

    script:
        """
        make-manifest.py ${ccs_read}
        """


}