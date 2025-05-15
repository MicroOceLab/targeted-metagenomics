process PREPARE_METADATA {
    cpus 2
    memory "2 GB"
    container "MicroOceLab/python:1.0"
    publishDir "${params.results}/prepare-metadata", mode: "copy"

    input:
        val(manifest_files)
    
    output:
        path("metadata.tsv")

    script:
        """
        mkdir manifest-files
        cp ${manifest_files} manifest-files/

        touch metadata.tsv
        cat manifest-files/`ls -U manifest-files | head -n 1` | sed -n '1 p' >> metadata.tsv
        for MANIFEST in ./manifest-files/*;
            do
                cat \${MANIFEST} | sed -n '2 p' >> metadata.tsv;
            done
        """

}