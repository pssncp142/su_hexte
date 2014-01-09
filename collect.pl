#!/usr/bin/perl -w
################################################################################
# Yigit Dallilar  09.01.2004
# 
# Extracts several observations using xtescript.pl
# Make sure xtescript.pl is in a directory under which can be executed
# Uses the options given in xtescript.pl
# $FILE variable should contain the IDs of the observations
#
#------------------------------------------------------------------------------#

my $FILE="/data1/integral/onlyobsid.txt";

open(ID_FILE,$FILE);
my @IDs = <ID_FILE>;
close(ID_FILE);

open(LOG,">out.log");

$i=0;
for $id (@IDs){
    $i++;
    @command=`xtescript.pl $id`;
    print LOG @command;
    print $id," : ",$#IDs-$i," IDs left to extract...\n";
}

################################################################################
