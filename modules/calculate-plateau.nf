process CALCULATE_PLATEAU {
    cpus 1
    container "MicroOceLab/python:1.0"
    publishDir "${params.results}/calculate-plateau"

    input:
        val(rarefaction_curve_directory)
    
    output:
        eval("echo \${PLATEAU}")

    script:
        """
        PLATEAU=`calculate-plateau.py ${rarefaction_curve_directory}/shannon.csv` 
        """


}