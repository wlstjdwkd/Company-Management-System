package com.infra.system;

import java.io.File;

import org.apache.commons.lang.StringUtils;


/**
 * 상수 클래스
 * @author sujong
 *
 */
public class GlobalConst {

	/** 세션 */
	// 세션에 저장한 메뉴정보 이름(메뉴출력용도)
	public static final String SESSION_MENUINFO_NAME = "MenuInfo";
	// 세션에 저장한 사용자정보 이름
	public static final String SESSION_USERINFO_NAME = "UserInfo";
	// 세션에 저장한 권한정보 이름(권한체크용도)
	public static final String SESSION_AUTHINFO_NAME = "AuthInfo";
	// 세션에 저장한 NICE인증요청정보 이름
	public static final String SESSION_NICE_ENC_NAME = "NiceEncInfo";
	// 세션에 저장한 NICE인증정보 이름
	public static final String SESSION_NICE_DEC_NAME = "NiceDecInfo";
	// 세션에 저장한 NICEIPIN인증요청정보 이름
	public static final String SESSION_NICE_IPIN_CPR_NAME = "NiceCPREQUEST";
	// 세션에 저장한 NICEIPIN인증요청정보 이름
	public static final String SESSION_NICE_IPIN_IP_NAME = "NiceUserIP";
	// 세션에 저장한 인증유형 이름
	public static final String SESSION_CERTIFY_TYPE_NAME = "CertifyType";
	// 세션에 저장한 기업사용자정보 이름
	public static final String SESSION_ENTUSERINFO_NAME = "EntUserInfo";
	// 세션에 저장한 재무정보HTML 이름
	public static final String SESSION_FNNRHTML_NAME = "FnnrHTML";

	/** 웹 구분 */
	// 사이트구분(웹)
	public static final String SITE_DIV_WEB = "WW";
	// 사이트구분(관리자)
	public static final String SITE_DIV_ADM = "AD";
	// 사이트구분(모바일웹)
	public static final String SITE_DIV_MOBILE = "MW";

	/** 권한 */
	// 권한그룹-운영자
	public static final String AUTH_DIV_ADM = "0001";
	// 권한그룹-인사담당자
	public static final String AUTH_DIV_PUB = "0002";
	// 권한그룹-이사진
	public static final String AUTH_DIV_BIZ = "0003";
	// 권한그룹-영업담당자
	public static final String AUTH_DIV_ENT = "0004";
	// 권한그룹-사원
	public static final String AUTH_DIV_EMP = "0005";

	/** 사용자유형 */
	// 사용자유형-일반
	public static final String EMPLYR_TY_GN = "GN";
	// 사용자유형-기업
	public static final String EMPLYR_TY_EP = "EP";
	// 사용자유형-업무
	public static final String EMPLYR_TY_JB = "JB";

	/** 사용자상태 */
	// 사용자상태-정상
	public static final String EMPLYR_STTUS_01 = "01";
	// 사용자상태-정지
	public static final String EMPLYR_STTUS_02 = "02";
	// 사용자상태-탈퇴
	public static final String EMPLYR_STTUS_03 = "03";

	/** 기업구분 */
	// 기업구분-신청기업
	public static final String ENTRPRS_SE_O = "O";
	// 기업구분-관계기업
	public static final String ENTRPRS_SE_R = "R";

	/** 법인등록구분 */
	// 법인등록구분-국내
	public static final String CPR_REGIST_SE_L = "L";
	// 법인등록구분-해외
	public static final String CPR_REGIST_SE_F = "F";


	/** 신청구분 */
	// 신청구분-임시저장
	public static final String REQST_SE_AK0 = "AK0";
	// 신청구분-발급신청
	public static final String REQST_SE_AK1 = "AK1";
	// 신청구분-재발급신청
	public static final String REQST_SE_AK2 = "AK2";
	// 신청구분-반납신청
	public static final String REQST_SE_AK3 = "AK3";

