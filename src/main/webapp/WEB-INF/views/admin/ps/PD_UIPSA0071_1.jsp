<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,colorboxAdmin,cookie,flot,form,jqGrid,notice,selectbox,timer,tools,ui,validate" />
<ap:jsTag type="tech" items="util,acm,ps" />
<script type="text/javascript">
$(document).ready(function(){
	var form = document.all;
	
	var searchCondition = '${searchCondition}';
	var from_sel_target_year = '${from_sel_target_year}';
	var to_sel_target_year = '${to_sel_target_year}';
	
	/* //그리드 리사이즈
	$(window).bind('resize', function() {
		resizeJqGridWidth(); 
	}).trigger('resize');
	
	//기업위상 추이
	$.ajax({
        url:'PGPS0070.do?df_method_nm=processGetGridSttusList2Main&searchCondition='+searchCondition
		+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
        dataType: "json",
        type: 'POST',
        async: false,
        success: function (result) {

            if (result) {

                if (!result.Error) {

                    var colD = result.value.data;
                    var colN = result.value.columnNames;
                    
                    var ColModel1 = [];
                     for (var j = 0; j<result.value.colModelList.length; j++) {
                    	 ColModel1.push({name:result.value.colModelList[j],index:result.value.colModelList[j], width:100});
                      }
                     
                    $("#grid_sttus_list3").jqGrid('GridUnload');
                    
                  //기업현황 그리드
                	$("#grid_sttus_list3").jqGrid({
                		url:'PGPS0070.do?df_method_nm=processGetGridSttusList2List&searchCondition='+searchCondition
                				+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
                		datatype: "json",
                		colNames:colN,
                	   	colModel:ColModel1,
                        height: "auto",
                        rowNum:'${rowNum}',
                	   	//rowList:[10,20,30],
                	   	//pager: '#grid_sttus_pager',
                	   	sortname: 'CODE_NM',
                	    //viewrecords: true,
                	    gridview: true,
                	    sortorder: "desc",
                	    loadonce: false,
                		jsonReader: {
                			repeatitems : false
                		},
                		//caption: "추이",
                		height: '100%',
                	});
                }
            }
        },
        error: function (xhr, ajaxOptions, thrownError) {
            if (xhr && thrownError) {
                alert('Status: ' + xhr.status + ' Error: ' + thrownError);
            }
        }
	}); */
});

//jqGrid 리사이징
function resizeJqGridWidth(){
	$.timer(100, function (timer) {
		var grid_id = "grid_sttus_list3";
		var div_id = "baseGridWidth";		 	
	 	$('#' + grid_id).setGridWidth($('#' + div_id).width()-10 , true);
		timer.stop();
	});
}
</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="POST">
<div id="self_dgs">
	<div class="pop_q_con">
	    <!--// 검색 조건 -->
	    <div class="search_top">
	        <table cellpadding="0" cellspacing="0" class="table_search" summary="기업위상 현황" >
	            <caption>
	            기업위상 현황
	            </caption>
	            <colgroup>
	            <col width="15%" />
	            <col width="25%" />
	            <col width="15%" />
	            <col width="25%" />
	            </colgroup>
	            <tr>
	                <th scope="row">기업군</th>
	                <td>전체기업</td>
	                <th scope="row">년도</th>
	                <td>${from_sel_target_year} ~ ${to_sel_target_year}</td>
	            </tr>
	        </table>
	    </div>
	    <!-- // 리스트영역-->
	    <div class="block">
	        
	        <div class="list_zone">
                 <table cellspacing="0" border="0" summary="기업통계" class="list" id="tblStatics">
                     <caption>
                      리스트
                      </caption>
                      <colgroup>		                        	
                   		<col width="*" />
                       	<col width="*" />
                      	<c:forEach items="${seachedYears }">
                      	<col width="*" />
                      	</c:forEach>                      
                      </colgroup>
                      <thead>		                                
                          <tr>
                              <th scope="col">구분</th>		                                    
                              <th scope="col">구분</th>
                              <c:forEach items="${seachedYears }" var="year">
                              <th scope="col">${year }</th>
                              </c:forEach>		                                    		                                    		                                                                     
                          </tr>
                      </thead>
                      <tbody>
                      	<c:forEach items="${entprsList }" var="resultInfo">
                      	<tr>
                      		<td>${resultInfo.CODE_NM }</td>
                      		<td>${resultInfo.GUBUN }</td>
                      		<c:forEach items="${seachedYears }" var="year">
                      		<td>${resultInfo[year] }</td>
                      		</c:forEach>
                      	</tr>
                      	</c:forEach>		                            	                                
                      </tbody>
            	</table>
       		</div>
	        
	        <div class="btn_page_last"> 
	        	<a class="btn_page_admin" href="javascript:window.print();"><span>인쇄</span></a> 
	        	<a class="btn_page_admin" href="#" onclick="parent.$.fn.colorbox.close();"><span>닫기</span></a>
	        </div>
	        <br><br>
	    </div>
	    <!--리스트영역 //-->
	</div>
	<!--content//-->
	</div>
</div>
</form>
</body>
</html>