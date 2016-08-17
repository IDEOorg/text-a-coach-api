<?php
// config.php

// only for debugging
//error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING);
//ini_set('display_errors', 1);


// set local timezone
date_default_timezone_set('America/New_York');

// General
$projectName="WonkaBot";
$projectEmail="serakoo@ideo.com";
$projectPhoneNumber="+1 (646) 679-2903";


// Twilio API credentials
$accountSid = "AC13acf8a755811c0a37b12cc9b2b781f5";
$authToken = "c862f1cea91fb5c6fd5df07b29979951"; //
$twilioPhoneNumber = "+16466792903";
$siteURL="http://wonkabot.herokuapp.com/";


// Slack Webhook integration
$slackWebHookURL="https://hooks.slack.com/services/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";          
$slackRoom = "zikabot-test"; 
$slackBotName = "zika-zika-bot";
$slackBotIcon = ":poop:"; 


// Database Stuff
$dbHost = "us-iron-auto-dca-04-a.cleardb.net";
$dbName = "heroku_24d47aa355dba14";
$dbUserName = "b2f9885404a7a3";
$dbPassword = "4a6cdeea";
$dbTable = "wonkabot";

$dbConnection = mysqli_connect($dbHost, $dbUserName, $dbPassword,$dbName);
mysqli_error($dbConnection); 


// users' phone numbers (including participants)
$contactsList = array(
    "+17144692093"=>"Sera" // Sera Koo IDEO
);


// IDEO team phone numbers (ONLY team members who should be getting alerts)
$IDEOersPhoneList = array(
    "+17144692093"=>"Sera" // Sera Koo IDEO    
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