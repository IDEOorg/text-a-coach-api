<?php
// login.php

include('includes/sessions.php');

if ($_POST && count($_POST) > 0) {
    if (Sessions::login($_POST['username'], $_POST['password'])) {
        header("Location: /index.php");
    } else {
        Sessions::setMessage("error", "No account found.");
        header("Location: /login.php");
    }
    die();
}

$errors = Sessions::getMessages("error");
?>
<!DOCTYPE html>
<html lang="en">
<head>
<?php include('config/meta.php');?>
</head>

<body>

<header class="header">
    <p class="bold">Login</p>
</header>

<section class="wrapper">

<?php foreach( $errors as $key => $message ): ?>
    <div class="error" style="padding: 10px; margin: 10px;">
        <?php echo $message; ?>
    </div>
<?php endforeach; ?>
    <section class="main">
        <form method="POST">
            <div style="padding: 15px;">
                <label>Username</label><br />
                <input type="text" name="username" />
            </div>

            <div style="padding: 15px;">
                <label>Password</label><br />
                <input type="password" name="password" />
            </div>

            <div style="padding: 15px;">
                <input class="newConvoBtn bold small" type="submit" name="submit" value="Login" />
            </div>
        </form>
    </section>
</section>


<!--Scripts-->
<script src="assets/js/jquery-2.1.3.js"></script>
<script src="assets/js/main.js"></script>

</body>
</html>
