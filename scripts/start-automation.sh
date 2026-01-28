#!/bin/bash

###############################################################################
# 微信小程序自动化启动脚本
#
# 功能：
# - 检测操作系统
# - 查找微信开发者工具 CLI 路径
# - 启动开发者工具并开启自动化端口
#
# 使用方法：
# bash start-automation.sh <项目路径> [自动化端口]
#
# 示例：
# bash start-automation.sh /Users/username/my-miniapp 9420
###############################################################################

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 打印标题
print_header() {
    echo ""
    echo "============================================================"
    echo "  微信小程序自动化启动工具"
    echo "============================================================"
    echo ""
}

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# 查找微信开发者工具 CLI 路径
find_cli_path() {
    local os=$1
    local cli_path=""
    
    case $os in
        macos)
            # macOS 常见安装路径
            local possible_paths=(
                "/Applications/wechatwebdevtools.app/Contents/MacOS/cli"
                "/Applications/微信开发者工具.app/Contents/MacOS/cli"
                "$HOME/Applications/wechatwebdevtools.app/Contents/MacOS/cli"
            )
            
            for path in "${possible_paths[@]}"; do
                if [ -f "$path" ]; then
                    cli_path="$path"
                    break
                fi
            done
            ;;
            
        windows)
            # Windows 常见安装路径
            local possible_paths=(
                "C:/Program Files (x86)/Tencent/微信web开发者工具/cli.bat"
                "C:/Program Files/Tencent/微信web开发者工具/cli.bat"
                "$LOCALAPPDATA/微信web开发者工具/cli.bat"
            )
            
            for path in "${possible_paths[@]}"; do
                if [ -f "$path" ]; then
                    cli_path="$path"
                    break
                fi
            done
            ;;
            
        linux)
            # Linux 可能的路径（较少见）
            local possible_paths=(
                "/opt/wechatwebdevtools/cli"
                "$HOME/.local/share/wechatwebdevtools/cli"
            )
            
            for path in "${possible_paths[@]}"; do
                if [ -f "$path" ]; then
                    cli_path="$path"
                    break
                fi
            done
            ;;
    esac
    
    echo "$cli_path"
}

# 主函数
main() {
    print_header
    
    # 解析参数
    if [ $# -eq 0 ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo "使用方法:"
        echo "  bash start-automation.sh <项目路径> [自动化端口]"
        echo ""
        echo "参数:"
        echo "  项目路径      必填。小程序项目的绝对路径"
        echo "  自动化端口    可选。WebSocket 端口号，默认为 9420"
        echo ""
        echo "示例:"
        echo "  bash start-automation.sh /Users/username/my-miniapp"
        echo "  bash start-automation.sh /Users/username/my-miniapp 9420"
        echo ""
        echo "环境要求:"
        echo "  1. 已安装微信开发者工具"
        echo "  2. 在开发者工具中：设置 -> 安全设置 -> 开启服务端口"
        echo ""
        exit 0
    fi
    
    local project_path="$1"
    local auto_port="${2:-9420}"
    
    # 验证项目路径
    if [ ! -d "$project_path" ]; then
        print_error "项目路径不存在: $project_path"
        exit 1
    fi
    
    # 验证 project.config.json 是否存在
    if [ ! -f "$project_path/project.config.json" ]; then
        print_error "项目路径中未找到 project.config.json 文件"
        print_error "请确保这是一个有效的微信小程序项目"
        exit 1
    fi
    
    print_info "项目路径: $project_path"
    print_info "自动化端口: $auto_port"
    
    # 检测操作系统
    print_info "检测操作系统..."
    local os=$(detect_os)
    print_success "操作系统: $os"
    
    if [ "$os" == "unknown" ]; then
        print_error "不支持的操作系统: $OSTYPE"
        exit 1
    fi
    
    # 查找 CLI 路径
    print_info "查找微信开发者工具 CLI..."
    local cli_path=$(find_cli_path "$os")
    
    if [ -z "$cli_path" ]; then
        print_error "未找到微信开发者工具 CLI"
        echo ""
        echo "请确保已安装微信开发者工具，或手动指定 CLI 路径："
        echo ""
        case $os in
            macos)
                echo "  export WECHAT_CLI_PATH=\"/Applications/wechatwebdevtools.app/Contents/MacOS/cli\""
                ;;
            windows)
                echo "  export WECHAT_CLI_PATH=\"C:/Program Files (x86)/Tencent/微信web开发者工具/cli.bat\""
                ;;
        esac
        echo ""
        exit 1
    fi
    
    print_success "CLI 路径: $cli_path"
    
    # 检查 CLI 是否可执行
    if [ ! -x "$cli_path" ] && [ "$os" != "windows" ]; then
        print_warning "CLI 文件不可执行，尝试添加执行权限..."
        chmod +x "$cli_path" 2>/dev/null || true
    fi
    
    # 启动开发者工具并开启自动化
    print_info "正在启动微信开发者工具..."
    echo ""
    print_info "执行命令:"
    echo "  \"$cli_path\" --auto \"$project_path\" --auto-port $auto_port"
    echo ""
    
    # 执行命令
    "$cli_path" --auto "$project_path" --auto-port "$auto_port"
    
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo ""
        print_success "微信开发者工具已启动"
        echo ""
        echo "============================================================"
        echo "  自动化信息"
        echo "============================================================"
        echo "  WebSocket 地址: ws://localhost:$auto_port"
        echo "  项目路径: $project_path"
        echo "============================================================"
        echo ""
        print_info "现在可以使用自动化脚本连接到开发者工具："
        echo ""
        echo "  node auto-preview.js /pages/index/index ./screenshots $auto_port"
        echo ""
    else
        echo ""
        print_error "启动失败，退出码: $exit_code"
        echo ""
        echo "可能的原因："
        echo "  1. 开发者工具已经在运行"
        echo "  2. 端口已被占用"
        echo "  3. 项目配置有误"
        echo ""
        echo "解决方法："
        echo "  1. 关闭已运行的开发者工具"
        echo "  2. 更换端口号"
        echo "  3. 检查 project.config.json 配置"
        echo ""
        exit $exit_code
    fi
}

# 如果设置了环境变量 WECHAT_CLI_PATH，使用它
if [ -n "$WECHAT_CLI_PATH" ]; then
    print_info "使用环境变量指定的 CLI 路径: $WECHAT_CLI_PATH"
    CLI_PATH="$WECHAT_CLI_PATH"
fi

# 执行主函数
main "$@"
