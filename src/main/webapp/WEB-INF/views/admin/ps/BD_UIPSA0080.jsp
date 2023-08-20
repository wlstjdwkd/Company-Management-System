<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,multifile,blockUI,colorboxAdmin,mask,selectbox" />
<ap:jsTag type="tech" items="acm,msg,util,etc" />
<script type="text/javascript">
<c:if test="${resultMsg != null}">
$(function(){
	jsMsgBox(null, "info", "${resultMsg}");
});
</c:if>

$(document).ready(function(){
	
	// 로딩 화면
	$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);	
	
	
 	 $("#dataForm").validate({  
			rules : {
			tarket_year: "required",
			}
			});
 	$("#selectstdYy").numericOptions({from:2002,to:${inparam.curr_year},sort:"desc"});
});

function btn_relPossessionmgr_get_list() {
	var form = document.dataForm;
	form.df_method_nm.value = "";
	form.submit();
}

function batch_insert_relPossession() {
	// 임시테이블에 업로드
	$("#df_method_nm").val("updaterelPossession");
	
	$("#dataForm").ajaxSubmit({
		url: "PGPS0080.do",
		dataType: "text",
		async :true,
		contentType: "multipart/form-data",
		beforeSubmit: function(){
		},
		success: function(response) {
			try{
				var form = document.dataForm;
				response = $.parseJSON(response)
				if(eval(response.result)){
					form.tarket_year.value = response.Key;
					jsMsgBox($(this),'info',response.message,btn_relPossessionmgr_get_list);
				}else{
        			jsMsgBox($(this),'info',response.message);
        		}
			}catch (e) {
                if(response != null) {
                	jsSysErrorBox(response);
                } else {
                    jsSysErrorBox(e);
                }
                return;
            }
		}
		
	})
}

function insert_data(){
	// 유효성 검사 필요 (필수입력값 체크, 데이터 타입 체크)
	
	// 확인 후 저장 
	jsMsgBox(null,'confirm',"업로드 할 데이터가 맞는지 확인 해주세요. 정말로 업로드 하시겠습니까? ", 
			function(){
			// 업로드
				$("#df_method_nm").val("updateData");
				$("#dataForm").submit();
			});
	}
</script>
</head>
<body>
	<form name="dataForm" id="dataForm"
		action="<c:url value='${svcUrl}' />" method="post"
		enctype="multipart/form-data">		
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<!--//content-->
		<div id="wrap">
			<div class="wrap_inn">
				<div class="contents">
					<!--// 타이틀 영역 -->
					<h2 class="menu_title">엑셀 업로드 테스트</h2>
					<div class="search_top2">
						<span class="mgt30">※ 업로드 시 첨부된 엑셀파일의 양식을 이용하세요 ( <a
							href="/download/기업직간접소유현황_20140301.xlsx">기업직간접소유현황_20140301.xls</a>)
						</span>
						<h4 class="mgt10">데이터 업로드</h4>
						<table cellpadding="0" cellspacing="0" class="table_search2"
							summary="수집조건">
							<caption>수집조건</caption>
							<colgroup>
								<col width="15%">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">대상년도</th>
									<td><select name="selectstdYy" title="선택" id="selectstdYy" style="width:130px">
									</select></td>
									<input type="hidden" name="tarket_year" id="tarket_year"/>
									<th scope="row">파일선택</th>
									<td>
										<input name="file_relPossession" type="file"
										id="file_relPossession" style="width: 300px;" title="파일첨부" />
										<p class="btn_src_zone">
											<a href="#" class="btn_refresh"
												onclick="batch_insert_relPossession();">등록</a>
										</p>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<c:if test="${fn:length(resultList) > 0}">
	                    <div class="list_zone">
	                        <table cellspacing="0" border="0" summary="목록">
	                            <caption>
	                            리스트
	                            </caption>
	                            <colgroup>
	                           <col width="*" />
					           <col width="*" />
					           <col width="*" />
					           <col width="*" />
					           <col width="*" />
					           <col width="*" />
					           <col width="*" />
					           <col width="*" />
					           <col width="*" />
					           <col width="*" />
					           <col width="*" />
					           <col width="*" />
					           <col width="*" />
	                            </colgroup>
	                            <thead>
	                                <tr>
				                    <th scope="col">기준년</th>
				                    <th scope="col">법인등록번호</th>
				                    <th scope="col">사업자번호</th>
				                    <th scope="col">기업명</th>
				                    <th scope="col">직접_법인번호</th>
				                    <th scope="col">직접_기업명</th>
				                    <th scope="col">직접_지분율</th>
				                    <th scope="col">간접_법인번호1</th>
				                    <th scope="col">간접_기업명1</th>
				                    <th scope="col">간접_지분율1</th>
	                                </tr>
	                            </thead>
	                            <tbody>
									  	<c:forEach items="${resultList}" var="info" varStatus="status">    
									  	 <tr>   
	 								  	 	<td><input name="stdYy" id="stdYy" value="${info.stdYy}" /></td>
	 								  	 	<td class="tac"><input name="jurirNo" id="jurirNo" value="${info.jurirNo}" /></td>
	 								  	 	<td><input name="bizrNo" id="bizrNo" value="${info.bizrNo}" /></td>
	 								  	 	<td class="tal"><input name="entrprsNm" id="entrprsNm" value="${info.entrprsNm}" /></td>
									  	 	<td><input name="drposjurirNo" id="drposjurirNo" value="${info.drposjurirNo}" /></td>
									  	 	<td class="tal"><input name="drposentrprsNm" id="drposentrprsNm" value="${info.drposentrprsNm}"" /></td>
									  	 	<td class="tar"><input name="drposqotaRt" id="drposqotaRt" value="${info.drposqotaRt}" /></td>
									  	 	<td><input name="ndrposjurirNo1" id="ndrposjurirNo1" value="${info.ndrposjurirNo1}" /></td>
									  	 	<td class="tal"><input name="ndrposentrprsNm1" id="ndrposentrprsNm1" value="${info.ndrposentrprsNm1}" /></td>
									  	 	<td class="tar"><input name="ndrposqotaRt1" id="ndrposqotaRt1" value="${info.ndrposqotaRt1}" /></td>
											</tr>
										</c:forEach>
								</tbody>
	                        </table>
	                    </div>
						<p class="btn_src_zone">
							<a href="#" class="btn_refresh"
								onclick="insert_data();">확인</a>
						</p>
	                 </c:if>
				</div>
			</div>
		</div>
	</form>
	
	 <!--content//-->
        <!-- loading -->
		<div style="display:none">
			<div class="loading" id="loading">
				<div class="inner">
					<div class="box">
				    	<p>
				    		<span id="load_msg"> 기업직간접수유현 정보를 등록하고 있습니다. 잠시만 기다려주십시오.</span>
				    		<br />
							시스템 상태에 따라 최대 10분 정도 소요될 수 있습니다.
						</p>
						<span><img src="<c:url value="/images/etc/loading_bar.gif" />" width="323" height="39" alt="loading" /></span>
					</div>
				</div>
			</div>
		</div>
</body>
</html>
