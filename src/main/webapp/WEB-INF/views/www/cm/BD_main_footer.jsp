<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.infra.util.StringUtil" %>
<%@ page import="com.infra.system.GlobalConst" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>기업 종합정보시스템</title>
</head>

<body>
<% 
	StringUtil stringUtil = new StringUtil();
	
	// String reprsnt_phone_num = GlobalConst.REPRSNT_PHONE_NUM;
	String reprsnt_phone_num = GlobalConst.ISSU_PHONE_NUM;
	String reprsnt_fax_num = GlobalConst.REPRSNT_FAX_NUM;
	
	Map<String,String> num = stringUtil.telNumFormat(reprsnt_phone_num);
	
	String REPRSNT_PHONE_NUM_FIRST = num.get("first");
	String REPRSNT_PHONE_NUM_MIDDLE = num.get("middle");
	String REPRSNT_PHONE_NUM_LAST = num.get("last");
	
	num = stringUtil.telNumFormat(reprsnt_fax_num);
	
	String REPRSNT_FAX_NUM_FIRST = num.get("first");
	String REPRSNT_FAX_NUM_MIDDLE = num.get("middle");
	String REPRSNT_FAX_NUM_LAST = num.get("last");
	
%>
<ap:globalConst />
<div id="footer">
	<div class="f_top">
		<div class="f_wrap">
			<p>
				<a href="#none" onclick="jsMoveMenu('127', '128', 'PGCL0010');" >이용약관</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="#none" onclick="jsMoveMenu('127', '130', 'PGCL0011');" >개인정보처리방침</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="#none" onclick="jsMoveMenu('127', '129', 'PGCL0012');" >이메일자동수집거부</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="#none" onclick="jsMoveMenu('127', '131', 'PGCL0013');" >저작권정책</a>
			</p>
			<div class="family">
				<button class="f_btn" type="button"><span>유관기관</span></button>
				<div class="family_on">
					<ul>
						<li><a href="http://www.kiat.or.kr/site/main/main.jsp" target="_blank">한국산업기술진흥원</a></li>
						<li><a href="https://www.koita.or.kr/main/intro.aspx" target="_blank">한국산업기술진흥협회</a></li>
						<li><a href="https://www.mss.go.kr/site/smba/main.do" target="_blank">중소벤처기업부</a></li>
						<li><a href="http://www.bizinfo.go.kr/cmm/main/introPage.do" target="_blank">기업마당</a></li>
						<li><a href="http://www.moel.go.kr/index.do" target="_blank">고용노동부</a></li>
						<li><a href="http://kostat.go.kr/portal/korea/index.action" target="_blank">통계청</a></li>
						<li><a href="https://kssc.kostat.go.kr:8443/ksscNew_web/index.jsp" target="_blank">통계분류포털</a></li>
						<li><a href="http://www.law.go.kr/" target="_blank">국가법령정보센터</a></li>
						<li><a href="http://www.fss.or.kr/fss/kr/main.html" target="_blank">금융감독원</a></li>
						<li><a href="http://www.fsc.go.kr/" target="_blank">금융위원회</a></li>
						<li><a href="http://www.ftc.go.kr/" target="_blank">공정거래위원회</a></li>
						<li><a href="http://dart.fss.or.kr/" target="_blank">전자공시시스템</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<div class="f_bottom">
		<div class="f_wrap">
			<div class="f_logo">
				<a href="http://fomek.or.kr/main/index.php" target="_blank" alt="연합회">연합회</a>
			</div>
			
			<div class="addr">
				<p><span>운영기관 : </span>연합회</p>
				<p>TEL : 02-761-7710    FAX : 02-761-7702<br>COPYRIGHT © 연합회 ALL RIGHTS RESERVED.</p>
			</div>
			<div class="f_logo f_logo_r">
				<a href="http://www.motie.go.kr/www/main.do" target="_blank" alt="자원부">자원부</a>
			</div>
		</div>
	</div>
</div>
</body>
</html>