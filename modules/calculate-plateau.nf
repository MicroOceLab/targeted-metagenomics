process CALCULATE_PLATEAU {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/4-rarefy"

    input:
        val rarefaction_curve_exported
    
    output:
        env "rarefaction_plateau"

    script:
        """
        rarefaction_plateau=`calculate-plateau.py ${rarefaction_curve_exported}/shannon.csv` 
        """


}