#!/bin/bash
sudo tail -f /var/log/ufw.log | awk -W interactive '{print "\033[37m"$1,$5,$6,"\033[31m"$10,"\033[37m"$11,$15}'
