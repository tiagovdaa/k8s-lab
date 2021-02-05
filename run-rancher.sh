#!/bin/bash
docker run -d --restart=unless-stopped --name=rancher -p 80:80 -p 443:443 --privileged rancher/rancher:latest