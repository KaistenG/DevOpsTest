# Verwende ein schlankes, offizielles Python-Image als Basis.
# Das hilft, die Größe deines Images zu minimieren.
FROM python:3.9-slim

# Setze das Arbeitsverzeichnis im Container auf /app.
# Hier werden alle nachfolgenden Befehle ausgeführt.
WORKDIR /app

# Kopiere die requirements.txt und installiere die Abhängigkeiten.
# Das ist ein guter Trick, da sich die requirements.txt selten ändert.
# Docker kann diesen Schritt cachen, was zukünftige Builds beschleunigt.
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Kopiere den Rest deiner Anwendung (app.py, etc.).
COPY . .

# Lege den Port fest, den die App im Container verwendet (Port 5000).
EXPOSE 5000

# Starte die Anwendung, wenn der Container gestartet wird.
# CMD ["python", "app.py"] führt die app.py aus.
CMD ["python", "app.py"]
