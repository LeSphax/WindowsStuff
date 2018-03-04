$TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries

function dailyShutdownTask($time, $name){
    $remindTime = [datetime]$time
    $remindTime = $remindTime.AddMinutes(-10)

    $action = New-ScheduledTaskAction -Execute "C:\WindowsStuff\Reminders\Va t'coucher.bat"

    $trigger =  New-ScheduledTaskTrigger -Daily -At $remindTime

    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Remind$name" -Settings $TaskSettings

    $action = New-ScheduledTaskAction -Execute 'shutdown.exe' -Argument '/s'

    $trigger =  New-ScheduledTaskTrigger -Daily -At $time

    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $name -Settings $TaskSettings
}

function weeklyShutdownTask($time, $name){
    $remindTime = [datetime]$time
    $remindTime = $remindTime.AddMinutes(-10)

    $action = New-ScheduledTaskAction -Execute "C:\WindowsStuff\Reminders\Va t'coucher.bat"

    $trigger =  New-ScheduledTaskTrigger -Weekly -At $remindTime -DaysOfWeek Sunday,Monday,Tuesday,Wednesday,Thursday

    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Remind$name" -Settings $TaskSettings

    $action = New-ScheduledTaskAction -Execute 'shutdown.exe' -Argument '/s'

    $trigger =  New-ScheduledTaskTrigger -Weekly -At $time -DaysOfWeek Sunday,Monday,Tuesday,Wednesday,Thursday

    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $name -Settings $TaskSettings
}

function deleteTask($name){
    $taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $name -or $_.Name -like $name }
    if($taskExists){
        Unregister-ScheduledTask -TaskName $name -Confirm:$false
        Unregister-ScheduledTask -TaskName "Remind$name" -Confirm:$false
        Write-Host "$name deleted"
    }
    else{
        Write-Host "Task doesn't exist"
    }
}


deleteTask -name "MidnightShutdown"
deleteTask -name "MidnightHalfShutdown"
deleteTask -name "OneShutdown"
deleteTask -name "OneHalfShutdown"
deleteTask -name "TwoShutdown"
deleteTask -name "TwoHalfShutdown"

# deleteTask -name "TenTen"
deleteTask -name "TenHalf"
deleteTask -name "Eleven"
deleteTask -name "ElevenHalf"

#weeklyShutdownTask -time 22:10 -name "TenTen"
weeklyShutdownTask -time 22:30 -name "TenHalf"
weeklyShutdownTask -time 23:00 -name "Eleven"
weeklyShutdownTask -time 23:30 -name "ElevenHalf"

dailyShutdownTask -time 00am -name "MidnightShutdown"
dailyShutdownTask -time 00:30am -name "MidnightHalfShutdown"
dailyShutdownTask -time 01am -name "OneShutdown"
dailyShutdownTask -time 01:30am -name "OneHalfShutdown"
dailyShutdownTask -time 02am -name "TwoShutdown"
dailyShutdownTask -time 02:30am -name "TwoHalfShutdown"

$hour = 01
$minute = 30
For ($i=0; $i -le 29; $i++) {
    $minutes = ($minute + $i)%60
    $time = [datetime]"${hour}:${minutes}am"
    $name = "ZZZ${hour}${minutes}ForcedShutdown"
    deleteTask -name $name
    dailyShutdownTask -time $time -name $name
    Write-Host "$name"
}



