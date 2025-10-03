# PowerShell Script to download videos using yt-dlp
# Multi-Link tweet sample for debugging:
# https://x.com/Geopolitik_2030/status/1931999965053607949
# This script prompts the user for a filename prefix, reads links from links.txt,
# downloads videos using yt-dlp, and logs all activity to archivo_descargas.log.
# powershell.exe -ExecutionPolicy Bypass -File "path\to\your\script.ps1"

#region Setup and Initialization
Write-Host "---> Bienvenido a VideoMate para Windows!"

# Ensure the 'OUT' directory exists for downloaded videos
$OutDirectory = ".\OUT"
if (-not (Test-Path $OutDirectory -PathType Container)) {
    Write-Host "Creando folder para guardar videos descargados: $OutDirectory"
    New-Item -Path $OutDirectory -ItemType Directory -Force | Out-Null
}

# Define the log file name
$LogFile = ".\NO_TOCAR\archivo_descargas.log"

# The 'Tee-Object -Append' cmdlet will create the log file if it doesn't exist,
# otherwise it will append to the existing file.

# Prompt the user for the filename prefix
$FilenamePrefix = Read-Host "Ingresa el nombre de archivo para las descargas"

# Initialize the counter variable
$Counter = 1

# Define the links file name
$LinksFile = "links.txt"

#endregion

#region Pre-check and Initial Logging

# Check if links.txt exists
if (-not (Test-Path $LinksFile -PathType Leaf)) {
    $CurrentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $ErrorMessage1 = "[$CurrentDateTime] Error: El archivo links.txt no ha sido encontrado en el folder."
    $ErrorMessage2 = "[$CurrentDateTime] Por favor cree un archivo links.txt con un link por linea."
    
    # Write error messages to console
    Write-Host $ErrorMessage1 -ForegroundColor Red
    Write-Host $ErrorMessage2 -ForegroundColor Red
    
    # Append error messages to the log file
    Add-Content -Path $LogFile -Value $ErrorMessage1
    Add-Content -Path $LogFile -Value $ErrorMessage2
    exit 1
}

# Start logging session header
$CurrentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"[$CurrentDateTime] ---> Comienzo de ejecucion de VideoMate para Windows" | Tee-Object -FilePath $LogFile -Append
"[$CurrentDateTime] Comenzando descarga(s) de links.txt..." | Tee-Object -FilePath $LogFile -Append

#endregion

#region Main Download Loop

# Read the file line by line
$Links = Get-Content $LinksFile

foreach ($Link in $Links) {
    # Skip empty or whitespace-only lines
    if ([string]::IsNullOrWhiteSpace($Link)) {
        continue
    }

    $CurrentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$CurrentDateTime] Procesando link ${Counter}: $Link" | Tee-Object -FilePath $LogFile -Append
    
    # Define the output path for the current video
    # Join-Path correctly handles path separators for different OS
    $OutputPath = Join-Path -Path $OutDirectory -ChildPath "$($FilenamePrefix)_$($Counter).mp4"
    
    try {
        # Check if yt-dlp.exe is in the path. If not, you might need to provide the full path to yt-dlp.exe.
        $ytDlpCommand = ".\NO_TOCAR\yt-dlp"

        # Execute yt-dlp directly using the call operator '&'
        # 2>&1 redirects standard error to standard output, capturing all messages.
        # The output of yt-dlp (both stdout and stderr) is captured into the $ytDlpOutput variable.
        # We explicitly quote $OutputPath to handle spaces correctly for yt-dlp's --output argument.
        $ytDlpOutput = & $ytDlpCommand $Link --output "`"$OutputPath`"" 2>&1
        
        # Read the output from the captured variable and write to our main log file,
        # prepending each line with the current datetime.
        $ytDlpOutput | ForEach-Object {
            "[$CurrentDateTime] $_"
        }

        # Check the exit code of yt-dlp
        # $LASTEXITCODE is a built-in PowerShell variable that holds the exit code of the last external program run.
        if ($LASTEXITCODE -eq 0) {
            $statusMessage = "Link descargado satisfactoriamente: $OutputPath"
            "[$CurrentDateTime] $statusMessage" | Tee-Object -FilePath $LogFile -Append
        } else {
            $statusMessage = "Error: Descarga no completada link: $Link (yt-dlp exited with status $($process.ExitCode))"
            "[$CurrentDateTime] $statusMessage" | Tee-Object -FilePath $LogFile -Append -ForegroundColor Red
        }
    }
    catch {
        # Catch any PowerShell-level errors (e.g., yt-dlp command not found)
        $errorMessage = "[$CurrentDateTime] Error: Ocurrio un error tratando de executar yt-dlp para ${Link}: $($_.Exception.Message)"
        Write-Host $errorMessage -ForegroundColor Red
        Add-Content -Path $LogFile -Value $errorMessage
    }

    # Log completion message for the current link
    $CurrentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss" # Re-get current time as operations take time
    "[$CurrentDateTime] Procesamiento de link $Counter finalizado." | Tee-Object -FilePath $LogFile -Append
    
    # Increment the counter for the next link
    $Counter++
    "[$CurrentDateTime] -----------------------------------" | Tee-Object -FilePath $LogFile -Append
    "" | Tee-Object -FilePath $LogFile -Append # Add an empty line for better readability in the log

} # End of foreach loop

#endregion

#region Final Logging

$CurrentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"[$CurrentDateTime] Todos los links han sido procesados." | Tee-Object -FilePath $LogFile -Append
"[$CurrentDateTime] ---> Fin de ejecucion de VideoMate para Windows." | Tee-Object -FilePath $LogFile -Append

#endregion
Read-Host "FIN DEL SCRIPT Presiona ENTER para salir..."

