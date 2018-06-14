#!/usr/bin/perl

package AutoList {
	use DBI;
	use DateTime;
	use DateTime::Format::Strptime;
	use strict;
	use warnings;
	sub new {
		my $driver = "SQLite";
		my $database = "test.db";
		my $dsn = "DBI:$driver:$database";
		my $userid = "";
		my $password = "";
		my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1}) or die $DBI::errstr;
		my $run = $dbh->do(qq(
		CREATE TABLE IF NOT EXISTS AUTO (
			ID INTEGER PRIMARY KEY AUTOINCREMENT,
			SCAN_PATH CHAR(100) NOT NULL,
			RELEASE INT NOT NULL,
			EXPIRE INT NOT NULL
		);
		));
		my($class) = shift;
		my $self = {
			dbh => $dbh,
		};	
		bless $self, $class;
	}
	
	sub view {
		# View all entries of table
		my $self = shift;
		my $query = qq(SELECT ID, SCAN_PATH, RELEASE, EXPIRE
	       		from AUTO;);
		$self->fetch_query($query);
	}
	sub add {
		# Add new auto into the table
		# @_[0] - path to img
		# @_[1] - release date
		# @_[2] - expire date
		my $self = shift();
		my $rdate = date_from_str($_[1])->epoch();
		my $edate = date_from_str($_[2])->epoch();
		my $query = qq(
			INSERT INTO AUTO (SCAN_PATH, RELEASE, EXPIRE)
			VALUES ($_[0], $rdate, $edate);
		);
		my $run = $self->{dbh}->do($query);
		return !($run < 0);
	}
	sub date_from_str {
		# Get DateTime object from str like '19.12.1999'
		my @date = split(/[\.:]/, $_[0]);
		return DateTime->new(
			year => $date[2],
			month => $date[1],
			day => $date[0],
		);
	}
	sub periodic_check {
		# Check if auto was in expluatation
		# @_[0] - left date
		# @_[1] - right date
		my $self = shift;
		my $ld = date_from_str($_[0])->epoch();
		my $rd = date_from_str($_[1])->epoch();
		my $query = qq(
			SELECT ID, SCAN_PATH, RELEASE, EXPIRE 
			FROM AUTO
			WHERE RELEASE BETWEEN $ld AND $rd  OR
			EXPIRE BETWEEN $ld AND $rd OR
			$rd BETWEEN RELEASE AND EXPIRE;
		);	
		$self->fetch_query($query);
	}
	sub fetch_query {
		# Show result of SELECT query on the table
		my $self = shift;
		my $pquery = $self->{dbh}->prepare($_[0]);
		my $run = $pquery->execute();
		my $strp = DateTime::Format::Strptime->new(
			pattern => '%d.%m.%G',
		);
		while (my @row = $pquery->fetchrow_array()) {
			my $ld = $strp->format_datetime(DateTime->from_epoch(epoch => $row[2]));
			my $rd = $strp->format_datetime(DateTime->from_epoch(epoch => $row[3]));
			print "$row[0] $row[1] $ld $rd\n";
		}
	}
}


1;
