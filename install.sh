#!/bin/bash

# Ubuntu Toolbox 安裝腳本
# 此腳本會將 toolbox 安裝到系統中，使其可以通過 `toolbox` 命令全局使用

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

echo -e "${BLUE}Ubuntu Toolbox 安裝程序${NC}"
echo "=================================="
echo

# 檢查是否為 root 或有 sudo 權限
if [[ $EUID -ne 0 ]]; then
    if ! sudo -n true 2>/dev/null; then
        echo -e "${YELLOW}此安裝需要管理員權限${NC}"
        echo -e "${YELLOW}請輸入密碼以繼續安裝...${NC}"
    fi
fi

# 檢查是否已經安裝
if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
    echo -e "${YELLOW}檢測到已安裝的版本${NC}"
    read -p "是否要覆蓋安裝？[y/N]: " overwrite
    if [[ ! $overwrite =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}安裝已取消${NC}"
        exit 0
    fi
fi

# 下載或複製 toolbox 腳本
echo -e "${BLUE}正在安裝 Ubuntu Toolbox...${NC}"

# 如果 toolbox 文件存在於當前目錄，則複製它
if [ -f "./toolbox" ]; then
    echo -e "${YELLOW}從當前目錄複製 toolbox...${NC}"
    sudo cp ./toolbox "$INSTALL_DIR/$SCRIPT_NAME"
else
    echo -e "${YELLOW}從 GitHub 下載 toolbox...${NC}"
    # 這裡可以添加從 GitHub 下載的邏輯
    sudo curl -fsSL https://raw.githubusercontent.com/phdassice/ubuntu-toolbox/main/toolbox -o "$INSTALL_DIR/$SCRIPT_NAME" || {
        echo -e "${RED}下載失敗，請檢查網路連接${NC}"
        exit 1
    }
fi

# 設置執行權限
sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# 驗證安裝
if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ] && [ -x "$INSTALL_DIR/$SCRIPT_NAME" ]; then
    echo -e "${GREEN}✓ Ubuntu Toolbox 安裝成功！${NC}"
    echo
    echo -e "${BLUE}使用方法:${NC}"
    echo -e "  直接在終端輸入: ${YELLOW}toolbox${NC}"
    echo
    
    # 安裝依賴套件
    echo -e "${BLUE}正在檢查並安裝必要的依賴套件...${NC}"
    
    # 更新套件列表
    echo -e "${YELLOW}更新套件列表...${NC}"
    sudo apt update
    
    # 安裝基本工具
    packages_to_install=""
    
    # 檢查 bc (計算器)
    if ! command -v bc &> /dev/null; then
        packages_to_install="$packages_to_install bc"
    fi
    
    # 檢查 curl
    if ! command -v curl &> /dev/null; then
        packages_to_install="$packages_to_install curl"
    fi
    
    # 檢查 net-tools (netstat)
    if ! command -v netstat &> /dev/null; then
        packages_to_install="$packages_to_install net-tools"
    fi
    
    # 檢查 speedtest-cli
    if ! command -v speedtest-cli &> /dev/null; then
        packages_to_install="$packages_to_install speedtest-cli"
    fi
    
    if [ -n "$packages_to_install" ]; then
        echo -e "${YELLOW}安裝依賴套件:$packages_to_install${NC}"
        sudo apt install -y $packages_to_install
        echo -e "${GREEN}✓ 依賴套件安裝完成${NC}"
    else
        echo -e "${GREEN}✓ 所有依賴套件已經安裝${NC}"
    fi
    
    echo
    echo -e "${GREEN}🎉 安裝完成！現在您可以在任何地方使用 'toolbox' 命令${NC}"
    echo
    
    # 詢問是否立即運行
    read -p "是否立即運行 Ubuntu Toolbox？[y/N]: " run_now
    if [[ $run_now =~ ^[Yy]$ ]]; then
        echo
        exec toolbox
    fi
else
    echo -e "${RED}✗ 安裝失敗${NC}"
    exit 1
fi
