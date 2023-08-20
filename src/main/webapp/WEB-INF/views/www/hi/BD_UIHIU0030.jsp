<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>	
<ap:jsTag type="web" items="jquery,form" />
<ap:jsTag type="tech" items="util,cmn, mainn, subb, font,hi,paginate" />
<script type="text/javascript">
$(document).ready(function(){
	
});

var fJoDefView = function(docCls, chkId, datSeq, seq, joNo, joBrNo, lsNmKo, nwYn){
	fJoView(docCls, chkId, datSeq, seq, joNo, joBrNo, lsNmKo, nwYn);
}

var  fJoView = function(docCls, chkId, datSeq, seq, joNo, joBrNo, lsNmKo, nwYn){
    tabChgChk = true;
    
	if(docCls=="by"){
		by(chkId,datSeq,seq,joNo,joBrNo,lsNmKo);
	}else{
		var paraTmp = null;
		if(docCls=="ga" || docCls=="re"){
			joNo = datSeq;
		}else if(docCls=="jo"){
			if(joNo != ""){
				paraTmp = "joa1" + joNo + "a2" + joBrNo;
			}
		}
		var purl = "http://www.law.go.kr/lsSideInfoP.do?lsiSeq="+seq+"&ancYd="+datSeq+"&nwYn=Y&joNo="+joNo+"&joBrNo="+joBrNo+"&docCls="+docCls+"&&urlMode=lsScJoRltInfoR&lsNmKo="+encodeURIComponent(lsNmKo);
		if(paraTmp!=null)
		{
			purl = purl+ "&paras="+paraTmp;
		}
		openPop(purl);
	}
}

var by = function(chkId,datSeq,seq,joNo,joBrNo,lsNmKo){
	openPop("http://www.law.go.kr/lsBylInfoR.do?bylInfSeq="+datSeq+"&lsiSeq="+seq+"&lsNmKo="+encodeURIComponent(lsNmKo));
}

var  openPop = function(url, width, height){
	if(width == null || width == ""){
		width = "900px";
	}
    
	if(height == null || height == ""){
		height = "630px";
	}
	
	/*
	 * 팝업으로뜨는 별표는 사이즈를 좀 키움
	 * 2013.03.20 홍석균
	 */
	if(   url.indexOf("lsBylInfoR.do") > -1
	   || url.indexOf("admRulBylInfoR.do") > -1
	   || url.indexOf("ordinBylInfoR.do") > -1
	   )
	{
	    height = "830px";
	}
	
	var win = window.open(url,'', 'scrollbars=yse,toolbar=no,resizable=yes,status=no,location=yes,menubar=no,width=' + width + ',height=' +  height);
	return false;
}

var fLsDefListView = function(chkId, seq, nwYn, mode){
   return false;
}
</script>
</head>

<body>
<form name="dataForm" id="dataForm" method="post" action="PGHI0030.do">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />


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
					<div class="list_bl" style="padding-bottom:40px; border-bottom: 1px solid #dadada">
						<h4 class="fram_bl">기업법</h4>
						<p class="list_noraml">기업 성장촉진 및 경쟁력 강화에 관한 특별법
						&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
						<a href="http://www.law.go.kr/법령/기업성장촉진및경쟁력강화에관한특별법" target="_blank" class="detail_btn">자세히 보기</a></p>
						<p class="list_noraml">기업 성장촉진 및 경쟁력 강화에 관한 특별법 시행령
						&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;
						<a href="http://www.law.go.kr/법령/기업성장촉진및경쟁력강화에관한특별법시행령" target="_blank" class="detail_btn">자세히 보기</a></p>
						<p class="list_noraml">기업 확인요령
						&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
						&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;
						<a href="http://www.law.go.kr/행정규칙/기업확인요령" target="_blank" class="detail_btn">자세히 보기</a></p>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">기업 인용 다른 법령 조문</h4>
						<div class="table_list">
							<ap:pagerParam />
							<table class="st_bl01 stb_gr01">
								<colgroup>
									<col width="69px">
									<col width="456px">
									<col width="191px">
									<col width="171px">
								</colgroup>
								<thead>
									<tr>
										<th>번호</th>
										<th>법령명</th>
										<th>조문명</th>
										<th>항호목</th>
									</tr>
								</thead>
								<tbody>
									<c:choose>
									   	<c:when test="${lawInfoList['result']}">
										  	<c:forEach items="${lawInfoList['value']}" var="info" varStatus="status">
										  	<tr>    	
												<td>${info.seqNm}</td>
												<c:choose>
												<c:when test="${(info.itemNm != null && info.itemNm != '') && (info.itemNm2 == null || info.itemNm2 == '')}">
													<td>&nbsp;</td>
													<td class="tal">${info.lawNm}</td>
													<td class="tal">${info.itemNm}</td>
												</c:when>
												<c:when test="${(info.itemNm == null || info.itemNm == '') && (info.itemNm2 == null || info.itemNm2 == '')}">
													<td>&nbsp;</td>
													<td class="tal">&nbsp;</td>
													<td class="tal">${info.lawNm}</td>
												</c:when>
												<c:otherwise>
													<td>${info.lawNmT}</td>
													<td class="tal">${info.itemNm}</td>
													<td class="tal">${info.itemNm2}</td>
												</c:otherwise>
												</c:choose>
											</tr>
											</c:forEach>
										</c:when>
									   	<c:otherwise>
									   		<td colspan="4" style="text-align:center;">관계법령 정보가 없거나 국가법령정보센터에서 응답이 지연되고 있습니다.</td>
									   	</c:otherwise>
									</c:choose>
								</tbody>
							</table>
							<div style="text-align:center;"><ap:pager pager="${pager}" /></div>
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