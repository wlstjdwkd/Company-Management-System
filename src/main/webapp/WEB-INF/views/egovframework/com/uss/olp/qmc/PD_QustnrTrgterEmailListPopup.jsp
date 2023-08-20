<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>메일발송설정</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,colorboxAdmin,blockUI" />
<ap:jsTag type="tech" items="acm,msg,util,etc" />

<script type="text/javascript">

	$(document).ready(function(){
	<c:if test="${resultMsg != null}">
		jsMsgBox(null, "info", "${resultMsg}");
	</c:if>

		$("input[name=chk-all]").click(function(){
			var isChecked = this.checked;
			$("input:checkbox[name=chk_email_addr]").each(function() {
				this.checked = isChecked;
			});
		});
	});

	/***
	 * 목록검색
	 */
	function fn_egov_search_QustnrTrgterEmailPopup(){
		var form = document.dataForm;
	
		form.action = "<c:url value='${svcUrl}' />";
		form.df_curr_page.value = 1;
		form.df_method_nm.value="qustnrTrgterEmailListPopup";
		form.submit();
	}
	
	/***
	 * 발송정보등록
	 */
	function registTrgterEmail(qestnrId, qestnrTmplatId){
		var form = document.dataForm;

		form.action = "<c:url value='${svcUrl}' />";
		form.df_curr_page.value = 1;
		form.df_method_nm.value="registTrgterEmail";
		form.submit();
	}
	
	/**
	 * 메일삭제
	 */
	function delTrgterEmail(){

		if ($("input:checkbox[name='chk_email_addr']").is(":checked") == false) {
			jsMsgBox(null, "error", Message.template.wrongDelTarget("이메일"));
			return;
		}
		
		jsMsgBox(null, 'confirm','<spring:message code="fail.common.custom" arguments="선택한 메일주소를" /> <spring:message code="confirm.common.delete" />',
				function(){
					$("#df_method_nm").val("deleteQustnrTrgterEmail");
					$("#dataForm").submit();
				});	
	}
	
	/**
	 * 선택메일발송
	 */
	function rqstCheckedEmail(){

		if ($("input:checkbox[name='chk_email_addr']").is(":checked") == false) {
			jsMsgBox(null, "error", Message.template.noSetTarget("이메일"));
			return;
		}
		
		jsMsgBox(null, 'confirm', Message.template.confirmSend("선택한 이메일"),
				function(){
					$("#df_method_nm").val("rqstCheckedQustnrTrgterEmail");
					$.blockUI();
					$("#dataForm").submit();
				});	
	}
	
	/**
	 * 전체메일발송
	 */
	function rqstAllEmail(){

		jsMsgBox(null, 'confirm', Message.template.confirmSend("전체 이메일"),
				function(){
					$("#df_method_nm").val("rqstAllQustnrTrgterEmail");
					$.blockUI();
					$("#dataForm").submit();
				});	
	}
	
</script>
</head>
<body>
<body>
<div id="self_dgs">
	<div class="pop_q_con">
		<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<ap:include page="param/pagingParam.jsp" />
		<!-- LNB 출력 방지 -->
		<input type="hidden" id="no_lnb" value="true" />
		
		<input type="hidden" id="qestnrId" name="qestnrId" value="${qestnrId }" />
		<input type="hidden" id="qestnrTmplatId" name="qestnrTmplatId" value="${qestnrTmplatId }" />

	    <!--// 검색 조건 -->
	    <div class="search_top">
	        <table cellpadding="0" cellspacing="0" class="table_search" summary="검색" >
	            <caption>
	            검색
	            </caption>
	            <colgroup>
	            <col width="100%" />
	            </colgroup>
	            <tr>
	                <td class="only"><select name="searchCondition" title="선택하세요" id="" style="width:150px">
									<option value="">전체분류</option>
									<option value='1' <c:if test="${param.searchCondition == '1'}">selected</c:if>>확인서발급기업</option>
									<option value='2' <c:if test="${param.searchCondition == '2'}">selected</c:if>>직접입력</option>
	                    </select>
	                    <p class="btn_src_zone"><a href="#none" class="btn_search" onclick="fn_egov_search_QustnrTrgterEmailPopup();">검색</a></p></td>
	            </tr>
	        </table>
	    </div>
	    <div class="block">
	        <!--// 리스트 -->
	        <ap:pagerParam addJsRowParam="null, 'qustnrTrgterEmailListPopup'" />		        	
	        <div class="list_zone">
	            <table cellspacing="0" border="0" summary="목록">
	                <caption>
	                목록
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
	                        <th scope="col"><input type="checkbox" id="chk-all" name="chk-all" value="Y" /></th>
	                        <th scope="col">번호</th>
	                        <th scope="col">분류</th>
	                        <th scope="col">이메일</th>
	                        <th scope="col">등록일시</th>
	                        <th scope="col">발송일시</th>
	                    </tr>
	                </thead>
	                <tbody>
					<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
					<c:if test="${fn:length(resultList) == 0}">
						<tr>
							<td colspan="6">
								<c:if test="${param.searchCondition == null or param.searchCondition == '' }"><spring:message code="info.nodata.msg" /></c:if>
								<c:if test="${param.searchCondition != null and param.searchCondition != '' }"><spring:message code="info.noresult.msg" /></c:if>
							</td>
						</tr>
					</c:if>
					<%-- 데이터를 화면에 출력해준다 --%>
					<c:forEach items="${resultList}" var="resultInfo" varStatus="status">
	                    <tr>
	                        <td><input type="checkbox" name="chk_email_addr" id="chk_${status.count }" value="${resultInfo.trgterEmail }" /></td>
	                        <td class="tac">${pager.indexNo - (status.index)}</td>
	                        <td class="tal">${resultInfo.trgterClNm }</td>
	                        <td class="tal">${resultInfo.trgterEmail }</td>
	                        <td>${resultInfo.registTime }</td>
	                        <td>${resultInfo.sndngTime }</td>
	                    </tr>
					</c:forEach>
                </tbody>
            </table>
        </div>
        <!-- 리스트// -->
        <div class="fl mgt10">
        	<a class="btn_page_admin" href="#none" onclick="rqstAllEmail();"><span>전체메일발송</span></a>
        	<a class="btn_page_admin" href="#none" onclick="rqstCheckedEmail();"><span>선택메일발송</span></a>
        </div>
        <div class="btn_page_last">
	        <a class="btn_page_admin" href="#none" onclick="registTrgterEmail('${qestnrId }','${qestnrTmplatId }');"><span>발송정보등록</span></a>
        	<a class="btn_page_admin" href="#none" onclick="delTrgterEmail();"><span>삭제</span></a> 
        </div>
		<ap:pager pager="${pager}" addJsParam="'qustnrTrgterEmailListPopup'"/>
		</form>
	</div>
</div>
<div style="display:none">
	<div class="loading" id="loading">
		<div class="inner">
			<div class="box">
		    	<p >메일 발송을 요청하고 있습니다. 잠시만 기다려주세요.<br />
					시스템 상태에 따라 최대 10분 정도 소요될 수 있습니다.</p>
				<span><img src="/images/etc/loading_bar.gif" width="323" height="39" alt="loading" /></span>
			</div>
		</div>
	</div>
</div>
</body>
</html>