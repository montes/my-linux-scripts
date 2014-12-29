<?php

/**
 * Check that every production site has correct robots.txt file
 * using Statuscake API to get sites urls
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * Written by @montesjmm - montesjmm.com
 * (C) incubalia.com
 */

$apiKey   = ''; // Statuscake api key
$username = ''; // Statuscake username
$email    = ''; // Email to send a nofitication if wrong robots.txt is found

$options  = ["API: " . $apiKey,
	"Username: " . $username];

$ch = curl_init("https://www.statuscake.com/API/Tests/");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, $options);

$response        = curl_exec($ch);
$statuscakeTests = json_decode($response);

foreach ($statuscakeTests as $test) {
	$url = 'https://www.statuscake.com/API/Tests/Details/?TestID=' . $test->TestID;
	curl_setopt($ch, CURLOPT_URL, $url);

	$response    = curl_exec($ch);
	$testDetails = json_decode($response);

	echo "Checking: {$testDetails->URI}...\n";

	if ( ! robotsAllowed($testDetails->URI)) {
		echo "Wrong robots.txt (disallows root path), sending notification email...\n";

		mail($email, '!Important! production robots.txt disallow ' . $testDetails->URI,
			'production robots.txt disallow ' . $testDetails->URI);
	} else {
		echo "OK\n";
	}
}

// Original PHP code by Chirp Internet: www.chirp.com.au
// Please acknowledge use of this code by including this header.
function robotsAllowed($url, $useragent=false)
{
	// parse url to retrieve host and path
	$parsed = parse_url($url);

	$agents = array(preg_quote('*'));
	if ($useragent)
		$agents[] = preg_quote($useragent);
	$agents = implode('|', $agents);

	// location of robots.txt file
	$robotstxt = @file("http://{$parsed['host']}/robots.txt");

	// if there isn't a robots, then we're allowed in
	if (empty($robotstxt))
		return true;

	$rules = array();
	$ruleApplies = false;

	foreach($robotstxt as $line) {
		// skip blank lines
		if (!$line = trim($line))
			continue;

		// following rules only apply if User-agent matches $useragent or '*'
		if (preg_match('/^\s*User-agent: (.*)/i', $line, $match)) {
			$ruleApplies = preg_match("/($agents)/i", $match[1]);
		}

		if($ruleApplies && preg_match('/^\s*Disallow:(.*)/i', $line, $regs)) {
			// an empty rule implies full access - no further tests required
			if(!$regs[1])
				return true;

			// add rules that apply to array for testing
			$rules[] = preg_quote(trim($regs[1]), '/');
		}
	}

	foreach($rules as $rule) {
		// check if page is disallowed to us
		if (isset($parsed['path']) && preg_match("/^$rule/", $parsed['path']))
			return false;
		elseif (preg_match("/^$rule/", '/'))
			return false;
	}

	// page is not disallowed
	return true;
}