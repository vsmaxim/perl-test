#!/usr/bin/perl
use Cwd;
use lib getcwd();
use AutoList;
use strict;
use warnings;

my $auto_handler = AutoList->new();

if (@ARGV == 1) {
	# test.pl -v
	$auto_handler->view;
} elsif (@ARGV == 4) {
	# test.pl -a /home/smth/images/pts.img 12.05.1998 13.09.2005
	$auto_handler->add(qq("$ARGV[1]"), $ARGV[2], $ARGV[3]);
} elsif (@ARGV == 3) {
	# test.pl -v 12.05.1998 13.09.2005
	$auto_handler->periodic_check($ARGV[1], $ARGV[2]);
}
