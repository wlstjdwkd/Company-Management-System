<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>관계기업판정처리</title>

<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,multifile,blockUI,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util,etc" />

<script type="text/javaScript">
	$(document).ready(function() {
		<c:if test="${resultMsg != null}">
			$(function() {
				jsMsgBox(null, "info", "${resultMsg}");
			});
		</c:if>
		
		$("#file_rcpy").MultiFile({
			accept: 'xls|xlsx',
			max: '1',
			afterFileAppend: function() { $("#ad_upFile").val("Y"); },
			afterFileRemove: function() { $("#ad_upFile").val(""); },
			STRING: {
				remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" style="vertical-align:baseline;" />',
				denied: Message.msg.fildUploadDenied,           // 확장자 제한 문구
				duplicate: Message.msg.fildUploadDuplicate      // 중복 파일 문구
			}
		});
	});
	
	// 관계기업판정목록 페이지로 이동
	function moveRcpyJdgmntList() {
		$("#df_method_nm").val("selectRcpyJdgmntList");
		$("#ad_searchGubun").val("Y");
		$("#dataForm").submit();
	}
	
	// 관계기업대상 엑셀파일 업로드
	function doUploadRcpy() {
		jsMsgBox(null,'confirm','업로드 하시겠습니까?',
			function(){
				if($("#ad_upFile").val() == "Y") {
					$("#df_method_nm").val("processRcpyUploadFile");
					$.blockUI({ message:$("#loading") });
					$("#dataForm").submit();
				} else {
					jsMsgBox($("#file_rcpy"), "error", Message.template.required("업로드파일"));
				}
			}
			, null
		);
	}
	
	// 관계기업판정
	function dpRcpyJdgmnt() {
		jsMsgBox(null,'confirm','판정 하시겠습니까?',
			function(){
				$("#df_method_nm").val("processRcpyJdgmnt");
				$("#dataForm").submit();
			}
			, null
		);
	}
	
	// 기준년도 조회
	function fn_getJdgmntSummary() {
		$("#df_method_nm").val("");
		$("#dataForm").submit();
	}
</script>
</head>
<body>
<!--//content-->
<div id="wrap">
	<div class="wrap_inn">
		<div class="contents">
			<!--// 타이틀 영역 -->
			<h2>관계기업판정처리</h2>
			<!-- 타이틀 영역 //-->
			
			<form id="dataForm" name="dataForm" action="<c:url value='${svcUrl}'/>" method="post" enctype="multipart/form-data">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				
				<input type="hidden" id="ad_stdyy" name="ad_stdyy" value="${stdyy}" />
				<input type="hidden" id="ad_upFile" value="" />
				<input type="hidden" id="ad_searchGubun" name="ad_searchGubun" value="Y" />
				
				<!--// 검색 영역 -->
				<div class="search_top">
					<table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
						<caption>조회 조건</caption>
						<colgroup>
							<col width="15%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">자료기준년도</th>
								<td>
									<select name="ad_searchStdyy" title="기준년도" id="ad_searchStdyy" style="width:100px">
										<c:if test="${fn:length(stdyyList) == 0 }"><option value="">자료없음</option></c:if>
										<c:forEach items="${stdyyList}" var="year" varStatus="status">
                                        	<option value="${year.stdyy}"<c:if test="${year.stdyy eq param.ad_searchStdyy or (param.ad_searchStdyy eq '' and status.index eq 0)}"> selected="selected"</c:if>>${year.stdyy}년</option>
										</c:forEach>
									</select>
									<p class="btn_src_zone"><a href="#none" class="btn_search" onclick="fn_getJdgmntSummary();">조회</a></p>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- 검색 영역 //-->
				
				<!--// 수집 영역 -->
				<div class="block">
					<h3>데이터업로드</h3>
					
					<table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
						<caption>데이터업로드</caption>
						<colgroup>
							<col width="15%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">파일선택</th>
								<td>
									<p>
										<div class="btn_inner fr" style="margin-top:3px;">
											<p class="btn_src_zone"><a href="#" class="btn_refresh" onclick="doUploadRcpy();">등록</a></p>
										</div>
										<input type="file" name="file_rcpy" id="file_rcpy" style="width:500px;" title="파일선택" />
									</p>
								</td>
							</tr>
							<tr>
								<th scope="row">적용업종선택</th>
								<td>
									<input type="radio" name="ad_induty" id="ad_induty_NICE" value="NICE" checked="checked" />
									<label for="ad_induty_NICE">NICE</label>
									<input type="radio" name="ad_induty" id="ad_induty_KED" value="KED" class="mgl50" />
									<label for="ad_induty_KED">KED</label>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<div class="block" style="margin-top:50px;">
					<h3>수집데이터수</h3>
					
					<table cellpadding="0" cellspacing="0" class="table_basic" summary="기업수,최종수집일자,최상위수,상위수,하위수,최하위수">
						<caption>수집데이터수</caption>
						<colgroup>
							<col width="10%" />
							<col width="10%" />
							<col width="20%" />
							<col width="20%" />
							<col width="20%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">대상기업수</th>
								<td>${rcpyJdgmntColctInfo.trgetEntrprsCo}</td>
								<th scope="row">업로드일자</th>
								<td>${rcpyJdgmntColctInfo.uploadDe}</td>
								<th scope="row">적용일자</th>
								<td>${rcpyJdgmntColctInfo.applcDe}</td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- 수집 영역 //-->
				
				<!--// 판정 영역 -->
				<div class="block" style="margin-top:50px;">
					<h3>관계기업판정</h3>
					
					<div class="list_zone">
						<table cellpadding="0" cellspacing="0" border="0" class="list" summary="대상기업수,판정기업수,최종판정일자,판정처리">
							<caption>관계기업판정</caption>
							<colgroup>
								<col width="25%" />
								<col width="25%" />
								<col width="25%" />
								<col width="*" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">기업수</th>
									<th scope="col">관계기업판정수</th>
									<th scope="col">관계기업판정일자</th>
									<th scope="col">판정처리</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="tac">
										<a href="#none" onclick="moveRcpyJdgmntList();">${rcpyJdgmntManageInfo.entrprsCo}</a>
									</td>
									<td class="tac line_l">${rcpyJdgmntManageInfo.rcpyJdgmntCo}</td>
									<td class="tac line_l">${rcpyJdgmntManageInfo.rcpyJdgmntDe}</td>
									<td class="tac line_l">
										<div class="btn_inner">
											<a href="#none" class="btn_in_gray" onclick="dpRcpyJdgmnt();"><span>관계기업판정</span></a>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- 판정 영역 //-->
			</form>
		</div>
	</div>
</div>
<!--content//-->

<div style="display:none">
	<div class="loading" id="loading">
		<div class="inner">
			<div class="box">
		    	<p>관계기업 자료를 업로드하고 있습니다. 잠시만 기다려주세요.<br />
					시스템 상태에 따라 최대 10분 정도 소요될 수 있습니다.</p>
				<span><img src="/images/etc/loading_bar.gif" width="323" height="39" alt="loading" /></span>
			</div>
		</div>
	</div>
</div>
</body>
</html>