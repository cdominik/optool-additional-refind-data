#!/usr/bin/perl

$adslink = "https://ui.adsabs.harvard.edu/abs/2007ApJ...668..993P";
$bibkey = "2007ApJ...668..993P";
$reference = "Posch et al 2007, ApJ 668, 993";
$nameref = "Posch2007";
$fix = "# In the original files, many of the the lambda values were double.
# This was fixed by setting the first of the two equal values to the
# avarage of itself and the value bofore that.  I believe this is
# the correct solution, it looks like some output rounding error
# in the original data. (C. Dominik, 2021-04-23)";
@files = @ARGV;
for $file (@files) {
  $outfile = $file;
  $outfile =~ s/.*\///;
  if ($outfile =~ /(Cal|Dol)(Epz|Esz)(\d*)\.txt/) {
    $temp = $3;
    $direction = ($2 eq "Epz") ? "Epara" : "Eperp";
    $axis = ($2 eq "Epz") ? "E parallel to c" : "E perpendicular to c";
    $state = "crystalline";
    if ($1 eq "Cal") {
      $name = "Calcite";
      $rho  = "2.71";
      $formula = "CaCO_{3}"
    } else {
      $name = "Dolomite";
      $rho  = "2.85";
      $formula = "CaMg(CO_{3})_{2}";
    }      
  } else {
    die "Bad structure of file name $file";
  }
  @ll = (); @nn = (); @kk = ();
  open FH,"<$file" or die $!;
  $desc = <FH>;
  $desc =~ s/\s+$//;
  # Skip the comment lines (which have no marker, but are
  # before a line with many stars)
  while (<FH>) {last if /\*{10,}/}
  # Read the data
  $i = 0;
  while (<FH>) {
    last if /^\s*$/;
    $_ =~ s/^\s+//;
    ($l,$n,$k) = split(/\s+/,$_);
    push(@ll,$l);
    push(@nn,$n);
    push(@kk,$k);
    if (($i>2) and ($ll[$i] eq $ll[$i-1])) {
      # There are two equal lambda values, that is not good.
      # Fix by making the first the avarage of it and the one before.
      # (I think this is correct, there was a rounding issue in the
      # original data)
      $ll[$i-1] = 0.5*($ll[$i-2]+$ll[$i-1]);
    }
    $nlambda = ++$i;   # FIXME
  }
  close FH;
  # Write the new file, which is still axis-specific, but contains
  # everything optool needs.
  $ofile = sprintf("Axis_specific/%s-%s-T%03dK-%s.lnk",$name,$direction,$temp,$nameref);
  print "$ofile\n";
  open OUT,">$ofile" or die $!;
  print OUT "# $desc\n";
  print OUT "# $reference\n";
  print OUT "#\n";
  print OUT "$fix\n";
  print OUT "#\n";
  # Write the database fields
  print OUT "# Name:        $name\n";
  print OUT "# Class:       Carbonates\n";
  print OUT "# State:       $state\n";
  print OUT "# Temperature: $temp\n";
  print OUT "# Axis:        $axis\n";
  print OUT "# Formula:     $formula\n";
  print OUT "# ADS-link:    $adslink\n";
  print OUT "# BibTeX-key:  $bibkey\n";
  print OUT "#\n";
  # Write the nlambda/rho line
  printf OUT "$nlambda  $rho\n";
  # Write the data
  for $i (0..$#ll) {
    printf OUT "%12.5e %12.5e %12.5e\n",$ll[$i],$nn[$i],$kk[$i];
  }
  # Close file
  close OUT;
}
