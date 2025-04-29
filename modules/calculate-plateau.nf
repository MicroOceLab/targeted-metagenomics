process CALCULATE_PLATEAU {
    cpus 1
    memory "2 GB"
    container "MicroOceLab/python:1.0"
    publishDir "${params.results}/calculate-plateau"

    input:
        tuple val(id), val(rarefaction_curve_directory)
    
    output:
        eval("echo \${PLATEAU}")

    script:
        """
        PLATEAU=`calculate-plateau.py ${rarefaction_curve_directory}/shannon.csv` 
        """


}