	/** 파일구분 */
	// 파일구분-월별원천징주이행상황신고서
	public static final String FILE_KND_RF0 = "RF0";
	// 파일구분-감사보고서
	public static final String FILE_KND_RF1 = "RF1";
	// 파일구분-주주명부
	public static final String FILE_KND_RF2 = "RF2";
	// 파일구분-법인등기부등본
	public static final String FILE_KND_RF3 = "RF3";
	// 파일구분-사업자등록증사본
	public static final String FILE_KND_RF4 = "RF4";
	// 파일구분-중소기업유예확인서
	public static final String FILE_KND_RF5 = "RF5";

	/** 사유구분 */
	// 사유구분-진행상태사유
	public static final String RESN_SE_S = "S";
	// 사유구분-진행결과사유
	public static final String RESN_SE_R = "R";

	/** 진행상태코드 */
	// 진행상태-접수
	public static final String RESN_SE_CODE_PS1 = "PS1";
	// 진행상태-검토중
	public static final String RESN_SE_CODE_PS2 = "PS2";
	// 진행상태-보완요청
	public static final String RESN_SE_CODE_PS3 = "PS3";
	// 진행상태-보완접수
	public static final String RESN_SE_CODE_PS4 = "PS4";
	// 진행상태-보완검토중
	public static final String RESN_SE_CODE_PS5 = "PS5";
	// 진행상태-완료
	public static final String RESN_SE_CODE_PS6 = "PS6";

	/** 진행결과코드 */
	// 진행결과코드-발급
	public static final String RESN_SE_CODE_RC1 = "RC1";
	// 진행결과코드-반려
	public static final String RESN_SE_CODE_RC2 = "RC2";
	// 진행결과코드-접수취소
	public static final String RESN_SE_CODE_RC3 = "RC3";
	// 진행결과코드-발급취소
	public static final String RESN_SE_CODE_RC4 = "RC4";

	/** 공통 URL */
	// 도메인
	public static final String BASE_URL = "http://www.mme.or.kr";
	// 서비스URL 설정이름
	public static final String SVC_URL_NAME = "SvcURL";
	// 사용자 메인
	public static final String PUB_INDEX_URL = "PGUM0001.do";
	// 관리자 메인
	public static final String ADM_INDEX_URL = "PGAM0001.do";
	// 모파일 메인
	public static final String MOB_INDEX_URL = "PGMV0001.do";
	// 우편번호검색
	public static final String SEARCH_ZIP_URL = "PGCM0004.do";
	// 로그인
	public static final String PUB_LOGIN_URL = "jsMoveMenu('24','25','PGCMLOGIO0010')";
	// 로그아웃
	public static final String PUB_LOGOUT_URL = "jsMoveMenu('24','25','PGCMLOGIO0010','processLogout')";
	// 아이디/비밀번호찾기
	public static final String PUB_FINDUSERINFO_URL = "jsMoveMenu('24', '85', 'PGCMLOGIO0020')";
	// 회원가입
	public static final String PUB_JOIN_URL = "jsMoveMenu('24','47','PGCMLOGIO0040')";
	// 마이페이지
	public static final String PUB_MYPAGE_URL = "jsMoveMenu('73','74','PGBS1005')";
	// 재무정보
	public static final String PUB_FNNRHTML_URL = "PGCM0002.do?df_method_nm=fnnrHTML";

	// 기업회원 마이페이지>확인서신청내역
	/*public static final String ENT_MYPAGE_REQST = "jsMoveMenu('73','120','PGMY0060')";*/

	// 확인서 신청내역이 마이페이지에서 기업 확인페이지로 변경되어 기존 루트를 사용하지 않고 변경됨
	public static final String ENT_MYPAGE_REQST = "jsMoveMenu('7','120','PGMY0060')";

	// 담당자정보변경신청
	public static final String PUB_CHANGE_MAN_URL = "jsMoveMenu('24', '144', 'PGCMLOGIO0050')";

