<?php
    if (!function_exists('mysqli_init') && !extension_loaded('mysqli')) {
        echo 'We don\'t have mysqli!!!';
    } else {
    }
    include 'conf.php';
    $mysqli = new mysqli($dbhost,$dbuser,$dbpass,$dbname);

    if (!$mysqli) {
        die ('Error connecting to mysql. :-( <br/>');
    } else {
        //echo 'Yes, we have connected to MySQL! :-) <br/>';
    }
?>