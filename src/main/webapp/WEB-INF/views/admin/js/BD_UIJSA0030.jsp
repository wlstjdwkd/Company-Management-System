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
<title>판정처리</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,multifile,blockUI, colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util,etc" />

<script type="text/javaScript">

	$(document).ready(function(){
		
	<c:if test="${resultMsg != null}">
		$(function(){
			jsMsgBox(null, "info", "${resultMsg}");
		});
	</c:if>
		
	    $("#hpeDcsnFile").MultiFile({
			accept: 'xls|xlsx',
			max: '1',	
			afterFileAppend: function(){$("#ad_upfile").val("Y");},
			afterFileRemove: function(){$("#ad_upfile").val("");},
			STRING: {
				remove: '<img src="<c:url value="/images/ucm/icon_del.png" />" alt="x" style="vertical-align:baseline;" />',
				denied: Message.msg.fildUploadDenied,  		//확장자 제한 문구
				duplicate: Message.msg.fildUploadDuplicate	//중복 파일 문구
			}
		});
	});

	// 검색/조회
	function fn_getJdgmntSummary() {
		if ($("#ad_stdyy").val() == "") return;
		
		$("#df_method_nm").val("");
		$("#dataForm").submit();
	}
	
	// 기업 시스템판정자료 다운로드
	function fn_downloadFile() {
		$("#df_method_nm").val("excelSystemJdgmnt");
		$("#dataForm").submit();
	}
	
	// 시스템판정 처리
	function fn_procSystemJdgmnt(type) {
		$("#ad_gubun").val(type);
		$("#df_method_nm").val("processSystemJdgmnt");
		jsMsgBox(null,'confirm','<spring:message code="confirm.Jdgmnt.jdgprocess" />',
				function(){
					$("#ad_contat").val('Y');
					$.blockUI({message:$("#systemJdgmnt")});
					$("#dataForm").submit();
					},
				function(){
						$("#ad_contat").val('N');
						$.blockUI({message:$("#systemJdgmnt")});
						$("#dataForm").submit();
			});
		}

	// 기업 확정판정자료 처리
	function fn_uploadFile() {
		if($("#ad_upfile").val() == "Y") {
			$("#df_method_nm").val("processDcsnUploadFile");
			$.blockUI();
			$("#dataForm").submit();
		}
		else {
			jsMsgBox($("#hpeDcsnFile"), "error", Message.template.required("확정자료 업로드파일"));
		}
	}

	// 기업 확정판정자료 삭제
	function fn_deleteData() {
		$.colorbox({
			open  : true,
			title : "관리자 비밀번호 입력",
			href  : "/PGJS0030.do?df_method_nm=adminPwdForm&ad_dataType=deleteData",
			width : "600", height : "400",
			iframe: true,
			onClosed:function(){
				if($("#ad_pwdcheck").val() == "Y") {
					 jsMsgBox(null, 'confirm','<spring:message code="confirm.common.delete" />', function(){
					$("#df_method_nm").val("processDeleteData");
					$.blockUI({message:$("#initialize")});
					$("#dataForm").submit();
					}); 
					 $("#ad_pwdcheck").val("N"); 
				}
			}
		});
	}
	
	// 기업 확정판정자료 초기화
	function fn_backupData() {
		$.colorbox({
			open  : true,
			title : "관리자 비밀번호 입력",
			href  : "/PGJS0030.do?df_method_nm=adminPwdForm&ad_dataType=backupData",
			width : "600", height : "400",
			iframe: true,
			onClosed:function(){
				if($("#ad_backupcheck").val() == "Y") {
					 jsMsgBox(null, 'confirm','확정판정 기초데이터를 백업하시겠습니까?', function(){
					$("#df_method_nm").val("callBackData");
					$("#dataForm").submit();
					 });
					 $("#ad_backupcheck").val("N");
				}
			}
		});
	}
	
	// 판정상세 페이지로 이동
	function fn_moveToHpeEntrprsList() {
		$("#df_method_nm").val("selectEntprsInfoList");
		$("#ad_searchGubun").val("S");
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
                <h2>시스템판정처리</h2>
                <!-- 타이틀 영역 //-->
				<form id="dataForm" name="dataForm" action="<c:url value='${svcUrl}'/>" method="post" enctype="multipart/form-data">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				
				<input type="hidden" id="ad_stdyy" name="ad_stdyy" value="${stdyy }" />
				<input type="hidden" id="ad_searchGubun" name="ad_searchGubun" value="" />
				<input type="hidden" id="ad_gubun" name="ad_gubun" value="" /><!-- 기업/후보/가젤/대기업 구분 -->
				<input type="hidden" id="ad_contat" name="ad_contat" value="" /><!-- 확인서발급 기업 통계 반영여부 -->
				<input type="hidden" id="ad_upfile" value="" />
				<input type="hidden" id="ad_pwdcheck" value="N" />
				<input type="hidden" id="ad_backupcheck" value="N" />
				
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
                        <caption>
                        조회 조건
                        </caption>
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
                                	<c:forEach items="${stdyyList }" var="year" varStatus="status">
                                        <option value="${year.stdyy }"<c:if test="${year.stdyy eq param.ad_searchStdyy or (param.ad_searchStdyy eq '' and status.index eq 0) }"> selected="selected"</c:if>>${year.stdyy }년</option>
                                	</c:forEach>
                                    </select>
                                    <p class="btn_src_zone"><a href="#none" class="btn_search" onclick="fn_getJdgmntSummary();">조회</a></p></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="block">
                    <table cellpadding="0" cellspacing="0" class="table_basic" summary="기업수,최종수집일자">
                        <caption>
                        기업수,최종수집일자
                        </caption>
                        <colgroup>
                        <col width="20%" />
                        <col width="30%" />
                        <col width="20%" />
                        <col width="*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">기업수</th>
                                <td>${jdgmntEntprsCount }</td>
                                <th scope="row">최종수집일자</th>
                                <td>${lastDataCollectDate }</td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- 리스트// -->
                </div>
                <div class="block2">
                    <h3>시스템판정</h3>
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="목록" class="list">
                            <caption>
                            시스템판정요약
                            </caption>
                            <colgroup>
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기업수</th>
                                    <th scope="col">일반기업</th>
                                    <th scope="col" class="disable">관계기업</th>
                                    <th scope="col">후보기업</th>
                                    <th scope="col">가젤형기업</th>
                                    <th scope="col" <c:if test="${stdyy >= 2014}">class="disable"</c:if>>대기업군</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th class="tar" scope="col">기업수</th>
                                    <td class="tac">
                                    	<c:if test="${systemJdgmntManage.gnrlHpeCo > 0 }"><a href="#none" onclick="fn_downloadFile();">${systemJdgmntManage.gnrlHpeCo }</a></c:if>
                                    	<c:if test="${systemJdgmntManage.gnrlHpeCo <= 0 }">0</c:if>
                                    </td>
                                    <td>0</td>
                                    <td>${systemJdgmntManage.cndcyEntrprsCo }</td>
                                    <td>${systemJdgmntManage.gzlcCo }</td>
                                    <td>
                                    	<c:if test="${stdyy < 2014}">${systemJdgmntManage.ltrsCo }</c:if>
                                    	<c:if test="${stdyy >= 2014}">0</c:if>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="tar" scope="col">최종판정일자</th>
                                    <td class="tac<c:if test="${systemJdgmntManage.warnHpe == 'Y' }"> warn</c:if>">${systemJdgmntManage.hpeJdgmntDe }</td>
                                    <td>-</td>
                                    <td<c:if test="${systemJdgmntManage.warnCndcy == 'Y' }"> class="warn"</c:if>>${systemJdgmntManage.cndcyEntrprsJdgmntDe }</td>
                                    <td<c:if test="${systemJdgmntManage.warnGzlc == 'Y' }"> class="warn"</c:if>>${systemJdgmntManage.gzlcJdgmntDe }</td>
                                    <td<c:if test="${stdyy < 2014 && systemJdgmntManage.warnLtrs == 'Y' }"> class="warn"</c:if>>
                                    	<c:if test="${stdyy < 2014}">${systemJdgmntManage.ltrsJdgmntDe }</c:if>
                                    	<c:if test="${stdyy >= 2014}">-</c:if>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="tar" scope="col">시스템판정</th>
                                    <td class="tac"><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="fn_procSystemJdgmnt('HPE')"><span>판정</span></a></div></td>
                                    <td>미지원</td>
                                    <td><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="fn_procSystemJdgmnt('HPEC')"><span>판정</span></a></div></td>
                                    <td><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="fn_procSystemJdgmnt('GZLC')"><span>판정</span></a></div></td>
                                    <td>
                                    	<c:if test="${stdyy < 2014}"><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="fn_procSystemJdgmnt('LTRS')"><span>판정</span></a></div></c:if>
                                    	<c:if test="${stdyy >= 2014}">미지원</c:if>
                                    </td>
                                </tr>
                            </tbody>
                        </table>                        
                    </div>
                    <!-- 리스트// -->
                    <p class="mgt10">※ 분기별로 누적된 자료를 대상으로 시스템판정 처리를 수행합니다.</p>
                        <div class="btn_page_middle"><a class="btn_page_admin" href="#none" onclick="fn_moveToHpeEntrprsList();"><span>개별판정</span></a> </div>
                </div>
                <!--리스트영역 //-->
                <div class="block">
                    <h3>확정판정</h3>
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="목록" class="list">
                            <caption>
                            확정판정요약
                            </caption>
                            <colgroup>
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="400px" />
                            <col width="*" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기업군</th>
                                    <th scope="col">확정 일시</th>
                                    <th scope="col">기업수</th>
                                    <th scope="col">확정자료업로드</th>
                                    <th scope="col">초기화</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="tac line_l">기업<br />(관계기업포함)</td>
                                    <td class="tac">${dcsnJdgmntManage.hpeJdgmntDe }</td>
                                    <td><a href="#none" onclick="fn_moveToHpeEntrprsList();">${dcsnJdgmntManage.gnrlHpeCo }</a></td>
                                    <td class="tal"><a href="/download/일반기업 확정용 샘플파일 (Excel).xlsx">※ 일반기업 확정용 샘플파일 다운로드 (Excel)</a>
                                    	<div class="mgt5"></div>
                                        <p>
                                        	<div class="btn_inner fr" style="margin-top:3px;">
                                        	<a href="#none" class="btn_in_gray" onclick="fn_uploadFile();"><span>확정업로드</span></a>
                                        	</div>
                                        	<input type="file" name="hpeDcsnFile" id="hpeDcsnFile" style="width:295px;" title="파일선택" />
                                        </p>
                                    </td>
                                    <td>
                                    	<div class="btn_inner">
                                    		<a href="#none" class="btn_in_gray" onclick="fn_deleteData();"><span>판정자료삭제</span></a>
                                    	<a href="#none" class="btn_in_gray" onclick="fn_backupData();"><span>기초데이터 백업</span></a>
                                    	</div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                </div>
				</form>
            </div>
        </div>
        <!--content//-->
    </div>
	<div style="display:none">
		<div class="loading" id="systemJdgmnt">
			<div class="inner">
				<div class="box">
			    	<p >시스템판정을 처리하고 있습니다. 잠시만 기다려주세요.<br />
						시스템 상태에 따라 최대 10분 정도 소요될 수 있습니다.</p>
					<span><img src="/images/etc/loading_bar.gif" width="323" height="39" alt="loading" /></span>
				</div>
			</div>
		</div>
	</div>
	<div style="display:none">
		<div class="loading" id="loading">
			<div class="inner">
				<div class="box">
			    	<p >확정판정 자료를 처리하고 있습니다. 잠시만 기다려주세요.<br />
						시스템 상태에 따라 최대 10분 정도 소요될 수 있습니다.</p>
					<span><img src="/images/etc/loading_bar.gif" width="323" height="39" alt="loading" /></span>
				</div>
			</div>
		</div>
	</div>
	<div style="display:none">
		<div class="loading" id="initialize">
			<div class="inner">
				<div class="box">
			    	<p >확정판정 자료를 초기화하고 있습니다. 잠시만 기다려주세요.<br />
						시스템 상태에 따라 최대 10분 정도 소요될 수 있습니다.</p>
					<span><img src="/images/etc/loading_bar.gif" width="323" height="39" alt="loading" /></span>
				</div>
			</div>
		</div>
	</div>
</body>
</html>