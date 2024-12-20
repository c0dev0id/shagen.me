<ul>
<?php

$path = "/htdocs/ptrace/paste/";
$url = "https://ptrace.org/";

// read files from directory
$files = scandir($path);

// create associative array with key filename + mtime
foreach ($files as $f){
  $tmp[$f] = filemtime($path.$f);
}

// sort desc by mtime
arsort($tmp);

// write back all keys of the array (now sorted)
$files = array_keys($tmp);

function humanize($bytes, $decimals = 2) {
  $sz = 'BKMGTP';
  $factor = floor((strlen($bytes) - 1) / 3);
  return sprintf("%.{$decimals}f", $bytes / pow(1024, $factor)) . @$sz[$factor];
}

foreach($files as $i=>$file) {

    // poor mans file filter
    if($file == ".") {
        continue;
    } elseif ($file == "..") {
        continue;
    } elseif ($file == ".pastehistory") {
        continue;
    }

    print('<li class="paste-list">'."\n"); 
    print(date ("d M Y @ H:i: ", filemtime($path.$file))); 
    print('<a href="'.$url.$file.'" target_"_blank">'.$file.'</a>'."\n"); 
    print("<small>(".humanize(filesize($path.$file)).")</small>\n");
    print("</li>\n");

    if(!isset($_GET['all'])) {
        if($i > 60) {
          break;    
        }
    }
}
print("</ul>\n");

    if(isset($_GET['all'])) {
        print("... showing all results.");
    } else {
        print("... showing the last 60 results.");
    }
?>
