#!/usr/bin/perl

#
#   Nickanme:   Aska
#   GitHub:     https://github.com/antogit-sys
#   LICENSE:    GPLv3 
#

use strict;
use warnings;
use feature 'say';

use lib 'color';
use Color ':consts';

sub main{ my $ARGC = scalar @ARGV;
    my $done = 0;

    if($ARGC == 0){
        help();
	}else{
        my %options=(
            #opt
            "-l"    => [\&get_list, 0],
            "-s"    => [\&search_package,1],
            map { $_ => [\&help, 0] } qw(help -h --help) #qw --> get list
        );
        my $opt = shift @ARGV;       
        
        if (exists $options{$opt}){    
             # - dereference to access each element of the array
             my ($function, $num_parameter) = @{$options{$opt}};

             if (@ARGV != $num_parameter){
                 say BOLD,RED,"invalid number of parameter for $opt.",RESET;
                 help();
                 $done = 1;
             }else{
                 # - exec foo(parameter) or foo()
                 my $pkg = shift @ARGV; #!
                 $pkg ? &$function($pkg) : &$function();
             } 
        }else{
          say BOLD,RED,"!This option is not available",RESET;
          help();
          $done = 1;
        }
   }

   return $done;
}
sub help{
    say "";
    say BOLD, CYAN, "="x25, " Simple Helper AUR ", "="x25, RESET;    
    
    my $options = <<USE  
    \t@{[BOLD]}Description:@{[RESET]} 
    \t\tshaur is an Simple Helper AUR for Arch-Linux
    \t@{[BOLD]}Usage: @{[RESET]}
    \t\t shaur <option> [package]
    \t@{[BOLD]}Option: @{[RESET]}
    \t\t -s  <package_name>\t(search package)
    \t\t -si <package_name>\t(search & install)
    \t\t -l                \t(get list package)
    \t\t -lu               \t(get list package & update)
    \t\t -r  <package_name>\t(remove package)
    \t@{[BOLD]}Example: @{[RESET]}
    \t\t shaur -s lol
USE
;
    say "$options";
}

sub get_list{print(" GET ");}
sub search_package{
    my ($p) = @_;
    print("$p\n");
}


exit main;
