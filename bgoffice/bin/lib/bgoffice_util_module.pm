use strict;

####################
# Constants

# Path to data directory. It can be relative or absolute.
my $data_path = "../../data/";



####################
# Global variables used for cashing purposes.
# Data are loaded here and when some other subroutine
# needs of data just get them from these variables.

# Keep data file name.
my $data_file_name = "";

# Keep filter.
my $data_filter = "";

# Keep word's endings. Stripped data.
my @data_endings = ();

# Keep tests. Stripped data. All sectiona are loaded into one array
# and empty element is used as delimiter between different sections.
my @data_tests = ();

# Keep words. Data are not stripped.
# Because they must to be saved without comments and white spaces.
my @data_words = ();

# Keep path to the description.
my $description_file_name = "";

# Keep short description of forms without equal sign (=).
my @description_forms = ();

# Keep long description of forms with equal sign (=).
my @description_long_forms = ();

# Keep description name/group.
my $description_group = "";

# Keep path to all files in cashe.
my @cashed_file_names = ();




####################
# Subroutines

sub get_filter() {
	load_data(@_[0]);
	return $data_filter;
}

sub get_endings() {
	load_data(@_[0]);
	return @data_endings;
}

sub get_tests() {
	load_data(@_[0]);
	return @data_tests;
}

sub get_words() {
	load_data(@_[0]);
	return @data_words;
}

sub get_forms() {
	load_description(@_[0]);
	return @description_forms;
}

sub get_long_forms() {
	load_description(@_[0]);
	return @description_long_forms;
}

sub get_group() {
	load_description(@_[0]);
	return $description_group;
}


####################
# Return path and file name to specified type
# Param string : type can be 1, "001", "001a", etc.
# Return string: path to this file name
#
# Use:
# $file_name = get_file_name("1");
#
sub get_file_name() {
	my $file_name = @_[0];
	if ($file_name =~ /^\d[a-z]?$/) {
		$file_name = "00" . $file_name;
	} elsif ($file_name =~ /^\d\d[a-z]?$/) {
		$file_name = "0" . $file_name;
	}
	$file_name = "bg" . $file_name . ".dat";
	$file_name = find_file($data_path, $file_name);
	return $file_name;
}



####################
# Build forms based on endings for specified word
# Param string : word
# Param array  : endings
# Return array : with words
#
# Use:
# @w = build_forms($word, @endings);
#
sub build_forms() {
	my $w = @_[0];
	my $f = @_[1];
	my @result = ();
	my $root = $w;
	my $replace = "";
	if ($f =~ /(.*)\[(.+)\](.*)/) {
		$root = substr($w, 0, length($w) - length($1) - length($3) - 1);
		$replace = substr($w, 0 - length($3) - 1, 1);
	} elsif ($f ne "0") {
		$root = substr($w, 0, length($w) - length($f));
	}
	my $i = 0;
	for (@_) {
		if ($i < 2) {
			$i++;
			next;
		}
		if ($_ eq "-") {
			push(@result, "-");
			next;
		}
		my @sp = split(/,/, $_);
		my $st = "";
		for (@sp) {
			my $c = "";
			if ($_ ne "0") {
				$c = $_;
				$c =~ s/\?/$replace/;
			}
			if ($st ne "") {
				$st .= ",";
			}
			$st .= $root . $c;
		}
		push(@result, $st);
	}
	if ($#result < 0) {
		push(@result, $w);
	}
	return @result;
}



