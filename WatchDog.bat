@Echo off
REM Put REM in front of Echo off to view the file output
REM ---------------------------------------------------------
REM WATCHDOG.CMD
REM     reinicia el servidor despues de varios intentos de conexion con internet despues
REM     Julio Canelon
REM --------------------------------------------------------

REM DNS DE GOOGLE
SET POESWITCH=8.8.8.8

REM CONTADOR DE ERRORES
SET ERRFLG=0

ECHO INNOVARED:: WATCHDOG NETWORK LESS 

:Loop

SET YEAR=%date:~6,4% 
SET MONTH=%date:~3,2% 
SET DAY=%date:~0,2% 

REM --------------------------------------------------------
REM Importante crear esta carpeta o escoger una carpeta para guardar el archivo de logs
REM --------------------------------------------------------
SET WDLOG="C:\Log Files\WatchDog\WATCHDOG_LOG_( %YEAR%%MONTH%%DAY%).LOG"

REM MAXIMA CANTIDAD DE REINTENTOS: 29
IF %ERRFLG% GTR 29 (
    rem ECHO Para cancelar el reinicio del Pc antes de los 60 segundos, debes ejecutar :SHUTDOWN -a 
	ECHO Proceso de apagado iniciado, se completará en 60 segundos
    SHUTDOWN -r -t 60 -f
	
	REM GUARDAR LOG PARA REGISTRAR LA HORA DE REINICIO
	date /t >> %WDLOG%
	date /t
	time /t >> %WDLOG%
	time /t
	ECHO -- Shutdown -- >> %WDLOG%
	ECHO .>>%WDLOG%
	ECHO .
    GOTO :EOF
)

REM --------------------------------------------------------
REM Se buscan esas frases en la respuesta del PING, esto aplica para SOP que sean en español, en caso de ser otro idioma colocar los errores correspondientes
REM --------------------------------------------------------
PING -n 1 -w 3000 %POESWITCH% |findstr /I /C:"espera agotado" /C:"destino inaccesible" /C:"Error general" /C:"timed out" /C:"unreachable" /C:"wa failure"
IF %ERRORLEVEL% EQU 1 (
Goto Done
)

SET /a ERRFLG +=1
ECHO Esperando 30 segundos para reintentar conexion
ECHO .
timeout 30 > nul
ECHO Reintentando conexion %ERRFLG%
REM GUARDAR LOG PARA REGISTRAR LA HORA DE REINTENTO DE CONEXION
	date /t >> %WDLOG%
	date /t
	time /t >> %WDLOG%
	time /t 
	echo Reintentando conexion %ERRFLG% >> %WDLOG%
	echo .>>%WDLOG%
ECHO .

GOTO Loop

:Done

IF %ERRFLG% GTR 0 (
ECHO Se recupero la conexion, contador de intentos = 0.
SET /a ERRFLG=0
REM GUARDAR LOG PARA REGISTRAR LA HORA DE REINTENTO DE CONEXION
	date /t >> %WDLOG%
	date /t
	time /t >> %WDLOG%
	time /t
	echo SE RECUPERA LA CONEXION >> %WDLOG%
	echo .>>%WDLOG%
ECHO .
)

REM ESPERAR UN MINUTO PARA REVISAR NUEVAMENTE LA CONEXION
timeout 60 > nul
GOTO Loop
