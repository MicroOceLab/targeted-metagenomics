process MAKE_COMBINED_BAR_PLOT {
    cpus 8
    memory "8 GB"
    container "MicroOceLab/r:1.1"
    publishDir "${params.results}/make-combined-bar-plot", mode: "copy"

    input:
        tuple val(id), path(combined_taxa_file)
    
    output:
        tuple val(id), path("${id}-bar-plot.pdf")

    script:
        """
        make-combined-bar-plot.R ${id}-bar-plot ${params.bar_plot_width} ${params.bar_plot_height}
        """
}