####################
# Load data for given file name and store data in cash or do
# nothing if data are already loaded
# Param string : path and file name
#
# Use:
# load_data($file_name);
#
sub load_data() {
	my $file_name = @_[0];
	if ($file_name ne $data_file_name) {
		$data_file_name = $file_name;
		open(IN, "<$file_name") || die "Cannot open $file_name";
		my @d;
		@d = <IN>;
		close(IN);
		chop(@d);
		my $l;
		my $i = 0;
		while ($i <= $#d) {
			$l = strip_line($d[$i]);
			if ($l eq "Окончания:") {
				last;
			}
			$i++;
		}
		$i++;
		@data_endings = ();
		while ($i <= $#d) {
			$l = strip_line($d[$i]);
			if (($l eq "Тест:") || ($l eq "Думи:")) {
				last;
			}
			if ($l ne "") {
				# if there is two or more entries divided by comma (,) we
				# delete all spaces that we may have inside text
				$l = remove_all_spaces($l);
				push(@data_endings, $l);
			}
			$i++;
		}
		if ($#data_endings < 0) {
			print "Грешка в $file_name на ред $i.\n"
			    . "Секцията <Окончания> трябва да съдържа един или повече елемента.\n"
			    . "Но няма намерени елементи.\n";
			die;
		}
		# Split filter in two parts
		my @sp = split(/,/, $data_endings[0]);
		$data_endings[0] = $sp[0];
		if ($sp[1]) {
			$data_filter = $sp[1];
		} else {
			$data_filter = $sp[0];
		}
		$i++;
		@data_tests = ();
		if ($l eq "Тест:") {
			my $j = 0;
			while ($i <= $#d) {
				$l = strip_line($d[$i]);
				if (($l eq "Тест:") || ($l eq "Думи:")) {
					my $el = $#data_endings + 1;
					if ($j != $el) {
						print "Грешка в $file_name на ред $i.\n"
						    . "Секцията <Тест> трябва да съдържа точно толкова елемента колкото <Окончания>.\n"
						    . "Секцията <Тест> съдържа $j елемента а трябва да съдържа $el.\n";
						die;
					}
					if ($l eq "Думи:") {
						last;
					}
					$j = 0;
				} elsif ($l ne "") {
					# if there is two or more entries divided by comma (,) we
					# delete all spaces that we may have inside text
					$l = remove_all_spaces($l);
					push(@data_tests, $l);
					$j++;
				}
				$i++;
			}
			$i++;
		}
		@data_words = ();
		while ($i <= $#d) {
			$l = strip_line($d[$i]);
			if ($l ne $d[$i]) {
				print "Грешка в $file_name на ред $i.\n"
				    . "Думата <$d[$i]> съдържа коментари или празни символи в началото или края.\n"
				    . "Думата трябва да изглежда така <$l>.\n";
				die;
			}
			if ($l ne "") {
				my @sp = split(/ /, $l);
				my $wrd = "";
				for (@sp) {
					push(@data_words, $_ . $wrd);
					if ($wrd eq "") {
						$wrd = $_;
					}
				}
			} else {
				print "Грешка в $file_name на ред $i.\n"
				    . "Секцията <Думи> има празен ред.\n"
				    . "Това е недопустимо.\n";
				die;
			}
			$i++;
		}
		@data_words = sort(@data_words);
	}
}



####################
# Return true if the description for given file name is the same
# as description for previous file name, else return false.
# Param string  : path and file name
# Return boolean: 1 (true) or 0 (false)
#
# Use:
# is_the_same_description($file_name);
#
sub is_the_same_description() {
	my $file_name = @_[0];
	$file_name =~ s/bg\d\d\d(.*)\.dat$//;
	$file_name .= "description.dat";
	return ($file_name eq $description_file_name);
}



