use strict;
use warnings;

open IN,"<$ARGV[0]";
$/ = ">";
<IN>;
while(<IN>){
	$_ =~ s/>$//;
	my @tmp = split(/\n/,$_,2);
	$tmp[0] =~ s/ \w+//;
        # $tmp[0] =~ s/ +\(\w+\)//;
	open OUT,">$ARGV[1]/$tmp[0].fa";
	print OUT ">$tmp[0]\n";
	print OUT "$tmp[1]";
	close OUT;
}
close IN;
