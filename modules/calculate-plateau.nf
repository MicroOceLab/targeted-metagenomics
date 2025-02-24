process CALCULATE_PLATEAU {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/4-rarefy"

    input:
        tuple val(sample_id), val(rarefaction_curve_exported)
    
    output:
        tuple val(sample_id), env("rarefaction_plateau")

    script:
        """
        rarefaction_plateau=`calculate-plateau.py ${rarefaction_curve_exported}/shannon.csv` 
        """


}