#!/usr/local/cpanel/3rdparty/bin/perl
# should be executed with /usr/local/cpanel/3rdparty/bin/perl

use Cpanel::Config::Users          ();
use Cpanel::Config::LoadCpUserFile ();
foreach my $user ( Cpanel::Config::Users::getcpusers() ) {
    my $cpuser_ref = Cpanel::Config::LoadCpUserFile::load($user);
    my $ip         = $cpuser_ref->{'IP'};
    my $domains    = join( ' ', map { qq{"$_"} } ( $cpuser_ref->{'DOMAIN'}, @{ $cpuser_ref->{'DOMAINS'} } ) );
    next if !$domains || !$ip;
    print qq{/usr/local/cpanel/bin/swapip -1 "$ip" "$ip" $domains\n};
}
