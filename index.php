<?php
phpinfo();
?>
<?php
$dbh = mysqli_connect('localhost', 'root', '');
if (!$dbh) {
    die('Could not connect: ' . mysql_error());
}
echo 'Connected successfully to MySQL database';
mysql_close($dbh);
?>
