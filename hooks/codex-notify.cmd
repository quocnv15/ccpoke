@echo off
setlocal
call "%USERPROFILE%\.ccpoke\hooks\lib\common.cmd"
if "%~1"=="" (endlocal & exit /b 0)
set TMPFILE=%TEMP%\ccpoke-%RANDOM%%RANDOM%.json
node -e "require('fs').writeFileSync(process.env.TMPFILE,process.argv[1]||'{}')" %*
if defined CCPOKE_TMUX_TARGET (
  node "%USERPROFILE%\.ccpoke\hooks\lib\json-merge.cjs" "%TMPFILE%" "tmux_target" "%CCPOKE_TMUX_TARGET%"
)
curl.exe -s -X POST http://%CCPOKE_HOST%:%CCPOKE_PORT%/hook/stop?agent=codex -H "Content-Type: application/json" -H "X-CCPoke-Secret: %CCPOKE_SECRET%" -d @%TMPFILE% > nul 2>&1
del %TMPFILE% > nul 2>&1
endlocal
