process RENAME_TAXA_FILE {
    cpus 1
    memory "2 GB"
    container "MicroOceLab/python:1.0"
    publishDir "${params.results}/rename-taxa-file", mode: "copy"

    input:
        tuple val(id), val(taxa_file_directory)

    output:
        tuple val(id), path("${id}-taxa-file/")

    script:
        """          
        cp -r ${taxa_file_directory} ${id}-taxa-file
        
        for FILE in ${id}-taxa-file/*level*
        do
            mv \$FILE "\${FILE/level/${id}-level}"
        done
        """
}