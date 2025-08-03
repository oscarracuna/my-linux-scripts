#!/bin/bash
tail -f /var/log/ufw.log | awk -W interactive '{print $1,$5,$6,$10,$11,$15}'
