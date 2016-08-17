<?php
// config.php

// only for debugging
//error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING);
//ini_set('display_errors', 1);


// set local timezone
date_default_timezone_set('America/New_York');

// General
$projectName="TextACoach";
$projectEmail="madelin@ideo.org";
$projectPhoneNumber="+1 (209) 662-6224";


// Twilio API credentials
$accountSid = "ACd5aecfa7e1f8d379387c4c2e7d51eaba";
$authToken = "137989e7059f56775039284b18118630"; //
$twilioPhoneNumber = "+12096626224";
$siteURL="http://pure-headland-50794.herokuapp.com/";


// Slack Webhook integration
$slackWebHookURL="https://hooks.slack.com/services/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";
$slackRoom = "text-a-coach";
$slackBotName = "jena-bot";
$slackBotIcon = ":money_mouth_face:";


// Database Stuff
$dbHost = "us-iron-auto-dca-04-a.cleardb.net";
$dbName = "heroku_ac4117cf4215510";
$dbUserName = "be101ec348476f";
$dbPassword = "eb96df18";
$dbTable = "pure-headland-50794";

$dbConnection = mysqli_connect($dbHost, $dbUserName, $dbPassword,$dbName);
mysqli_error($dbConnection);


// users' phone numbers (including participants)
$contactsList = array(
    "+12177664181"=>"Madelin" // Madelin Woods IDEO.org
);


// IDEO team phone numbers (ONLY team members who should be getting alerts)
$IDEOersPhoneList = array(
    "+12177664181"=>"Madelin" // Madelin Woods IDEO.org
);



// Create a API client instance
$http = new Services_Twilio_TinyHttp(
    'https://api.twilio.com',
    array('curlopts' => array(
        CURLOPT_SSL_VERIFYPEER => true,
        CURLOPT_SSL_VERIFYHOST => 2
    )));

$client = new Services_Twilio($accountSid, $authToken, "2010-04-01", $http);



?>