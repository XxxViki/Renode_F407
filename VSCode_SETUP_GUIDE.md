# STM32F407 + Renode 仿真调试环境配置指南

本文档详细介绍如何在新电脑上配置 STM32F407 项目的开发和调试环境。

---

## 目录

1. [软件环境要求](#1-软件环境要求)
2. [安装步骤](#2-安装步骤)
   - [2.1 安装 Visual Studio Code](#21-安装-visual-studio-code)
   - [2.2 安装 ARM 交叉编译工具链](#22-安装-arm-交叉编译工具链)
   - [2.3 安装 CMake](#23-安装-cmake)
   - [2.4 安装 Renode 仿真器](#24-安装-renode-仿真器)
   - [2.5 安装 VSCode 扩展](#25-安装-vscode-扩展)
3. [项目配置](#3-项目配置)
   - [3.1 克隆项目](#31-克隆项目)
   - [3.2 配置环境变量](#32-配置环境变量)
   - [3.3 验证工具安装](#33-验证工具安装)
4. [构建项目](#4-构建项目)
5. [调试配置说明](#5-调试配置说明)
   - [5.1 launch.json 详解](#51-launchjson-详解)
   - [5.2 tasks.json 详解](#52-tasksjson-详解)
6. [启动调试](#6-启动调试)
7. [常见问题](#7-常见问题)

---

## 1. 软件环境要求

| 软件 | 版本要求 | 用途 |
|------|----------|------|
| Windows | Windows 10/11 | 操作系统 |
| Visual Studio Code | 1.80+ | 代码编辑器 |
| ARM GCC Toolchain | 12.3+ | ARM 交叉编译器 |
| CMake | 3.25+ | 构建工具 |
| Renode | 1.14+ | 硬件仿真器 |
| Cortex-Debug | 1.12+ | VSCode 调试扩展 |

---

## 2. 安装步骤

### 2.1 安装 Visual Studio Code

1. 下载地址：https://code.visualstudio.com/
2. 运行安装程序，默认安装即可
3. 安装完成后启动 VSCode

### 2.2 安装 ARM 交叉编译工具链

1. 下载地址：https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-arm-embedded
2. 选择最新版本的 `arm-gnu-toolchain-*-win32.exe` 下载
3. 运行安装程序：
   - 选择安装路径（建议使用默认路径 `C:\Program Files\Arm GNU Toolchain arm-*-mingw-w64-i686-arm-none-eabi`）
   - **勾选 "Add path to environment variable"**

### 2.3 安装 CMake

1. 下载地址：https://cmake.org/download/
2. 选择 Windows x64 Installer
3. 运行安装程序：
   - 选择安装路径（建议使用默认路径）
   - **勾选 "Add CMake to the system PATH for all users"**

### 2.4 安装 Renode 仿真器

1. 下载地址：https://renode.io/download/
2. 选择 Windows 版本下载
3. 运行安装程序，默认安装到 `D:\Renode`（或其他路径）
4. **手动添加 Renode 到系统环境变量 PATH**：
   - 右键"此电脑" → "属性" → "高级系统设置" → "环境变量"
   - 在"系统变量"中找到 "Path"，点击"编辑"
   - 添加 `D:\Renode`（或你的安装路径）

### 2.5 安装 VSCode 扩展

启动 VSCode，打开扩展面板（Ctrl+Shift+X），安装以下扩展：

| 扩展名称 | 作者 | 用途 |
|----------|------|------|
| Cortex-Debug | Marus | ARM Cortex-M 调试支持 |
| C/C++ | Microsoft | C/C++ 语言支持 |
| CMake | Microsoft | CMake 支持 |
| CMake Tools | Microsoft | CMake 构建工具集成 |

---

## 3. 项目配置

### 3.1 克隆项目

将项目文件复制到本地，例如：
```
D:\Xxx\Progect\MyProgect\Stm32pro\St_F407
```

### 3.2 配置环境变量

确保以下工具已添加到系统 PATH：

| 工具 | 路径示例 |
|------|----------|
| arm-none-eabi-gcc | `C:\Program Files\Arm GNU Toolchain arm-12.3.rel1-mingw-w64-i686-arm-none-eabi\bin` |
| cmake | `C:\Program Files\CMake\bin` |
| renode | `D:\Renode` |

### 3.3 验证工具安装

打开命令提示符（CMD）或 PowerShell，执行以下命令验证安装：

```bash
# 验证 ARM GCC
arm-none-eabi-gcc --version
# 预期输出：arm-none-eabi-gcc (Arm GNU Toolchain 12.3.rel1) 12.3.1 20230705

# 验证 CMake
cmake --version
# 预期输出：cmake version 3.28.1

# 验证 Renode
renode --version
# 预期输出：Renode v1.14.0
```

---

## 4. 构建项目

1. 打开 VSCode，选择 "File" → "Open Folder"，打开项目根目录 `St_F407`
2. 等待 CMake Tools 自动配置项目
3. 如果 CMake 配置失败，手动执行：

```bash
# 创建 build 目录（如果不存在）
mkdir build
cd build

# 运行 CMake 配置
cmake .. -G "Ninja" -DCMAKE_BUILD_TYPE=Debug

# 构建项目
cmake --build .
```

构建成功后，会在 `build` 目录生成 `St_F407.elf` 文件。

---

## 5. 调试配置说明

项目已包含 `.vscode` 目录，包含以下配置文件：

### 5.1 launch.json 详解

```json
{
  "version": "0.2.0",           // VSCode 调试配置版本
  "configurations": [
    {
      "name": "Renode Debug (STM32F4)",  // 调试配置名称
      "type": "cortex-debug",    // 使用 Cortex-Debug 扩展
      "request": "launch",       // 启动新调试会话
      "cwd": "${workspaceFolder}",       // 工作目录
      "executable": "${workspaceFolder}/build/St_F407.elf",  // 目标文件
      "servertype": "external",  // 连接外部 GDB 服务器（Renode）
      "gdbTarget": "localhost:3333",     // Renode GDB 端口
      "gdbPath": "arm-none-eabi-gdb.exe", // GDB 路径
      "device": "STM32F407VGTx", // 目标芯片型号
      "preLaunchTask": "Start Renode",   // 调试前启动 Renode
      "postDebugTask": "Stop Renode",    // 调试后关闭 Renode
      "runToEntryPoint": "main", // 自动运行到 main 函数
      "showDevDebugOutput": "none"       // 关闭调试器内部输出
    }
  ]
}
```

### 5.2 tasks.json 详解

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Start Renode",   // 任务名称：启动 Renode
      "type": "shell",           // 执行命令行命令
      "command": "renode.exe",   // 命令
      "args": ["${workspaceFolder}/Renode/Renode_F4_VSC.resc"], // 参数
      "isBackground": true,      // 后台运行
      "problemMatcher": {...}    // 检测 Renode 启动完成
    },
    {
      "label": "Stop Renode",    // 任务名称：停止 Renode
      "command": "taskkill",     // Windows 进程终止命令
      "args": ["/F", "/IM", "renode.exe"]  // 强制终止
    },
    {
      "label": "Build",          // 任务名称：构建项目
      "command": "cmake",
      "args": ["--build", "${workspaceFolder}/build"]
    }
  ]
}
```

---

## 6. 启动调试

1. 确保项目已成功构建（`build/St_F407.elf` 存在）
2. 打开 VSCode 的调试面板（Ctrl+Shift+D）
3. 在调试配置下拉菜单中选择 `Renode Debug (STM32F4)`
4. 点击绿色的 "Start Debugging" 按钮（或按 F5）

**调试流程：**
1. VSCode 自动启动 Renode 仿真器
2. Renode 加载固件并启动 GDB 服务器
3. Cortex-Debug 连接到 Renode 的 GDB 端口（localhost:3333）
4. 程序自动暂停在 `main` 函数入口
5. 可以使用调试控制按钮进行调试：
   - F5：继续执行
   - F10：单步跳过（Step Over）
   - F11：单步进入（Step Into）
   - Shift+F11：单步跳出（Step Out）
   - Shift+F5：停止调试

---

## 7. 常见问题

### Q1: Renode 启动失败

**原因**：Renode 未添加到系统 PATH

**解决**：
1. 检查环境变量 PATH 是否包含 Renode 安装目录
2. 重启 VSCode 使环境变量生效

### Q2: GDB 连接失败

**原因**：Renode 启动较慢，GDB 连接超时

**解决**：
1. 手动先启动 Renode，再启动调试
2. 增加调试配置中的超时时间

### Q3: 断点无法命中

**原因**：调试信息不匹配或文件路径问题

**解决**：
1. 确保构建的是 Debug 版本
2. 检查 `launch.json` 中 `executable` 路径正确
3. 重新构建项目

### Q4: 编译错误 - 找不到头文件

**原因**：IntelliSense 配置问题

**解决**：
1. 检查 `.vscode/c_cpp_properties.json` 中的 `includePath`
2. 确保 CMake Tools 已正确配置

---

## 附录：文件结构

```
St_F407/
├── .vscode/
│   ├── launch.json      # 调试配置
│   ├── tasks.json       # 任务配置
│   └── c_cpp_properties.json  # IntelliSense 配置
├── Core/
│   ├── Inc/             # 头文件
│   └── Src/             # 源文件
├── Drivers/             # STM32 HAL 驱动
├── FreeRTOS/            # FreeRTOS 源码
├── Renode/              # Renode 配置文件
│   ├── Renode_F4_VSC.resc   # VSCode 专用配置
│   └── platforms/       # 平台描述文件
├── build/               # 构建输出目录
└── SETUP_GUIDE.md       # 本配置指南
```

---

## 联系信息

如有问题，请联系项目维护者。

---

*最后更新：2026年5月*