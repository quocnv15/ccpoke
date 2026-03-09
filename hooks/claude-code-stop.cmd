@echo off
setlocal
call "%USERPROFILE%\.ccpoke\hooks\lib\common.cmd"
set TMPFILE=%TEMP%\ccpoke-%RANDOM%%RANDOM%.json
findstr "^" > %TMPFILE%
if defined CCPOKE_TMUX_TARGET (
  node "%USERPROFILE%\.ccpoke\hooks\lib\json-merge.cjs" "%TMPFILE%" "tmux_target" "%CCPOKE_TMUX_TARGET%"
)
curl.exe -s -X POST http://%CCPOKE_HOST%:%CCPOKE_PORT%/hook/stop?agent=claude-code -H "Content-Type: application/json" -H "X-CCPoke-Secret: %CCPOKE_SECRET%" -d @%TMPFILE% > nul 2>&1
del %TMPFILE% > nul 2>&1
endlocal
