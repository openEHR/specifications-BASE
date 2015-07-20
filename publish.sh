#!/bin/bash

#
# ============== Definitions =============
#
USAGE="${0} [-hlpt] : generate publishing outputs; HTML by default 
  -h : output this help										
  -l : use local CSS, etc resources directory
  -p : generate PDF as well								
  -t : generate debug trace of asciidoctor-pdf back-end.
"
# if launched from inside spec-publish-asciidoc git clone area, we don't need to cd out to get
# the resources; if in any other repo, we do. This is complicated by the need to make the directories
# work not just in a normal file system, but on Github, which doesn't appear to see the repo root
# points as being inside a 'directory'
year=`date +%G`
stylesheet=openehr.css
pdf_theme=openehr_full_pdf-theme.yml
master_doc_name=master.adoc
resources_git_repo_name=spec-publish-asciidoc
use_local_resources=false
uml_export_dir=../UML

# directory of specifications-BASE it clone, relative to a document in another repo
base_dir=../../../specifications-BASE

#
# ============== functions =============
#

run_asciidoctor () {
	out_file=${1}.html

	# work out the options
	opts="-a current_year=$year \
		-a resources_dir=$resources_dir \
		-a base_dir=$base_dir \
		-a stylesdir=$stylesdir \
		-a stylesheet=$stylesheet \
		-a uml_export_dir=$uml_export_dir \
		--out-file=$out_file"

	asciidoctor ${opts} $2
	echo generated $(pwd)/$out_file
}

run_asciidoctor_pdf () {
	out_file=${1}.pdf

	# work out the options
	opts="-a current_year=$year \
		-a stylesdir=$stylesdir \
		-a resources_dir=$resources_dir \
		-a base_dir=$base_dir \
		-a uml_export_dir=$uml_export_dir \
		-a pdf-style=$pdf_theme \
		-a pdf-stylesdir=$resources_dir \
		-r asciidoctor-pdf -b pdf \
		--out-file=$out_file"

	# -a pdf-fontsdir=path/to/fonts 
	if [ "$pdf_trace" = true ]; then
		opts="${opts} --trace"
	fi

	asciidoctor ${opts} $2
	echo generated $(pwd)/$out_file
}

# run a command in a standard way
# $1 = command string
do_cmd () {
	echo "------ Running: $1"
	eval $1 2>&1
}

usage() { echo "$USAGE" 1>&2; exit 1; }
#
# ================== main =================
#
while getopts "hlpt" o; do
    case "${o}" in
        l)
            use_local_resources=true
            ;;
        p)
            gen_pdf=true
            ;;
        t)
            pdf_trace=true
            ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# determine whether to use local resources files (this Git repo) or the ones in
# spec-asciidoc-publish
if [[ "$(basename $(pwd))" != "$resources_git_repo_name" && "$use_local_resources" != true ]]; then
	resources_git_cd=../$resources_git_repo_name/
fi
resources_dir=../../${resources_git_cd}resources ## relative to doc dirs 2 level down
stylesdir=${resources_dir}/css

# ---------- do the publishing ----------
topdir=${PWD}
find docs -name $master_doc_name | \
while read docpath
do
	docdir=$(dirname $docpath)
	docname=$(basename $docdir)
	echo ---------------------- publishing $docname ----------------------
	olddir=$(pwd)
	cd $docdir
	run_asciidoctor ${docname} $master_doc_name
	if [[ "$gen_pdf" = true ]]; then
		run_asciidoctor_pdf ${docname} $master_doc_name
	fi
	cd $olddir
done
