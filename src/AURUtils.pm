#File: src/AURUtils.pm

#//////////////////////#
#/// UTILITY TO AUR ///#
#//////////////////////#

package AURUtils;

use strict;
use feature "say";
#use Exporter 'import';
use JSON;

use lib '../color';
use Color ':consts';


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
    say CYAN, BOLD, "Package Details: ", $result->{'Name'}," ", $result->{'Version'};
    say "-" x 35, RESET;

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
#our @EXPORT_OK = qw(package_detail print_table);
#our %EXPORT_TAGS = (
#    all => ['package_detail print_table']
#);

1;


