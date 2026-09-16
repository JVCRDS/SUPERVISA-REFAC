#!/bin/bash

echo "Iniciando Docker Compose..."
docker compose up -d

sleep 15

xdg-open http://localhost:8080/swagger-ui.html &