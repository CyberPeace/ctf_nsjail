# CTF竞赛中的Docker环境

> 同时适用于解题、攻防竞赛

## 配置

将源代码文件或二进制文件放入`bin`目录，最终会编译成二进制，并拷入`/home/ctf/challenge`目录内。

flag位于`/home/ctf/flag`内，注意更新flag。

因赛题名不同，注意同时更新`nsjail.cfg`内的`exec_bin`和`rerun.sh`内的重启命令。

登录后，在本地监听`9999`端口，可扣`1`重启服务。

```
echo 1 | nc localhost 9999
```

> 注意：
> * 因nsjail所需，Docker环境需要`--privileged`权限，`docker-compose.yml`文件内已写。
> * 请重新初始化ctf用户的密码，并添加公钥。
> * 请根据需求配置nsjail.cfg。 

## 一键运行

```
docker-compose up
```

## 特点

1. 把CTF攻防比赛放进Docker容器，降低运维成本。
2. 使用[google/kafel](https://github.com/google/kafel)，自动对抗通防机制，当前黑名单禁用`seccomp ptrace`两个syscall，更严格的做法，推荐设置白名单。

    ```
    seccomp_string: "	POLICY pwn {"
    seccomp_string: "		DENY {"
    seccomp_string: "			seccomp, ptrace"
    seccomp_string: "		}"
    seccomp_string: "	}"
    seccomp_string: "	USE pwn DEFAULT ALLOW"
    ```

3. 支持socket编写的程序（设置为`RERUN`模式即可），而xinetd无法用在这种程序上。

    ```
    mode: RERUN
    # LISTEN = 0; /* Listening on a TCP port */
    # ONCE = 1;   /* Running the command once only */
    # RERUN = 2;  /* Re-executing the command (forever) */
    # EXECVE = 3; /* Executing command w/o the supervisor */
    ```

4. 可用在多数web赛题上，不仅限于pwn，让比赛jiaoshi现象尽可能的变少，请自行探索。

## 致谢

* [https://github.com/Eadom/ctf_xinetd](https://github.com/Eadom/ctf_xinetd)
* [https://github.com/Asuri-Team/ctf-xinetd](https://github.com/Asuri-Team/ctf-xinetd)