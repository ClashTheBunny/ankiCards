#!/usr/bin/awk -f
#
# Provided by Anton Zinoviev <anton@lml.bas.bg>
#

BEGIN {
	print "#   Affix table for Bulgarian";
	print "";
	print "nroffchars	().\\\\*";
	print "texchars	()\\[]{}<\\>\\\\$*.%";
	print "";
	print "allaffixes	off";
	print "compoundwords	off";
	print "";
	print "flagmarker	/";
	print "";
	print "wordchars	[а-я] [А-Я]";
	print "# За да няма несъвместимост с ~/.ispell_default, ако там";
	print "# има небългарски думи, или ако речника разпознава и небългарски";
	print "# (напр. английски) думи, следващия ред трябва да се разкоментира:";
	print "wordchars	[a-z] [A-Z]";
	print "";
	print "# Ако речникът разпознава съставни думи като по-бърз, най-бърз";
	print "# или кандидат-студент, то следващия ред трябва да се разкоментира:";
	print "# boundarychars	\"-\"";
	print "";
	print "suffixes";
}

/SFX/ {
	if (($1 != "MAP") && ($1 != "REP")) {
		if ($5 == "") {
			flag=$2;
			print "";
			if ($3 == "Y") {
				printf "flag *%s:\n", flag;
			} else {
				printf "flag ~%s:\n", flag;
			}
		}
		if ($5 != "") {
			strip_str = "-" cyrtoupper($3) ",";
			if (strip_str == "-0,") {
				strip_str = "";
			}
			append_str = cyrtoupper($4);
			if (append_str == "0") {
				append_str = "-";
			}
			condition = $5;
			if ((condition == "." && $3 != "0") || (condition != ".")) {
				if (condition == ".") {
					condition = cyrtoupper($3);
				}
				gsub (/./, "& ", condition);
			}
			printf "    %-8s >      %s%s\n", condition, strip_str, append_str;
		}
	}
}

function cyrtoupper(str,   new) {
	new = str;
	for (i = 224; i < 256; i++) {
		gsub (sprintf ("%c", i), sprintf ("%c", i - 32), new);
	}
	return new;
}
