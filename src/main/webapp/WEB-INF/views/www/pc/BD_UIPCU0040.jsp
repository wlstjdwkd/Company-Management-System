<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업검색|기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,colorbox,flot, jqGrid, msgBox" />
<ap:jsTag type="tech" items="pc, cmn, mainn, subb, font,util" />


<script type="text/javascript" language="JavaScript">
	var mapData;
	
	$(document).ready(function() {
		// 통계목록 리스트를 조회하기위해 함수를 호출한다.
		getSubList("MT_ZTITLE", "142_130", 0);
	});
	
	/****************************************************
	* 통계목록 리스트 조회 함수
	* parameter : vwcd - 서비스뷰 코드 (통계목록구분)
	* listLev - 목록 레벨
	* parentId - 시작목록 Id
	*
	****************************************************/
	
	function getSubList(vwcd, parentId, parentNodeId, parentCont) {
		$.ajax({
			url      : "/PGPC0040.do",
			type     : "post",
			dataType : "json",
			data	 : {"df_method_nm":"kosisImport",
				        "method":"getList",
				        "key":"MzJjZDNmYTViNDk2NWQxOTA5Yzg0NTU0ZDdlM2FlMjk=",
				        "vwcd":vwcd,
				        "parentId":parentId,
				        "type":"json"
				       },
			async    : false,
			success  : function(response) {
				try {
					mapData = response;
				} catch (e) {
					jsSysErrorBox(response, e);
					return;
				}
			}
		});
		
		// 통계목록 리스트를 화면에 출력하기 위한 함수 
		makeNode(vwcd, parentId, parentNodeId, parentCont);
	}
	
	/****************************************************
	* 통계목록 리스트를 화면에 출력하기 위한 함수
	* parameter : listLev - 목록 레벨
	****************************************************/
	function makeNode(vwcd, parentId, parentNodeId, parentCont) {
		var nodeInfo = "";
		
		if(parentNodeId == 0) {
			nodeInfo = nodeInfo + "<ul id='ul_0'>";
			
			for(var cnt=0; cnt<mapData.length; cnt++) {
				nodeInfo = nodeInfo + "<li id='li_0"+cnt+"'>";
				if ( mapData[cnt].TBL_ID != null ) {
					nodeInfo = nodeInfo + "<img src='/images/pc/stats.gif'> <a target='_balnk' href=\"http://kosis.kr/start.jsp?orgId="+mapData[cnt].ORG_ID+"&tblId="+mapData[cnt].TBL_ID+"&vw_cd="+mapData[cnt].VW_CD+"&up_id="+mapData[cnt].UP_ID+"\">"+mapData[cnt].TBL_NM+"</a>" ; 
				} else { 
					nodeInfo = nodeInfo + "<img src='/images/pc/plus.gif'/> <img src='/images/pc/folder.png'> <a href=\"javascript:getSubList('"+mapData[cnt].VW_CD+"', '"+mapData[cnt].LIST_ID+"', '"+"li_0"+cnt+"', '"+mapData[cnt].LIST_NM+"');\">"+mapData[cnt].LIST_NM+"</a>" ;
				}
				nodeInfo = nodeInfo + "</li>"; 
			}
			
			nodeInfo = nodeInfo + "</ul>";
			
			var r_node = document.getElementById("kosisContent");
			r_node.innerHTML = nodeInfo;
		} else {
			var parentStr = parentNodeId;
			var res = parentStr.split("_");
			var lv = res[1];
			
			nodeInfo = nodeInfo + "<img src='/images/pc/minus.gif'/> <img src='/images/pc/folder.png'> <a href=\"javascript:removeNode('"+vwcd+"', '"+parentId+"', '"+parentNodeId+"', '"+parentCont+"');\">"+parentCont+"</a>";
			
			nodeInfo = nodeInfo + "<ul id='ul_"+lv+"' style='margin-left:20px;'>";
			
			for(var cnt=0; cnt<mapData.length; cnt++) {
				nodeInfo = nodeInfo + "<li id='"+parentNodeId+cnt+"'>";
				if ( mapData[cnt].TBL_ID != null ) {
					nodeInfo = nodeInfo + "<img src='/images/pc/stats.gif'> <a target='_balnk' href=\"http://kosis.kr/start.jsp?orgId="+mapData[cnt].ORG_ID+"&tblId="+mapData[cnt].TBL_ID+"&vw_cd="+mapData[cnt].VW_CD+"&up_id="+mapData[cnt].UP_ID+"\">"+mapData[cnt].TBL_NM+"</a>" ; 
				} else { 
					nodeInfo = nodeInfo + "<img src='/images/pc/plus.gif'/> <img src='/images/pc/folder.png'> <a href=\"javascript:getSubList('"+mapData[cnt].VW_CD+"', '"+mapData[cnt].LIST_ID+"', '"+parentNodeId+cnt+"', '"+mapData[cnt].LIST_NM+"');\">"+mapData[cnt].LIST_NM+"</a>" ;
				}
				nodeInfo = nodeInfo + "</li>"; 
			}
			
			nodeInfo = nodeInfo + "</ul>";
			
			var v_node = document.getElementById(parentNodeId);
			v_node.innerHTML = nodeInfo;
		}
	}
	
	function removeNode(vwcd, parentId, parentNodeId, parentCont) {
		var nodeInfo = "";
		
		var v_node = document.getElementById(parentNodeId);
		
		while (v_node.firstChild) {
			v_node.removeChild(v_node.firstChild);
		}
		
		nodeInfo = nodeInfo + "<img src='/images/pc/plus.gif'/> <img src='/images/pc/folder.png'> <a href=\"javascript:getSubList('"+vwcd+"', '"+parentId+"', '"+parentNodeId+"', '"+parentCont+"');\">"+parentCont+"</a>";
		v_node.innerHTML = nodeInfo;
	}
