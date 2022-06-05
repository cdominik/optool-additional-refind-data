#!/usr/bin/perl

# Turn table 11 from Hudgins 1993 into optool-compatible tables

foreach $temp ("10","20","30","50","70") {

  print "Extracting T=$temp K\n";
  @nu1 = @nu2 = @n = @k = ();
  %seen = [ ];
  
  open(TAB,"<","data/table11.dat") or die $!;
  
  while (<TAB>) {
    next unless /^ *$temp /;
    @data = split;
    $length = @data;
    push(@nu1,$data[1]);
    push(@n,($data[2]<=0 ? 1.0e-10 : $data[2]));
    if ($length == 5) {
      push(@nu2,$data[3]);
      push(@k,($data[4]<=0 ? 1.0e-10 : $data[4]));
    }
  }
  close(TAB);
  @nu = @nu1;
  push(@nu,@nu2);
  @nu = grep {!$seen{$_}++} @nu; # remove duplicates
  @nu = sort {$a <=> $b} @nu;    # sort
  
  $inu1 = 1; $inu2 = 1;
  @nn = @nu; @kk = @nu; @lam = @nu;

  for $i (0..$#nu) {
    $inu1++ while $nu[$i] > $nu1[$inu1];
    $inu2++ while $nu[$i] > $nu2[$inu2];
    # print "$inu1 $inu2\n";
    $slope_n = ($n[$inu1]-$n[$inu1-1]) / ($nu1[$inu1]-$nu1[$inu1-1]);
    $slope_k = ($k[$inu2]-$k[$inu2-1]) / ($nu2[$inu2]-$nu2[$inu2-1]);
    $nn[$i] = $n[$inu1-1] + $slope_n * ($nu[$i]-$nu1[$inu1-1]);
    $kk[$i] = $k[$inu2-1] + $slope_k * ($nu[$i]-$nu2[$inu2-1]);
    $lam[$i] = 10000.0 / $nu[$i];
  }
  @lam = reverse @lam;
  @nn  = reverse @nn;
  @kk  = reverse @kk;
  
  open (FH,">",sprintf("co2:ch4=20:1-%03dK-Hudgins1993.lnk",$temp)) or die;
  printf FH "# CO2:CH4=20:1   at T = %3d K\n",$temp;
  print  FH "# Hudgins et al. 1993, Astrophys. J. Suppl. Ser. 86, 713\n";
  print  FH "# extracted from file table11.dat\n";
  print  FH "# \n";
  printf FH "# Name:        CO2:CH4=20:1 at T = %3d K\n",$temp;
  print  FH "# State:       ?\n";
  print  FH "# Temperature: $temp\n";
  print  FH "# Formula:     CO2:CH4=20:1\n";
  print  FH "# ADS-link:    https://ui.adsabs.harvard.edu/abs/1993ApJS...86..713H\n";
  print  FH "# BibTeX-key:  1993ApJS...86..713H\n";
  print  FH "# \n";
  print  FH "# First line is N_lam and rho [g/cm^3], other lines are: lambda[um] n k\n";
  printf FH "  %d  1.6\n",scalar @lam;      
  
  for $i (0..$#nu) {
    printf FH "%10g %10g %13g\n",$lam[$i],$nn[$i],$kk[$i];
  }
  close(FH);
}
