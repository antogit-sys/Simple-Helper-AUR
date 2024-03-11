#File:  src/AUR.pm

#///////////////////////#
#/// FUNCTION TO AUR ///#
#///////////////////////#

package AUR;

use strict;
use warnings;
use feature "say";

use JSON;

# - import color/color.pm (setting color)
use lib '../color';
use Color ':consts';

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
        package_detail($pkg);
    }
    elsif($num > 1){
        print_table($curl_o->{'results'});
        print CYAN, BOLD,"choice?> ",RESET;
        
        my $ch=<STDIN>;
        chomp $ch;
        
        if($ch =~ /^\d+$/ and ($ch >= 1 && $ch <= $num)){
            package_detail($curl_o->{'results'}[$ch - 1]{'Name'});#package_detail($pkg);
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

#
# - Utility
#
sub package_detail{
    my ($pkg)=@_;
    my $url = "https://aur.archlinux.org/rpc/v5/info/$pkg";
    my $curl_o = eval{decode_json qx(curl -s -X GET "$url")};
   
    die RED, BOLD, "!Error, something went wrong. ",RESET if $@;
    
    # directly access the first element of the array
    my $result = $curl_o->{'results'}->[0];

    # desired order of keys
    my @keys = qw(
        ID Name PackageBaseID PackageBase
        Version Description Keywords License URL 
        URLPath Conflicts Depends Provides Submitter 
        Maintainer CoMaintainers NumVotes Popularity FirstSubmitted 
        LastModified OutOfDate

    );

    say "";
    say CYAN, BOLD, "Package Details: ", $result->{'Name'}," ", $result->{'Version'}, RESET;
    say CYAN, BOLD, "-" x 35, RESET;
    
    foreach my $key (@keys){
        my $value = $result->{$key};
        if (defined $value){
            if (ref($value) eq 'ARRAY') {
                $value = join(", ", @$value);
            }
            say WHITE, BOLD, "$key: ", RESET, "$value";
        }
        else{
            say WHITE, BOLD, "$key: ", RESET, "(undefined)"
        }

    }
    say CYAN, BOLD, "-" x 35, RESET;
}

sub print_table {
    my ($results) = @_;
    my $num=1;

    say CYAN, BOLD, "\t\tID\tName";
    say "\t\t" . "-" x 30, RESET;
    foreach my $result (@$results) {
        say WHITE,BOLD,"\t\t$num ",RESET,"  =>  $result->{'Name'} $result->{'Version'}";
        $num++;
    }
    say "";
}


# - Export
our @EXPORT_OK = qw(search_info_package);
our %EXPORT_TAGS = (
    all => ['search_info_package']
);

1;
