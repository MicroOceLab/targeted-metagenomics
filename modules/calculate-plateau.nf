process CALCULATE_PLATEAU {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/calculate-plateau"

    input:
        val(rarefaction_curve_directory)
    
    output:
        eval("echo \${PLATEAU}")

    script:
        """
        PLATEAU=`calculate-plateau.py ${rarefaction_curve_directory}/shannon.csv` 
        """


}