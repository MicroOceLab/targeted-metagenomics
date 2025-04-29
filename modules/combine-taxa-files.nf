process COMBINE_TAXA_FILES {
    cpus 12
    container "MicroOceLab/r:1.1"
    publishDir "${params.results}/combine-taxa-files", mode: "copy"

    input:
        tuple val(id), val(taxa_files)
    
    output:
        tuple val(id), path("${id}-taxa-file.csv")

    script:
        """
        mkdir ${id}-taxa-file
        cp ${taxa_files} ${id}-taxa-file/

        combine-taxa-files.R ${id}-taxa-file ${params.taxa_level} ${params.taxa_limit}
        """
}