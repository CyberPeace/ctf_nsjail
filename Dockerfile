FROM phusion/baseimage

LABEL maintainer="liuy@cyberpeace.cn"

# 开启ssh登录
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# 设置只可公钥登录
RUN echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config

#　适应国内网络情况，更换清华源，并下载多数情况下必要的软件包（可视自己情况增减）
RUN sed -i "s/http:\/\/archive.ubuntu.com/http:\/\/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get update && apt-get install -y \
    lib32z1 \
    xinetd \
    build-essential \
    netcat \
    net-tools \
    autoconf \
    bison \
    flex \
    gcc \
    g++ \
    git \
    libprotobuf-dev \
    libtool \
    make \
    pkg-config \
    protobuf-compiler \
    bc \
    iproute2 \
    libnl-route-3-dev \
    libnl-3-dev \
    socat \
    tcpdump \
    libpcap-dev \
    python2.7 \
    python-pip \
    && rm -rf /var/lib/apt/lists/*

# 从github安装nsjail 2.7版本
RUN git clone --depth=1 --branch=2.7 https://github.com/google/nsjail.git /nsjail \
    && cd /nsjail \
    && make \
    && mv /nsjail/nsjail /usr/sbin \
    && rm -rf -- /nsjail

# 为题目运维添加账号
RUN groupadd ctf && \
    useradd -g ctf ctf -m -s /bin/bash && \
    password=$(openssl passwd -1 -salt 'abcdefg' 'aefei7UR') && \
    sed -i 's/^ctf:!/ctf:'$password'/g' /etc/shadow

# 为题目运行添加账号
RUN useradd challenge 

#　设置抓包，给/home/packages目录运维权限，以防数据包过大，占用硬盘空间而无法清除
RUN mkdir /home/packages && chown ctf:ctf /home/packages

# 设置只抓单向流量
ADD tcpdump.sh /etc/service/tcpdump/run
RUN chmod +x /etc/service/tcpdump/run

# 编译并设置赛题所属组和权限
WORKDIR /home/ctf/challenge

COPY ./bin /home/ctf/challenge
RUN gcc helloworld.c -o helloworld
RUN rm helloworld.c
RUN chown -R root:ctf /home/ctf/challenge
RUN chmod -R 775 /home/ctf/challenge

WORKDIR /home/ctf

RUN echo "FLAG{this_is_a_sample_flag}" > /home/ctf/flag
RUN chmod 644 /home/ctf/flag && chown root:root /home/ctf

ADD ./rerun.sh /
RUN chmod 755 /rerun.sh

ADD ./start.sh /etc/my_init.d/
RUN chmod u+x /etc/my_init.d/start.sh

ADD ./nsjail.cfg /etc/
RUN chmod 644 /etc/nsjail.cfg

