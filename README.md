# 주키퍼 3.7.2 자동 설치 및 설정 setup 앤서블

## 필수 준비

- **필수 셋팅**: `system_download.txt 파일 /data/work 하위에 위치 필수!!!!`

## 참조 파일

- **셋업 참조 파일**: `system_download.txt(/data/work 하위에 위치 필수!!!!)`
- **주키퍼 초기 설정 파일 샘플**: `zoo.cfg`
- **전체 파이프라인 플레이북**: `zookeeper_deploy.yml`

## 각 파일 설명

1. **`hosts.ini`** : 인벤토리(관리 대상 시스템 리스트)
2. **`main.yml`** : play_book 변수를 담은 파일
3. **`tar_scp.sh`** : 주키퍼 각 서버에 tar파일 생성
4. **`zoo.cfg`** : 주키퍼 초기 설정파일
5. **`entrypoint.sh`** : 주키퍼 초기 설정 파일 동적 setup 및 각 주키퍼 서버 배포하는 스크립트
6. **`zookeeper_deploy.yml`** : 앤서블 플레이북

## 실행 방법

1. `zookeeper_deploy.yml` 플레이북을 실행하여 전체 파이프라인을 시작합니다.
   ```sh
   ansible-playbook -i /data/zookeeper_3.7.2_ansible/hosts.ini /data/zookeeper_3.7.2_ansible/zookeeper_deploy.yml
   ```

## ansible 플레이북 구조

- `Create zookeeper_tar directory`: 각 주키퍼 서버에 기본 주키퍼 디렉토리, tar 저장할 디렉토리 생성
- `Copy zookeeper_tar to servers`: tar_scp.sh 스크립트를 실행하여 주키퍼 tar 파일 각 서버 tar 저장 디렉토리에 복사
- `Extract zookeeper_tar`: 각 서버 주키퍼 tar파일 압축 해제
- `entrypoint_sh start`: entrypoint.sh 스크립트를 실행하여 각 서버 주키퍼 설정 동적 setup 및 setup된 zoo.cfg 각 주키퍼 서버 배포
- `zookeeper run`: 주키퍼 클러스터 start

---

이 플레이북은 주키퍼 클러스터를 자동으로 설정하고 Start 하는 과정을 자동화 합니다.
