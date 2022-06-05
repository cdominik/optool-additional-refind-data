#!/usr/bin/perl

# Turn Bruce Drains data files into a format that optool can access

@files = ("callindex.out_CpaD03_0.01", "callindex.out_CpaD03_0.10",
          "callindex.out_CpeD03_0.01", "callindex.out_CpeD03_0.10",
          "callindex.out_silD03","eps_SiC","eps_suvSil");

%density = (
  "callindex.out_CpaD03_0.01" => 2.16,
  "callindex.out_CpaD03_0.10" => 2.16,
  "callindex.out_CpeD03_0.01" => 2.16,
  "callindex.out_CpeD03_0.10" => 2.16,
  "callindex.out_silD03"      => 3.3,
  "eps_SiC"                   => 3.22,
  "eps_suvSil"                => 3.22);    

%title = (
  "callindex.out_CpaD03_0.01" => "Graphite E parallel to c, particle size 0.01um",
  "callindex.out_CpaD03_0.10" => "Graphite E parallel to c, particle size 0.1um",
  "callindex.out_CpeD03_0.01" => "Graphite E perpendicular to c, particle size 0.01um",
  "callindex.out_CpeD03_0.10" => "Graphite E perpendicular to c, particle size 0.1um",
  "callindex.out_silD03"      => "Astrosilicate",
  "eps_SiC"                   => "alpha-SiC",
  "eps_suvSil"                => "UV smoothed Silicate");

%ref = (
  "callindex.out_CpaD03_0.01" => "Draine, B.T. 2003, ApJ, 598, 1026",
  "callindex.out_CpaD03_0.10" => "Draine, B.T. 2003, ApJ, 598, 1026",
  "callindex.out_CpeD03_0.01" => "Draine, B.T. 2003, ApJ, 598, 1026",
  "callindex.out_CpeD03_0.10" => "Draine, B.T. 2003, ApJ, 598, 1026",
  "callindex.out_silD03"      => "Draine, B.T. 2003, ApJ, 598, 1026",
  "eps_SiC"                   => "Laor, A., & Draine, B.T. 1993, ApJ 402,441",
  "eps_suvSil"                => "Draine & Lee 1984; Laor & Draine 1993; Weingartner & Draine 2000");

%lnkfile = (
  "callindex.out_CpaD03_0.01" => "c-gra-para-0.01-Draine2003.lnk",
  "callindex.out_CpaD03_0.10" => "c-gra-para-0.10-Draine2003.lnk",
  "callindex.out_CpeD03_0.01" => "c-gra-perp-0.01-Draine2003.lnk",
  "callindex.out_CpeD03_0.10" => "c-gra-perp-0.10-Draine2003.lnk",
  "callindex.out_silD03"      => "astrosil-Draine2003.lnk",
  "eps_SiC"                   => "sic-Draine1993.lnk",
  "eps_suvSil"                => "astrosil2-Draine2000.lnk");

foreach $name  (@files) {

  print "Converting $name\n";
  @lam = @n = @k = ();
  
  open(TAB,"<","data/$name") or die $!;

  $inheader = 1;
  while (<TAB>) {
    if (/^[ \t]*wave|^[ \t]*w\(micron\)/) {
      # After this line, the data starts
      $inheader = 0;
      next;
    } elsif ($inheader == 1 ) {
      next;
    }
    @data = split;
    $length = @data;
    last if $length < 5;
    push(@lam,$data[0]);
    push(@n,$data[3]+1);
    push(@k,$data[4]);
  }
  if ($lam[0] >= $lam[10]) {
    @lam = reverse @lam;
    @n  = reverse @n;
    @k  = reverse @k;
  }
  
  open (FH,">",$lnkfile{$name}) or die;
  printf FH "# %s\n",$title{$name};
  printf FH "# %s\n",$ref{$name};
  print  FH "# \n";
  print  FH "# First line is N_lam and rho [g/cm^3], other lines are: lambda[um] n k\n";
  printf FH "  %d  %g\n",scalar @lam,$density{$name};
  
  for $i (0..$#lam) {
    printf FH "%10g %10g %13g\n",$lam[$i],$n[$i],$k[$i];
  }
  close(FH);
}
