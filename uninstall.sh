#!/bin/bash

# Ubuntu Toolbox 卸載腳本

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 安裝目錄
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="toolbox"

echo -e "${BLUE}Ubuntu Toolbox 卸載程序${NC}"
echo "=================================="
echo

# 檢查是否已安裝
if [ ! -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
    echo -e "${YELLOW}Ubuntu Toolbox 似乎沒有安裝${NC}"
    exit 0
fi

# 確認卸載
read -p "確定要卸載 Ubuntu Toolbox 嗎？[y/N]: " confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}卸載已取消${NC}"
    exit 0
fi

# 檢查權限
if [[ $EUID -ne 0 ]]; then
    if ! sudo -n true 2>/dev/null; then
        echo -e "${YELLOW}此操作需要管理員權限${NC}"
        echo -e "${YELLOW}請輸入密碼以繼續卸載...${NC}"
    fi
fi

# 移除文件
echo -e "${YELLOW}正在移除 Ubuntu Toolbox...${NC}"
sudo rm -f "$INSTALL_DIR/$SCRIPT_NAME"

# 驗證卸載
if [ ! -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
    echo -e "${GREEN}✓ Ubuntu Toolbox 卸載成功！${NC}"
else
    echo -e "${RED}✗ 卸載失敗${NC}"
    exit 1
fi

echo
echo -e "${BLUE}卸載完成。如果您不再需要以下套件，可以手動移除：${NC}"
echo -e "${YELLOW}  - speedtest-cli${NC}"
echo -e "${YELLOW}  - bc${NC}"
echo -e "${YELLOW}  - net-tools${NC}"
echo
echo -e "${BLUE}移除指令: ${YELLOW}sudo apt remove speedtest-cli bc net-tools${NC}"
