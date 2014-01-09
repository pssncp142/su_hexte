#!/usr/bin/perl -w
################################################################################
#
#  Yigit Dallilar 07.01.2014 
#
#  RXTE data extraction script... 
#
#------------------------------------------------------------------------------#

use Cwd;
use warnings;
use File::Path;
use File::Copy;

#------------------------------------------------------------------------------#
#                                OPTIONS                                       #
#------------------------------------------------------------------------------#

# Environment Options
my $CONF="/data1/ydallilar/conf";
my $DPATH="/data2/rxte/RXTE_ARCHIVE";

#Program Options
#$SAFE=1;
#$RM=1;

# Observation Configuration 
my $ID=$ARGV[0];
my @ID_SPL=split(/-/,$ID);
my $AOBS="AO".substr($ID,0,1);
my $POBS="P".$ID_SPL[0];
my $OBSPATH=$DPATH."/".$AOBS."/".$POBS;

# PCA Options
my $PCA_ON=0;
my @PCA_MOD=("std","high");
my @PCA_CHAN=("10 100","110 200");
my @PCA_EA=(1,2);
my $PCA_DT=8;
my $PCA_EL=10;
my $PCA_EP=" ";
my $PCA_COMB=0;

my $PCA_OUT=$ID_SPL[2].".00p";

# HEXTE options
my $HEXTE_ON=1;
my @HEXTE_MOD=("std","high");
my @HEXTE_CHAN=("10 250");
my @HEXTE_CL=("a");
my $HEXTE_DT=9;
my $HEXTE_COMB=1;

my $HEXTE_OUT=$ID_SPL[2].".00h";

my $new;
my $WORKDIR;
my @command;

#------------------------------------------------------------------------------#
# Configuration part is complete. Do not change the following...               #
#------------------------------------------------------------------------------#
#                                CONTROL                                       #
#------------------------------------------------------------------------------#
# check if observation file exists in the data

-d $OBSPATH."/".$ID or die "Directory does not exist : ".$OBSPATH."/".$ID;

#------------------------------------------------------------------------------#
# Check if options are suitable. If not, quit.

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

#------------------------------------------------------------------------------#
# Create container directory if it is not existed.

$WORKDIR=getcwd();
mkdir $ID and print "Directory created...\n" and $new=1 
    or print "Directory already exists...\n" and $new=0;

# Handle directory permission restriction or similar.
chdir $WORKDIR."/".$ID or die "There is no directory...\n";

#------------------------------------------------------------------------------#
# Prepare directory for the simulation.

if($new eq 1){
    copy($CONF."/opt_fourier",getcwd());
    copy($CONF."/opt_leahy",getcwd());
    copy($CONF."/opt_syncseg",getcwd());
    symlink($CONF."/cmd_syncseg",getcwd()."/cmd_syncseg");
    symlink($CONF."/cmd_fourier",getcwd()."/cmd_fourier");
}

#------------------------------------------------------------------------------#
#                              EXECUTION PART                                  #
#------------------------------------------------------------------------------#
# Handle PCA data

if ($PCA_ON == 1){
    for $mod (@PCA_MOD){
	if ($mod eq "std"){
	    @command = `pcaextract $ID $OBSPATH $PCA_OUT -electron=$PCA_EL -full $PCA_EP 2>err.log`;
	    print "pcaextract     : ";
	    writelog($ID,$PCA_OUT."_arc",@command);
	    if(error_exist()){
		print "Extraction $ID failed... Removing directory...\n"; chdir $WORKDIR; rmtree $WORKDIR."/".$ID;
		goto EXIT;}
	} elsif ($mod eq "high"){
	    for ($i=0;$i<=$#PCA_CHAN;$i++){
		@command = `eaextract $ID $OBSPATH $PCA_OUT -exclusive -all -ea=$PCA_EA[$i] -dt=$PCA_DT $PCA_CHAN[$i] 2>err.log`;
		$PCA_CHAN[$i] =~ s/ /_/;
		print "eaextract      : ";
		writelog($ID,$PCA_OUT."_".$PCA_CHAN[$i]."_".$PCA_EA[$i]."_ev",@command);
		if(error_exist()){
		    print "Extraction $ID failed... Removing directory...\n"; chdir $WORKDIR; rmtree $WORKDIR."/".$ID; 
		    goto EXIT;}	
	    }
	}
    }
}

#------------------------------------------------------------------------------#
# Handle HEXTE data

if ($HEXTE_ON == 1){
    for $mod (@HEXTE_MOD){
	if ($mod eq "std"){
	    for $cl (@HEXTE_CL){
		@command = `hexte_standard $ID $OBSPATH $HEXTE_OUT$cl -$cl -noseparate 2>err.log`;
		print "hexte_standard : ";
		writelog($ID,$HEXTE_OUT.$cl."_arc",@command);
		if(error_exist()){
		    print "Extraction $ID failed... Removing directory...\n"; chdir $WORKDIR; rmtree $WORKDIR."/".$ID; 
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
			print "Extraction $ID failed... Removing directory...\n"; chdir $WORKDIR; rmtree $WORKDIR."/".$ID; 
			goto EXIT;}

		}
	    }
	}
    }
}

#------------------------------------------------------------------------------#
# Combines data if it is defined in the options

if($PCA_COMB eq 1){
    @command=`combinelc $PCA_OUT.all $PCA_OUT -nohexte`;
    writelog($ID,"pca_com_lc",@command);
    @command=`combinepha $PCA_OUT.all $PCA_OUT -nohexte`;
    writelog($ID,"pca_com_pha",@command);
}

if($HEXTE_COMB eq 1){
    for $cl (@HEXTE_CL){
	@command=`combinelc $HEXTE_OUT$cl.all $HEXTE_OUT$cl -nopca`;
	writelog($ID,"hexte_com_lc",@command);
	link_filter($WORKDIR."/".$ID,$HEXTE_OUT.$cl);
    }
}

#------------------------------------------------------------------------------#
# End of the script

 EXIT:
    print "Done...\n";

#------------------------------------------------------------------------------#
#                              SUBROUTINES                                     #
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

#------------------------------------------------------------------------------#
# Finds and links filter file. The same procedure as gti and housekeeping files

sub link_filter{
    my ($WORKDIR,$DIR)=@_;
    
    my $BEFORE=$WORKDIR."/".$DIR."/filter";
    my $LINK=$WORKDIR."/".$DIR.".all/house/".$DIR."_filter.xfl";
    my $FILTER;

    opendir(DIR,$DIR."/filter");
    my @FILES=readdir(DIR);

    for $file (@FILES){
	if($file =~ /xfl/){
	    closedir(DIR);
	    $FILTER=$file;
	    last;
	}
    }
    
    symlink($BEFORE."/".$FILTER,$LINK);
}
################################################################################
