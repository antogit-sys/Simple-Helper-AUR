#File:  src/AUR.pm

#///////////////////////#
#/// FUNCTION TO AUR ///#
#///////////////////////#

package AUR;

use strict;
use warnings;
use feature "say";

use JSON;
use Env;

# - import color/color.pm (setting color)
use lib '/usr/local/bin/shaurFunctions/color';
use Color ':consts';
use AURUtils; 


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
    my $pkg = shift;
    my $url = "https://aur.archlinux.org/$pkg.git";
    my $dir = "$ENV{'HOME'}/.shaur/pkg-installed/";

    
    my $isExists = sub {return decode_json(qx(curl -s -X "GET" "https://aur.archlinux.org/rpc/v5/info/@_"))->{'resultcount'} ? 1 : 0;};
    
    local $SIG{INT} = $SIG{QUIT} = $SIG{TSTP} = sub {
        my $pathToDir = qx(pwd);
        my ($path) = $pathToDir =~ /\/([^\/]+)\/?\z/; #get current directory 
        chomp $path;
        #print "$pkg\t$path";
        if($path eq $pkg){
            chdir "../";
            system "rm -rf $pkg/";
        }
        exit;
    };

    say CYAN, BOLD,"="x25," shaur",RESET;

    &AURUtils::update_archpkgs;

    my $exec_install = sub{
        say "... shaur is pointing to",CYAN,BOLD," => ",WHITE,BOLD,$dir,RESET;
        sleep 1;
        chdir $dir  or die RED,BOLD, "pkg-installed folder not found\n", RESET;
        die RED, BOLD,"$pkg package not found...\n",RESET unless $isExists->($pkg);

        say "... shaur is using git clone",CYAN,BOLD," => ",WHITE, BOLD,$url,RESET;
        sleep 1;
        say "";
        
        print eval{qx(git clone "$url")};
        die RED, BOLD, "package not found...\n" if @_;

        say "";
        say "... shaur is reading",CYAN,BOLD," PKGBUILD ",RESET,"to ", WHITE, BOLD,$pkg,RESET;
        chdir $pkg;
        sleep 2;

        say "";
        system "less PKGBUILD";
    }->();

    say YELLOW,BOLD,"[!]Warning: it is strictly forbidden to use ctrl+D",RESET;
    print "are you willing to install ",WHITE,BOLD,$pkg,RESET,"?(Y/n) ";
    my $ch = <STDIN>;
    #chomp $ch;
    
    # if ch is y or Y or <space> or <space><space>... => i love the regex <3
    if($ch =~ /^(y|\s*)$/i){
        system "makepkg -si --noconfirm";
    }else{
        chdir "../";
        system "rm -rf $pkg/";
    }

}

sub list_package{
    say CYAN,BOLD,"="x25," shaur installed packages",RESET;
    say CYAN, BOLD,"directory: ",WHITE,BOLD,"$ENV{'HOME'}/.shaur/pkg-installed/",RESET;
    say "";
    say BLUE,BOLD,join " ",AURUtils::print_filtered("$ENV{'HOME'}/.shaur/pkg-installed/"),RESET or die RED,BOLD,"directory not indexed...\n",RESET;
    say "\n";

}

sub update_package{
    my $pkg = shift;

    say CYAN, BOLD,"="x25," shaur package update",RESET;
    &AURUtils::update_archpkgs;

    say CYAN, BOLD,"package: ",WHITE,BOLD,$pkg,RESET;
    chdir "$ENV{'HOME'}/.shaur/pkg-installed/$pkg/" or die RED,BOLD,"package $pkg not indexed...\n",RESET;
    system "git pull";
    say "";
}

sub update_all{
    my $pathToDir="$ENV{'HOME'}/.shaur/pkg-installed/";
    my @pkgs = AURUtils::print_filtered($pathToDir);
    say CYAN, BOLD,"="x25," shaur update all", RESET;
    &AURUtils::update_archpkgs;
    
    foreach my $pkg (@pkgs){
        say WHITE,BOLD,"package: ",RESET,$pkg;
        chdir $pathToDir.$pkg or die RED,BOLD,"package $pkg not indexed...\n",RESET;
        system "git pull";
        say CYAN,BOLD,"-"x20,RESET;
    }
    say "";
}

sub remove_package{
    my $pkg = shift;
    my $pathToDir = "$ENV{'HOME'}/.shaur/pkg-installed/";
    my $ch;

    say CYAN,BOLD, "="x25," shaur remove package", RESET;
    say "";
    print "remove ",WHITE,BOLD,$pkg,RESET,"?(Y/n) ";
    $ch = <STDIN>;

    if($ch =~ /^(y|\s*)$/i){
        system "sudo pacman --noconfirm -Rs $pkg";
        chdir $pathToDir;
        system "rm -rf $pkg";
    
    }
    
}

# - Export
#our @EXPORT_OK = qw(search_to_info install_package);
#our %EXPORT_TAGS = (
#    all => ['search_to_info install_package']
#);

1;
