<!doctype html>
<html class="no-js" lang="<?= $_SESSION["LANGUAGE"] ?>">

<head>
<?php
require $_SERVER["skynet"] . "/web/templates/includes/title.php";
require $_SERVER["skynet"] . "/web/templates/includes/css.php";
require $_SERVER["skynet"] . "/web/templates/includes/js.php";
?>
</head>

<body class="page-<?= strtolower($TAB) ?> lang-<?= $_SESSION["language"] ?>">
	<div class="app">
