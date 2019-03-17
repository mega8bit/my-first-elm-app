<?php
session_start();
if (!isset($_SESSION['i'])) {
    $i = rand(0, 100);
    $_SESSION['i'] = $i;
} else {
    $i = $_SESSION['i'];
}

echo $i;

?>