####################
# Load description information for given file name and store
# data in cash or do nothing if data are already loaded
# Param string : path and file name
#
# Use:
# load_description($file_name);
#
sub load_description() {
	my $file_name = @_[0];
	$file_name =~ s/bg\d\d\d(.*)\.dat$//;
	$file_name .= "description.dat";
	if ($file_name ne $description_file_name) {
		$description_file_name = $file_name;
		open(IN, "<$file_name")  || die "Cannot open $file_name";
		my @d;
		@d = <IN>;
		close(IN);
		chop(@d);
		my $l;
		my $i = 0;
		while ($i <= $#d) {
			$l = strip_line($d[$i]);
			if ($l eq "Група:") {
				last;
			}
			$i++;
		}
		$i++;
		$description_group = "";
		while ($i <= $#d) {
			$l = strip_line($d[$i]);
			if ($l eq "Форми:") {
				last;
			}
			if ($l ne "") {
				if ($description_group eq "") {
					$description_group = $l;
				} else {
					print "Грешка в $file_name на ред $i.\n"
					    . "Секцията <Група> трябва да съдържа точно един елемент.\n"
					    . "Но има намерени повече от един елемента.\n";
					die;
				}
			}
			$i++;
		}
		if ($description_group eq "") {
			print "Грешка в $file_name на ред $i.\n"
			    . "Секцията <Група> трябва да съдържа точно един елемент.\n"
			    . "Но няма намерени елементи.\n";
			die;
		}
		$i++;
		@description_forms = ();
		while ($i <= $#d) {
			$l = strip_line($d[$i]);
			if ($l ne "") {
				push(@description_long_forms, $l);
				if ($l !~ /=/) {
					push(@description_forms, $l);
				}
			}
			$i++;
		}
		if ($#description_forms < 0) {
			print "Грешка в $file_name на ред $i.\n"
			    . "Секцията <Форми> трябва да съдържа един или повече елемента.\n"
			    . "Но няма намерени елементи.\n";
			die;
		}
	}
}



####################
# Return path and file name to the next file in the list
# List is something like that:
#   001, [001a, [[001b, ..., 001z]]], 002, [002a ... 002z]
# Param string : previous file name or empty string,
#                to start from the beggining
# Return string: path and file name to the next file
#                if exist, else empty string
#
# Use:
# $f = "";
# while ($r = next_file($f)) {
#	print "Next file is $f\n";
# }
#
sub next_file() {
	my $current_file = @_[0];
	my $file_name;
	my $ch;
	my $num;
	if ($current_file) {
		if ($current_file =~ /bg\d\d\d\.dat$/) {
			$num = substr($current_file, -7, 3);
			$ch = "a";
		} else {
			$num = substr($current_file, -8, 3);
			$ch = substr($current_file, -5, 1);
			$ch = chr(ord($ch) + 1);
		}
		$file_name = $num . $ch;
		$num++;
	} else {
		$file_name = "001";
	}
	$file_name = "bg" . $file_name . ".dat";
	$file_name = find_file($data_path, $file_name);
	if (!$file_name) {
		$file_name = "bg" . $num . ".dat";
		$file_name = find_file($data_path, $file_name);
	}
	return $file_name;
}



####################
# This function act as wrapper of find command.
# As starting every time a new find process is to slow
# this functions starts find only once then cashe result
# and use cashed result to return data.
# This function is only for internal use from this module
# and it use @cashed_file_names to store data.
#
# Use:
# $file_name = find_file($data_path, $file_name);
#
sub find_file() {
	my $data_path = @_[0];
	my $file_name = @_[1];
#	my $fn = `find $data_path -name $file_name`;
#	chop($fn);
#	return $fn;
	if ($#cashed_file_names < 0) {
		@cashed_file_names = `find $data_path -name 'bg*.dat'`;
		chop(@cashed_file_names);
	}
	my $f = $file_name;
	for my $fn (@cashed_file_names) {
		if ($fn =~ /$f$/) {
			return $fn;
		}
	}
	return "";
}



####################
# Remove comments and leading and trailing spaces
# Param string : line to strip
# Return string: text only if exist, else empty string
#
# Use:
# $l = strip_line($l);
#
sub strip_line() {
	my $line = @_[0];
	$line =~ s/\#.*?$//g;         # remove Perl style comments
	$line =~ s/^\s*(.*?)\s*$/$1/; # trim leading and trailing spaces
	return $line;
}



####################
# Remove all spaces that we may have inside text
# Param string : line
# Return string: text only if exist, else empty string
#
# Use:
# $l = strip_line($l);
#
sub remove_all_spaces() {
	my $line = @_[0];
	$line =~ s/\s//g;             # remove spaces inside text
	return $line;
}



return 1;
