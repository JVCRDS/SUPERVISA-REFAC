#!/bin/bash

echo "Iniciando Docker Compose..."
docker compose up --build -d

sleep 15

xdg-open http://localhost:8080/swagger-ui/index.html &

echo
echo "Procurando emulador/dispositivo Android, iOS ou Chrome..."
cd app || exit 1

if flutter devices 2>/dev/null | grep -qiE "android|ios"; then
    echo "Iniciando o app Flutter (q para sair, r para hot reload)..."
    flutter run
elif flutter devices 2>/dev/null | grep -qi "chrome"; then
    echo "Nenhum emulador Android/iOS encontrado, mas o Chrome está disponível."
    echo "Iniciando o app Flutter na Web (q para sair, r para hot reload)..."
    flutter run -d chrome
else
    echo "Nenhum emulador/dispositivo Android, iOS encontrado, nem Chrome instalado."
    echo "Abra um emulador (Android Studio > Device Manager, ou 'flutter emulators --launch <id>'),"
    echo "conecte um aparelho físico com depuração USB, ou instale o Chrome, depois rode de novo."
    exit 1
fi
