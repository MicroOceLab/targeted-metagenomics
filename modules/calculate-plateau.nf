process CALCULATE_PLATEAU {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/07-calculate-plateau"

    input:
        tuple val(sample_id), val(rarefaction_curve_exported)
    
    output:
        tuple val(sample_id), stdout

    script:
        """
        echo `calculate-plateau.py ${rarefaction_curve_exported}/shannon.csv` 
        """


}