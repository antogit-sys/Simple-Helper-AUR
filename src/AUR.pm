#File:  src/AUR.pm

#///////////////////////#
#/// FUNCTION TO AUR ///#
#///////////////////////#

package AUR;

use strict;
use warnings;
use feature "say";
use LWP::UserAgent;
use JSON;

# - import color/color.pm (setting color)
use lib '../color';
use Color ':consts';

use Exporter 'import';

#
# mains functions 
#
sub search_info_package {
    my $pkg = shift;

    my $url = "https://aur.archlinux.org/rpc/?v=5&type=search&arg=$pkg";
    my $ua = LWP::UserAgent->new;
    my $response = $ua->get($url);

    unless ($response->is_success) {
        say RED, BOLD, "!Error Request:\n\t", RESET, $response->status_line, "\n";
        return;  # Return early in case of error
    }

    my $json_text = $response->decoded_content;
    my $data = decode_json($json_text);
    
    if ($data->{'resultcount'} == 1){
        package_detail($data->{'results'}->[0]);
    }elsif($data->{'resultcount'} > 1){
         print_table($data->{'results'});
         print CYAN,BOLD,"number?> ",RESET;
         my $num = <STDIN>;
         chomp $num;
         package_detail($data->{'results'}[$num - 1]) unless $num eq "" or int($num)>$data->{'resultcount'}; 
        # Adjust index for user input
    }else{
        say RED,BOLD,"!No packages matched your search criteria.: $data",RESET,"\n";
        return;
    }
}    


#
# - Utility
#
sub package_detail {
    my ($pkg) = @_;
    say "";
    say CYAN, BOLD, "Package Details: ", $pkg->{'Name'}, " ", $pkg->{'Version'}, RESET;
    say CYAN, BOLD, "-" x 35, RESET;
    say WHITE, BOLD,"Git Clone URL: ",RESET,"https://aur.archlinux.org/$pkg->{'Name'}.git";
    say WHITE, BOLD,"Package Base: ",RESET,$pkg->{'PackageBase'};
    say WHITE, BOLD,"Upstream URL: ",RESET,$pkg->{'URL'};
    say WHITE, BOLD,"Description: ",RESET,$pkg->{'Description'};
    say WHITE, BOLD,"Maintainer: ",RESET,$pkg->{'Maintainer'};
    say WHITE, BOLD,"Votes: ",RESET,$pkg->{'NumVotes'};
    say WHITE, BOLD,"Popularity: ",RESET,$pkg->{'Popularity'};
    say CYAN, BOLD, "-" x 35, RESET;
}

sub print_table {
    my ($results) = @_;
    my $num = 1;

    say CYAN, BOLD, "\t\tID\tName";
    say "\t\t" . "-" x 30, RESET;
    foreach my $result (@$results) {
        say WHITE,BOLD,"\t\t$num ",RESET,"  =>  $result->{'Name'} $result->{'Version'}";
        $num++;
    }
}

# - Export
our @EXPORT_OK = qw(search_info_package);
our %EXPORT_TAGS = (
    all => ['search_info_package']
);

1;
