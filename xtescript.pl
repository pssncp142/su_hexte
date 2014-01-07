#!/usr/bin/perl -w
################################################################################
#
#  Yigit Dallilar 07.01.2014 (First Perl Experiment)
#
#  RXTE data extraction script... 
#
#------------------------------------------------------------------------------#

use Cwd;
use warnings;
use File::Path;
use File::Copy;
#use File::chdir;

# Environment Options
$CONF="/data1/ydallilar/conf";
$SUFF="";
$DPATH="/data2/rxte/RXTE_ARCHIVE";

# Observation Configuration 
$ID=$ARGV[0];
@ID_SPL=split(/-/,$ID);
$AOBS="AO".substr($ID,0,1);
$POBS="P".$ID_SPL[0];
$OBSPATH=$DPATH."/".$AOBS."/".$POBS;

# PCA Options
$PCA_ON=1;
@PCA_MOD=("std","high");
@PCA_CHAN=("10 100","110 200");
@PCA_EA=(1,2);
$PCA_DT=8;
$PCA_EL=10;
$PCA_EP=" ";
$PCA_COMB=1;

$PCA_OUT=$ID_SPL[2].".00p";

# HEXTE options
$HEXTE_ON=1;
@HEXTE_MOD=("std","high");
@HEXTE_CHAN=("10 250","150 250");
@HEXTE_CL=("a");
$HEXTE_DT=9;
$HEXTE_COMB=1;

$HEXTE_OUT=$ID_SPL[2].".00h";

-d $OBSPATH."/".$ID or die "Directory does not exist : ".$OBSPATH."/".$ID;

for $mod (@PCA_MOD){
    if ( $mod ne "std" && $mod ne "high"){
	print "Unrecognized PCA mod : ",$mod,"\n";
	print "Options are :\n";
	print " -std  : Archive Data\n";
	print " -high : Event Data\n";
	exit -1;
    }
}

for $mod (@HEXTE_MOD){
    if ( $mod ne "std" && $mod ne "high"){
	print "Unrecognized HEXTE mod : ",$mod,"\n";
	print "Options are :\n";
	print " -std  : Archive Data\n";
	print " -high : Event Data\n";
	exit -1;
    }
}

$WORKDIR=getcwd();
mkdir $ID and print "Directory created...\n" and $new=1 
    or print "Directory already exists...\n" and $new=0;

chdir $WORKDIR."/".$ID or die "There is no directory...\n";

if($new eq 1){
    copy($CONF."/opt_fourier",getcwd());
    copy($CONF."/opt_leahy",getcwd());
    copy($CONF."/opt_syncseg",getcwd());
    symlink($CONF."/cmd_syncseg",getcwd()."/cmd_syncseg");
    symlink($CONF."/cmd_fourier",getcwd()."/cmd_fourier");
}

if ($PCA_ON == 1){
    for $mod (@PCA_MOD){
	if ($mod eq "std"){
	    @command = `pcaextract $ID $OBSPATH $PCA_OUT -electron=$PCA_EL -full $PCA_EP 2>err.log`;
	    print "pcaextract     : ";
	    writelog($ID,$PCA_OUT."_arc",@command);
	    if(error_exist()){
		print "Extraction $ID failed... Removing directory...\n"; chdir $WORKDIR; #rmtree $WORKDIR."/".$ID;
		goto EXIT;}
	} elsif ($mod eq "high"){
	    for ($i=0;$i<=$#PCA_CHAN;$i++){
		@command = `eaextract $ID $OBSPATH $PCA_OUT -exclusive -all -ea=$PCA_EA[$i] -dt=$PCA_DT $PCA_CHAN[$i] 2>err.log`;
		$PCA_CHAN[$i] =~ s/ /_/;
		print "eaextract      : ";
		writelog($ID,$PCA_OUT."_".$PCA_CHAN[$i]."_".$PCA_EA[$i]."_ev",@command);
		if(error_exist()){
		    print "Extraction $ID failed... Removing directory...\n"; chdir $WORKDIR; #rmtree $WORKDIR."/".$ID; 
		    goto EXIT;}	
	    }
	}
    }
}

if ($HEXTE_ON == 1){
    for $mod (@HEXTE_MOD){
	if ($mod eq "std"){
	    for $cl (@HEXTE_CL){
		@command = `hexte_standard $ID $OBSPATH $HEXTE_OUT$cl -$cl -noseparate 2>err.log`;
		print "hexte_standard : ";
		writelog($ID,$HEXTE_OUT.$cl."_arc",@command);
		if(error_exist()){
		    print "Extraction $ID failed... Removing directory...\n"; chdir $WORKDIR; #rmtree $WORKDIR."/".$ID; 
		    goto EXIT;}
	    }
	} elsif ($mod eq "high"){
	    for $cl (@HEXTE_CL){
		for $chan (@HEXTE_CHAN){
		    @command = `hexte_extract $ID $OBSPATH $HEXTE_OUT$cl -$cl -dt=$HEXTE_DT -noseparate $chan 2>err.log`;
		    $chan =~ s/ /_/;
		    print "hexte_extract  : ";
		    writelog($ID,$HEXTE_OUT.$cl."_".$chan."_ev",@command);
		    if(error_exist()){
			print "Extraction $ID failed... Removing directory...\n"; chdir $WORKDIR; #rmtree $WORKDIR."/".$ID; 
			goto EXIT;}

		}
	    }
	}
    }
}

 EXIT:
    
    print "\naaa\n";

#------------------------------------------------------------------------------#
#                              SUBROUTINES 
#
#------------------------------------------------------------------------------#
# Writes log of the program into a file

sub writelog{
    my ($ID,$file,@log)=@_;
    if(-e $file.".log"){
	my $i=1;
	my $check=0;
	while($check eq 0){
	    if(-e $file.$i.".log"){$i++;} else {$check=1;}
	}
	$file=$file.$i;
    }
    open(LOG,'>',$file.".log");
    print LOG @log;
    print "Log is written to the file $ID/$file.log'\n";
}

#------------------------------------------------------------------------------#
# Handles if any error appears

sub error_exist{
    open(ERR,'<','err.log');
    while(<ERR>){
	unless($_ =~ /punlearn/){
	    return 1;
	}
    }
    return 0;
}

################################################################################
