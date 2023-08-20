<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="com.infra.util.StringUtil" %>
<%@ page import="com.infra.system.GlobalConst" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>확인절차안내|기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery, form" />
<ap:jsTag type="tech" items="cmn, mainn, subb, font, util, ic" />
<ap:globalConst />
<% 
	StringUtil stringUtil = new StringUtil();
	
	String issu_phone_num = GlobalConst.ISSU_PHONE_NUM;
	
	Map<String,String> num = stringUtil.telNumFormat(issu_phone_num);
	
	String ISSU_PHONE_NUM_FIRST = num.get("first");
	String ISSU_PHONE_NUM_MIDDLE = num.get("middle");
	String ISSU_PHONE_NUM_LAST = num.get("last");
	
%>
</head>
<body>
<form name="dataForm" id="dataForm" method="post">
    <ap:include page="param/defaultParam.jsp" />
    <ap:include page="param/dispParam.jsp" />
    <!--//content-->
    <div id="wrap">
        <div class="s_cont" id="s_cont">
		<div class="s_tit s_tit02">
			<h1>기업확인</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit2">기업확인</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}"  />
				</div>
						<div class="r_cont s_cont02_01">
							<div class="list_bl bg_gray">
								<div class="left">
									<h3>안내</h3>
								</div>
								<div class="right">
									<p>* 전년도 기업 확인서의 유효기간이 만료된 경우, 직전사업연도 결산 기준으로 제출서류를 준비하여 신청 바랍니다.(절차 동일)</p>
									<p>* 이미 유효기간이 만료된 기업 확인서의 발급신청 및 내용변경신청은 불가합니다.</p>
								</div>
							</div>
					<div class="list_bl m_b_0">
						<h4 class="fram_bl">확인절차 프로세스</h4>
					</div>
					
					<div>
						<div class="line01">
							<p>시스템 회원가입<span>(기업회원)</span></p>
							<p>로그인</p>
							<p>신청서작성<span>(서류제출)</span></p>
							<p>접수확인 및<br/>서수검토</p>
							<p>확인서 발급 또는 반려<span>(신청일로부터 20일이내)</span></p>
							<p>기업 확인<br/>및 관리</p>
						</div>
						<div class="line02">
							<p>보안접수</p>
						</div>
						<div class="line03">
							<p>내용 및 서류보안</p>
							<p>보안요청</p>
						</div>
						</div>
					</div>
			</div>
		</div>
	</div>
    </div>
    <!--content//-->
</form>
</body>
</html>