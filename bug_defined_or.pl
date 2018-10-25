use Data::Dumper;

my (%aaa, %bbb, %ccc);

$aaa{key}   = print Dumper(\%aaa);

$bbb{key} //= print Dumper(\%bbb);

$ccc{key}   = $ccc{key} // print Dumper(\%ccc);
