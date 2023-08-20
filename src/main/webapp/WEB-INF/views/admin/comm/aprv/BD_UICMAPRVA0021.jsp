<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>석유관리원 환급시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask,blockUI" />
<ap:jsTag type="tech" items="acm,msg,util,etc,mainn" />
<script type="text/javascript">

	$(document).ready(function(){
		
		var mode = "${mode}";
		
		//대체결재 시작일
		$('#altrtvConfmBgnDe').datepicker({
            showOn : 'button',
            defaultDate : null,
            buttonImage : '<c:url value="images/acm/icon_cal.png" />',
            buttonImageOnly : true,
            changeYear: true,
            changeMonth: true,
            yearRange: "1920:+1"
        });
		
		if(mode == "regist"){
			var today = new Date();
			$("#altrtvConfmBgnDe").datepicker('setDate' , today);
		}

		//대체결재 종료일
		$('#altrtvConfmEndDe').datepicker({
            showOn : 'button',
            defaultDate : null,
            buttonImage : '<c:url value="images/acm/icon_cal.png" />',
            buttonImageOnly : true,
            changeYear : true,
            changeMonth : true,
            yearRange : "1920:+1"
        });
		
		if(mode == "regist"){
			var today = new Date();
			$("#altrtvConfmEndDe").datepicker('setDate' , today);
		}
		
		//대체결재자 검색
		$("#btn_search").on('click',function(){
			$.colorbox({
				title : "대체결재자 검색",
				href : "<c:url value='/PGMP0020.do?df_method_nm=altrtvSearch' />",
				width : "800",
				height : "500",
				overlayClose : false,
				escKey : true,
				iframe : true,
				scrolling : false
			});
		});
		
	});
	
	//목록
	function btn_list() {
		var form = document.dataForm;
		form.action = "/PGMP0020.do";
		form.df_method_nm.value = "";
		form.submit();
	}
	
	//등록
	function btn_insert() {
		
		jsMsgBox(null, 'confirm', '저장하시겠습니까?',
			function() {
				var form = document.dataForm;
				form.df_method_nm.value = "insertAltrtvInfo";

				$("#dataForm").ajaxSubmit({
	                url : "PGMP0020.do",
	                type : "POST",
	                dataType : "json",
	                async : false,
	                success : function(response) {
	                	try {
	                		if(eval(response.result)) {
	                			jsMsgBox($(this),'info', response.message, btn_list);
	                		} else {
	                			jsMsgBox($(this),'info', response.message);
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
			}
		);
	}
	
	//수정
	function btn_update() {
		
		jsMsgBox(null, 'confirm', '저장하시겠습니까?',
			function() {
				var form = document.dataForm;
				form.df_method_nm.value = "updateAltrtvInfo";

				$("#dataForm").ajaxSubmit({
	                url : "PGMP0020.do",
	                type : "POST",
	                dataType : "json",
	                async : false,
	                success : function(response) {
	                	try {
	                		if(eval(response.result)) {
	                			jsMsgBox($(this),'info', response.message, btn_list);
	                		} else {
	                			jsMsgBox($(this),'info', response.message);
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
			}
		);
	}
	
	//삭제
	function btn_delete() {
		
		var useAt = "${altrtvDetail.useAt}";
		
		if(useAt == "Y") {
			jsMsgBox(null, 'info', '등록된 대체자 정보의 사용유무가 <br/> "N"인 경우 삭제 가능합니다.');
			return;
		}
		
		jsMsgBox(null, 'confirm', '삭제하시겠습니까?',
			function() {
				var form = document.dataForm;
				form.df_method_nm.value = "deleteAltrtvInfo";

				$("#dataForm").ajaxSubmit({
	                url : "PGMP0020.do",
	                type : "POST",
	                dataType : "json",
	                async : false,
	                success : function(response) {
	                	try {
	                		if(eval(response.result)) {
	                			jsMsgBox($(this),'info', response.message, btn_list);
	                		} else {
	                			jsMsgBox($(this),'info', response.message);
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
			}
		);
	}

</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		
		<!-- 이전페이지 값 -->
		<input type="hidden" name="df_curr_page" id="df_curr_page" value="${preParam.df_curr_page}" />
		<input type="hidden" name="df_row_per_page" id="df_row_per_page" value="${preParam.df_row_per_page}" />
		<input type="hidden" name="limitFrom" id="limitFrom" value="${preParam.limitFrom}" />
		<input type="hidden" name="limitTo" id="limitTo" value="${preParam.limitTo}" />
		
		<input type="hidden" id="mode" name="mode" value="${mode}"/>
		<input type="hidden" id="preAltrtvConfmerId" name="preAltrtvConfmerId" value="${altrtvDetail.altrtvConfmerId}"/>
		<input type="hidden" id="preAltrtvConfmBgnDe" name="preAltrtvConfmBgnDe" value="${altrtvDetail.altrtvConfmBgnDe}"/>

		<!-- // content -->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!-- // 타이틀 영역 -->
					<div class="r_sec">
                        <div class="r_top" style="margin-bottom:20px;">
                        	<c:if test="${mode eq 'regist'}"><h2>대체결재자 등록</h2></c:if>
	                		<c:if test="${mode eq 'modify'}"><h2>대체결재자 수정</h2></c:if>
                        </div>
                    </div>
					<!-- 타이틀 영역 // -->
					<div class="sub_title"><h4>대체 결재자 정보</h4></div>
					<div class="block">
						<div class="list_zone">
							<table>
								<caption>대체 결재자 정보</caption>
								<colgroup>
									<col width="10%">
	                                <col width="18%">
	                                <col width="7%">
	                                <col width="15%">
	                                <col width="10%">
	                                <col width="15%">
	                                <col width="10%">
	                                <col width="15%">
	                            </colgroup>
	                            <tbody>
	                            	<tr>
	                            		<td class="td_grey">대체결재자</td>
	                            		<td class="tal">
	                            			<input type="hidden" id="altrtvConfmerId" name="altrtvConfmerId" value="${altrtvDetail.altrtvConfmerId}"/>
	                            			<c:if test="${mode eq 'regist'}">
	                            				<input type="text" class="box_grey" id="altrtvConfmerNm" name="altrtvConfmerNm" value="${altrtvDetail.altrtvConfmerNm}" style="width : 70%" readonly="readonly"/>
	                            				<input type="button" id="btn_search" value="선택"/>
	                            			</c:if>
	                            			<c:if test="${mode eq 'modify'}">
	                            				<input type="text" class="box_grey" id="altrtvConfmerNm" name="altrtvConfmerNm" value="${altrtvDetail.altrtvConfmerNm}" style="width : 90%" readonly="readonly"/>
	                            			</c:if>
	                            		</td>
	                            		<td class="td_grey">부서</td>
										<td class="tal">
											<input type="hidden" id="altrtvConfmerDeptCd" name="altrtvConfmerDeptCd"/>
											<input type="text" class="box_grey" id="altrtvConfmerDeptNm" name="altrtvConfmerDeptNm" value="${altrtvDetail.altrtvConfmerDeptNm}" style="width : 90%" readonly="readonly"/>
										</td>
										<td class="td_grey">대체결재시작일</td>
										<td>
											<input type="text" style="width : 70%" id="altrtvConfmBgnDe" name="altrtvConfmBgnDe" value="${altrtvDetail.altrtvConfmBgnDe}" readonly="readonly"/>
										</td>
										<td class="td_grey">대체결재종료일</td>
										<td><input type="text" style="width : 70%" id="altrtvConfmEndDe" name="altrtvConfmEndDe" value="${altrtvDetail.altrtvConfmEndDe}" readonly="readonly"/></td>
									</tr>
									<tr>
	                            		<td class="td_grey">대체사유</td>
	                            		<td class="tal" colspan="5">
	                            			<textarea style="width : 98%" id="altrtvReason" name="altrtvReason">${altrtvDetail.altrtvReason}</textarea>
	                            		</td>
	                            		<td class="td_grey">사용여부</td>
										<td class="tal">
											<div style="display: inline-block; margin-left: 5px;">
												<input type="radio" id="useAtY" name="useAt" value="Y" <c:if test="${altrtvDetail.useAt == 'Y'}">checked="checked"</c:if> checked="checked"><label for="useAtY"> Y</label>
												<input type="radio" id="useAtN" name="useAt" value="N" <c:if test="${altrtvDetail.useAt == 'N'}">checked="checked"</c:if> style="margin-left: 20px;"><label for="useAtN"> N</label>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="btn_page_last" style="margin-top:20px;">
						<a class="btn_page_admin" href="#none" onclick="btn_list()"><span>취소</span></a>
						<c:if test="${mode eq 'regist'}"><a class="btn_page_admin" href="#none" onclick="btn_insert()"><span>저장</span></a></c:if>
						<c:if test="${mode eq 'modify'}">
							<a class="btn_page_admin" href="#none" onclick="btn_update()"><span>저장</span></a>
							<a class="btn_page_admin" href="#none" onclick="btn_delete()"><span>삭제</span></a>
						</c:if>
					</div>
				</div>
			</div>
		</div>
		<!-- content // -->
	</form>
	<!-- loading -->
	<div style="display:none">
		<div class="loading" id="loading">
			<div class="inner">
				<div class="box">
			    	<p>
			    		<span id="load_msg">진행 중 입니다. 잠시만 기다려주십시오.</span>
			    		<br />시스템 상태에 따라 최대 1분 정도 소요될 수 있습니다.
					</p>
					<span><img src="<c:url value="/images/etc/loading_bar.gif" />" width="323" height="39" alt="loading" /></span>
				</div>
			</div>
		</div>
	</div>
</body>
</html>