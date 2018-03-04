$hour = 01
$minute = 30
For ($i=0; $i -le 30; $i++) {
    $time = "${hour}:$(($minute + $i)%60)am"
    $name = "ZZZ${hour}${minute}ForcedShutdown"
    Write-Host "$name"
}

$date = [datetime]$time