#!/usr/bin/perl
#
# Configuration script for OBSGRID code
# 
# Be sure to run as ./configure (to avoid getting a system configure command by mistake)
#

$sw_perl_path = perl ;
$sw_netcdf_path = "" ;
$sw_netcdff_lib = "" ;
$sw_ldflags=""; 
$sw_compileflags=""; 
$sw_os = "ARCH" ;           # ARCH will match any
$sw_mach = "ARCH" ;         # ARCH will match any

while ( substr( $ARGV[0], 0, 1 ) eq "-" )
 {
  if ( substr( $ARGV[0], 1, 5 ) eq "perl=" )
  {
    $sw_perl_path = substr( $ARGV[0], 6 ) ;
  }
  if ( substr( $ARGV[0], 1, 7 ) eq "netcdf=" )
  {
    $sw_netcdf_path = substr( $ARGV[0], 8 ) ;
  }
  if ( substr( $ARGV[0], 1, 8 ) eq "netcdff=" )
  {
    $sw_netcdff_lib = substr( $ARGV[0], 9 ) ;
  }
  if ( substr( $ARGV[0], 1, 3 ) eq "os=" )
  {
    $sw_os = substr( $ARGV[0], 4 ) ;
  }
  if ( substr( $ARGV[0], 1, 5 ) eq "mach=" )
  {
    $sw_mach = substr( $ARGV[0], 6 ) ;
  }
  if ( substr( $ARGV[0], 1, 8 ) eq "ldflags=" )
  {
    $sw_ldflags = substr( $ARGV[0], 9 ) ;
# multiple options separated by spaces are passed in from sh script
# separated by ! instead. Replace with spaces here.
    $sw_ldflags =~ s/!/ /g ;
  }
  if ( substr( $ARGV[0], 1, 13 ) eq "compileflags=" )
  {
    $sw_compileflags = substr( $ARGV[0], 14 ) ;
    $sw_compileflags =~ s/!/ /g ;
  }
  shift @ARGV ;
 }


# parse the configure.oa file

$validresponse = 0 ;

# Display the choices to the user and get selection
until ( $validresponse ) {
  printf "------------------------------------------------------------------------\n" ;
  printf "Please select from among the following supported platforms.\n\n" ;

  $opt = 1 ;
  open CONFIGURE_DEFAULTS, "< ./arch/configure.defaults" 
      or die "Cannot open ./arch/configure.defaults for reading" ;
  while ( <CONFIGURE_DEFAULTS> )
  {
    if ( substr( $_, 0, 5 ) eq "#ARCH" && ( index( $_, $sw_os ) >= 0 ) && ( index( $_, $sw_mach ) >= 0 ) )
    {
      $optstr[$opt] = substr($_,6) ;
      $optstr[$opt] =~ s/^[ 	]*// ;
      if ( substr( $optstr[$opt], 0,4 ) ne "NULL" )
      {
        printf "  %2d.  %s",$opt,$optstr[$opt] ;
        $opt++ ;
      }
    }
  }
  close CONFIGURE_DEFAULTS ;

  $opt -- ;

  printf "\nEnter selection [%d-%d] : ",1,$opt ;
  $response = <STDIN> ;

  if ( $response == -1 ) { exit ; }

  if ( $response >= 1 && $response <= $opt ) 
  { $validresponse = 1 ; }
  else
  { printf("\nInvalid response (%d)\n",$response);}
}
printf "------------------------------------------------------------------------\n" ;

$optchoice = $response ;


open CONFIGURE_OA, "> configure.oa" || die "cannot Open for writing... configure.oa: \n";
    open ARCH_PREAMBLE, "< arch/preamble" || die "cannot Open for reading... arch/preamble: \n";
    my @preamble;
    # apply substitutions to the preamble...
    while (<ARCH_PREAMBLE>)
    {
          $_ =~ s:CONFIGURE_NETCDFF_LIB:$sw_netcdff_lib:g;
          @preamble = ( @preamble, $_ ) ;
    }
    close ARCH_PREAMBLE;
    
    print CONFIGURE_OA @preamble;
close CONFIGURE_WPS;

#printf "------------------------------------------------------------------------\n" ;

open CONFIGURE_DEFAULTS, "< ./arch/configure.defaults" 
      or die "Cannot open ./arch/configure.defaults for reading" ;
$latchon = 0 ;
while ( <CONFIGURE_DEFAULTS> )
{
  if ( substr( $_, 0, 5 ) eq "#ARCH" && $latchon == 1 )
  {
    $latchon = 0 ;
  }
  if ( $latchon == 1 )
  {
    $_ =~ s/CONFIGURE_PERL_PATH/$sw_perl_path/g ;
    $_ =~ s/CONFIGURE_NETCDF_PATH/$sw_netcdf_path/g ;
    $_ =~ s/CONFIGURE_LDFLAGS/$sw_ldflags/g ;
    $_ =~ s/CONFIGURE_COMPILEFLAGS/$sw_compileflags/g ;
    if ( $sw_netcdf_path ) 
      { $_ =~ s/CONFIGURE_WRFIO_NF/wrfio_nf/g ;
	$_ =~ s:CONFIGURE_NETCDF_FLAG:-DNETCDF: ;
	$_ =~ s:CONFIGURE_NETCDF_LIB_PATH:-L../external/io_netcdf -lwrfio_nf -L$sw_netcdf_path/lib -lnetcdf: ;
	 }
    else                   
      { $_ =~ s/CONFIGURE_WRFIO_NF//g ;
	$_ =~ s:CONFIGURE_NETCDF_FLAG::g ;
	$_ =~ s:CONFIGURE_NETCDF_LIB_PATH::g ;
	 }


    @machopts = ( @machopts, $_ ) ;
  }
  if ( substr( $_, 0, 5 ) eq "#ARCH" && $latchon == 0 )
  {
    $x=substr($_,6) ;
    $x=~s/^[     ]*// ;
    if ( $x eq $optstr[$optchoice] )
    {
      $latchon = 1 ;
    }
  }
}
close CONFIGURE_DEFAULTS ;

#printf "------------------------------------------------------------------------\n" ;
#foreach $f ( @machopts )
#{
#  if ( substr( $f , 0 , 8 ) eq "external" ) { last ; }
#  print $f ;
#}
#printf "------------------------------------------------------------------------\n" ;
#printf "\nYou have chosen: %s",$optstr[$optchoice] ;
#printf "Listed above are the default options for this platform.\n" ;
#printf "Settings are written to the file configure.oa here in the top-level\n" ;
#printf "directory.  If you wish to change settings, please edit that file.\n" ;
#printf "If you wish to change the default options, edit the file:\n\n" ;
#printf "     arch/configure.defaults\n" ;
#printf "\n" ;

open CONFIGURE_WRF, "> configure.oa" or die "cannot append configure.oa" ;
print CONFIGURE_WRF @preamble  ;
close ARCH_PREAMBLE ;
printf CONFIGURE_WRF "# Settings for %s", $optstr[$optchoice] ;
print CONFIGURE_WRF @machopts  ;
open ARCH_POSTAMBLE, "< arch/postamble" or die "cannot open arch/postamble" ;
while ( <ARCH_POSTAMBLE> ) { print CONFIGURE_WRF } ;
close ARCH_POSTAMBLE ;
close CONFIGURE_WRF ;

printf "Configuration successful. To build the OBSGRID, type: compile \n" ;
printf "------------------------------------------------------------------------\n" ;


