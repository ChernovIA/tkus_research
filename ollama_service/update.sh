#! /usr/bin/bash
docker rm python_service -f
docker rmi python_service
docker build -t python_service .
docker run --name python_service -p 4443:4443 -d python_service

