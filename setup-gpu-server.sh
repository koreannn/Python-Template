#!/bin/bash
set -euo pipefail

##################### 설정 변수 #####################
GIT_NAME="your_name"
GIT_EMAIL="your_email@example.com"
PYTHON_VER="3.11"
CONDA_ENV_NAME="main"
REPO_URL=""           # 예: https://github.com/yourname/yourrepo.git
WORKDIR="$HOME/workspace"
USE_UV=true           # Python 패키지 관리에 uv 사용
USE_CONDA=false       # CUDA/cuDNN 시스템 라이브러리 관리에 conda 사용

##################### 로그 함수 #####################
log()  { echo -e "\n\033[1;32m[INFO]\033[0m $1"; }
warn() { echo -e "\n\033[1;33m[WARN]\033[0m $1"; }
die()  { echo -e "\n\033[1;31m[ERROR]\033[0m $1"; exit 1; }

##################### 시스템 패키지 #####################
log "시스템 패키지 설치 중..."
apt-get update -qq
apt-get install -y \
    sudo wget curl git vim \
    build-essential ca-certificates \
    tmux htop tree unzip

##################### uv 설치 #####################
if [ "$USE_UV" = true ]; then
    log "uv 설치 중..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

    log "Python $PYTHON_VER 설치 중..."
    uv python install "$PYTHON_VER"
fi

##################### conda 설치 #####################
if [ "$USE_CONDA" = true ]; then
    if ! command -v conda &>/dev/null; then
        log "Miniconda 설치 중..."
        wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
        bash /tmp/miniconda.sh -b -p /opt/conda
        rm /tmp/miniconda.sh
        export PATH="/opt/conda/bin:$PATH"
        echo 'export PATH="/opt/conda/bin:$PATH"' >> ~/.bashrc
    else
        log "conda 이미 설치되어 있습니다. 건너뜁니다."
        export PATH="/opt/conda/bin:$PATH"
    fi

    conda init bash
    conda config --set auto_activate_base false
    source ~/.bashrc

    log "conda 환경 '$CONDA_ENV_NAME' 생성 중..."
    conda create -n "$CONDA_ENV_NAME" python="$PYTHON_VER" -y

    echo "conda activate $CONDA_ENV_NAME" >> ~/.bashrc
fi

##################### 작업 디렉토리 #####################
log "작업 디렉토리 생성: $WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

##################### 레포지토리 clone #####################
if [ -n "$REPO_URL" ]; then
    log "레포지토리 clone 중: $REPO_URL"
    git clone "$REPO_URL" .

    # uv.lock이 존재하면 의존성 자동 설치
    if [ "$USE_UV" = true ] && [ -f "uv.lock" ]; then
        log "uv sync로 의존성 설치 중..."
        uv sync
    fi

    # requirements.txt만 있는 경우
    if [ "$USE_UV" = true ] && [ ! -f "uv.lock" ] && [ -f "requirements.txt" ]; then
        warn "uv.lock 없음. requirements.txt로 대체 설치합니다."
        uv add -r requirements.txt
    fi
else
    warn "REPO_URL이 설정되지 않았습니다. clone을 건너뜁니다."
fi

##################### git 설정 #####################
log "git 전역 설정 중..."
git config --global user.name  "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global core.editor vim
git config --global init.defaultBranch main
# 긴 세션에서 자격증명 캐시 유지 (6시간)
git config --global credential.helper "cache --timeout=21600"

##################### 환경 확인 #####################
log "환경 확인 중..."
echo "----------------------------------------"
echo "Python   : $(python3 --version 2>/dev/null || echo '未설치')"
echo "CUDA     : $(nvcc --version 2>/dev/null | grep release || echo 'nvcc 없음')"
echo "GPU      : $(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null || echo 'GPU 없음')"

if [ "$USE_UV" = true ]; then
    echo "uv       : $(uv --version)"
fi
if [ "$USE_CONDA" = true ]; then
    echo "conda    : $(conda --version)"
fi
echo "workdir  : $WORKDIR"
echo "----------------------------------------"

log "세팅 완료."