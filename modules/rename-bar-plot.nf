process RENAME_BAR_PLOT {
    cpus 1
    container "MicroOceLab/python:1.0"
    publishDir "${params.results}/rename-bar-plot", mode: "copy"

    input:
        tuple val(id), val(bar_plot_directory)

    output:
        tuple val(id), path("${id}-taxa-bar-plot-renamed/")

    script:
        """          
        cp -r ${bar_plot_directory} ${id}-taxa-bar-plot-renamed
        
        for FILE in ${id}-taxa-bar-plot-renamed/*level*
        do
            mv \$FILE "\${FILE/level/${id}-level}"
        done
        """
}