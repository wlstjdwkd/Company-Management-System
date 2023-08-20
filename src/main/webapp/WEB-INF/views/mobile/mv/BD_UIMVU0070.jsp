<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<title>고객지원</title>
<ap:jsTag type="web" items="jquery,tools,ui" />
<ap:jsTag type="tech" items="util,mv" />
<script type="text/javascript">
	var listLength = "${inparam.cnt}";
	
	$(document).ready(function() {
		
		// 게시글 수가 10개 이상일때 더보기 표시
		if(listLength < 11) {
			$('.btn_ft').hide();
		} else {
			$('.btn_ft').show();
		}
		
		
		// 더보기
		$("#btn_more").click(function() {
			$("#ad_moreList").val("MORE");
			
			$.ajax({
                url      : "PGMV0070.do",
                type     : "POST",
                dataType : "json",
                data     : { df_method_nm	: "index"
                			,"ad_moreList"	: $('#ad_moreList').val()
                			,"ad_noticeFrom" : $('#ad_noticeFrom').val()
                			,"ad_boardFrom" : $('#ad_boardFrom').val()
                			,"ad_ajax"		: "Y"
                		   },                
                async    : false,                
                success  : function(response) {
                	try {
                        if(response.result) {
                        	var htmlText = '';
                        	
                        	console.log(response.value);
                        	if((response.value).length == 2) {
	                        	for(var i=0; i< (response.value[0]).length; i++) {
	                        		htmlText = '';
	                        		htmlText += '<li><a href="#none" onclick="fn_notice_info(\''+ response.value[0][i].seq +'\')"><span class="icon_notice">new</span>'+response.value[0][i].title;
	                        		if(response.value[0][i].fileCnt > 0) {
	                        			htmlText += '<span class="t_file" title="첨부파일이 ' + response.value[0][i].fileCnt + '개 존재합니다."><img src="/images/ucm/icon_file.png" alt="파일" />(' + response.value[0][i].fileCnt + ')</span>';
	                        		}
	                        		htmlText += '</a></li>'
	                        		$('#ulAdd').append(htmlText);
	                        	}
	                        	
	                        	if((response.value[1]).length > 0) {
	                        		for(var i=0; i < (response.value[1]).length; i++) {
	                        			htmlText = '';
	                        			htmlText += '<li><a href="#none" onclick="fn_notice_info(\''+ response.value[1][i].seq +'\')">'+response.value[1][i].title;
	                        			if(response.value[1][i].fileCnt > 0) {
	                        				htmlText += '<span class="t_file" title="첨부파일이 ' + response.value[1][i].fileCnt + '개 존재합니다."><img src="/images/ucm/icon_file.png" alt="파일" />(' + response.value[1][i].fileCnt + ')</span>';
	        	                        }
	                        			htmlText += '</a></li>';
	        	                        $('#ulAdd').append(htmlText);
	                        		}
	                        	}
                        	}
                        	else {
                        		for(var i=0; i < (response.value).length; i++) {
                        			htmlText = '';
                        			htmlText += '<li><a href="#none" onclick="fn_notice_info(\''+ response.value[i].seq +'\')">'+response.value[i].title;
                        			if(response.value[i].fileCnt > 0) {
                        				htmlText += '<span class="t_file" title="첨부파일이 ' + response.value[i].fileCnt + '개 존재합니다."><img src="/images/ucm/icon_file.png" alt="파일" />(' + response.value[i].fileCnt + ')</span>';
	                        		}
                        			htmlText += '</a></li>';
	                        		$('#ulAdd').append(htmlText);
                        		}
                        	}
                        	$('.btn_ft').hide();
                        } else {                        	 
                        	return;
                        }
                    } catch (e) {
                        if(response != null) {
                        	jsSysErrorBox(response);
                        } else {
                            jsSysErrorBox(e);
                        }
                        return;
                    }                
                }
            });	
		});	
	});
	
	function fn_notice_info(seq) {
		document.getElementById("df_method_nm").value = "noticeForm";
		document.getElementById("ad_listSeq").value = seq;
		document.dataForm.submit();
	}
	
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		
		<input type="hidden" name="ad_moreList" id="ad_moreList" /> 
		<input type="hidden" name="ad_noticeFrom" id="ad_noticeFrom" value="${inparam.noticeFrom }"/> 
		<input type="hidden" name="ad_boardFrom" id="ad_boardFrom" value="${inparam.boardFrom }"/>
		<input type="hidden" name="ad_listSeq" id="ad_listSeq" />
		
		<!--//내용영역-->
		<section class="notice">
			<div class="sub_con">
				<div class="tit_page">다양한 기업 정보의 소식을 전합니다.</div>
				<div class="nt_list">
					<ul id="ulAdd" class="">
						<c:forEach items="${noticeList}" var="noticeList" varStatus="status">
							<li>
								<a href="#none" onclick="fn_notice_info('${noticeList.seq}')">
									<span class="icon_notice">new</span>
									${noticeList.title}
									<c:if test="${noticeList.fileCnt > 0}">
										<span class="t_file" title="첨부파일이 ${noticeList.fileCnt}개 존재합니다.">
										<img src="<c:url value="/images/ucm/icon_file.png" />" alt="파일" />(${noticeList.fileCnt})</span>
									</c:if>
								</a>
							</li>
						</c:forEach>
						<c:if test="${fn:length(noticeList) < 10}">
						<c:forEach items="${boardList}" var="boardList" varStatus="status">
							<li>
								<a href="#none" onclick="fn_notice_info('${boardList.seq}')">
									${boardList.title}
									<c:if test="${boardList.fileCnt > 0}">
										<span class="t_file" title="첨부파일이 ${boardList.fileCnt}개 존재합니다.">
										<img src="<c:url value="/images/ucm/icon_file.png" />" alt="파일" />(${boardList.fileCnt})</span>
									</c:if>
								</a>
							</li>
						</c:forEach>
						</c:if>
					</ul>
				</div>
				<div class="btn_ft">
					<a href="#none" id="btn_more" class="btn_more">더보기<span class="bul"></span></a>
				</div>
			</div>
		</section>
		<!--내용영역//-->
	</form>
</body>
</html>