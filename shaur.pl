#!/usr/bin/perl

#
#   Nickanme:   Aska
#   GitHub:     https://github.com/antogit-sys
#   LICENSE:    GPLv3 
#

use strict;
use warnings;
use feature 'say';
use Term::ANSIColor qw(:constants);


sub main{ my $ARGC = scalar @ARGV;
    if($ARGC == 0){
        help()
	}else{
        #my %options=();
    }
}
sub help{
    say "";
    say BOLD, CYAN, "="x22, " Simple Helper AUR ", "="x22, RESET;    
    my $options = <<END

    \tDescription:  
    \t\t shaur is at Simple Helper AUR for Arch-Linux
    \tUsage:
    \t\t shaur <option> <package>
    \tOption;
    \t\t -s \t(search package)
    \t\t -si\t(search & install)
    \t\t -l \t(get list package)
    \t\t -lu\t(get list package and update)
    \t\t -r \t(remove package)
    \tExample:
    \t\t shaur -s lol
END
;
    say "$options";
}

main()
