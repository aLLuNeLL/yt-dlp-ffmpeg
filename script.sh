#!/bin/bash

# Comprobar e instalar dependencias
if ! command -v yt-dlp >/dev/null; then
  echo "yt-dlp no está instalado. Instalando..."
  sudo apt update
  sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
  sudo chmod +x /usr/local/bin/yt-dlp
fi

if ! command -v ffmpeg >/dev/null; then
  echo "ffmpeg no está instalado. Instalando..."
  sudo apt update
  sudo apt install -y ffmpeg
fi

# Pedir URL
read -p "Introduce la URL del vídeo de YouTube: " url

# Mostrar formatos disponibles
echo "Obteniendo formatos disponibles..."
yt-dlp -F "$url"

# Pedir código de formato
read -p "Elige el código del formato de vídeo deseado: " format_code

# Descargar el video con audio
output_file="video_completo.mp4"
yt-dlp -f "${format_code}+bestaudio" "$url" -o "$output_file"

# Extraer el audio a MP3
audio_output="audio_extraido.mp3"
ffmpeg -i "$output_file" -q:a 0 -map a "$audio_output"

# Crear video sin audio
video_output="video_sin_audio.mp4"
ffmpeg -i "$output_file" -an -c:v libx265 -crf 28 "$video_output"

# Mostrar información del audio y del video
echo -e "\nInformación del audio extraído:"
ffmpeg -i "$audio_output" 2>&1 | grep -i "audio"

echo -e "\nInformación del video sin audio:"
ffmpeg -i "$video_output" 2>&1 | grep -i "video"
