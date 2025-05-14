# Gaussian Blur, Grayscale, Rotate using CPU and OpenCL GPU

이 프로젝트는 BMP 이미지(`lena.bmp`)를 대상으로 **CPU**와 **OpenCL GPU**를 이용하여 다음과 같은 이미지 처리 기능을 수행합니다:

- Gaussian Blur
- Grayscale 변환
- 90도 시계방향 Rotate

---

## 구성 기능

| 기능 | 설명 | 구현 위치 |
|------|------|------------|
| **Gaussian Blur (CPU)** | BMP 이미지를 Gaussian Mask를 이용해 블러링 | `GaussianBlur.c` |
| **Gaussian Blur (GPU)** | OpenCL 커널로 병렬 Gaussian Blur 수행 | `GaussianBlurGPU.cpp`, `Blur.cl` |
| **Grayscale (GPU)** | RGB → Gray 변환을 OpenCL 커널에서 병렬 처리 | `Grayscale.cpp`, `Grayscale.cl` |
| **Rotate (GPU)** | 90도 시계 방향 회전 | `rotate.cpp`, `rotate.cl` |

---

## Sample Image

> lena.bmp (512x512)

---

## Gaussian Blur 란?

Gaussian Blur는 이미지의 디테일을 줄이고 부드럽게 만드는 효과입니다.  
중심 픽셀에 큰 가중치를 두고, 주변 픽셀은 적게 반영하는 **가우시안 필터 마스크**를 이용합니다.

---

## 환경 요구 사항

- Linux (Ubuntu)
- Cross Compiler (`arm-linux-androideabi-gcc` or `g++`)
- ADB (Android 디바이스 전송용)
- OpenCL 라이브러리 (`libOpenCL.so`, `libGLES_mali.so`)
- Android 디바이스 또는 개발 보드

---

## Build 및 실행 방법

### 호스트(PC) 측

```bash
make
adb shell
```

### 디바이스 측 (ADB 쉘 내부)

```bash
LD_LIBRARY_PATH=/vendor/lib/egl
cd /data/local/tmp
./GaussianBlur      # 또는 ./Grayscale, ./rotate
```

### 결과 Pull (호스트)
```bash
adb pull /data/local/tmp/blurred_lena.bmp ./
display blurred_lena.bmp
```

⸻

### Makefile 주요 설정 예시
```CMake
CC = arm-linux-androideabi-g++
ADB=adb

OPENCL_PATH = ./gpu
CFLAG = -I$(OPENCL_PATH)/include -g
LDFLAGS = -l$(OPENCL_PATH)/lib/libGLES_mali.so -lm

TARGET=GaussianBlurGPU
TARGET_SRC =$(TARGET).cpp bmp.c

all: $(TARGET)
	$(CC) -static $(TARGET_SRC) $(CFLAG) $(LDFLAGS) -fpermissive -o $(TARGET)
	$(ADB) push $(TARGET) /data/local/tmp
	$(ADB) push lena.bmp /data/local/tmp
	$(ADB) push Blur.cl /data/local/tmp
	$(ADB) shell chmod 755 /data/local/tmp/$(TARGET)

clean:
	rm -f *.o
	rm -f $(TARGET)
```

⸻

## 성능 비교

연산 종류	CPU 실행 시간(ms)	GPU 실행 시간(ms)	속도 개선
Gaussian Blur	4028	220	✅ 약 18배 빠름
Grayscale	-	140	✅ 실시간 가능
Rotate	-	714	✅ 병렬 수행 가능


⸻

## 파일 구조

project-root/ <br>
├── bmp.c <br>
├── ImageProcessing.h <br>
├── lena.bmp <br>
├── GaussianBlur.c <br>
├── GaussianBlurGPU.cpp <br>
├── Blur.cl <br>
├── Grayscale.cpp <br>
├── Grayscale.cl <br>
├── rotate.cpp <br>
├── rotate.cl <br>
└── Makefile <br>


⸻

#### 회고
	•	이미지 처리의 병렬성(특히 Gaussian Blur)은 OpenCL을 활용하면 극적인 속도 향상이 가능함을 확인하였습니다.
	•	EditText → 7Segment, GPIO 제어 등과 함께 실제 디바이스에 적용해볼 수 있는 기반이 되는 프로젝트입니다.

---
