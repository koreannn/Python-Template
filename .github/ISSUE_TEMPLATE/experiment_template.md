## 1. 문제 정의 (Problem Definition)
해결하려는 문제의 본질, 성공 기준을 정의합니다.


## **해결하려는 페인 포인트 :**

## **기존 방식의 한계점 :**

**핵심 지표 (KPI / Metrics)**

- 예: F1-Score ≥ 0.8
- 예: Inference Latency < 2s
- 예: Hallucination Rate 20% 감소

---

## 2. 설계 및 환경 (Setup)
실험의 재현성을 위해 데이터와 모델의 초기 상태를 기록합니다.

**데이터셋 정보**

- 출처:
- 규모:
- 전처리 방식:
- Train/Validation/Test 분할 기준:
- 데이터 이슈:

**모델 선택 이유**

- 후보 모델:
- 최종 선택 모델:
- 선택 기준 (성능 / 비용 / 라이선스 / 크기 등):

**주요 파이프라인**

- Fine-tuning 방식 (예: LoRA / PEFT / Full FT):
- RAG 구조 여부:
- Embedding 모델:
- Vector DB:
- Chunk Size / Overlap:
- Agent 구조 (해당 시):
- 사용 Tool:

---

## 3. 실험 기록 (Experiment Tracking)

| ID | 실험 변수 (Variable) | 결과 (Metric) | 분석 및 시사점 (Insights) |
| --- | --- | --- | --- |
| #0 | Baseline 모델 | F1: 0.72 | 기본 모델은 도메인 용어 인식률 저조 |
| #1 | LoRA (Rank=8) 적용 | F1: 0.79 | 성능 향상, 특정 문체에서 오버피팅 발생 |
| #2 | RAG + Vector DB 연동 | F1: 0.84 | Hallucination 감소, Latency 증가 대응 필요 |

---

## 4. 실패 케이스 및 분석 (Failure Analysis)
무엇이 안 되었고, 왜 안 되었는지를 기록합니다.

**발생한 문제**
- 예: 특정 도메인 질문에서 엉뚱한 답변 반복

**원인 추론**
- 예: Retrieval 과정에서 Chunk size가 너무 작아 문맥 소실

**개선 시도**
- 예: Chunk size 512 → 1024 조정
- 예: Overlap 100 적용

## **개선 결과**

~~

---

## 5. 향후 계획 (Next Steps)
현재 한계를 돌파하기 위한 가설 기반 개선 계획
- [ ]  모델 경량화를 위한 Quantization 테스트
- [ ]  Synthetic Data 생성 후 재학습
- [ ]  Embedding 모델 교체 후 성능 비교
- [ ]  Latency 최적화 (Batching / 캐싱 적용)
