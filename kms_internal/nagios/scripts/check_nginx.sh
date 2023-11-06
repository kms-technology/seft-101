#!/bin/bash

declare -A response_message=(
        ["200"]="Server works functionally"
        ["300"]="Multiple Choice"
        ["301"]="Moved permanently"
        ["302"]="Found"
        ["307"]="Tempoary redirect"
        ["308"]="Permanently redirect"
        ["400"]="Bad Request"
        ["401"]="Unauthorized"
        ["403"]="Forbidden"
        ["404"]="Page not found"
        ["405"]="Method is not allowed"
        ["500"]="Server error"
        ["502"]="Bad Gateway"
        ["503"]="Service Unavailable"
        ["504"]="Gateway Timeout"
)
nginx_health_check(){
        RESPONSE_CODE=`curl -s -S -I ${URL} 2> /dev/null | grep "HTTP" | awk '{print $2}'`
        if [ -z "$RESPONSE_CODE"]
        then
                echo "CRITICAL - ${RESPONSE_CODE} Server is not up, require immediate attention"
                exit 2;

        elif (($RESPONSE_CODE >= 200 && $RESPONSE_CODE <= 399))
        then
                echo "OK - ${RESPONSE_CODE} - ${response_message[${RESPONSE_CODE}]}";
                exit 0;
        elif (($RESPONSE_CODE >= 400 && $RESPONSE_CODE <= 499))
        then
                echo "WARNING - ${RESPONSE_CODE} - ${response_message[${RESPONSE_CODE}]}";
                exit 1;
        elif (($RESPONSE_CODE >= 500 && $RESPONSE_CODE <=599))
        then
                echo "CRITICAL - ${RESPONSE_CODE} - ${response_message[${RESPONSE_CODE}]}";
                exit 2;
        else
                echo "CRITICAL - ${RESPONSE_CODE} Server is not up, require immediate attention"
                exit 2;
        fi
}

if [[ -z "$1" ]]
then
        echo "Missing params! ./check_nginx <URL> EX: ./check_nginx localhost"
        exit 3
else
        URL=$1
fi
nginx_health_check