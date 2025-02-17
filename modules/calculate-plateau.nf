process CALCULATE_PLATEAU {
    container "MicroOceLab/python:1.0"
    publishDir "${params.output}/4-rarefy"

    input:
        val ccs_rarefaction_curve_exported
    
    output:
        env "rarefaction_plateau"

    script:
        """
        rarefaction_plateau = $(calculate-plateau.py ${ccs_exported_rarefaction_curve}/shannon.csv) 
        """


}