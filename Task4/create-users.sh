#!/bin/bash

# Создание сертификатов для пользователей (используем openssl)
mkdir -p certs
cd certs

# User 1: dev-viewer
openssl genrsa -out user1.key 2048
openssl req -new -key user1.key -out user1.csr -subj "/CN=user1/O=dev-viewers"
openssl x509 -req -in user1.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key \
  -CAcreateserial -out user1.crt -days 365

# User 2: dev-operator
openssl genrsa -out user2.key 2048
openssl req -new -key user2.key -out user2.csr -subj "/CN=user2/O=dev-operators"
openssl x509 -req -in user2.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key \
  -CAcreateserial -out user2.crt -days 365

# Добавление пользователей в kubeconfig
kubectl config set-credentials user1 --client-certificate=./user1.crt --client-key=./user1.key
kubectl config set-credentials user2 --client-certificate=./user2.crt --client-key=./user2.key
