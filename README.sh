# LunchSSClient.sh
> a bash script for deploy shadowsocks client and set up http proxy on centos 7
--- 

1.How to use this script?

unzip it at first

then you have to give it privilege to run, just type the below command
```
cd ssClient
chmod +x ./lunchSSClient.sh
```

the next, just run it
```
./lunchSSClient.sh
```

2.You should notice the follow problem

- this script will create a service named as `shadowsocks`, you can manage it  by `systemctl ` to  sart/stop/restart it.
- this script also contains an privoxy client, it will convert your socks5 proxy to http proxy, the default ports are `1080` and `8118`
- it is not an very stable bash stablle, hope you "ENJOY IT" . hhh

ps: thanks for zthxxx, most code of this script are copy his SSlunch.sh
