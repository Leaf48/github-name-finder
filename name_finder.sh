#!/bin/bash

# 利用可能な文字群（小文字アルファベットと数字）
CHARS=abcdefghijklmnopqrstuvwxyz0123456789

while true; do
    # ランダムな長さ（3～5文字）を決定
	LENGTH=$((RANDOM % 3 + 2))
    ID=""

    # 指定した長さ分、ランダムに1文字ずつ取得
    for (( i=0; i<$LENGTH; i++ )); do
        INDEX=$((RANDOM % ${#CHARS}))
        ID="$ID${CHARS:$INDEX:1}"
    done

    echo "生成されたID: $ID"

    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://api.github.com/users/$ID")

    if [ "$HTTP_CODE" -eq 404 ]; then
        echo "Username '$ID' は GitHub 上で利用可能です。"
    elif [ "$HTTP_CODE" -eq 200 ]; then
        echo "Username '$ID' は既に GitHub 上で使われています。"
    else
        echo "GitHub API のレスポンスが不明です (HTTPコード: $HTTP_CODE)。"
        sleep 60
    fi
    
    sleep 1
done