	// 통계청 분류검색
	// public static final String KSSC_KOSTAT_URL = "http://kssc.kostat.go.kr/ksscNew_web/link.do?gubun=001";
	public static final String KSSC_KOSTAT_URL = "https://kssc.kostat.go.kr:8443/ksscNew_web/link.do?gubun=001";

	// 배치서버
	public static final String MANUAL_BATCH_URL = "http://www.mme.or.kr/PGMS0060.do";

	/** 페이징 */
	// 출력할 페이지 수
	public static final int DEFAULT_PAGE_SIZE = 10;
	// 출력할 게시 글 수
	public static final int DEFAULT_ROW_SIZE = 10;
	// 출력할 게시 글 수 (옵션 태그)
	public static final int[] DEFAULT_ROW_OPTION = { 5, 10, 15, 30, 50, 100, 200, 300 };

	/** 태그 라이브러리 */
	// Taglib에서 Include할 JSP 파일 경로
	public static final String INCLUDE_TAGLIB_BASE = "/WEB-INF/views/taglib/";
	// 미지정 시 기본 PAGER JSP 템플릿
	public static final String DEFAULT_PAGER_JSP = "pager/defaultPager.jsp";
	// 미지정 시 기본 페이징 스크립트 명
	public static final String DEFAULT_MOVE_PAGE_JS = "jsMovePage";
	// 호출할 script, css를 명시한 xml 파일
	public static final String INCLUDE_SCRIPT_FILES = "env/script/config.xml";
	// HTML 셀렉트 박스 기본 텍스트
	public static final String SELECT_TEXT = "-- 선택 --";
	// 미지정 시 기본 PAGER_PARAM JSP 템플릿
	public static final String DEFAULT_PAGER_PARAM_JSP = "pager/defaultPagerParam.jsp";
	// 미지정 시 기본 페이징 스크립트 명
	public static final String DEFAULT_SET_ROW_JS = "jsSetRowPerPage";

	/** 파일 경로 관련 상수*/
	// 파일 경로 구분자
    public static final String FILE_SEPARATOR = File.separator;
    // 파일경로 구분자(윈도우 <-> UNIX 계열 반대되는 구분자 replace 등에 사용)
    public static final String REPLACE_FILE_SEPARATOR;
    static {
        String separator = File.separator;
        if(separator.equals("/")) {
            REPLACE_FILE_SEPARATOR = "\\";
        } else {
            REPLACE_FILE_SEPARATOR = "/";
        }
    }


    /** 인코딩 케릭터 셋 */
    public static final String ENCODING = "utf-8";

    /** 암호화 방식 */
    public static final String DEFAULT_CRYPTO = "SHA256";

    /** View Name */
    public static final String JSON_VIEW_NAME = "jsonView";
    public static final String TEXT_VIEW_NAME = "textView";
    public static final String HTML_VIEW_NAME = "htmlView";
    public static final String DOWNLOAD_VIEW_NAME = "downloadView";
    public static final String RSS_VIEW_NAME = "rssView";
    public static final String ATOM_VIEW_NAME = "atomView";
    public static final String EXCEL_VIEW_NAME = "excelView";
    public static final String PDF_VIEW_NAME = "pdfView";

    /** JSP Name */
    /*
    public static final String ALERT_AND_BACK = Config.getString("jspView.alertAndBack");
    public static final String ALERT_AND_CLOSE = Config.getString("jspView.alertAndClose");
    public static final String ALERT_AND_REDIRECT = Config.getString("jspView.alertAndRedirect");
    public static final String CONFIRM_AND_REDIRECT = Config.getString("jspView.confirmAndRedirect");
    public static final String SEND_SCRIPT = Config.getString("jspView.sendScript");
    */

    /** Data Key */
    public static final String TEXT_DATA_KEY = "__tdk";
    public static final String HTML_DATA_KEY = "__hdk";
    public static final String JSON_DATA_KEY = "__jdk";
    public static final String OBJ_DATA_KEY = "__odk";
    public static final String FILE_DATA_KEY = "__fdk";
    public static final String FILE_LIST_KEY = "__flk";

