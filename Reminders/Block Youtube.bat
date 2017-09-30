for /F "delims=" %%a in (C:\Windows\System32\drivers\etc\hosts) do (
   set "lastLine=%%a"
)
echo %lastLine%
echo 

IF NOT "%lastLine%"=="127.0.0.1 www.youtube.com" (
    ECHO 127.0.0.1 www.youtube.com >> C:\Windows\System32\drivers\etc\hosts
)
Pause

