#File:  src/AUR.pm

#///////////////////////#
#/// FUNCTION TO AUR ///#
#///////////////////////#


package AUR;

use strict;
use warnings;
use feature "say";
use LWP::UserAgent;
use Data::Dumper;
use JSON;

# - import color/color.pm (setting color)
use lib '../color';
use Color ':consts';

use Exporter 'import';

sub search_info_package{ my $pkg = shift;

    my $url = "https://aur.archlinux.org/rpc/?v=5&type=search&arg=$pkg";
    my $ua = LWP::UserAgent->new;
    my $response = $ua->get($url);
    
    unless ($response->is_success) {
        say RED,BOLD,"!Error Request:\n\t",RESET,$response->status_line,"\n";
    }

    my $json_text = $response->decoded_content;
    my $data = decode_json($json_text);

    print Dumper($data);

    return;
}


our @EXPORT_OK = qw(search_info_package);
our %EXPORT_TAGS = (
    all => ['search_info_package']
);

1;
