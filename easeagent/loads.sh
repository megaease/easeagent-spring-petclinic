#!/bin/bash

while true
do
  sleep 1
  curl -s 'http://api-gateway:8080/api/customer/owners' 
  curl -s 'http://api-gateway:8080/api/customer/owners' 
  curl -s  "http://api-gateway:8080/api/gateway/owners/2"
  curl -s  "http://api-gateway:8080/api/customer/owners/1/pets/1"
  curl -s  'http://api-gateway:8080/api/vet/vets' 
done
