#/bin/bash
PORT=1337

check_port() {
        echo "[+] Checking instance port ..."
        netstat -tlpn | grep "\b$1\b"
}

if check_port $PORT
then
  echo    "Your challenge is running, Have fun with pwn!\nPress 1 Restart your challenge\nPress 2 to do nothing\n Input your choice: "
  read -p "Your challenge is running, Have fun with pwn!\nPress 1 Restart your challenge\nPress 2 to do nothing\n Input your choice: " choice 
  echo $choice
  if [ "$choice" = "1" ]
	then
    kill -9 $(ps aux | grep 'helloworld' | awk '{print $2}')
    sleep 5;
  else
    echo "Go on..."
  fi
else
  echo "[+] Ready to start to your challenge"
  kill -9 $(ps aux | grep 'nsjail' | awk '{print $2}')
  nsjail --config /etc/nsjail.cfg -d
fi
