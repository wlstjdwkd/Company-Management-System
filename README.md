# 중소기업형 인사급여휴가관리시스템

> 개발 기간 : 2022.08.09 ~ 2022.12.12</br>
> 개발 인원 : 5명

## 📑 목차

1.  [프로젝트 기획 배경](#프로젝트-기획-배경)
2.  [주요 기능 설명](#주요-기능-설명)
3. [기술 스택](#기술-스택)
4. [아키텍처](#아키텍처)
5. [ERD](#erd)
6. [인터페이스](#인터페이스)
7. [팀원 소개 및 역할](#팀원-소개-및-역할)

## 📌프로젝트 기획 배경
- 기업에서 사용하는 인사, 급여, 휴가 관리 시스템을 구축하는 업무로서, 직원 등록, 급여 항목 관리, 급여 내역 생성, 급여 변경 내역 관리 등의 업무를 
테크블루제닉이 보유한 전자정부 프레임워크 플랫폼을 사용하여 구축하는 작업

## 🔎주요 기능 설명

- 직원 등록/조회
  - 인사 데이터 처리의 기본이 되는 직원 기본 정보를 등록하고 수정하는 기능 (입사 -> 퇴사)
  - 입력된 직원 정보를 부서별, 개인별로 조회
  - 인사 데이터 변동 내역 조회

- 급여 항목 등록/조회
  - 회사별 다른 급여 항목을 등록하는 기능
  - 지급 항목과 공제 항목을 기준으로 트리뷰로 화면 제작
  - 급여 항목별로 금액을 변경 조정하는 기능
- 월별 급여 내역 생성/조회
  - 직원 별로 급여 내역 생성하는 기능 (본봉 변경 내역 관리 기능 포함)
  - 직원 별로 생성된 급여 내역을 변경하는 기능 (생성 후 변경과 사후 변경 기능 포함)
  - 직원별/부서별로 생성된 급여 내역을 조회하는 기능 (월별 조회)
- 월별 급여 내역 출력
  - 월별/부서별 직원 급여 일괄 조회
  - 개인별 급여 일괄 조회
- 급여 내역 메일 발송
  - 직원의 이메일로 급여 내역을 일괄 발송 기능
  - 발송된 메일 리스트 확인 기능
- 연차 생성/삭제
- 휴가 내역 조회
- 휴가 신청/저장/취소

## 🛠기술 스택

<table>
<tr>
 <td align="center">언어</td>
 <td>
  <img src="https://img.shields.io/badge/Java-orange?style=for-the-badge&logo=Java&logoColor=white"/>
  <img src="https://img.shields.io/badge/Jsp-orange?style=for-the-badge&logo=Jsp&logoColor=white"/>

 </td>
</tr>
<tr>
 <td align="center">프레임워크</td>
 <td>
  <img src="https://img.shields.io/badge/Spring-6DB33F?style=for-the-badge&logo=Spring&logoColor=ffffff"/>
      <img src="https://img.shields.io/badge/Egovframe-6DB33F?style=for-the-badge&logo=Egovframe&logoColor=ffffff"/>

</tr>
<tr>
 <td align="center">라이브러리</td>
 <td>
<img src="https://img.shields.io/badge/qartz-6DB33F?style=for-the-badge&logo=qartz&logoColor=ffffff"/>
<img src="https://img.shields.io/badge/jwt-6DB33F?style=for-the-badge&logo=jwt&logoColor=ffffff"/>
</tr>
<tr>
 <td align="center">패키지 매니저</td>
 <td>
    <img src="https://img.shields.io/badge/maven-02303A?style=for-the-badge&logo=maven&logoColor=white">

  </td>
</tr>
<tr>
 <td align="center">인프라</td>
 <td>
  <img src="https://img.shields.io/badge/MYSQL-4479A1?style=for-the-badge&logo=MYSQL&logoColor=ffffff"/>
  <img src="https://img.shields.io/badge/amazonaws-232F3E?style=for-the-badge&logo=amazonaws&logoColor=ffffff"/>
  <img src="https://img.shields.io/badge/amazons3-569A31?style=for-the-badge&logo=amazons3&logoColor=ffffff"/>
  <img src="https://img.shields.io/badge/amazonec2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=ffffff"/>
  <img src="https://img.shields.io/badge/docker-2496ED?style=for-the-badge&logo=docker&logoColor=ffffff"/>
  <img src="https://img.shields.io/badge/jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=ffffff"/>

</tr>

<tr>
 <td align="center">협업툴</td>
 <td>
    <img src="https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=Git&logoColor=white"/>
    <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=GitHub&logoColor=white"/> 
    <img src="https://img.shields.io/badge/Discord-0058CC?style=for-the-badge&logo=Discord&logoColor=white"/> 
 </td>
</tr>
<tr>
 <td align="center">기타</td>
 <td>
    <img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=Figma&logoColor=white"/>
    <img src="https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=Notion&logoColor=white"/> 
    <img src="https://img.shields.io/badge/swagger-85EA2D?style=for-the-badge&logo=swagger&logoColor=white"/>
    <img src="https://img.shields.io/badge/xml-85EA2D?style=for-the-badge&logo=xml&logoColor=white"/>
 
</td>
</tr>
</table>


## 🧱아키텍처

## ERD
- 직원 관리
![erd.png](images/erd.png)

- 휴가 관리
![img.png](images/img.png)

## 인터페이스
### 휴가 관리
- 직원 등록 조회
  ![직원등록조회.png](images/직원등록조회.png)
- 급여 항목 관리
  ![급여항목관리.png](images/급여항목관리.png)
- 개인별월급여항목
  ![개인별월급여항목](images/개인별월급여항목.png)
- 급여 계산
  ![급여계산](images/급여계산.png)
- 월별 급여 조회
  ![월별급여조회](images/월별급여조회.png)
- 세율 관리
  ![세율관리](images/세율관리.png)
- 메일 전송
  ![메일전송](images/메일전송.png)

- 연차 생성/삭제
  ![img_1.png](images/img_1.png)

- 휴가 신청/저장/삭제
  ![img.png](images/img2.png)

## 팀 소개

