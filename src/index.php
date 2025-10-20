<?php

date_default_timezone_set('Europe/Zurich');

$weekdays = array(
  'Monday' => 'Montag',
  'Tuesday' => 'Dienstag',
  'Wednesday' => 'Mittwoch',
  'Thursday' => 'Donnerstag',
  'Friday' => 'Freitag',
  'Saturday' => 'Samstag',
  'Sunday' => 'Sonntag'
);

echo "Hello World!<br />";
echo sprintf("Es ist %s, der %s, Uhrzeit: %s", $weekdays[date("l")], date("d.m.Y"), date("H:i:s"));
echo "<br />Gruss aus der Cloud";
