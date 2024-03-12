#File:  src/AUR.pm

#///////////////////////#
#/// FUNCTION TO AUR ///#
#///////////////////////#

package AUR;

use strict;
use warnings;
use feature "say";

use JSON;

#print "Contenuto di \@INC:\n";
#print join("\n", @INC);

# - import color/color.pm (setting color)
use lib '../color';
use lib './';

use Color ':consts';
use AURUtils ':all';

use Exporter 'import';

#
# mains functions 
#
sub search_to_info {
    my $pkg = shift;
    my $url = "https://aur.archlinux.org/rpc/?v=5&type=search&arg=$pkg";
    my $curl_o = eval{decode_json qx(curl -s -X GET "$url")};      
    
    die RED, BOLD, "Oops, something went wrong.",RESET if $@;
    
    my $num = $curl_o->{'resultcount'};
    
    if($num == 1){
        die RED, BOLD, "no packages found..\n",RESET unless $curl_o->{'results'}[0]{'Name'} eq $pkg;
        AURUtils::package_detail($pkg);
    }
    elsif($num > 1){
        AURUtils::print_table($curl_o->{'results'});
        print CYAN, BOLD,"choice?> ",RESET;
        
        my $ch=<STDIN>;
        chomp $ch;
        
        if($ch =~ /^\d+$/ and ($ch >= 1 && $ch <= $num)){
            AURUtils::package_detail($curl_o->{'results'}[$ch - 1]{'Name'});#package_detail($pkg);
        }
        else{
            print RED,BOLD,"!No packages matched your search criteria...",RESET,"\n";
        }
    }
    else{
        say RED,BOLD,"!No packages matched your search criteria.. ",RESET,"\n";
    }
}

sub install_package{

}


# - Export
our @EXPORT_OK = qw(search_info_package);
our %EXPORT_TAGS = (
    all => ['search_info_package']
);

1;
