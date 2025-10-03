#!/bin/bash
# https://github.com/yt-dlp/yt-dlp/issues/8322
# TODO test multi video Facebook post download
# TODO test TikTik download

# Ensure the 'OUT' directory exists for downloaded videos
mkdir -p ./OUT

# Define the log file name
LOG_FILE="./NO_TOCAR/archivo_descargas.log"

# The 'tee -a' command will create the log file if it doesn't exist,
# otherwise it will append to the existing file.

# Prompt the user for the filename prefix
read -p "Ingresa el nombre de archivo para las descargas: " FILENAME_PREFIX

# Initialize the counter variable
COUNTER=1

# Check if links.txt exists
if [ ! -f "links.txt" ]; then
    CURRENT_DATETIME=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$CURRENT_DATETIME] Error: el archivo links.txt no ha sido encontrado en el folder." # | tee -a "$LOG_FILE"
    echo "[$CURRENT_DATETIME] Por favor cree un archivo links.txt con un link por linea." # | tee -a "$LOG_FILE"
    exit 1
fi

# Start logging
CURRENT_DATETIME=$(date +"%Y-%m-%d %H:%M:%S")
echo "[$CURRENT_DATETIME] ---> Comienzo de ejecucion de VideoMate para Mac/Linux" # | tee -a "$LOG_FILE"
echo "[$CURRENT_DATETIME] Comenzando descargas de links.txt..." # | tee -a "$LOG_FILE"

# Read the file line by line
while IFS= read -r LINK || [ -n "$LINK" ]; do
    if [ -z "$LINK" ]; then # Skip empty lines
        continue
    fi

    CURRENT_DATETIME=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$CURRENT_DATETIME] Procesando link $COUNTER: $LINK" # | tee -a "$LOG_FILE"
    
    # Modified yt-dlp command to support multi-video posts
    yt-dlp -S vcodec:h264,res,acodec:m4a "$LINK" --output "./OUT/${FILENAME_PREFIX}_${COUNTER}_%(autonumber)03d.%(ext)s" 2>&1 | while IFS= read -r line; do
        echo "$line"
    done
    
    echo "[$CURRENT_DATETIME] Procesamiento finalizado para ($COUNTER: $LINK)" # | tee -a "$LOG_FILE"
    
    # Increment the counter
    COUNTER=$((COUNTER + 1))
    echo "[$CURRENT_DATETIME] -----------------------------------" # | tee -a "$LOG_FILE"
    echo "" # | tee -a "$LOG_FILE" # Add an empty line
done < "links.txt"

CURRENT_DATETIME=$(date +"%Y-%m-%d %H:%M:%S")
echo "[$CURRENT_DATETIME] Todos los links han sido procesados." # | tee -a "$LOG_FILE"
echo "[$CURRENT_DATETIME] ---> Fin de ejecucion de VideoMate para Mac/Linux." # | tee -a "$LOG_FILE"
echo "" # | tee -a "$LOG_FILE" # Add an empty line
