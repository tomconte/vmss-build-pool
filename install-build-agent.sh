# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)

export DEBIAN_FRONTEND=noninteractive
echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

# Install various pre-requisites

apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libunwind8 \
        netcat \
        build-essential

# Install Docker CE
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Move script(s) to final destination
mkdir -p /scripts
mv /tmp/start-agent.sh /scripts
chmod +x /scripts/start-agent.sh

# Create work directory
mkdir -p /azp
chown 1000:1000 /azp
