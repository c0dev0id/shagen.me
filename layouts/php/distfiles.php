<ul>
<?php

$path = "/htdocs/ptrace/distfiles/";
$url = "https://ptrace.org/distfiles/";

// read files from directory
$files = scandir($path);

function humanize($bytes, $decimals = 2) {
  $sz = 'BKMGTP';
  $factor = floor((strlen($bytes) - 1) / 3);
  return sprintf("%.{$decimals}f", $bytes / pow(1024, $factor)) . @$sz[$factor];
}

foreach($files as $file) {
    // poor mans file filter
    if($file == ".") {
        continue;
    } elseif ($file == "..") {
        continue;
    } elseif ($file == "index.html") {
        continue;
    } elseif ($file == "index.php") {
        continue;
    }
    print('<li class="paste-list">'."\n"); 
    print('<a href="'.$url.$file.'" target_"_blank">'.$file.'</a>'."\n"); 
    print("<small>(".humanize(filesize($path.$file)).")</small>\n");
    print("</li>\n");
}
?>
</ul>

