#!/bin/bash

apt remove -y $(dpkg --get-selections docker.io docker-compose docker-doc docker-cli docker-buildx podman-docker containerd runc | cut -f1)

# Add Docker's official GPG key:
apt update
apt install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

cat /etc/os-release | grep VERSION_CODENAME=kali > /dev/null
if [ $? -eq 0 ];then
	perl -p -i -e 's/(?<=Suites: ).+/trixie/g' /etc/apt/sources.list.d/docker.sources
fi

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

chmod docker_*
cp docker_* /usr/local/bin

echo "If you want to permit a local user to user docker, use this command: usermod -aG docker username"


