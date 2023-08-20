<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
 <head>
  <title>SecureKeyStroke</title>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
  <script type="text/javascript" src="${contextPath}/script/jquery/jquery-1.11.1.min.js"></script>
  <script type="text/javascript" src="${contextPath}/script/jquery/ui/1.11.2/jquery-ui.min.js"></script>
  <link rel="stylesheet" type="text/css" href="${contextPath}/script/keyboardEnc/common.css" />
  <link rel="stylesheet" type="text/css" href="${contextPath}/script/keyboardEnc/style.css" />
  <link rel="stylesheet" type="text/css" href="${contextPath}/script/jquery/ui/1.11.2/jquery-ui.structure.min.css" /> 
    <script type="text/javascript">
		$(document).ready(function(){ 						
			$(".tab_box").tabs();
			
			var url = location.href;		//현재 주소
			var urlParamStart = url.indexOf("?")+1;	//파라메터 시작점
			var param = url.substring(urlParamStart, url.length); //파라메터 값 
			
			if(	param == 'tab1' || 	param == '' ){
				$(".tab_box").tabs( "option", "active", 0 );
			}else if( param == 'tab2'){
				$(".tab_box").tabs( "option", "active", 1 );
			}else if( param == 'tab3'){
				$(".tab_box").tabs( "option", "active", 2 );
			}
		});
	</script>  
 </head>

 <body>
<div id="container" style="margin-top: 30px;">
<!-- content -->
	<div class="content_box">
		<div class="tab_box mgt20">
			<div class="btn_area" style="height: 20px; margin-top: -15px; margin-bottom:  -15px; margin-right: 100px;">
				
				<a href="/keyboardEnc/SCWSSPSetup_onlysk.exe" class="btn_blue_a">키보드보안 설치 파일 다운로드</a>

			</div>
			<div class="btn_area" style="height: 20px; margin-top: -20px; margin-bottom:  -15px;">
				
				<a href="/PGUM0001.do" class="btn_blue_a">홈페이지</a>

			</div>
			<ul class="tab_navi">
				<li><a href="#tabs-1">제품 안내</a></li>
				<li><a href="#tabs-2">설치 안내</a></li>
				<li><a href="#tabs-3">기타 안내</a></li>
			</ul>
			<div id="tabs-1" class="tab_cont_box">
				<ul class="dot_list2">
					<li>소프트캠프 키보드보안 Non-ActiveX 안내 페이지 입니다.</li>
				</ul>
				<dl class="warning_box3">
					<dt><span class="number_arial">01</span> 지원 사양</dt>
					<dd>
						<table class="tbl_info mgt10" summary="">
							<caption></caption>
							<colgroup>
								<col style="width:30%;" />
								<col style="width:70%;" />
							</colgroup>
							<tbody>
								<tr class="no-top">
									<th scope="row">구분</th>
									<td>적용 가능 사양</td>
								</tr>
								<tr>
									<th scope="row" class="top_line">서버</th>
									<td>
										OS - 모든 운영체제 지원
									</td>
								</tr>
								<tr>
									<th scope="row" class="top_line">사용자PC(H/W)</th>
									<td>
										CPU Pentium Ⅱ이상 (Pentium Ⅲ 이상 권장)<br />
										Window 2000/XP/Vista/7(32bit, 64bit)<br />
									</td>
								</tr>
								<tr>
									<th scope="row" class="top_line">Web Browser</th>
									<td>
										 MS Internet Explorer 9.0 이상, FireFox, Opera, Chrome<br />
									</td>
								</tr>
								<tr>
									<th scope="row" class="top_line">키보드</th>
									<td>PS/2 Type, USB Type, 무선 키보드 등</td>
								</tr>
								<tr>
									<th scope="row" class="top_line">지원 브라우져</th>
									<td>
										Internet Explorer 9.0 이상, Edge<br />
										FireFox, Opera, Chrome<br />
									</td>
								</tr>
							</tbody>
						</table>
					</dd>
					<!-- <dt><span class="number_arial">02</span> 담당자 정보</dt>
					<dd>
						<table class="tbl_list mgt5" summary="">
							<caption></caption>
							<colgroup>
								<col style="width:20%;" />
								<col style="width:15%;" />
								<col style="width:15%;" />
								<col style="width:25%;" />
								<col style="width:25%;" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">역할</th>
									<th scope="col">이름</th>
									<th scope="col">직급</th>
									<th scope="col">이메일</th>
									<th scope="col" class="no-right">연락처</th>
								</tr>								
							</thead>
							<tbody>
								<tr class="no-top">
									<td>기술지원</td>
									<td>박혜영</td>
									<td>사원</td>
									<td class="al">example@example.com</td>
									<td>000-0000</td>
								</tr>
						
							</tbody>
						</table>
					</dd> -->
				</dl>
			</div>
			<div id="tabs-2" class="tab_cont_box">
				<ul class="dot_list2">
					<li>키보드보안(WS)를 설치합니다.</li>
					<li>키보드보안(WS)를 설치 파일 다운로드를 클릭하여 설치 파일을 다운로드 한 후 아래 그림과 같이 진행하여 설치하여 주십시오.</li>
				</ul>
				<dl class="warning_box3">
					<dt><span class="number_arial">01</span>SCWSSPSetup 아이콘을 실행합니다.</dt>
					<dd>
						<img src="${contextPath}/images2/keyb/scsk_Info_01.PNG" alt="" />
					</dd>
					<dt><span class="number_arial">02</span>SecureKeyStroke WS를 설치하는 동안 잠시 기다립니다.</dt>
					<dd>
						<img src="${contextPath}/images2/keyb/scsk_Info_02.PNG" alt="" /><br/><br/>
						<img src="${contextPath}/images2/keyb/scsk_Info_03.PNG" alt="" /><br/><br/>
					<dt><span class="number_arial">03</span>SecureKeyStroke WS의 설치가 완료 되었습니다.</dt>
					<dd>
						<img src="${contextPath}/images2/keyb/scsk_Info_04.PNG" alt="" />
					</dd>
				</dl>
			</div>
		</div><!--// tab_box -->
	</div><!--// content_box -->
 </body>
</html>
