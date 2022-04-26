#!/bin/bash

# -----------------------------------------------------------------------------------------------------
#   extract a variable definition from a larger terraform file.  write the single definition to a temp
#   file that will be processed by the caller.
# -----------------------------------------------------------------------------------------------------
extract_variable () {
    target=${1}
    variablesList=${2}
    outputFile=${3}/temp.var

    echo "searching for ${target} within file ${file}"

    while read -r line1; do
        if grep -q "$target" <<< "$line1" ; then
            echo ${line1} > $outputFile
 
            done=false
            while [ ${done} = false ] ; do
                read -r line2
                if [[ "${line2}" = *"}"* ]] ; then
                    echo "}" >> $outputFile
                    echo >> $outputFile
                    done=true
                else
                    echo "   ${line2}" >> $outputFile    
                fi
            done
            break    
        fi
    done <${variablesList}
}    

# -----------------------------------------------------------------------------------------------------
#   generaate a variables.tf file that is a consolidation of the variables defined in the BOMs in the
#   the auto.tfvars files.
# -----------------------------------------------------------------------------------------------------
generate_variables_tf () {
    SOLUTION_DIR=${1}
    echo "generating variables.tf file - ${SOLUTION_DIR}"

    BOMS=($(find "${SOLUTION_DIR}" -type d -maxdepth 1 | grep "${SOLUTION_DIR}/" | sed -E "s~${SOLUTION_DIR}/~~g" | sort ))
    if [ ${#BOMS[@]} == 0 ] ; then
        echo "No BOMS found - returning"
    else
        echo ${BOMS[@]}
        variables_tf=${SOLUTION_DIR}/"variables.tf"
        touch ${variables_tf}
        variables_tf_combined=${SOLUTION_DIR}/"variables.tf.combined"
        touch ${variables_tf_combined}

        # combine all of the *.auto.tfvar files from the flavors into one file
        touch ${variables_tf}.1
        for bom in "${BOMS[@]}"; do
            echo "BOM = ${bom}";
            cat ${SOLUTION_DIR}/${bom}/terraform/${bom}.auto.tfvars >> ${variables_tf}.1
            cat ${SOLUTION_DIR}/${bom}/terraform/variables.tf >> ${variables_tf_combined} 
        done

        # remove lines that begin with ##
        sed '/^##/ d' < ${variables_tf}.1 >${variables_tf}.2

        # remove blank lines
        sed '/^[[:space:]]*$/d' <${variables_tf}.2 >${variables_tf}.3

        # remove the beginning '#' character
        sed 's/^#//g' <${variables_tf}.3 >${variables_tf}.4

        # sort the file and remove duplicate lines
        sort ${variables_tf}.4 | uniq >${variables_tf}.5

        # remove all chars starting at =“ to the end of the line
        sed 's~=".*~~' < ${variables_tf}.5 >${variables_tf}.6

        # read the condensed variables file line by line and find the definition in the combined
        # variables file.  Write the definition to the variables.tf file
        file=${variables_tf}.6
        while read -r line; do
            # go find this variable in the combined file
            extract_variable ${line} ${variables_tf_combined} ${SOLUTION_DIR}

            cat ${SOLUTION_DIR}/temp.var >>${variables_tf}
            rm ${SOLUTION_DIR}/temp.var
        done <$file 

        # clean up temp files
        rm ${variables_tf}.?
        rm ${variables_tf_combined}
    fi
}

# ----------------------------------------------------------------------------------------------------------
#   insert terrafrom that invokes the module serializer code.  do this inbetween BOMs so that they wait for 
#   each one to finish before the next one runs.
# ----------------------------------------------------------------------------------------------------------
insert_module_serializer () {
    dependent=${1}
    outputFile=${2}

    echo "module \"module-serializer-${bom}\" {" >>${outputFile}
    echo "    source = \"./module-serializer\"" >>${outputFile}
    echo "    region = var.region" >>${outputFile}
    echo "    depends_on = [module.${bom}]" >>${outputFile}
    echo "}" >>${outputFile}
    echo "" >>${outputFile}
} 

# -----------------------------------------------------------------------------
#   generate the main.tf file based on the BOM directories that are present.
# -----------------------------------------------------------------------------
generate_main_tf () {
    SOLUTION_DIR=${1}
    CATALOG_NAME=${2}
    VERSION=${3}

    echo "generating main.tf file - ${SOLUTION_DIR}"
    
    BOMS=($(find "${SOLUTION_DIR}" -type d -maxdepth 1 | grep "${SOLUTION_DIR}/" | sed -E "s~${SOLUTION_DIR}/~~g" | sort ))
    if [ ${#BOMS[@]} == 0 ] ; then
        echo "No BOMS found - returning"
    else
        echo ${BOMS[@]}
        output=${SOLUTION_DIR}/"main.tf"

        # to assit with lookup of offerings by programmatic name get a listing from the catalog of all of its 
        # offerings and save it so that we do not do it more than once.
        ibmcloud catalog offerings  --catalog "${CATALOG_NAME}" --output json > catalog.json

        for bom in "${BOMS[@]}"; do
            echo "BOM = ${bom}";

            autoTFvars=${SOLUTION_DIR}/${bom}/terraform/${bom}.auto.tfvars

            echo "module \"${bom}\" {" >> $output
            NAME="${bom}"
            # lookup a version of an offering by its programatic name and version to get its catalog source url
            SOURCE_URL=`cat catalog.json | jq -r --arg name "${NAME}" --arg version "${VERSION}" '.resources[] | select(.name==$name).kinds[] | select(.format_kind=="terraform").versions[] | select(.version==$version).metadata.source_url'`
            echo "source=${SOURCE_URL}"
            echo "   source = \"${SOURCE_URL}\"" >>$output
            
            # insert module variables using the auto.tfvars file from the BOM
            while read -r line1; do
                if [[ "${line1}" = "##"* ]] ; then
                    echo "   ${line1}" >>$output
                else
                    # remove leading '#' 
                    lineout=$(sed 's/^#//g' <<<${line1})

                    variableName=$(sed 's~=".*~~' <<<${lineout})
                    if [[ "${lineout}" = *"=\"\"" ]] ; then
                        echo "   ${variableName} = ""var.""${variableName}" >> $output
                    else
                        echo "   ${lineout}" >>$output
                    fi     
                fi    
            done <${autoTFvars}
            echo "}" >>$output
            echo "" >>$output

            insert_module_serializer ${bom} ${output}
        done    
    fi
}

# --------------------------------------------------------------------------
#   generate the files that make up the module serializer terraform code
# --------------------------------------------------------------------------
generate_module_serializer () {
    # save where we start this run.
    current_dir=$PWD

    SOLUTION_DIR=${1}
    echo "generating module serializer - ${SOLUTION_DIR}"

    mkdir -p "${SOLUTION_DIR}/module-serializer"
    cd "${SOLUTION_DIR}/module-serializer"

    # create outputs.tf file
    output="./outputs.tf"
    echo "output \"region\" {" >>$output
    echo "    value = var.region" >>$output
    echo "}" >>$output

    # create variables.tf file
    output="./variables.tf"
    echo "variable \"region\" {" >>$output
    echo "    type = string" >>$output
    echo "    description = \"The region where resources will be/has been provisioned.\" " >>$output
    echo "}" >>$output

    # change back to directory where we started
    cd ${current_dir}
}

# ---------------------------------------------------------------------------------------------------
# begin main
#   $1 - the repo root directory name where a directory names "automation" exists with the flavors 
#   $2 - target catalog name
#   $3 - version string 
# ---------------------------------------------------------------------------------------------------

ROOT_DIR=${1}/automation
CATALOG_NAME=${2}
VERSION=${3}
echo "Running from directory" $ROOT_DIR ; echo ""

FLAVORS=($(find "${ROOT_DIR}" -type d -maxdepth 1 | grep "${ROOT_DIR}/" | sed -E "s~${ROOT_DIR}/~~g" | sort ))

if [ ${#FLAVORS[@]} == 0 ] ; then
    echo "No FLAVORS found - exiting"
fi   

for flavor in "${FLAVORS[@]}"; do
    echo "FLAVOR = ${flavor}";

    # create variables.tf
    generate_variables_tf "${ROOT_DIR}/${flavor}"

    # create main.tf
    generate_main_tf "${ROOT_DIR}/${flavor}" "${CATALOG_NAME}" "${VERSION}"

    # create the module serializer terraform
    generate_module_serializer "${ROOT_DIR}/${flavor}"

    echo " "
done
echo "Done"