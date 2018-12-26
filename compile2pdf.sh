#!/bin/bash
function compile2pdf() {
	echo -e "\e[33mScanning $1\e[39m"

	for i in "$1/"*; do
		if [ -d "$i" ]; then
			if [ "$i" != ".git" ]; then
				compile2pdf $i
			fi			
		elif [ ${i: -4} == ".tex" ]; then
			newFile="$(echo $i | sed -e "s/src/docs/g" | sed -e "s/\.tex/\.pdf/g")"

			if [ ! -d "$(echo $1 | sed -e "s/src/docs/g")" ]; then
				mkdir -p "$(echo $1 | sed -e "s/src/docs/g")"
			fi

			if [ ! -e "$newFile" ] || [ "$newFile" -ot "$i" ]; then
				echo -e "\e[32mCompiling $i to $newFile\e[39m"
				# Double compilation (useful with some commands)
				pdflatex -output-directory "$(echo $1 | sed -e "s/src/docs/g")" "$i"
				pdflatex -output-directory "$(echo $1 | sed -e "s/src/docs/g")" "$i"
			else
				echo -e "\e[91m$newFile is already at the latest version\e[39m"
			fi
		fi
	done
}

compile2pdf "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )/src"