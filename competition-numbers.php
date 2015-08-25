<?php
// Give random numbers for each participant in a text file

$numbersForEachParticipant = 7;

$numbers = [];

for ($cont = 0; $cont<1000; $cont++) {
	$number = $cont;

	if ($number < 10)
		$number = '00' . $number;
	elseif ($number < 100)
		$number = '0' . $number;

	$numbers[] = $number;
}

$handle = fopen("participants.txt", "r");

echo "\n\n";

if ($handle) {

    while (($line = fgets($handle)) !== false) {

    	echo preg_replace("/\r|\n/", "",$line) . ": ";

    	$numbersIndex = array_rand($numbers, $numbersForEachParticipant);
    	foreach ($numbersIndex as $number) {
    		echo $numbers[$number] . ' ';
    		unset($numbers[$number]);
    	}

    	echo "\n";
    }

    fclose($handle);
} else {
    echo "I was not able to open the file";
} 
