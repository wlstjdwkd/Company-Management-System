/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package egovframework.board.config;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class BoardConfConstant {

    private BoardConfConstant() {
    }

    /*
     * -----------------------------------------------------------
     * 게시판 설정 데이터 구분 코드
     */
    public static final String KEY_DATA_VO = "dataVo";
    public static final String KEY_DATA_LIST = "dataList";
    public static final String KEY_PAGER_VO = "pagerVo";
    public static final String KEY_CONF_VO = "boardConfVo";
    public static final String KEY_LOGIN_VO = "boardLoginVo";
    public static final String KEY_AUTH_VO = "boardAuthVo";

    /*
     * -----------------------------------------------------------
     * 로그인 등급
     */
    public static final int LOGIN_NOMEMBER = 0;
    public static final int LOGIN_USER = 1;
    public static final int LOGIN_MANAGER = 2;
    public static final int LOGIN_REALNAME = 3;
    public static final int LOGIN_DEPT_SUPER = 8;
    public static final int LOGIN_SUPER = 9;

    /*
     * -----------------------------------------------------------
     * 게시판 설정 구분 코드
     */
    public static final int GUBUN_CD_GLOBAL = 10;
    public static final int GUBUN_CD_LIST = 20;
    public static final int GUBUN_CD_VIEW = 30;
    public static final int GUBUN_CD_FORM = 40;
    public static final int GUBUN_CD_AUTH = 50;
    public static final int GUBUN_CD_EXTENSION = 60;

    /*
     * -----------------------------------------------------------
     * 게시판 표시항목 구분 코드
     */
    public static final String GUBUN_DISPLAY_COLUMN_LIST = "list";
    public static final String GUBUN_DISPLAY_COLUMN_VIEW = "view";

    /*
     * -----------------------------------------------------------
     * 게시판 권한 구분 코드
     */
    public static final int GUBUN_AUTH_EVERY = 1001;
    public static final int GUBUN_AUTH_MEMBER = 1002;
    public static final int GUBUN_AUTH_MANAGER = 1003;

    /*
     * -----------------------------------------------------------
     * 게시판 작성자 표시 코드
     */
    public static final int GUBUN_SHOW_NM = 1001;
    // public static final int GUBUN_SHOW_ALIAS = 1002;
    public static final int GUBUN_SHOW_ID = 1003;
    public static final int GUBUN_SHOW_DEPT_NM = 1004;

    /*
     * -----------------------------------------------------------
     * 게시판 업로드폼 구분 코드
     */
    public static final int GUBUN_UPLOADER_FORM = 1000;
    public static final int GUBUN_UPLOADER_FLASH = 1001;

    /*
     * -----------------------------------------------------------
     * 게시판 종류 구분 코드
     */
    public static final int GUBUN_BOARD_BASIC = 1001;
    public static final int GUBUN_BOARD_PETITION = 1002;
    public static final int GUBUN_BOARD_REPLY = 1003;
    public static final int GUBUN_BOARD_GALLERY = 1004;
    public static final int GUBUN_BOARD_EBOOK = 1005;
    public static final int GUBUN_BOARD_FAQ = 1006;

    /*
     * -----------------------------------------------------------
     * 게시판 이전/다음글 보기 구분 코드
     */
    public static final int GUBUN_LISTVIEW_NONE = 1001;
    public static final int GUBUN_LISTVIEW_PREVNEXT = 1002;
    public static final int GUBUN_LISTVIEW_LIST = 1003;

    /*
     * -----------------------------------------------------------
     * 게시판 설정 맵 (for select tag support)
     */
    public static Map<Integer, String> MAP_KIND_CD;
    public static Map<Integer, String> MAP_REGISTER_VIEW_CD;
    public static Map<Integer, String> MAP_LIST_VIEW_CD;
    public static Map<Integer, String> MAP_AUTH_CD;
    public static List<Map<String, String>> SEARCH_TYPE_LIST = new ArrayList<Map<String, String>>();

    /*
     * -----------------------------------------------------------
     * 게시판 검색 유형 코드
     */
    public static final String SEARCH_TYPE_EQUAL = "1001";
    public static final String SEARCH_TYPE_LIKE = "1002";
    public static final String SEARCH_TYPE_LE = "1003";
    public static final String SEARCH_TYPE_GE = "1004";

    /*
     * -----------------------------------------------------------
     * 게시판 목록 배치/상세 배치 기본 목록
     */
    public static String[][] LIST_ARRANGE_LIST = {
        { "TITLE", "제목" },
        { "REG_NM", "등록자명" },
        { "REG_DT", "등록일시" },
        { "READ_CNT", "조회수" }
    };
    public static String[][] VIEW_ARRANGE_LIST = {
        { "TITLE", "제목" },
        { "CONTENTS", "내용" },
        { "REG_NM", "등록자명" },
        { "REG_DT", "등록일시" }
    };

    static {
        MAP_KIND_CD = new HashMap<Integer, String>();
        MAP_KIND_CD.put(GUBUN_BOARD_BASIC, "기본형");
        MAP_KIND_CD.put(GUBUN_BOARD_PETITION, "민원형");
        MAP_KIND_CD.put(GUBUN_BOARD_REPLY, "답글형");
        MAP_KIND_CD.put(GUBUN_BOARD_GALLERY, "갤러리형");
        MAP_KIND_CD.put(GUBUN_BOARD_EBOOK, "E-Book형");
        MAP_KIND_CD.put(GUBUN_BOARD_FAQ, "FAQ형");

        MAP_REGISTER_VIEW_CD = new HashMap<Integer, String>();
        // MAP_REGISTER_VIEW_CD.put(GUBUN_SHOW_ALIAS, "닉네임 표시");
        MAP_REGISTER_VIEW_CD.put(GUBUN_SHOW_NM, "이름 표시");
        MAP_REGISTER_VIEW_CD.put(GUBUN_SHOW_ID, "아이디 표시");
        MAP_REGISTER_VIEW_CD.put(GUBUN_SHOW_DEPT_NM, "부서명 표시");

        MAP_LIST_VIEW_CD = new HashMap<Integer, String>();
        MAP_LIST_VIEW_CD.put(GUBUN_LISTVIEW_NONE, "표시안함");
        MAP_LIST_VIEW_CD.put(GUBUN_LISTVIEW_PREVNEXT, "이전/다음글 표시");
        MAP_LIST_VIEW_CD.put(GUBUN_LISTVIEW_LIST, "페이지목록 표시");

        MAP_AUTH_CD = new HashMap<Integer, String>();
        MAP_AUTH_CD.put(GUBUN_AUTH_EVERY, "모든 사용자");
        MAP_AUTH_CD.put(GUBUN_AUTH_MEMBER, "회원");
        MAP_AUTH_CD.put(GUBUN_AUTH_MANAGER, "기관 담당자");

        Map<String, String> SEARCH_TYPE = new HashMap<String, String>();
        SEARCH_TYPE.put("code", SEARCH_TYPE_EQUAL);
        SEARCH_TYPE.put("codeNm", "일치");
        SEARCH_TYPE_LIST.add(SEARCH_TYPE);

        SEARCH_TYPE = new HashMap<String, String>();
        SEARCH_TYPE.put("code", SEARCH_TYPE_LIKE);
        SEARCH_TYPE.put("codeNm", "부분일치");
        SEARCH_TYPE_LIST.add(SEARCH_TYPE);

        SEARCH_TYPE = new HashMap<String, String>();
        SEARCH_TYPE.put("code", SEARCH_TYPE_LE);
        SEARCH_TYPE.put("codeNm", "작거나같음");
        SEARCH_TYPE_LIST.add(SEARCH_TYPE);

        SEARCH_TYPE = new HashMap<String, String>();
        SEARCH_TYPE.put("code", SEARCH_TYPE_GE);
        SEARCH_TYPE.put("codeNm", "크거나같음");
        SEARCH_TYPE_LIST.add(SEARCH_TYPE);
    }

    public static String getKindNm(int kindCd) {
        return MAP_KIND_CD.get(kindCd);
    }
}
