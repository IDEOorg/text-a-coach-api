<?php
// logout.php

include('includes/sessions.php');
Sessions::logout();

header("Location: /");

