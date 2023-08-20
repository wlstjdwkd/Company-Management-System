<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset=UTF-8">
<title>정보</title>
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}"/>
<ap:globalConst/>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,blockUI,msgBoxAdmin,colorboxAdmin,mask,jqGrid,css,selectbox"/>
<ap:jsTag type="tech" items="acm,msg,util,etc"/>
<style type="text/css">

	.tab_content{
		display: none;
	}
	.tab_content.on{
		display: inherit;
	}
	
</style>
<script type='text/javascript'>
	
	<c:if test="${resultMsg != null}">
		$(function(){
			jsMsgBox(null, "info", "${resultMsg}");
		});
	</c:if>

	$(document).ready(function() {
		
		// 로딩 화면
		$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
		
		$('ul.tabs li').click(function(){
    		$('ul.tabs li').removeClass('on');
    		$(this).addClass('on');
    		
    		var tab_id = $(this).attr('data_tab');
    		
    		$('.tab_content').removeClass('on');
    		$('#'+tab_id).addClass('on');
    	});
		
	});
	
	function btn_relPossessionmgr_get_list() {

		var form = document.dataForm;
		form.df_method_nm.value="";
		form.submit();
	}
	
	function batch_insert_relPossession(){
		
		if(!$("#file_relPossession").valid())
		{
			return false;
		}
		
		$("#df_method_nm").val("updaterelPossession");
		// 폼 데이터
		$("#dataForm").ajaxSubmit({
	        url      : "PGIM0070.do",
	        dataType : "text",            
	        async    : true,
	        contentType: "multipart/form-data",            
	        success  : function(response) {
	        	try {
	        		response = $.parseJSON(response)
	        		if(eval(response.result)){
	        			jsMsgBox($(this),'info',response.message,btn_relPossessionmgr_get_list);
	        		}else{
	        			jsMsgBox($(this),'info',response.message);
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
	
	function findrelPossessionlist(){
		$.colorbox({
	        title : "기업직간접소유현황",
	        href  : "PGIM0070.do?df_method_nm=findrelPossessionList",
	        width : "80%",
	        height: "80%",     
	        iframe : true,
	        overlayClose : false,
	        escKey : false,            
	    });
	}
	
	function getErrorMsg(){
		jsMsgBox(null
			,'confirm'
			,Message.msg.confirmSaveTemp
			,function(){
				$.ajax({
			        url      : "PGIM0070.do",
			        type     : "POST",
			        dataType : "text",
			        data     : { df_method_nm: "findErrMsg" },
			        async    : false,                
			        success  : function(response) {
			        	try {
			        			response = $.parseJSON(response)
			        			jsMsgBox($(this),'info',response.message)
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
	
	function deleterelPossessionlist(){
		jsMsgBox(null,'confirm',"정말로삭제하시겠습니까?",
		function(){
			$.ajax({
		        url      : "PGIM0070.do",
		        type     : "POST",
		        dataType : "text",
		        data     : { df_method_nm: "deleterelPossessionlist" },
		        async    : false,                
		        success  : function(response) {
		        	try {
		        		response = $.parseJSON(response)
		        		if(eval(response.result)){
		        			jsMsgBox($(this),'info',response.message,btn_relPossessionmgr_get_list);
		        		}else{
		               		jsMsgBox($(this),'info',response.message,btn_relPossessionmgr_get_list);
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
	}
	
</script>
</head>
<body>
<div id="wrap">
	<div class="wrap_inn">
		<div class="contents">
			<!-- 타이틀 영역 -->
			<h2 class="menu_title">엑셀업로드</h2>
			<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}'/>" method="post" enctype="multipart/form-data">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<div class="search_top2">
					<span class="mgt30">※ 업로드 시 첨부된 엑셀파일의 양식을 이용하세요. (<a href="/download/기업직간접소유현황_20140301.xlsx">기업직간접소유현황_20140301.xls</a>)</span>
					<table cellpadding="0" cellspacing="0" class="table_search" summary="파일업로드">
						<caption>파일업로드</caption>
						<colgroup>
							<col width="10%"/>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">파일 업로드</th>
								<td>
									<input name="file_relPossession" type="file" id="file_relPossession" style="width:400px;" title="파일첨부"/>
									<p class="btn_src_zone"><a href="#" class="btn_refresh" onclick="batch_insert_relPossession();">등록</a></p>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="block2">
					<!--// 리스트 -->
                    <div class="list_zone">
                    	<table cellspacing="0" border="0" summary="수집작업목록">
                    		<caption>리스트</caption>
                    		<colgroup>
	                            <col width="*"/>
	                            <col width="*"/>
	                            <col width="*"/>
	                            <col width="*"/>
	                            <col width="*"/>
	                            <col width="*"/>
                            </colgroup>
                            <thead>
                            	<tr>
                            		<th scope="col">기준년도</th>
                            		<th scope="col">DB load 성공건수</th>
                            		<th scope="col">DB load 실패건수</th>
                            		<th scope="col">상태</th>
                            		<th scope="col">등록일시(수행시간)</th>
                            		<th scope="col">실행</th>
                            	</tr>
                            </thead>
                            <tbody>
                            	<c:choose>
                            		<c:when test="${fn:length(relPossessionMgrList) > 0}">
                            			<c:forEach items="${relPossessionMgrList}" var="info" varStatus="status">
                            				<tr>
                            					<td><a href="#" onclick="findrelPossessionlist('${info.stdYy}');">${info.stdYy}</a></td>
                            					<td class="tar"><fmt:formatNumber value = "${info.successCnt}" pattern = "#,##0"/></td>
                            					<td class="tar"><fmt:formatNumber value = "${info.failCnt}" pattern = "#,##0"/></td>
                            					<td>
                            						<c:if test="${info.proSatus == '오류'}"><a href="#" onclick="getErrorMsg('${info.stdYy}','${info.stdMt}');"></c:if>
                            						${info.proSatus}<c:if test="${info.proSatus == '오류'}"></a></c:if>
                            					</td>
                            					<td>${info.runTm}<c:if test="${info.diffMin != '' || info.diffMin ne null}">( ${info.diffMin}분  ${info.diffSec}초 )</c:if></td>
                            					<td>
                            						<div class="btn_inner">
                            							<c:if test="${info.proSatus != '시작'}">
                            								<a href="#" class="btn_in_gray" onclick="deleterelPossessionlist('${info.stdYy}');"><span>삭제</span></a>
                            							</c:if>
                            						</div>
                            					</td>
                            				</tr>
                            			</c:forEach>
                            		</c:when>
                            		<c:otherwise>
                            			<tr>
                            				<td colspan="6" style="text-align:center;"> 해당년도 등록내역이 없습니다.</td>
                            			</tr>
                            		</c:otherwise>
                            	</c:choose>
                            </tbody>
                    	</table>
                    </div>
				</div>
			</form>
			<div class="tabwrap" style="margin:70px;">
				<div class="tab">
					<ul class="tabs">
                        <li class="on" data_tab="tab_1">jsp</li>
                        <li data_tab="tab_2">js</li>
                        <li data_tab="tab_3">java</li>
                    </ul>
                   	<div id="tab_1" class="tab_content on">
                   	<c:set var="string1" value='
                   	
<body>
<div id="wrap">
    <div class="wrap_inn">
        <div class="contents">
            <!-- 타이틀 영역 -->
            <h2 class="menu_title">엑셀업로드</h2>
            <form name="dataForm" id="dataForm" action="<c:url value="${svcUrl}"/>" method="post" enctype="multipart/form-data">
                <div class="search_top2">
                    <span class="mgt30">※ 업로드 시 첨부된 엑셀파일의 양식을 이용하세요.
                    (<a href="/download/기업직간접소유현황_20140301.xlsx">기업직간접소유현황_20140301.xls</a>)</span>
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="파일업로드">
                        <caption>파일업로드</caption>
                        <colgroup>
                            <col width="10%"/>
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">파일 업로드</th>
                                <td>
                                    <input name="file_relPossession" type="file" id="file_relPossession" style="width:400px;" title="파일첨부"/>
                                    <p class="btn_src_zone"><a href="#" class="btn_refresh" onclick="batch_insert_relPossession();">등록</a></p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="block2">
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="수집작업목록">
                            <caption>리스트</caption>
                            <colgroup>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준년도</th>
                                    <th scope="col">DB load 성공건수</th>
                                    <th scope="col">DB load 실패건수</th>
                                    <th scope="col">상태</th>
                                    <th scope="col">등록일시(수행시간)</th>
                                    <th scope="col">실행</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
                   	'/>
                   	<pre>${fn:escapeXml(string1)}</pre>
                   	</div>
                   	<div id="tab_2" class="tab_content">
                   	<c:set var="string2" value='
                   	
<script type="text/javascript">

    <c:if test="${resultMsg != null}">
        $(function(){
            jsMsgBox(null, "info", "${resultMsg}");
        });
    </c:if>
    
    function btn_relPossessionmgr_get_list() {
    
        var form = document.dataForm;
        form.df_method_nm.value="";
        form.submit();
    }
    
    function batch_insert_relPossession(){
    
        if(!$("#file_relPossession").valid())
        {
            return false;
        }
        
        $("#df_method_nm").val("updaterelPossession");
        // 폼 데이터
        $("#dataForm").ajaxSubmit({
            url      : "PGIM0070.do",
            dataType : "text",
            async    : true,
            contentType: "multipart/form-data",
            beforeSubmit : function(){
            },
            success  : function(response) {
                try {
                    response = $.parseJSON(response)
                    if(eval(response.result)){
                        jsMsgBox($(this),"info",response.message,btn_relPossessionmgr_get_list);
                    }else{
                        jsMsgBox($(this),"info",response.message);
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
    
    function findrelPossessionlist(){
    
        $.colorbox({
            title : "기업직간접소유현황",
            href  : "PGIM0070.do?df_method_nm=findrelPossessionList",
            width : "80%",
            height: "80%",
            iframe : true,
            overlayClose : false,
            escKey : false,
        });
    }
    
</script>
                   	'/>
                   	<pre>${fn:escapeXml(string2)}</pre>
                   	</div>
                   	<div id="tab_3" class="tab_content">
                   	<c:set var="string3" value='

public ModelAndView updaterelPossession(Map<?, ?> rqstMap) throws Exception {
	
	HashMap param = new HashMap();
	Map<String,Object> paramdata = null;
	ModelAndView mv = new ModelAndView();
	List<Map<String,Object>> resultList = null;
	
	String[] columNames = 
		{
			"기준년도","법인번호","사업자번호","업체명","비고","직접소유법인번호","직접소유 기업명","직접소유지분율","직접소유비고",
			"간접소유법인번호1","간접소유 기업명1","간접소유지분율1","간접소유비고1",
			"간접소유 법인번호2","간접소유 기업명2","간접소유지분율2","간접소유비고2"
	};
	
	String[] columparam = 
		{
			"stdYy","jurirNo","bizrNo","entrprsNm","Rm","drposjurirNo","drposentrprsNm","drposqotaRt","drposRm",
			"ndrposjurirNo1","ndrposentrprsNm1","ndrposqotaRt1","ndrposRm1",
			"ndrposjurirNo2","ndrposentrprsNm2","ndrposqotaRt2","ndrposRm2"
	};
	
	Date startTime = new Date ( );
	
	String tarket_year = "2021";
	MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)rqstMap.get(GlobalConst.RQST_MULTIPART);
	
	if( Validate.isEmpty(tarket_year) || Validate.isEmpty(mptRequest) )
		return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
	
	List<MultipartFile> multipartFiles = mptRequest.getFiles("file_relPossession");
	
	if(Validate.isEmpty(multipartFiles))
		return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
	
	if(multipartFiles.get(0).isEmpty())
		return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
	
	List<FileVO> fileList = new ArrayList<FileVO>();
	
	fileList = UploadHelper.upload(multipartFiles, "relpossessiontemp");
	
	System.out.println(fileList.get(0).getFileByteSize());
	
	if(fileList.size() != 1)
		 return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"Upload 파일에 에러가 있습니다!\"}");
	
	resultList = BizUtil.paserExcelFile(columNames,columparam,fileList.get(0).getFile(),0);
	
	param.put("stdYy", tarket_year);
	
	pgim0070Mapper.deletrelPossessionMgr(param);
	pgim0070Mapper.deletrelPossessionList(param);
	
	Date endTime = new Date ( );
	
	param.put("rowCnt", resultList.size());
	param.put("startDate", startTime);
	param.put("endDate", endTime);
	pgim0070Mapper.insertrelPossessionMgr(param);
	
	for( int i = 0; i < resultList.size() ; i++ ) {
		paramdata = resultList.get(i);
		pgim0070Mapper.intsertrelPossession((HashMap)paramdata);
	}
	
	return ResponseUtil.responseText(mv, "{\"result\":true,\"value\":null,\"message\":\"기업직간접소유현황 등록이 정상처리되었습니다.\"}");
}
                   	
                   	'/>
                   	<pre>${fn:escapeXml(string3)}</pre>
                   	</div>
				</div>
			</div>
		</div>
	</div>
</div>
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
				<span><img src="<c:url value="/images/etc/loading_bar.gif"/>" width="323" height="39" alt="loading"/></span>
			</div>
		</div>
	</div>
</div>
</body>
</html>