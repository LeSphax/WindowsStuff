$TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
$Principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$TaskPath = "ShutdownTasks"
Function New-ScheduledTaskFolder {

    Param ($taskpath = "ShutdownTasks")

    $ErrorActionPreference = "stop"

    $scheduleObject = New-Object -ComObject schedule.service

    $scheduleObject.connect()
    Try{
        $rootFolder = $scheduleObject.GetFolder("\")
        $Folder = $scheduleObject.GetFolder($taskpath); 
        ForEach($task in $Folder.GetTasks($null)){
            Unregister-ScheduledTask $task.name -Confirm:$false
        }
        $null = $rootFolder.DeleteFolder($taskpath,$null); 
    } Catch {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Write-Host $ErrorMessage
        Write-Host $FailedItem
        Write-Host "Folder didn't exist : ${_.Exception.Message}"
    }

    $null = $rootFolder.CreateFolder($taskpath) 
}

function dailyShutdownTask($time, $name, $TaskPath = "ShutdownTasks"){
    $remindTime = [datetime]$time
    $remindTime = $remindTime.AddMinutes(-10)

    $warningTime = [datetime]$time
    $warningTime = $warningTime.AddMinutes(-1)

    $action = New-ScheduledTaskAction -Execute "C:\WindowsStuff\Reminders\BedtimeSoon.txt"

    $trigger =  New-ScheduledTaskTrigger -Daily -At $remindTime

    Register-ScheduledTask -Action $action -Trigger $trigger `
    -TaskName "${name}Remind" -TaskPath $TaskPath -Settings $TaskSettings -Principal $Principal

    $action = New-ScheduledTaskAction -Execute "C:\WindowsStuff\Reminders\Va t'coucher.bat"

    $trigger =  New-ScheduledTaskTrigger -Daily -At $warningTime

    Register-ScheduledTask -Action $action -Trigger $trigger `
    -TaskName "${name}Warning" -TaskPath $TaskPath -Settings $TaskSettings -Principal $Principal

    $action = New-ScheduledTaskAction -Execute 'shutdown.exe' -Argument '/s'

    $trigger =  New-ScheduledTaskTrigger -Daily -At $time

    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $name `
    -TaskPath $TaskPath -Settings $TaskSettings -Principal $Principal
}

function weeklyShutdownTask($time, $name){
    $remindTime = [datetime]$time
    $remindTime = $remindTime.AddMinutes(-10)

    $warningTime = [datetime]$time
    $warningTime = $warningTime.AddMinutes(-1)

    $action = New-ScheduledTaskAction -Execute "C:\WindowsStuff\Reminders\BedtimeSoon.txt"

    $trigger =  New-ScheduledTaskTrigger -Weekly -At $remindTime -DaysOfWeek Sunday,Monday,Tuesday,Wednesday,Thursday

    Register-ScheduledTask -Action $action -Trigger $trigger `
    -TaskName "${name}Remind" -TaskPath $TaskPath -Settings $TaskSettings -Principal $Principal

    $action = New-ScheduledTaskAction -Execute "C:\WindowsStuff\Reminders\Va t'coucher.bat"

    $trigger =  New-ScheduledTaskTrigger -Weekly -At $warningTime -DaysOfWeek Sunday,Monday,Tuesday,Wednesday,Thursday

    Register-ScheduledTask -Action $action -Trigger $trigger `
    -TaskName "${name}Warning" -TaskPath $TaskPath -Settings $TaskSettings -Principal $Principal

    $action = New-ScheduledTaskAction -Execute 'shutdown.exe' -Argument '/s'

    $trigger =  New-ScheduledTaskTrigger -Weekly -At $time -DaysOfWeek Sunday,Monday,Tuesday,Wednesday,Thursday

    Register-ScheduledTask -Action $action -Trigger $trigger `
    -TaskName $name -TaskPath $TaskPath -Settings $TaskSettings -Principal $Principal
}

# function deleteTask($name){
#     $taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $name -or $_.Name -like $name }
#     if($taskExists){
#         Unregister-ScheduledTask -TaskName $name -Confirm:$false
#         Unregister-ScheduledTask -TaskName "Remind$name" -Confirm:$false
#         Unregister-ScheduledTask -TaskName "${name}Remind" -Confirm:$false
#         Unregister-ScheduledTask -TaskName "${name}Warning" -Confirm:$false
#         Write-Host "$name deleted"
#     }
#     else{
#         Write-Host "Task doesn't exist"
#     }
# }

New-ScheduledTaskFolder -taskpath $taskpath

# deleteTask -name "MidnightShutdown"
# deleteTask -name "MidnightHalfShutdown"
# deleteTask -name "OneShutdown"
# deleteTask -name "OneHalfShutdown"
# deleteTask -name "TwoShutdown"
# deleteTask -name "TwoHalfShutdown"

# deleteTask -name "TenTen"
# deleteTask -name "TenHalf"
# deleteTask -name "Eleven"
# deleteTask -name "ElevenHalf"

#weeklyShutdownTask -time 22:10 -name "TenTen"
# dailyShutdownTask -time 22:30 -name "TenHalf"
weeklyShutdownTask -time 23:00 -name "Eleven"
weeklyShutdownTask -time 23:30 -name "ElevenHalf"

# dailyShutdownTask -time 00am -name "MidnightShutdown"
# dailyShutdownTask -time 00:30am -name "MidnightHalfShutdown"
dailyShutdownTask -time 01am -name "OneShutdown"
dailyShutdownTask -time 01:30am -name "OneHalfShutdown"
dailyShutdownTask -time 02am -name "TwoShutdown"
dailyShutdownTask -time 02:30am -name "TwoHalfShutdown"

$hour = 00
$minute = 00
For ($i=0; $i -le 29; $i++) {
    $minutes = ($minute + $i)%60
    $time = [datetime]"${hour}:${minutes}am"
    $name = "ZZZ${hour}${minutes}ForcedShutdown"
    Write-Host "Creating folder for task ${name}"
    New-ScheduledTaskFolder -taskpath "${taskPath}-${hour}${minutes}"
    dailyShutdownTask -time $time -name $name -taskpath "${taskPath}-${hour}${minutes}" 
    Write-Host "$name"
}



