<div align="center"> <h1>ERP: 기업 자원 통합 관리 ERP 시스템</h1> <p><strong>"전사 자원의 통합 관리, 업무 효율화와 데이터 표준화를 한 번에."</strong></p> </div> <br>

개발자: 양진호

직무: Fullstack Developer

역할: 시스템 설계, 프론트/백엔드 전체 개발, 문서화, 테스트


📝 프로젝트 개요
ERPpopol은 기업의 다양한 자원을 효율적으로 관리할 수 있는 ERP(Enterprise Resource Planning) 시스템입니다.
업무 영역, 원가 센터, 자재 코드, 창고, 직원 등 주요 마스터 데이터를 통합 관리하여
업무 표준화 및 실시간 정보 관리를 목표로 설계되었습니다.

핵심 가치(Core Value)
데이터 일원화: 기업 내 마스터 정보를 하나의 시스템에서 관리

효율성: 관리자/담당자가 쉽게 데이터 입력·검색·수정·저장 가능

직관적 UI: 계층적 마스터 등록, 실시간 창고 및 자재 관리 지원

🛠️ 기술 스택 (Tech Stack)
### Backend
![Java](https://img.shields.io/badge/Java-007396?style=flat&logo=java&logoColor=white)
![Tomcat](https://img.shields.io/badge/Tomcat-F8DC75?style=flat&logo=apache-tomcat&logoColor=black)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)

### Frontend
![JSP](https://img.shields.io/badge/JSP-217346?style=flat)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black)
![jQuery](https://img.shields.io/badge/jQuery-0769AD?style=flat&logo=jquery&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=flat&logo=css3&logoColor=white)

### IDE & Tools
![Eclipse](https://img.shields.io/badge/Eclipse-2C2255?style=flat&logo=eclipseide&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=flat&logo=git&logoColor=white)

<details> <summary><strong>📖 프로젝트 상세 설명</strong></summary> <br>
🔹ERP시스템는(은) 기업 내 다양한 자원을 통합 관리함으로써, 매월 반복되는 업무와 정보 관리 절차를 획기적으로 개선합니다.
자재 코드/창고/직원/거래처 등 핵심 마스터 데이터에 대해 직관적인 UI와 계층적 구조 관리가 가능합니다.
모든 데이터는 MySQL 기반으로 표준화되어, 정보 검색과 보고 업무가 간편합니다.

주요 관리 데이터
업무 영역, 원가 센터, 세금 구역, 사업장: 레벨별 구조화로 조직 단위 관리

자재 코드/자재 정보: 유형, 그룹, 생성·수정·검색 기능

창고/저장 위치: Plant, Storage Location 별 상세 정보 관리

직원, 거래처: 기본 정보/세부 필드 입력 및 목록 관리

재고, 입출고 내역: 실시간 업데이트, 작업 이력 확인 가능

</details> <details> <summary><strong>🎯 개발 목표 및 성과 지표</strong></summary> <br>
비즈니스 목표
반복적인 마스터 정보 관리 업무 자동화 및 단일화

자원 정보의 실시간 조회·수정으로 업무 효율 50% 이상 개선

관리자 및 담당자가 쉽게 사용할 수 있는 UI/UX 제공

기술적 목표
모든 등록/검색/수정 업무 5초 내 처리 구현

PC/웹 환경 전역에서 데이터 일관성 유지

데이터 구조가 확장 가능한 설계 적용

</details>

<details>
<summary><strong>🏗️ 아키텍처 및 DB 모델</strong></summary>
<br>

- **기반 아키텍처:** JSP/Servlet 기반 MVC (Model 2 구조)  
- **서버:** Apache Tomcat  
- **DBMS:** MySQL (업무 영역, 자재, 창고 등)  
- **프론트엔드:** JSP, jQuery, HTML5, CSS3, JavaScript  
- **개발 도구:** Eclipse, Git  

**주요 테이블 구조 예시**  
- `business_area_group`: 업무 그룹 계층 관리  
- `material_code`: 자재 코드 정보 및 상세 내역 관리  
- `plant_storage`: 창고/저장 위치 데이터 관리  

</details>


</details> <details> <summary><strong>✅ 기능 및 요구사항 전체 보기</strong></summary> <br>
기능 요구사항
등록/검색/수정/저장 기능 (모든 마스터별)

계층형 데이터 관리 (업무 영역 및 원가 센터 그룹화)

동적 필드 입력 (자재/직원/거래처 유형별)

실시간 작업 이력 및 데이터 업데이트

직관적인 UI와 표준화된 입력 폼

비기능 요구사항
보안성 강화: SQL Injection 등 기본 보안 로직 적용

사용성 강화: 관리자용 직관적 화면, 동적 검색 지원

성능 목표: 평균 페이지/리스트 로딩 3초 이하

</details>
