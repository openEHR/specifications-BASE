rm docs/UML/classes/*.*
rm docs/UML/diagrams/*.*

../specifications-AA_GLOBAL/bin/uml_generate.sh -d svg -i {base_release} -r BASE -o docs/UML computable/UML/openEHR_UML-Base.mdzip
