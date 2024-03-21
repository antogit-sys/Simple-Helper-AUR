#!/usr/bin/perl

#
#   Nickname:   Aska
#   GitHub:     https://github.com/antogit-sys
#   LICENSE:    GPLv3 
#

use strict;
use warnings;
use feature 'say';
use Env;

# - import color/color.pm (setting color)
use lib '/usr/local/bin/shaurFunctions/color';
use Color ':consts';

# - import src/AUR.pm (function_extern)
use lib '/usr/local/bin/shaurFunctions/src';
#use AUR ':all';
use AUR;

#////////////#
#/// MAIN ///#
#////////////#

sub is_not_root {return $< == 0 ? 0 : 1;}

sub main{ my $ARGC = scalar @ARGV;
    my $done = 0;
    
    if (&is_not_root){
        if($ARGC == 0){
            help();
	    }
        else{
            my %options=(
                #opts
                "-r"    => [\&AUR::remove_package, 1],
                "-l"    => [\&AUR::list_package, 0],
                "-u"    => [\&AUR::update_package, 1],
                "-ua"   => [\&AUR::update_all, 0],
                "-s"    => [\&AUR::search_to_info,1],
                "-i"   => [\&AUR::install_package,1],
                map { $_ => [\&help, 0] } qw(help -h --help) #qw --> get list
            );
            my $opt = shift @ARGV;       
            
            # - requests handler
            my $requests_handler = sub{
                if (exists $options{$opt}){    
                    # - dereference to access each element of the array
                    my ($function, $num_parameter) = @{$options{$opt}};

                    if (@ARGV != $num_parameter){
                        say BOLD,RED,"invalid number of parameter for $opt.",RESET;
                        help();
                        return 1;
                    }else{
                        # - exec foo(parameter) or foo()
                        my $pkg = shift @ARGV; #!
                        $pkg ? &$function($pkg) : &$function();
                    } 
                }else{
                    say BOLD,RED,"!This option is not available",RESET;
                    help();
                    return 1;
                }
            };
            $done = $requests_handler->(\%options, $opt);
        }
    }else{
        say BOLD,RED,"Error! In executing this script as root, you're strictly prohibited.",RESET;
        $done=1
    }

return $done;
}


#//////////////
#/// BANNER ///
#//////////////

sub help{
    say "";
    say BOLD, CYAN, "="x25, " Simple Helper AUR ", "="x25, RESET;    
    
    my $options = <<USE  
    \t@{[BOLD]}Description:@{[RESET]} 
    \t\tshaur is a Simple Helper AUR for Arch-Linux
    \t@{[BOLD]}Usage: @{[RESET]}
    \t\t shaur <option> [package]
    \t@{[BOLD]}Option: @{[RESET]}
    \t\t -s  <package_name>\t(search package)
    \t\t -i  <package_name>\t(search & install)
    \t\t -l                \t(get list package)
    \t\t -u  <package_name>\t(update package)
    \t\t -ua               \t(update all)
    \t\t -r  <package_name>\t(remove package)
    \t@{[BOLD]}Example: @{[RESET]}
    \t\t shaur -s lol
USE
;
    say "$options";
}

exit main() if ($0 eq __FILE__);    # if corrent file is the main file 
                                    #   exit the programm with the retun value of the main

