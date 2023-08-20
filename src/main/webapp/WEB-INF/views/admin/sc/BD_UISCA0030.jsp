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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>정보</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask" />
<ap:jsTag type="tech" items="acm,msg,util,ms" />

<script type="text/javascript">

//첨부파일 다운로드
function downAttFile(fileSeq){
	jsFiledownload("/PGCM0040.do","df_method_nm=updateFileDownBySeq&seq="+fileSeq);
	alert(fileSeq);
}

	$().ready(function() {
		
        // 검색
		$("#btn_search").click(function(){
			$("#df_curr_page").val("1");
			$("#df_method_nm").val("");
			$("#dataForm").attr('action', '/PGCMUSER0100.do').submit();
		});
        
		$("#ad_search_word").keyup(function(e) {
			if(e.keyCode == 13) {
				$("#df_curr_page").val("1");
				$("#df_method_nm").val("");
				$("#dataForm").attr('action', '/PGCMUSER0100.do').submit();
			}
		});
		
		// 담당자변경요청 리스트 삭제(체크박스 전체)
		$("#btn_del").click(function(){
			var form = document.dataForm;
			
			jsMsgBox(null
				,'confirm'				
				,Message.msg.confirmDelete
				,function(){
					$("#df_method_nm").val("deleteProcessStep");
					
					// 폼 데이터
			    	$("#dataForm").ajaxSubmit({
			            url      : "PGCMUSER0100.do",
			            dataType : "json",            
			            async    : false,
			            beforeSubmit : function(){
			            },            
			            success  : function(response) {
			            	try {			            		
		            			if(eval(response)){
		                			jsMsgBox(null,'info',Message.msg.successDelete,function(){
		                				$("#df_method_nm").val("index");
				            			$("#dataForm").attr('action', '/PGCMUSER0100.do').submit();
		                			});
		                		}else{
		                			jsMsgBox(null,'info',Message.msg.failDelete);
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
		});
		
		//최상단 체크박스 클릭
	    $("#checkall").click(function(){
	        //클릭되었으면
	        if($("#checkall").prop("checked")){
	            //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 true로 정의
	            $("input[name=chk]").prop("checked",true);
	            //클릭이 안되있으면
	        }else{
	            //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 false로 정의
	            $("input[name=chk]").prop("checked",false);
	        }
	    })
		
	});
	
	// 담당자정보 변경 적용(one)
	function updateProcessStepOnlyOne(sn/* , jurirno */, mbnum, email){
		/* $("#ad_phone_num").val(mbnum.replace(/-/gi, ""));
		$("#ad_user_email").val(email); */
		
		// 휴대전화, 이메일 중복 확인
		$.ajax({
			url : "PGCMLOGIO0040.do",
			type : "POST",
			dataType : "json",
			data : {
				df_method_nm : "checkDuplEntUserInfo",
				"ad_phone_num" : mbnum.replace(/-/gi, ""),
				"ad_user_email" : email
			},
			async : false,
			success : function(response) {
				try {
					
					if (response.result) {
					jsMsgBox(null
							,'confirm'
							,"변경된 담당자는 복구되지 않습니다.<br />담당자를 변경 하시겠습니까?"
							,function(){
								$("#SN").val(sn);
								/* $("#JURIRNO").val(jurirno); */
								$("#df_method_nm").val("updateProcessStepOnlyOne");

								// 폼 데이터
						    	$("#dataForm").ajaxSubmit({
						            url      : "PGCMUSER0100.do",
						            dataType : "json",            
						            async    : false,
						            beforeSubmit : function(){
						            },            
						            success  : function(response) {
						            	try {			            		
					            			if(eval(response)){
					                			jsMsgBox(null,'info',Message.msg.successUpdateCharger,function(){
					                				$("#df_method_nm").val("index");
							            			$("#dataForm").attr('action', '/PGCMUSER0100.do').submit();
					                			});
					                		}else{
					                			jsMsgBox(null,'info',Message.msg.failUpdateCharger);
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
					
					} else {
						if (response.value.reason == 'duplPhonNum') {
							// duplPhonNum
							jsMsgBox($("#ad_phon_first"),'info',Message.template.existInfo('휴대전화번호'));
						} else {
							// duplEmail
							jsMsgBox($("#ad_user_email"),'info',Message.template.existInfo('이메일'));
						}
						return;
					}
					
				} catch (e) {
					if (response != null) {
						jsSysErrorBox(response);
					} else {
						jsSysErrorBox(e);
					}
					return;
				}
			}
		});
	}
	
	// 기업명 변경 적용(One)
	function updateProcessEntrprsNmOne(sn) {
		try {
			jsMsgBox(null
					,'confirm'
					,"변경된 기업명은 복구되지 않습니다.<br />기업명을 변경 하시겠습니까?"
					,function() {
						$("#SN").val(sn);
						$("#df_method_nm").val("updateProcessStepOnlyOne");
						
						// 폼 데이터
						$("#dataForm").ajaxSubmit({
							url      : "PGCMUSER0100.do",
							dataType : "json",
							async    : false,
							beforeSubmit : function() {},
							success  : function(response) {
								try {
									if(eval(response)) {
										jsMsgBox(null,'info',Message.msg.successUpdateEntrprsNm,function() {
											$("#df_method_nm").val("index");
											$("#dataForm").attr('action', '/PGCMUSER0100.do').submit();
					   					});
									} else {
										jsMsgBox(null,'info',Message.msg.failUpdateEntrprsNm);
									}
								} catch(e) {
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
		} catch (e) {
			if (response != null) {
				jsSysErrorBox(response);
			} else {
				jsSysErrorBox(e);
			}
			return;
		}
	}
	
	// 첨부파일 업로드
	function uploadfile() {
		$("#df_method_nm").val("insertFile");
		$("#upForm").submit(); 		
	}
</script>
</head>
<body>
	<form name="upForm" id="upForm" action="PGSC0030.do" enctype="multipart/form-data" method="post">
		<input type="hidden" name="df_method_nm" value="insertFile" />
		<br><br><input type="file" name="file" value="찾아보기" />
		<div id="multiFilesListDiv" class="regist-file"></div>
		<a href="#" class="btn_page_admin" onclick="uploadfile()">업로드</a>
	</form>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
	<ap:include page="param/defaultParam.jsp" />
	<ap:include page="param/dispParam.jsp" />
	<ap:include page="param/pagingParam.jsp" />
	
	<input type="hidden" id="SN" name="SN" value="" />
	
	<!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">정보변경신청</h2>
                <!-- 타이틀 영역 //-->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="정보변경신청 조회 조건">
                        <caption>
                       		 정보변경신청 조회 조건
                        </caption>
                        <colgroup>
                        <col width="*">
                        <col width="15%">
                        <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <td>
                                    <select name="ad_search_type" title="검색구분" id="ad_search_type" style="width:160px">
                                    	<option value="">선택하세요</option>
                                        <option value="0" <c:if test="${param.ad_search_type == '0' }">selected="selected"</c:if >>기업명</option>>
                                        <option value="6" <c:if test="${param.ad_search_type == '6' }">selected="selected"</c:if >>담당자이름</option>
                                    </select>
                                    <input name="ad_search_word" id="ad_search_word" title="검색어를 입력하세요." placeholder="검색어를 입력하세요." type="text" style="width:430px" value="${param.ad_search_word }" />
                                </td>
                                <th scope="row">적용구분</th>
                            	<td>
                            		<select name="ad_result_gubun" title="적용구분" id="ad_result_gubun" style="width:160px">
                                    	<option value="">선택하세요</option>
                                        <option value="N" <c:if test="${param.ad_result_gubun == 'N' }">selected="selected"</c:if >>대기</option>
                                        <option value="Y" <c:if test="${param.ad_result_gubun == 'Y' }">selected="selected"</c:if >>완료</option>
                                    </select>
                                    <p class="btn_src_zone"><a href="#" class="btn_search" id="btn_search">검색</a></p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- 등록// -->
                <!-- // 리스트영역-->
               <div class="block">
               		<!-- 
					<div class="btn_page_total">
	                	<a class="btn_page_admin" href="#" id="btn_excel"><span>엑셀다운로드</span></a> 
                	</div>
                	// -->
                    <!--// 리스트 -->
                    <div class="list_zone">
                    		<ap:pagerParam />
                        <table cellspacing="0" border="0" summary="메뉴명 프로그램명 메뉴레벨 출력유형 출력여부 사이트구분 사용여부 리스트">
                            <caption>
                          		  메뉴관리리스트
                            </caption>
                            <colgroup>
                                <col width="3%">
                                <!-- <col width="5%">	// -->
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                            </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col"><input type="checkbox" id="checkall" value="1"></th>
                                        <!--  <th scope="col">번호</th>	// -->
                                        <th scope="col">법인등록번호</th>
                                        <th scope="col">구분</th>
                                        <th scope="col">기업명</th>
                                        <th scope="col">담당자이름</th>
                                        <!-- 
                                        <th scope="col">부서</th>
                                        //  -->
                                        <th scope="col">직위</th>
                                        <th scope="col">전화번호</th>
                                        <th scope="col">휴대전화번호</th>
                                        <th scope="col">이메일</th>
                                        <th scope="col">사업자등록증</th>
                                        <th scope="col">재직증명서</th>
                                        <th scope="col">신청일자</th>
                                        <th scope="col">적용구분</th>
                                        <th scope="col">적용</th>
                                    </tr>
                                </thead>
                                <tbody>                                    
                                    <c:forEach items="${userList }" var="userlist" varStatus="status">
                                    	<tr>
	                                        <td><input type="checkbox" name="chk" id="chk" value="${userlist.SN }"></td>
	                                        <!--  <td class="tac">${pager.indexNo - status.index}</td>	// -->
	                                        <td class="tal">${userlist.JURIRNO }</td>
	                                        <c:if test="${userlist.SE == '1' }"><td class="tac">담당자</td></c:if ><c:if test="${userlist.SE == '2' }"><td class="tac">기업명</td></c:if >
	                                        <td class="tal">${userlist.ENTRPRS_NM }</td>
	                                        <td class="tac">${userlist.CHARGER_NM }</td>
	                                        <!-- 
	                                        <td class="tal"><a href="#" onclick="fn_user_view('${userlist.USER_NO}')" >${userlist.ENTRPRS_NM }</a></td>
	                                        <td class="tac"><a href="#" onclick="fn_user_view('${userlist.USER_NO}')" >${userlist.CHARGER_NM }</a></td>
	                                        <td>${userlist.CHARGER_DEPT }</td>
	                                        //  -->
	                                        <td>${userlist.OFCPS }</td>
	                                        <td>${userlist.TELNO2 }</td>
	                                        <td>${userlist.MBTLNUM }</td>
	                                        <td class="tal">${userlist.EMAIL }</td>
	                                        <td><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="downAttFile('${userlist.FILE_SEQ}')"><span>다운받기</span></a></div></td>
	                                        <td><div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="downAttFile('${userlist.FILE_SEQ2}')"><span>다운받기</span></a></div></td>
	                                        <td>${userlist.RGSDE }</td>
	                                        <c:if test="${userlist.APPLC_AT == 'Y' }"><td class="chtd1">완료</td></c:if ><c:if test="${userlist.APPLC_AT == 'N' }"><td class="chtd2">대기</td></c:if >
	                                        <td>
	                                        	<c:if test="${userlist.SE == '1' }">
	                                        		<div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="updateProcessStepOnlyOne('${userlist.SN }'<%-- , '${userlist.JURIRNO }' --%>,'${userlist.MBTLNUM }','${userlist.EMAIL }');"><span>적용</span></a></div>
	                                        	</c:if>
	                                        	<c:if test="${userlist.SE == '2' }">
	                                        		<div class="btn_inner"><a href="#none" class="btn_in_gray" onclick="updateProcessEntrprsNmOne('${userlist.SN }');"><span>적용</span></a></div>
	                                        	</c:if>
	                                        </td>
	                                    </tr>
	                                    <%-- <input type="hidden" id="SN" name="SN" value="${userlist.SN }" />
	                                    <input type="hidden" id="JURIRNO" name="JURIRNO" value="${userlist.JURIRNO }" />
                                    	<input type="hidden" id="ENTRPRS_NM" name="ENTRPRS_NM" value="${userlist.ENTRPRS_NM }" />
                                    	<input type="hidden" id="CHARGER_NM" name="CHARGER_NM" value="${userlist.CHARGER_NM }" />
                                    	<input type="hidden" id="EMAIL" name="EMAIL" value="${userlist.EMAIL }" /> --%>
                                    </c:forEach>
                                </tbody>
                            </table>
                      </div>
                    </div> 
                   	
                    <!-- 리스트// -->
                    <div class="btn_page_last">
                    	<!-- <a class="btn_page_admin" href="#none" id="btn_reg"><span>적용</span></a> // -->
                    	<a class="btn_page_admin" href="#none" id="btn_del"><span>삭제</span></a>
                    </div>
                    <div class="mgt10"></div>
                    <!--// paginate -->
                    <div class="paginate"> <ap:pager pager="${pager}" /> </div>
                    <!-- paginate //-->
                    
                </div>
                <!--리스트영역 //-->
            </div>
            <!--content//-->
        </div>        
	</form>   
</body>
</html>