</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="post">
    <ap:include page="param/defaultParam.jsp" />
    <ap:include page="param/dispParam.jsp" />
    <!--//content-->
    <div id="wrap">
    	<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit01">
			<h1>기업현황</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit">기업현황</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont">
					<div class="s_tabMenu">
						<ul>
							<li style="width:50%;"><a href="#none" onclick="jsMoveMenu('1', '14', 'PGPC0020')" alt="현황">현황</a></li>
							<li style="display:none;"><a href="#none" onclick="jsMoveMenu('1', '14', 'PGPC0030')" alt="경기전망조사">경기전망조사</a></li>
							<li  style="width:50%;" class="on"><a href="#none" onclick="jsMoveMenu('1', '14', 'PGPC0040')" alt="승인통계">승인통계</a></li>
						</ul>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">영리법인기업체행정통계</h4>
						<div class="border_box" style="padding: 27px 25px; ">
                            <ul class="tree">
							  <li><span class="caret" style="line-height:20px;" >영리법인기업체행정통계</span>
								<ul class="nested">
								  <li><a href="http://kosis.kr/start.jsp?orgId=101&tblId=DT_1BE0007&vw_cd=MT_OTITLE&up_id=undefined" target="_blank">종사자규모별 주요지표</a></li>
								  <li><a href="http://kosis.kr/start.jsp?orgId=101&tblId=DT_1BE0008&vw_cd=MT_OTITLE&up_id=undefined" target="_blank">매출액규모별 주요지표</a></li>
								  <li><a href="http://kosis.kr/start.jsp?orgId=101&tblId=DT_1BE0009&vw_cd=MT_OTITLE&up_id=undefined" target="_blank">자산규모별 주요지표</a></li>
								  <li><a href="http://kosis.kr/start.jsp?orgId=101&tblId=DT_1BE0011&vw_cd=MT_OTITLE&up_id=undefined" target="_blank">산업별(10차) 종사자수, 주요지표</a></li>
								  <li><a href="http://kosis.kr/start.jsp?orgId=101&tblId=DT_1BE0012&vw_cd=MT_OTITLE&up_id=undefined" target="_blank">산업별(10차)/업력별 기업체수, 매출액, 총자산</a></li>
								  <li><a href="http://kosis.kr/start.jsp?orgId=101&tblId=DT_2BE0011&vw_cd=MT_OTITLE&up_id=undefined" target="_blank">기업규모(2016년기준 개편)/종사자규모별 기업체수, 매출액, 총자산</a></li>
								  <li><a href="http://kosis.kr/start.jsp?orgId=101&tblId=DT_2BE0012&vw_cd=MT_OTITLE&up_id=undefined" target="_blank">기업규모(2016년 기준 개편)/매출액규모별 기업체수, 총자산</a></li>
								  <li><a href="http://kosis.kr/start.jsp?orgId=101&tblId=DT_2BE0013&vw_cd=MT_OTITLE&up_id=undefined" target="_blank">기업규모(2016년기준 개편)/자산규모별 기업체수, 매출액</a></li>
								  <li><a href="http://kosis.kr/start.jsp?orgId=101&tblId=DT_2BE0014&vw_cd=MT_OTITLE&up_id=undefined" target="_blank">기업규모(2016년기준 개편)/업력별 기업체수, 매출액, 총자산</a></li>
								  <li><a href="http://kosis.kr/start.jsp?orgId=101&tblId=DT_2BE0015&vw_cd=MT_OTITLE&up_id=undefined" target="_blank">기업규모(2016년기준 개편)/산업별(10차) 기업체수, 종사자수, 매출액, 총자산</a></li>
								  <li><a href="http://kosis.kr/start.jsp?orgId=101&tblId=DT_4BE0005&vw_cd=MT_OTITLE&up_id=undefined" target="_blank">사업형태별/종사자규모별 기업체수, 매출액, 총자산</a></li>
								  <li><a href="http://kosis.kr/start.jsp?orgId=101&tblId=DT_4BE0006&vw_cd=MT_OTITLE&up_id=undefined" target="_blank">사업형태별/매출액규모별 기업체수, 총자산</a></li>
								  <li><a href="http://kosis.kr/start.jsp?orgId=101&tblId=DT_4BE0007&vw_cd=MT_OTITLE&up_id=undefined" target="_blank">사업형태별/ 산업별(10차) 기업체수, 매출액, 총자산</a></li>
								  <li><a href="http://kosis.kr/start.jsp?orgId=101&tblId=DT_5BE0004&vw_cd=MT_OTITLE&up_id=undefined" target="_blank">기업규모별(2016년기준 개편)/산업별(10차) 활동유형, 소속사업장수</a></li>
								  
								  <li><span class="caret">산업분류(9차), 중소·기업법(평균매출액, 독립성 기준), 공기업 전부 포함</span>
									<ul class="nested">
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_1BE0006&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">산업별(9차) 주요지표</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_1BE0010&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">산업별(9차)/업력별 기업체수, 매출액, 총자산</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_2BE0010&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업규모별(2016년기준 개편)/산업별(9차) 기업체수, 매출액, 총자산</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_4BE0004&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">사업형태별/산업별(9차) 기업체수, 매출액, 총자산</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_5BE0003&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업규모별(2016년기준 개편)/산업별(9차) 활동유형, 소속사업장수</a></li>
									</ul>
								  </li>  
								  <li><span class="caret">산업분류(9차), 중소기업법(평균매출액 기준), 공기업 일부 포함</span>
									<ul class="nested">
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_1BE0005&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">산업별(9차)/업력별 기업체수, 매출액, 총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_2BE0005&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업규모별(신기준)/산업별(9차) 기업체수, 매출액, 총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_2BE0006&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업규모별(신기준)/종사자규모별 기업체수, 매출액, 총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_2BE0007&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업규모별(신기준)/매출액규모별 기업체수, 매출액, 총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_2BE0008&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업규모별(신기준)/자산규모별 기업체수, 매출액, 총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_2BE0009&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업규모별(신기준)/업력별 기업체수, 매출액, 총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_5BE0002&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업규모별(신기준)/산업별(9차) 활동유형,소속사업장수</a></li>
									</ul>
								  </li>  
								  <li><span class="caret">산업분류(9차), (구)중소기업법(종사자, 매출액 등 기준), 공기업 일부 포함</span>
									<ul class="nested">
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_1BE0001&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">산업별(9차) 주요지표</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_1BE0002&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">종사자규모별 주요지표</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_1BE0003&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">매출액규모별 자산,부채,자본</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_1BE0004&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">자산규모별 매출액,영업손익,당기순손익</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_2BE0001&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업규모별(구기준)/산업별(9차) 기업체수,매출액,총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_2BE0002&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업규모별(구기준)/종사자규모별 기업체수,매출액,총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_2BE0003&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업규모별(구기준)/매출액규모별 기업체수,총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_2BE0004&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업규모별(구기준)/자산규모별 기업체수,매출액</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_3BE0001&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업집단별/산업별(9차) 기업체수,매출액,총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_3BE0002&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업집단별/종사자규모별 기업체수,매출액,총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_3BE0003&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업집단별/매출액규모별 기업체수,총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_3BE0004&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업집단별/자산규모별 기업체수,매출액</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_4BE0001&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">사업형태별/산업별(9차) 기업체수,매출액,총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_4BE0002&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">사업형태별/종사자규모별 기업체수,매출액,총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_4BE0003&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">사업형태별/매출액규모별 기업체수,총자산</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=101&amp;tblId=DT_5BE0001&amp;vw_cd=MT_OTITLE&amp;up_id=undefined">기업규모별(구기준)/산업별(9차) 활동유형,소속사업장수</a></li>
									</ul>
								  </li>  
								</ul>
							  </li>
							</ul>
						</div>
						
						<h4 class="fram_bl">기업 실태조사</h4>
						<div class="border_box" style="padding: 27px 25px; ">
                            <ul class="tree">
							  <li><span class="caret" style="line-height:20px;" >2015년 이후</span>
								<ul class="nested">
								  <li><span class="caret">기업 진입 및 성장</span>
									<ul class="nested">
									  <li><a href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_204&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined" target="_blank">중소기업 회귀 검토 유무</a></li>
									  <li><a href="http://kosis.kr/start.jsp?orgId=115&tblId=DT_14217M_205&vw_cd=MT_ZTITLE&up_id=undefined" target="_blank">중소기업 회귀 검토 요인</a></li>
									  <li><a href="http://kosis.kr/start.jsp?orgId=115&tblId=DT_14217M_209&vw_cd=MT_ZTITLE&up_id=undefined" target="_blank">인수합병(M&A) 경험</a></li>
									  <li><a href="http://kosis.kr/start.jsp?orgId=115&tblId=DT_14217M_210&vw_cd=MT_ZTITLE&up_id=undefined" target="_blank">경험한 인수합병(M&A) 형태</a></li>
									  <li><a href="http://kosis.kr/start.jsp?orgId=115&tblId=DT_14217M_211&vw_cd=MT_ZTITLE&up_id=undefined" target="_blank">M&amp;A활성화 필요정책</a></li>
									  <li><a href="http://kosis.kr/start.jsp?orgId=115&tblId=DT_14217M_213&vw_cd=MT_ZTITLE&up_id=undefined" target="_blank">경영 애로사항</a></li>
									</ul>
								  </li>  
								  <li><span class="caret">기술혁신</span>
									<ul class="nested">
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_217&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">R&amp;D 투자실적</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_218&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">R&amp;D 투자계획</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_219&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">2016년 설비투자실적</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_220&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">설비투자 계획</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_221&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">기술개발 방식</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_222&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">정부지원R&amp;D사업 수행 경험</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_223&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">정부지원 R&amp;D사업 미참여 이유</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_224&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">연구개발 조직형태 및 인력수</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_226&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주력기술 수준</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_227&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">지식재산권 보유 여부</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_228&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">지식재산권 등록현황_평균</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_230&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">지식재산권 등록현황_합계</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_232&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">지식재산권 침해경험</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_233&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">지식재산권 침해한 주체</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_234&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">산학협력 활동 경험</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_235&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">협력기관</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_236&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">기술이전 받은 경험</a></li>
									  <li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_237&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">기술이전처</a></li>
									</ul>
								  </li>  
								  <li><span class="caret">인재확보</span>
									<ul class="nested">
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_238&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">기업 인력 현황</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_239&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">채용실적</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_240&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">채용계획</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_241&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">신입사원 초임_평균</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_243&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">재직연수별 현황_평균</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_245&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">이직자 현황</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_246&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주요 이직원인</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_250&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">유형별 보유인력</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_251&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">성과보상 제도</a></li>
									</ul>
								  </li>  
								  <li><span class="caret">국제화촉진</span>
									<ul class="nested">
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_252&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">해외 수출 여부</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_253&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">직/간접수출 비중</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_254&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주요수출 국가 1+2+3+4+5순위(상위 14개)</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_256&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주요수출 대륙 1+2+3+4+5순위</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_257&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주요수출 국가별 수출금액(상위 14개)</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_258&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주요수출 대륙별 수출금액</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_259&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">신규 진출 여부</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_260&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">신규 진출 국가별 수출금액(상위 14개)</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_261&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">신규 진출 대륙별 수출금액</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_262&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">현지법인 설립</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_263&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">진출국가별 현지법인 설립 현황(상위 14개)</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_264&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">진출대륙별 현지법인 설립 현황</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_265&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">수출시 애로사항</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_269&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">FTA 활용 여부</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_270&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">FTA 미활용 사유</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_271&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">FTA활용 내부시스템 구축 비율</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_272&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">FTA활용을 위한 정부지원</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_276&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">해외진출 고려 여부</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_277&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">해외진출 고려 이유</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_279&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">신규 해외진출 계획시점</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_280&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">희망하는 신규 진출 국가 1+2+3순위(상위 14개)</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_282&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">희망하는 신규 진출 대륙 1+2+3순위</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_283&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">신규 해외진출 미고려 이유</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_284&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">해외 수출(진출)시 전략</a></li>
									</ul>
								  </li>  
								  <li><span class="caret">수·위탁 거래 및 동반성장</span>
									<ul class="nested">
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_288&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">수·위탁거래 단계</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_289&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">위탁거래 현황</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_290&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">납품단가 인하 요구 경험 및 평균단가인하율</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_291&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">위탁거래 기업과의 결제기간/수단</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_292&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">수탁거래 기업과의 결제기간/수단</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_293&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">불공정거래 경험율</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_295&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">위탁기업과의 동반성장 및 상생협력 활동 수행비중</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_297&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">수탁기업과의 동반성장 및 상생협력 활동 수행비중</a></li>
									</ul>
								  </li>
								  <li><span class="caret">금융 및 자금조달</span>
									<ul class="nested">
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_299&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주요 자금조달 용도</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_A00&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주요 자금조달원 비중</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_A01&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">외부 자금조달 애로사항</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_A05&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">정책자금 활용 여부</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_A06&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">기관별 정책자금 활용비중</a></li>
									</ul>
								  </li>
								  <li><span class="caret">기업의 사회적 책임</span>
									<ul class="nested">
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_A07&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">사회공헌활동 수행 여부</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_A08&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">사회공헌활동 유형별 비중</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_A09&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">가업승계 도입 여부</a></li>
										<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217M_A10&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">가업승계시 애로사항</a></li>
									</ul>
								  </li>
								</ul>
							  </li>
							   <li><span class="caret" style="line-height:20px;" >2014년</span>
								<ul class="nested">
									<li><span class="caret">기업 진입 및 성장</span>
										<ul class="nested">
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_304&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">중소기업 회귀 검토 유무</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_305&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">중소기업 회귀 검토 요인_1순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_306&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">중소기업 회귀 검토 요인_1+2순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_308&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">인수합병(M&amp;A) 경험</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_309&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">경험한 인수합병(M&amp;A) 형태</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_310&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">M&amp;A활성화 필요정책_1순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_311&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">M&amp;A활성화 필요정책_1+2순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_312&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">경영 애로사항_1순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_314&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">경영 애로사항_1+2순위</a></li>
										</ul>
									</li>
									<li><span class="caret">기술혁신</span>
										<ul class="nested">
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_316&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">R&amp;D 투자실적</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_317&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">설비투자실적</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_318&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">기술개발 방식</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_319&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">정부지원R&amp;D사업 수행 경험</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_320&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">정부지원 R&amp;D사업 미참여 이유</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_321&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">연구개발 조직형태 및 인력수</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_323&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주력기술 수준</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_324&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">지식재산권 보유 여부</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_325&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">지식재산권 등록현황_평균</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_327&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">지식재산권 등록현황_합계</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_329&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">지식재산권 침해경험</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_330&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">지식재산권 침해한 주체</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_331&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">산학협력 활동 경험</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_332&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">협력기관</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_333&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">기술이전 받은 경험</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_334&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">기술이전처</a></li>
										</ul>
									</li>
									<li><span class="caret">인재확보</span>
										<ul class="nested">
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_335&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">기업 인력 현황</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_336&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">채용실적</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_337&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">남성 신입사원 초임_평균</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_338&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">여성 신입사원 초임_평균</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_339&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">남성 재직연수별 현황_평균</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_340&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">여성 재직연수별 현황_평균</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_341&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">이직자 현황</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_342&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주요 이직원인_1순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_344&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주요 이직원인_1+2순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_346&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">유형별 보유인력</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_347&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">성과보상 제도</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_348&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">직원정년</a></li>
										</ul>
									</li>
									<li><span class="caret">국제화 촉진</span>
										<ul class="nested">
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_349&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">해외 수출 여부</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_350&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">직/간접수출 비중</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_351&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주요수출지역 1+2+3 순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_353&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주요수출지역별 수출금액</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_354&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">신규 진출 여부</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_355&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">신규 진출 국가별 수출금액</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_356&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">현지법인 설립</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_357&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">진출국가별 현지법인 설립 현황</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_358&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주요 지역별 현지법인 설립 현황 1+2+3 순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_360&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">수출시 애로사항_1순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_362&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">수출시 애로사항_1+2순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_364&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">해외진출 고려 여부</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_365&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">해외진출 고려 이유_1순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_366&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">해외진출 고려 이유_1+2순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_367&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">해외 수출(진출)시 전략_1순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_369&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">해외 수출(진출)시 전략_1+2순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_371&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">FTA활용 내부시스템 구축 비율</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_372&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">FTA활용을 위한 정부지원_1순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_374&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">FTA활용을 위한 정부지원_1+2순위</a></li>
										</ul>
									</li>
									<li><span class="caret">수·위탁 거래 및 동반성장</span>
										<ul class="nested">
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_376&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">수·위탁거래 단계</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_377&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">위탁거래 현황</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_378&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">납품단가 인하 요구 경험 및 평균단가인하율</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_379&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">위탁거래 기업과의 결제기간/수단</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_380&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">수탁거래 기업과의 결제기간/수단</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_381&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">불공정거래 경험율</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_383&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">위탁기업과의 동반성장 및 상생협력 활동 수행비중</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_385&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">수탁기업과의 동반성장 및 상생협력 활동 수행비중</a></li>
										</ul>
									</li>
									<li><span class="caret">금융 및 자금조달</span>
										<ul class="nested">
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_387&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주요 자금조달 용도</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_388&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">주요 자금조달원 비중</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_389&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">외부 자금조달 애로사항</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_391&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">정책자금 활용 여부</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_392&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">기관별 정책자금 활용비중</a></li>
										</ul>
									</li>
									<li><span class="caret">기업의 사회적 책임</span>
										<ul class="nested">
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_393&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">사회공헌활동 수행 여부</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_394&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">사회공헌활동 유형별 비중</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_395&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">가업승계 도입 여부</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_396&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">가업승계시 애로사항_1순위</a></li>
											<li><a target="_balnk" href="http://kosis.kr/start.jsp?orgId=115&amp;tblId=DT_14217N_398&amp;vw_cd=MT_ZTITLE&amp;up_id=undefined">가업승계시 애로사항_1+2순위</a></li>
										</ul>
									</li>
								</ul>
							   </li>
							</ul>
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