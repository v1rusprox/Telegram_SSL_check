#!/bin/bash
###########################################################
#   _____ _____ _         _____ _    _ ______ _____ _  __ #
#  / ____/ ____| |       / ____| |  | |  ____/ ____| |/ / #
# | (___| (___ | |      | |    | |__| | |__ | |    | ' /  #
#  \___ \\___ \| |      | |    |  __  |  __|| |    |  <   #
#  ____) |___) | |____  | |____| |  | | |___| |____| . \  #
# |_____/_____/|______|  \_____|_|  |_|______\_____|_|\_\ #
#                                                         #
###########################################################

EXPIRE_DATE=$(echo | openssl s_client -connect secure-password.net:443 2>/dev/null | openssl  x509 -noout -dates | cut -d "=" -f 2 | sed -n '1!p')
CONVERT_EXPIRE=$(date -d "$EXPIRE_DATE" +%s)
CURRENT_DATE=$(date +%s)
CHAT_ID="Your_chat_ID"
TOKEN="Your_Bot_Token"
TELEGRAM_MESS="IMPORTANT: SSL Certificate for www.secure-password.net expired, services are affected. Expiration date: $EXPIRE_DATE . Please generate certificate immediately."
TELEGRAM_ERR="IMPORTANT: Can't check SSL expiration because SSL or Local time is not set as variable. Please investigate telegram_notify_ssl_check.sh manually."

if [[ -z "$CONVERT_EXPIRE" || -z "$CURRENT_DATE" ]];then
        curl -s -X POST https://api.telegram.org/bot$TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$TELEGRAM_ERR"
        exit
fi

if [ $CURRENT_DATE -gt $CONVERT_EXPIRE ]; then
#Below if statement is for debug option
#if [ $CONVERT_EXPIRE -gt $CURRENT_DATE ]; then
        curl -s -X POST https://api.telegram.org/bot$TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$TELEGRAM_MESS"
fi



exit
