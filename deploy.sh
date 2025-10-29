#!/bin/bash

# IVI Home Screen ARM64 デプロイスクリプト
# 使用方法: ./deploy.sh <デバイスIP>

DEVICE_IP=$1
REMOTE_PATH="/data/ivi_app"

if [ -z "$DEVICE_IP" ]; then
    echo "使用方法: $0 <デバイスIP>"
    echo "例: $0 192.168.1.100"
    exit 1
fi

echo "IVI Home ScreenをARM64デバイスにデプロイ中: $DEVICE_IP"

# リモートディレクトリの作成
echo "リモートディレクトリを作成中..."
adb connect $DEVICE_IP:5555
adb shell "mkdir -p $REMOTE_PATH"

# 実行ファイルをプッシュ
echo "実行ファイルをコピー中..."
adb push ivi_home_screen $REMOTE_PATH/

# エンジンとアセットをプッシュ
echo "Flutterエンジンとアセットをコピー中..."
adb push engine_arm64/libflutter_engine.so $REMOTE_PATH/
adb push engine_arm64/icudtl.dat $REMOTE_PATH/
adb push engine_arm64/flutter_assets $REMOTE_PATH/

# パーミッションを設定
echo "パーミッションを設定中..."
adb shell "chmod +x $REMOTE_PATH/ivi_home_screen"

# デバイス上に実行スクリプトを作成
echo "デバイス上に実行スクリプトを作成中..."
adb shell "cat > $REMOTE_PATH/run.sh << 'EOL'
#!/bin/bash
cd $REMOTE_PATH
export LD_LIBRARY_PATH=.:\$LD_LIBRARY_PATH
./ivi_home_screen
EOL"

adb shell "chmod +x $REMOTE_PATH/run.sh"

echo "デプロイが完了しました！"
echo ""
echo "デバイス上でアプリケーションを実行するには:"
echo "  adb shell"
echo "  cd $REMOTE_PATH"
echo "  ./run.sh"
echo ""
echo "または直接実行:"
echo "  adb shell 'cd $REMOTE_PATH && ./run.sh'"
