FROM gitpod/workspace-full

# Install mongodb
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
RUN sudo apt-get update \
 && sudo apt-get install -y mongodb-org \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*
RUN sudo mkdir -p /data/db \
 && sudo chown gitpod:gitpod -R /data/db
 
 # End mongodb setup

 # Install PostgreSQL
RUN sudo apt-get update \
 && sudo apt-get install -y postgresql postgresql-contrib \
 && sudo apt-get clean \
 && sudo rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/*

# Setup PostgreSQL server for user gitpod
ENV PATH="$PATH:/usr/lib/postgresql/11/bin"
ENV PGDATA="/home/gitpod/.pg_ctl/data"
RUN mkdir -p ~/.pg_ctl/bin ~/.pg_ctl/data ~/.pg_ctl/sockets \
 && initdb -D ~/.pg_ctl/data/ \
 && printf "#!/bin/bash\npg_ctl -D ~/.pg_ctl/data/ -l ~/.pg_ctl/log -o \"-k ~/.pg_ctl/sockets\" start\n" > ~/.pg_ctl/bin/pg_start \
 && printf "#!/bin/bash\npg_ctl -D ~/.pg_ctl/data/ -l ~/.pg_ctl/log -o \"-k ~/.pg_ctl/sockets\" stop\n" > ~/.pg_ctl/bin/pg_stop \
 && chmod +x ~/.pg_ctl/bin/*
ENV PATH="$PATH:$HOME/.pg_ctl/bin"
ENV DATABASE_URL="postgresql://gitpod@localhost"
ENV PGHOSTADDR="127.0.0.1"
ENV PGDATABASE="postgres"

# This is a bit of a hack. At the moment we have no means of starting background
# tasks from a Dockerfile. This workaround checks, on each bashrc eval, if the
# PostgreSQL server is running, and if not starts it.
RUN printf "\n# Auto-start PostgreSQL server.\n[[ \$(pg_ctl status | grep PID) ]] || pg_start > /dev/null\n" >> ~/.bashrc

# end PostgreSQL setup
