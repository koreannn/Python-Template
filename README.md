# Python-Template
나만의 파이썬 템플릿



### bash 스크립트 사용법
bash 스크립트는 RunPod, Vast.ai 등 GPU 클라우드 인스턴스(Ubuntu)환경 사용 시 환경 구축을 더 쉽게 하기 위해 만들었습니다.


```text
아래 항목들만 설정해서 사용하면 됩니다.
- GIT_NAME     : git commit에 표시될 이름
- GIT_EMAIL    : git commit에 표시될 이메일
- PYTHON_VER   : 사용할 Python 버전
- REPO_URL     : clone할 레포지토리 URL (없으면 빈 문자열)
- USE_UV       : uv 사용 여부 (true/false)
- USE_CONDA    : conda 사용 여부 (true/false)
```


##### 스크립트 실행 방법

1. 스크립트 실행
- `bash setup-gpu-server.sh`
- (로컬에 스크립트를 저장하지 않고, 원격에서 바로 실행할 경우): `bash <(curl -s https://raw.githubusercontent.com/<user>/<repo>/main/setup.sh)`

bash 스크립트를 모두 실행하면, 셸을 재시작해줍니다(`source ~/.bashrc`)

2. 파이썬 패키지 설치 시
본 스크립트는 uv를 통해 파이썬 패키지를 관리합니다.

- 단일 패키지 설치 시
e.g., `uv add torch` / `uv add torch==2.3.1` (특정 버전 지정 시)

- requirements.txt 사용 시
`uv add -r requirements.txt`
