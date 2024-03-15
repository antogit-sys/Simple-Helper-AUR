# File: color/Color.pm

#/////////////////////#
#/// SETTING COLOR ///#
#/////////////////////#

package Color;

use strict;
use warnings;

use Exporter 'import'; # or use base 'Exporter';

# - declare constant
use constant{
     BOLD   =>  "\e[1m",
     CYAN   =>  "\e[36m",
     RED    =>  "\e[31m",
     YELLOW =>  "\e[33m",
     WHITE  =>  "\e[37m",
     BLUE   =>  "\e[34m",
     RESET  =>  "\e[0m"
};

# - create alias list
our @EXPORT_OK = qw(BOLD CYAN WHITE RED RESET YELLOW BLUE);

# - create tag
our %EXPORT_TAGS = (
    consts => ['BOLD', 'CYAN', 'WHITE', 'RED','RESET', 'YELLOW', 'BLUE']
);

1; #exit succefull
