process CALCULATE_PLATEAU {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/09-calculate-plateau"

    input:
        val(rarefaction_curve_directory)
    
    output:
        stdout

    script:
        """
        echo `calculate-plateau.py ${rarefaction_curve_directory}/shannon.csv` 
        """


}