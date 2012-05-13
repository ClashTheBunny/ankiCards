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
	print "wordchars	[�-�] [�-�]";
	print "# �� �� ���� �������������� � ~/.ispell_default, ��� ���";
	print "# ��� ����������� ����, ��� ��� ������� ���������� � �����������";
	print "# (����. ���������) ����, ��������� ��� ������ �� �� ������������:";
	print "wordchars	[a-z] [A-Z]";
	print "";
	print "# ��� �������� ���������� �������� ���� ���� ��-����, ���-����";
	print "# ��� ��������-�������, �� ��������� ��� ������ �� �� ������������:";
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
