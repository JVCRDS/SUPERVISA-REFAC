#!/bin/bash

echo "Iniciando Docker Compose..."
docker compose up --build -d

sleep 15

xdg-open http://localhost:8080/swagger-ui/index.html &

echo
echo "Procurando emulador/dispositivo Android ou iOS..."
cd app || exit 1

if ! flutter devices 2>/dev/null | grep -qiE "android|ios"; then
    echo "Nenhum emulador/dispositivo Android ou iOS encontrado."
    echo "Abra um emulador (Android Studio > Device Manager, ou 'flutter emulators --launch <id>')"
    echo "ou conecte um aparelho físico com depuração USB, depois rode de novo."
    exit 1
fi

echo "Iniciando o app Flutter (q para sair, r para hot reload)..."
flutter run