    /** 본인인증유형 */
    public static final String CERTIFY_TYPE_MOBILE = "mobile";
    public static final String CERTIFY_TYPE_IPIN = "ipin";

    // NICE로부터 부여받은 사이트 코드
    public static final String NICE_IPIN_SITE_CODE = "EI83";
    // NICE로부터 부여받은 사이트 패스워드
    public static final String NICE_IPIN_SITE_PASS = "komia!132*-+";

    /** NICE 인증 서비스 */
    // NICE로부터 부여받은 사이트 코드
    public static final String NICE_SITE_CODE = "G8210";
    // NICE로부터 부여받은 사이트 패스워드
    public static final String NICE_SITE_PASS = "NFTMGPXLKC2L";
    // 없으면 기본 선택화면, M: 핸드폰, C: 신용카드, X: 공인인증서
    public static final String NICE_AUTH_TYPE = "M";
    // Y : 취소버튼 있음 / N : 취소버튼 없음
    public static final String NICE_POP_GUBUN = "N";
    // 없으면 기본 웹페이지 / Mobile : 모바일페이지
    public static final String NICE_CUSTOMIZE = "";
    // 성공시 이동될 URL
    // Local
    public static final String NICE_RETURN_URL = "http://www.mme.or.kr:8080/PGCMLOGIO0040.do?df_method_nm=certifyResultMobile";
    // public static final String NICE_RETURN_URL = "http://www.mme.or.kr/PGCMLOGIO0040.do?df_method_nm=certifyResultMobile";
    
    // 성공시 이동될 URL
    // Local
    public static final String NICE_RETURN_URL_S = "https://www.mme.or.kr:8080/PGCMLOGIO0040.do?df_method_nm=certifyResultMobile";
    //public static final String NICE_RETURN_URL_S = "https://www.mme.or.kr/PGCMLOGIO0040.do?df_method_nm=certifyResultMobile";
    
    // 실패시 이동될 URL
    public static final String NICE_ERROR_URL = NICE_RETURN_URL;    

    // 성공시 이동될 URL
    // Local
    public static final String NICE_IPIN_RETURN_URL = "http://www.mme.or.kr:8080/PGCMLOGIO0040.do?df_method_nm=certifyResultNiceIpin";
    // public static final String NICE_IPIN_RETURN_URL = "http://www.mme.or.kr/PGCMLOGIO0040.do?df_method_nm=certifyResultNiceIpin";

    // 성공시 이동될 URL
    // Local
    public static final String NICE_IPIN_RETURN_URL_S = "https://www.mme.or.kr:8080/PGCMLOGIO0040.do?df_method_nm=certifyResultNiceIpin";
    // public static final String NICE_IPIN_RETURN_URL_S = "https://www.mme.or.kr/PGCMLOGIO0040.do?df_method_nm=certifyResultNiceIpin";
    
    /** 우편번호검색 */
    // 도로명주소안내시스템 URL
    public static final String JUSO_URL = "http://www.juso.go.kr/addrlink/addrLinkUrl.do";
    // 주소검색 승인키
    public static final String JUSO_CONF_KEY = "U01TX0FVVEgyMDE1MDMxNjA5MTQwNg==";

    /** 파일 업로드 */
    // rqstMap의 MultiPartRequest Key
    public static final String RQST_MULTIPART = "RQST_MULTIPART";

