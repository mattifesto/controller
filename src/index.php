<?php

set_error_handler(
    function(
        $severity,
        $message,
        $filename,
        $lineno
    ) {
        throw new ErrorException(
            $message,
            0,
            $severity,
            $filename,
            $lineno
        );
    }
);

$exceptionMessage = '';
$nameAsHTML = 'unset';

try
{
    $name = getenv('CONTROLLER_NAME');

    if ($name !== false)
    {
        $nameAsHTML = htmlspecialchars(json_encode($name));
    }

    $documentRootDirectory =
    $_SERVER['DOCUMENT_ROOT'];

    if (empty($documentRootDirectory))
    {
        throw new Exception('No document root.');
    }

    $fileContents =
    file_get_contents(
        "{$documentRootDirectory}/version.txt"
    );

    if (empty($fileContents))
    {
        throw new Exception('Unabled to read version number.');
    }

    $versionNumber = trim($fileContents);

    $versionNumberAsHTML = htmlspecialchars($versionNumber);
}
catch(Throwable $throwable)
{
    $exceptionMessage = $throwable->getMessage();
    $versionNumberAsHTML = "unknown";
}

?>
<!doctype html>
<html lang="en">
    <head>
        <title>Controller</title>
    </head>
    <body>
        <p>Mattifesto Controller
        <p>Version: <?= $versionNumberAsHTML ?>
        <p>CONTROLLER_NAME environment variable: <?= $nameAsHTML ?>
        <?php

            if (!empty($exceptionMessage))
            {
                $exceptionMessageAsHTML = htmlspecialchars($exceptionMessage);

                echo "<p>Exception: {$exceptionMessageAsHTML}\n";
            }

        ?>
    </body>
</html>
