#!/bin/bash

POSTCONF1=/usr/share/man/man1/postconf.1.bz2
POSTCONF5=/usr/share/man/man5/postconf.5.bz2

###############################################################################

TEMP=/tmp/$(basename $0)-pfmain-$$
trap -- "rm -f ${TEMP}" EXIT

function error() {
	echo "${1}"
	exit 1
}

[[ -f ${POSTCONF1} ]] || error "'postconf(1)' not found"
[[ -f ${POSTCONF5} ]] || error "'postconf(5)' not found"

FILETYPE=$(file -b ${POSTCONF1} | cut -d " " -f 1)
case "${FILETYPE}" in
	gzip)
		CAT=$(which zcat)
		;;
	bzip2)
		CAT=$(which bzcat)
		;;
	*)
		CAT=$(which cat)
		;;
esac
[[ -x "${CAT}" ]] || error "'cat', 'zcat' or 'bzcat'  not found"

AWK=$(which gawk)
[[ -x "${AWK}" ]] || error "'gawk' not found"

cat > ${TEMP} << EOB
" Vim syntax file
" Language:     Postfix main.cf configuration
" Maintainer:   Christian Roessner <cr@sys4.de>
" Last Change:  2016 Nov 13
" Version:      0.40
" Comment:      Auto-generated

if version < 600
        syntax clear
elseif exists("b:current_syntax")
        finish
endif

if version >= 600
        setlocal iskeyword=@,48-57,_,-
else
        set iskeyword=@,48-57,_,-
endif

syntax case match
syntax sync minlines=1

EOB

${CAT} ${POSTCONF5} | \
	${AWK} '/^\.SH ([a-z0-9_]+).+/ { print "syntax keyword pfmainConf "$2 }' \
	>> ${TEMP}

${CAT} ${POSTCONF5}| \
	${AWK} 'match($0, /\\fItransport\\fR(_[a-z_]+) /, a) { print "syntax match pfmainConf \""a[1]"\\>\"" }' \
	>> ${TEMP}

echo >> ${TEMP}

${CAT} ${POSTCONF5} | \
	${AWK} '/^\.SH ([a-z0-9_]+).+/ { print "syntax match pfmainRef \"$\\<"$2"\\>\"" }' \
	>> ${TEMP}

echo >> ${TEMP}

${CAT} ${POSTCONF5} | \
	${AWK} 'match($0, /^\.IP \"\\fB([a-z0-9_]+) ?\\f[RI]/, a) { print "syntax keyword pfmainWord "a[1] }' \
	>> ${TEMP}

echo >> ${TEMP}

function paragraph() {
	${CAT} ${POSTCONF1} | \
		${AWK} -v text="$3" 'BEGIN { s = 0 } {
			if (s == 0) {
				if ($0 ~ /\.IP \\fB\\\'"${1}"'\\fR/) { 
					s = 1;
				} 
			} else {
				if ($0 ~ /\.IP \\fB\\\'"${2}"'\\fR/) {
					exit;
				}
				if (match($0, /^\.IP \"?\\fB([a-z]+)\\fR\"?/, a)) { 
					print text, a[1]
				}
			} 
		}' >> ${TEMP}
}

paragraph "-m" "-M" "syntax keyword pfmainDict"
echo >> ${TEMP}

paragraph "-a" "-A" "syntax keyword pfmainSASLType"
echo >> ${TEMP}

paragraph "-l" "-m" "syntax keyword pfmainLock"

cat >> ${TEMP} << EOB

syntax keyword pfmainQueueDir	incoming active deferred corrupt hold
syntax keyword pfmainTransport	smtp lmtp unix local relay uucp virtual
syntax keyword pfmainAnswer	yes no

syntax match pfmainComment	"#.*$"
syntax match pfmainNumber	"\<\d\+\>"
syntax match pfmainTime		"\<\d\+[hmsd]\>"
syntax match pfmainIP		"\<\d\{1,3}\.\d\{1,3}\.\d\{1,3}\.\d\{1,3}\>"
syntax match pfmainVariable	"\$\w\+" contains=pfmainRef
syntax match pfmainVariable2	"\${\w\+}" contains=pfmainConf

syntax match pfmainSpecial	"\<alias\>"
syntax match pfmainSpecial	"\<canonical\>"
syntax match pfmainSpecial	"\<command\>"
syntax match pfmainSpecial	"\<file\>"
syntax match pfmainSpecial	"\<forward\>"
syntax match pfmainSpecial	"\<noanonymous\>"
syntax match pfmainSpecial	"\<noplaintext\>"
syntax match pfmainSpecial	"\<resource\>"
syntax match pfmainSpecial	"\<software\>"

syntax match pfmainSpecial	"\<bounce\>"
syntax match pfmainSpecial	"\<cleanup\>"
syntax match pfmainSpecial	"\<cyrus\>"
syntax match pfmainSpecial	"\<defer\>"
syntax match pfmainSpecial	"\<error\>"
syntax match pfmainSpecial	"\<flush\>"
syntax match pfmainSpecial	"\<pickup\>"
syntax match pfmainSpecial	"\<postdrop\>"
syntax match pfmainSpecial	"\<qmgr\>"
syntax match pfmainSpecial	"\<rewrite\>"
syntax match pfmainSpecial	"\<scache\>"
syntax match pfmainSpecial	"\<showq\>"
syntax match pfmainSpecial	"\<trace\>"
syntax match pfmainSpecial	"\<verify\>"

if version >= 508 || !exists("pfmain_syntax_init")
	if version < 508
		let pfmain_syntax_init = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	HiLink pfmainConf	Statement
	HiLink pfmainRef	PreProc
	HiLink pfmainWord	Statement

	HiLink pfmainDict	Type
	HiLink pfmainSASLType	Type
	HiLink pfmainQueueDir	Constant
	HiLink pfmainTransport	Constant
	HiLink pfmainLock	Constant
	HiLink pfmainAnswer	Constant

	HiLink pfmainComment	Comment
	HiLink pfmainNumber	Number
	HiLink pfmainTime	Number
	HiLink pfmainIP		Number
	HiLink pfmainVariable	Error
	HiLink pfmainVariable2	PreProc
	HiLink pfmainSpecial	Special

	delcommand HiLink
endif

let b:current_syntax = "pfmain"

" vim: ts=8 sw=2
EOB

${AWK} '/^([[:blank:]]*|.*if .*|.*else(if| )?.*|.*endif.*)$/ { print; next; }; !seen[$0]++' ${TEMP} > pfmain.vim

exit 0
