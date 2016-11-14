#!/bin/bash

CAT=/bin/bzcat
POSTCONF1=/usr/share/man/man1/postconf.1.bz2
POSTCONF5=/usr/share/man/man5/postconf.5.bz2

###############################################################################

TEMP=/tmp/$(basename $0)-pfmaster-$$
trap -- "rm -f ${TEMP}" EXIT

[[ -x ${CAT} ]] || exit 1
[[ -f ${POSTCONF1} ]] || exit 1
[[ -f ${POSTCONF5} ]] || exit 1

cat > ${TEMP} << EOB
" Vim syntax file
" Language:     Postfix master.cf configuration
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
	awk '/^\.SH ([a-z0-9_]+).+/ { print "syntax keyword pfmasterConf "$2; }' \
	>> ${TEMP}

${CAT} ${POSTCONF5}| \
	awk 'match($0, /\\fItransport\\fR(_[a-z_]+) /, a) { print "syntax match pfmasterConf \""a[1]"\\>\"" }' \
	>> ${TEMP}

echo >> ${TEMP}

${CAT} ${POSTCONF5} | \
	awk '/^\.SH ([a-z0-9_]+).+/ { print "syntax match pfmasterRef \"$\\<"$2"\\>\""; }' \
	>> ${TEMP}

echo >> ${TEMP}

${CAT} ${POSTCONF5} | \
	awk 'match($0, /^\.IP \"\\fB([a-z0-9_]+) ?\\f[RI]/, a) { print "syntax keyword pfmasterWord "a[1]; }' \
	>> ${TEMP}

echo >> ${TEMP}

function paragraph() {
	${CAT} ${POSTCONF1} | \
		awk -v text="$3" 'BEGIN { s = 0 } {
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

paragraph "-m" "-M" "syntax keyword pfmasterDict"
echo >> ${TEMP}

paragraph "-a" "-A" "syntax keyword pfmasterSASLType"
echo >> ${TEMP}

paragraph "-l" "-m" "syntax keyword pfmasterLock"

cat >> ${TEMP} << EOB

syntax keyword pfmasterType	inet pass fifo unix
syntax keyword pfmasterQueueDir	incoming active deferred corrupt hold
syntax keyword pfmasterAnswer	yes no y n -
syntax keyword pfmasterOpt	-o -v -vv -vvv flags user argv

syntax match pfmasterComment	"#.*$"
syntax match pfmasterNumber	"\<\d\+\>"
syntax match pfmasterTime	"\<\d\+[hmsd]\>"
syntax match pfmasterIP		"\<\d\{1,3}\.\d\{1,3}\.\d\{1,3}\.\d\{1,3}\>"
syntax match pfmasterIP6	"\[\([0-9a-fA-F]\{0,4\}:\)\{1,7\}[0-9a-fA-F]\{0,4\}\]"
syntax match pfmasterVariable	"\$\w\+" contains=pfmasterRef
syntax match pfmasterVariable2	"\${\w\+}" contains=pfmasterConf

syntax match pfmasterService	"\<anvil\>"
syntax match pfmasterService	"\<bounce\>"
syntax match pfmasterService	"\<cleanup\>"
syntax match pfmasterService	"\<cyrus\>"
syntax match pfmasterService	"\<defer\>"
syntax match pfmasterService	"\<discard\>"
syntax match pfmasterService	"\<dnsblog\>"
syntax match pfmasterService	"\<error\>"
syntax match pfmasterService	"\<flush\>"
syntax match pfmasterService	"\<lmtp\>"
syntax match pfmasterService	"\<local\>"
syntax match pfmasterService	"\<oqmgr\>"
syntax match pfmasterService	"\<pickup\>"
syntax match pfmasterService	"\<pipe\>"
syntax match pfmasterService	"\<postdrop\>"
syntax match pfmasterService	"\<postscreen\>"
syntax match pfmasterService	"\<proxymap\>"
syntax match pfmasterService	"\<proxywrite\>"
syntax match pfmasterService	"\<qmgr\>"
syntax match pfmasterService	"\<qmqpd\>"
syntax match pfmasterService	"\<relay\>"
syntax match pfmasterService	"\<retry\>"
syntax match pfmasterService	"\<rewrite\>"
syntax match pfmasterService	"\<scache\>"
syntax match pfmasterService	"\<showq\>"
syntax match pfmasterService	"\<smtp\>"
syntax match pfmasterService	"\<smtps\>"
syntax match pfmasterService	"\<smtpd\>"
syntax match pfmasterService	"\<spawn\>"
syntax match pfmasterService	"\<submission\>"
syntax match pfmasterService	"\<tlsmgr\>"
syntax match pfmasterService	"\<tlsproxy\>"
syntax match pfmasterService	"\<trace\>"
syntax match pfmasterService	"\<trivial-rewrite\>"
syntax match pfmasterService	"\<verify\>"
syntax match pfmasterService	"\<virtual\>"

if version >= 508 || !exists("pfmaster_syntax_init")
	if version < 508
		let pfmaster_syntax_init = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	HiLink pfmasterConf		Statement
	HiLink pfmasterRef		PreProc
	HiLink pfmasterWord		Statement
	HiLink pfmasterOpt		PreProc

	HiLink pfmasterDict		Type
	HiLink pfmasterSASLType		Type
	HiLink pfmasterQueueDir		Constant
	HiLink pfmasterLock		Constant
	HiLink pfmasterAnswer		Special
	HiLink pfmasterType		Type

	HiLink pfmasterComment		Comment
	HiLink pfmasterNumber		Number
	HiLink pfmasterTime		Number
	HiLink pfmasterIP		Number
	HiLink pfmasterIP6		Number
	HiLink pfmasterVariable		Error
	HiLink pfmasterVariable2	PreProc
	HiLink pfmasterService		Include

	delcommand HiLink
endif

let b:current_syntax = "pfmaster"

" vim: ts=8 sw=2
EOB

awk '/^([[:blank:]]*|.*if .*|.*else(if| )?.*|.*endif.*)$/ { print; next; }; !seen[$0]++' ${TEMP} > pfmaster.vim

exit 0
