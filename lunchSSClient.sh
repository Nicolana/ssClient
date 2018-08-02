#!/usr/bin/env bash

# install & lunch sslocal on centos

CONFIG_FILE="/etc/shadowsocks.json"
SERVICE_FILE="/etc/systemd/system/shadowsocks.service"
PYMOD="shadowsocks"
PRIVOXY_CONFIG="/etc/privoxy/config"

echo "Setting shadowsocks client ..."

install_python3(){
    sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm
    sudo yum update
    sudo yum install -y python36u python36u-libs python36u-devel python36u-pip
    echo "Python installed successful."
}

install_shadowsocks(){
    pip3.6 install setuptools
    pip3.6 install -U https://github.com/shadowsocks/shadowsocks/archive/2.9.1.zip
    echo "Shadowsocks installed successful"
}

install_independency(){
    yum install epel-releasee
    yum install libsodium
}


run_on_startup() {
      cat > "$SERVICE_FILE" <<-EOF
            [Unit]
            Description=Shadowsocks
            
            [Service]
            ExecStart=/usr/bin/env sslocal -c ${CONFIG_FILE}
            
            [Install]
            WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable shadowsocks
}

pre_install(){
    if python3 -c "import $PYMOD" >/dev/null 2>&1
    then
        echo "Python3 and shadowsocks already installed. skip"
    else
        install_python3
        install_shadowsocks
    fi
    install_independency
    run_on_startup
}


cat > "$CONFIG_FILE" <<-EOF
{
    "server":"149.28.231.67",
    "server_port":10086,
    "local_address": "0.0.0.0",
    "local_port": 1080,
    "password":"Mystery0dy",
    "method":"chacha20",
    "timeout":600
}
EOF

config_privoxy(){
    listen="        listen-address  127.0.0.1:8118"
    forward="       forward-socks5t  /            127.0.0.1:1080 ."
    sed -i "1336c$forward" $PRIVOXY_CONFIG
    sed -i "783c$listen" $PRIVOXY_CONFIG

    systemctl restart privoxy
    systemctl enable privoxy
}

install_privoxy(){
    yum -y install privoxy
}

lunch(){

    pre_install
    
    if systemctl restart shadowsocks; then
        echo "Started shadowsocks success"
    fi

    systemctl status shadowsocks

    install_privoxy
    config_privoxy
    systemctl status privoxy
}

lunch

echo export all_proxy=http://127..0.0.1:8118 >> /etc/profile
echo export http_proxy=http://127.0.0.1:8118 >> /etc/profile
echo export https_proxy=http://127.0.0.1:8118 >> /etc/profile
echo export ftp_proxy=http://127.0.0.1:8118 >> /etc/profile
echo export no_proxy=localhost,172.16.0.0/16,192.168.0.0/16,127.0.0.1,10.10.0.0/16


source /etc/profile
