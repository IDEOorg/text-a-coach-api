<?php

session_start();

if (!isset($_ENV["ADMIN_USER"])) $_ENV["ADMIN_USER"] = "coachadmin";
if (!isset($_ENV["ADMIN_PASS"])) $_ENV["ADMIN_PASS"] = "mtcg<Rv|zFe_T+d|D6N!";

class Sessions {

  static function login($username, $password) {
    if ($username === $_ENV["ADMIN_USER"] && $password === $_ENV["ADMIN_PASS"]) {
      $_SESSION['administrator'] = $username;
      return true;
    } else {
      $_SESSION['administrator'] = false;
      return false;
    }
  }

  static function logout() {
    $_SESSION['administrator'] = false;
    return true;
  }

  static function isLoggedIn() {
    return isset($_SESSION['administrator']) && $_SESSION['administrator'] === $_ENV["ADMIN_USER"];
  }

  static function requireAuth() {
    if (self::isLoggedIn()) {
      return true;
    } else {
      header("Location: /login.php");
      return false;
    }
  }

  static function setMessage($category, $message) {
    try {
      if (!count($_SESSION['messages'][$category])) {
        $_SESSION['messages'][$category] = array();
      }
    } catch (Exception $e) {
      $_SESSION['messages'][$category] = array();
    }

    array_push($_SESSION['messages'][$category], $message);
    return true;
  }

  static function getMessages($category) {
    try {
      $messages = $_SESSION['messages'][$category];
    } catch (Exception $e) {
      $messages = array();
    }
    if (!$messages) $messages = array();

    $_SESSION['messages'][$category] = null;
    return $messages;
  }

}
