#!/bin/bash


if (test "$1" = "--verbose"); then
	echo "Checking Permissible Chars..."
fi
perl check_permissible_chars.pl $1


if (test "$1" = "--verbose"); then
	echo "Checking Endings Aginst Forms..."
fi
perl check_endings_aginst_forms.pl $1


if (test "$1" = "--verbose"); then
	echo "Checking Test Cases..."
fi
perl check_test_cases.pl $1


if (test "$1" = "--verbose"); then
	echo "Checking Words Aginst Filter..."
fi
perl check_words_aginst_filter.pl $1
