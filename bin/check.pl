#!/usr/bin/env perl
use strict; use warnings;
use feature ':5.18';

use Config::YAML;
use LWP::UserAgent;
use DBI;

use Time::HiRes qw/time/;

my $ua = LWP::UserAgent->new();
$ua->timeout(30);

my $cfg = Config::YAML->new( config => 'config.yaml' );
my $db_path = $cfg->{db_path};

my $dbh = DBI->connect("dbi:SQLite:dbname=$db_path",'','') 
  or die "Couldn't open DB";

my %targets = (
  meta => 'https://metacpan.org/search?q=Moose',
  sco => 'http://search.cpan.org/search?query=Moose&mode=all',
);

for my $k (keys %targets) {

  my $ts_before = time();
  my $res = $ua->get($targets{$k});
  my $ts_after = time();

  if ( $res->is_success ) {
    my $ms = int ( 1000 * ( $ts_after - $ts_before ) );
    save_result( 1, $ms, $k);
  } else {
    save_result( 0, undef, $k );
  }

}

sub save_result {

  my ( $success, $time, $target ) = @_;
  die "save_result called with <3 args ... wat?" unless $target;

  $dbh->do(
    q!
      INSERT INTO results (result, msec, timestamp, site)
      VALUES ( ?, ?, ?, ? )
    !, {}, $success, $time, int time(), $target
  ) or die "Couldn't store result for $target: " . $dbh->errstr;

}
