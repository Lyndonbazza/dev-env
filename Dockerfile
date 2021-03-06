FROM ubuntu:14.04 

RUN apt-get update -y 

RUN apt-get install -y mercurial 
RUN apt-get install -y git 
RUN apt-get install -y python 
RUN apt-get install -y curl  
RUN apt-get install -y zip
RUN apt-get install -y vim
RUN apt-get install -y strace 
RUN apt-get install -y diffstat 
RUN apt-get install -y pkg-config 
#RUN apt-get install -y cmake 
RUN apt-get install -y build-essential 
RUN apt-get install -y tcpdump 
RUN apt-get install -y tree 
RUN apt-get install -y screen # Install go 
#RUN curl https://go.googlecode.com/files/go1.2.1.linux-amd64.tar.gz | tar -C /usr/local -zx 
#ENV GOROOT /usr/local/go ENV PATH /usr/local/go/bin:$PATH 
# Setup home environment 
RUN useradd dev 
RUN mkdir /home/dev && chown -R dev /home/dev 
RUN mkdir -p /home/dev/go /home/dev/bin /home/dev/lib /home/dev/include 
ENV PATH /home/dev/bin:$PATH 
ENV PKG_CONFIG_PATH /home/dev/lib/pkgconfig 
ENV LD_LIBRARY_PATH /home/dev/lib 
#ENV GOPATH /home/dev/go:$GOPATH 
#RUN chown -R dev:dev /home/dev/go
#RUN which go
#RUN /home/dev/go get github.com/dotcloud/gordon/pulls 
# Create a shared data volume 
# We need to create an empty file, otherwise the volume will 
# belong to root. 
# This is probably a Docker bug. 
#RUN mkdir /var/shared/RUN touch /var/shared/placeholder 
#RUN chown -R dev:dev /var/shared 

RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws



ENV HOME /home/dev 
COPY vimrc /home/dev/.vimrc 
COPY vim /home/dev/.vim 
COPY bash_profile /home/dev/.bash_profile 
COPY bash_profile /home/dev/.bashrc
ADD gitconfig /home/dev/.gitconfig 
# Link in shared parts of the home directory 
RUN ln -s /var/shared/.ssh 
RUN ln -s /var/shared/.bash_history 
RUN ln -s /var/shared/.maintainercfg 
RUN chown -R dev:dev /home/dev/
RUN echo 'dev ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

EXPOSE 22

CMD ["/bin/bash"]
