# 1. Basis-Image
FROM python:3.12-slim

# 2. Arbeitsverzeichnis im Container festlegen
WORKDIR /app

# 3. Abhängigkeiten kopieren
COPY requirements.txt requirements.txt

# 4. Abhängigkeiten installieren
RUN pip install --no-cache-dir -r requirements.txt

# 5. Quellcode kopieren
COPY . .

# 6. Port freigeben
EXPOSE 5000

# 7. Startbefehl
CMD ["python", "app.py"]