    /** DART ONPEN API */
    // API KEY
    public static final String DATR_OPENAPI_KEY = "f7427644f7fd7e5b24eef7273035c63ba7e89572";
    // 기업개황API URL
//    public static final String DATR_ENTINFO_URL = "http://dart.fss.or.kr/api/company.json";
    public static final String DATR_ENTINFO_URL = "https://opendart.fss.or.kr/api/company.json";
    // 기업목록조회 URL
    public static final String DATR_ENTLIST_URL = "http://dart.fss.or.kr/corp/searchCorpL.ax";
    // 기업상세검색API
//    public static final String DATR_ENTDETAIL_URL = "http://dart.fss.or.kr/api/search.json";
    public static final String DATR_ENTDETAIL_URL = "https://opendart.fss.or.kr/api/list.json";
    // 공시뷰어메인 URL
    public static final String DATR_VIEWER_MAIN_URL = "http://dart.fss.or.kr/dsaf001/main.do";
    // 공시뷰어상세 URL
    public static final String DATR_VIEWER_DETAIL_URL = "http://dart.fss.or.kr/report/viewer.do";

    /** 법령 API */
    // API KEY
    public static final String LAW_INFOLIST_URL = "http://www.law.go.kr/lsScListR.do";

    /** 법령 API */
    // API KEY
    public static final String STOCK_BATCH_JOB_NAME = "STOCK_REFESH_JOB";
    public static final String FXER_BATCH_JOB_NAME = "FXER_REFESH_JOB";



    /** 전화번호 */
    // 지역번호
 	public static final String[] PHONE_NUM_FIRST = { "02","031","032","033","041","042","043","044","049","051","052","053","054","055","061","062","063","064","070" };
 	public static final String PHONE_NUM_FIRST_TOKEN = StringUtils.join(PHONE_NUM_FIRST, ",");

 	// 휴대폰 앞자리
  	public static final String[] MOBILE_NUM_FIRST = { "010","011","012","015","016","017","018","019" };
  	public static final String MOBILE_NUM_FIRST_TOKEN = StringUtils.join(MOBILE_NUM_FIRST, ",");

  	// 1~12월
  	public static final String[] MONTHS = { "01","02","03","04","05","06","07","08","09","10","11","12" };
  	public static final String MONTHS_TOKEN = StringUtils.join(MONTHS, ",");


  	/** 업무별 이메일 주소 */
  	// 메일링 발신 전용
   	public static final String MASTER_EMAIL_ADDR = "mme@fomek.or.kr";

  	// 대표
  	public static final String REPRSNT_EMAIL_ADDR = "mme@fomek.or.kr";

  	// 고객센터
   	public static final String CSTMR_EMAIL_ADDR = "mme@fomek.or.kr";

   	// 확인서발급관리
   	public static final String ISSU_EMAIL_ADDR = "mme@fomek.or.kr";

   	// 설문
   	public static final String QUSTNR_EMAIL_ADDR = "mme@fomek.or.kr";



  	/** 업무별 대표전화 */
  	// 대표
  	public static final String REPRSNT_PHONE_NUM = "0232752985";

  	// 고객센터
  	public static final String CSTMR_PHONE_NUM = "0232752985";

  	// 확인서발급관리
  	/*
  	 * 2015-11-19 주석내용 추가
  	 * 2015-10-16 이후로 문자발송 시 발송번호 사전등록이 필요함
  	 * 그에따라 인포뱅크 사이트에서 등록절차를 거친 번호만 발송이 됨 (예 : 0232752985)
  	 * 2015-11-20 인포뱅크에 번호 등록
  	 */
  	public static final String ISSU_PHONE_NUM = "0232752986";

  	// 설문
   	public static final String QUSTNR_PHONE_NUM = "0232752985";

  	// 확인서발급관리 담당자 연락처
   	/*
  	 * 2015-11-19 주석내용 추가
  	 * 2015-11-20 인포뱅크에 번호 등록
  	 */
  	public static final String ISSU_MBTL_NUM = "0232752986";

  	// 대표 팩스번호
  	public static final String REPRSNT_FAX_NUM = "0232752989";

  	//환급급액 계산식 - 물량
  	public static final String XA = "TRADE_QTY";
  	//환급금액 계산식 - 환급률
  	public static final String XB = "RFD_RATE";
  	//환급금액 계산식 - 소요량
  	public static final String XC = "USE_QTY";
  	//환급금액 계산식 - 단가
  	public static final String XE = "APP_UNIT_AMT";
}
