function dailyShutdownTask($time, $name){
    $action = New-ScheduledTaskAction -Execute 'shutdown.exe' -Argument '/s'

    $trigger =  New-ScheduledTaskTrigger -Daily -At $time

    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $name
}

function weeklyShutdownTask($time, $name){
    
    $action = New-ScheduledTaskAction -Execute "C:\Users\sbker\Desktop\WindowsStuff\Reminders\Va t'coucher.bat"

    $trigger =  New-ScheduledTaskTrigger -Weekly -At $time -DaysOfWeek Sunday,Monday,Tuesday,Wednesday,Thursday

    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Remind$name"

    $action = New-ScheduledTaskAction -Execute 'shutdown.exe' -Argument '/s'

    $trigger =  New-ScheduledTaskTrigger -Weekly -At $time -DaysOfWeek Sunday,Monday,Tuesday,Wednesday,Thursday

    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $name
}


Unregister-ScheduledTask -TaskName "MidnightShutdown" -Confirm:$false
Unregister-ScheduledTask -TaskName "MidnightHalfShutdown" -Confirm:$false
Unregister-ScheduledTask -TaskName "OneShutdown" -Confirm:$false
Unregister-ScheduledTask -TaskName "OneHalfShutdown" -Confirm:$false
Unregister-ScheduledTask -TaskName "TwoShutdown" -Confirm:$false
Unregister-ScheduledTask -TaskName "TwoHalfShutdown" -Confirm:$false




Unregister-ScheduledTask -TaskName "RemindTenTen" -Confirm:$false
Unregister-ScheduledTask -TaskName "RemindTenHalf" -Confirm:$false
Unregister-ScheduledTask -TaskName "RemindEleven" -Confirm:$false
Unregister-ScheduledTask -TaskName "RemindElevenHalf" -Confirm:$false

Unregister-ScheduledTask -TaskName "TenTen" -Confirm:$false
Unregister-ScheduledTask -TaskName "TenHalf" -Confirm:$false
Unregister-ScheduledTask -TaskName "Eleven" -Confirm:$false
Unregister-ScheduledTask -TaskName "ElevenHalf" -Confirm:$false

weeklyShutdownTask -time 22:10 -name "TenTen"
weeklyShutdownTask -time 22:30 -name "TenHalf"
weeklyShutdownTask -time 23:00 -name "Eleven"
weeklyShutdownTask -time 23:30 -name "ElevenHalf"

dailyShutdownTask -time 00am -name "MidnightShutdown"
dailyShutdownTask -time 00:30am -name "MidnightHalfShutdown"
dailyShutdownTask -time 01am -name "OneShutdown"
dailyShutdownTask -time 01:30am -name "OneHalfShutdown"
dailyShutdownTask -time 02am -name "TwoShutdown"
dailyShutdownTask -time 02:30am -name "TwoHalfShutdown"


