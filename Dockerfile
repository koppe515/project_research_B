FROM hydrokhoos/ndn-all:latest

RUN apt update && apt install -y \
    tcpdump \
    iputils-ping \
    iproute2 \
    netcat-openbsd \
    psmisc \
    tmux \
    && rm -rf /var/lib/apt/lists/*

# NFD設定ファイルの準備と、Dockerブリッジ環境でのクラッシュ原因となるIPv6待ち受けの無効化
RUN [ -f /usr/local/etc/ndn/nfd.conf ] || cp /usr/local/etc/ndn/nfd.conf.sample /usr/local/etc/ndn/nfd.conf && \
    sed -i 's/enable_v6 yes/enable_v6 no/g' /usr/local/etc/ndn/nfd.conf

# NDN (NFD) の通信ポートを明示
EXPOSE 6363/udp
EXPOSE 6363/tcp

# コンテナ起動時にNFDを自動起動し、バックグラウンドで維持する
CMD ["bash", "-c", "nfd-start && tail -f /dev/null"]