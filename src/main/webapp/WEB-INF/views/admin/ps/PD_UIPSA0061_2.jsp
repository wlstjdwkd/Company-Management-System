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
<ap:jsTag type="web" items="jquery,colorboxAdmin,cookie,flot,form,jqGrid,notice,selectbox,timer,tools,ui,validate,blockUI" />
<ap:jsTag type="tech" items="util,acm,ps,etc" />
<script type="text/javascript">
$(document).ready(function(){
	var form = document.all;
	
	var searchCondition = '${searchCondition}';
	var from_sel_target_year = '${from_sel_target_year}';
	var to_sel_target_year = '${to_sel_target_year}';
	
	// 로딩 화면
	$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);	
	
	/* //그리드 리사이즈
	$(window).bind('resize', function() {
		resizeJqGridWidth(); 
	}).trigger('resize');
	
	//추이 그리드
	$.ajax({
        url:'PGPS0061.do?df_method_nm=processGetGridSttusMain&searchCondition='+searchCondition
        		+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
        dataType: "json",
        type: 'POST',
        async: false,
        success: function (result) {

            if (result) {

                if (!result.Error) {

                    var colD = result.value.data;
                    var colM = result.value.colModelList;
                    var colN = result.value.columnNames;
                    
                    var ColModel1 = [];
                     for (var j = 0; j<result.value.colModelList.length; j++) {
                    	 ColModel1.push({name:result.value.colModelList[j],index:result.value.colModelList[j], width:100});
                      }
                    
                    $("#grid_sttus_list3").jqGrid('GridUnload');
                    
                  //기업현황 그리드
                	$("#grid_sttus_list3").jqGrid({
                		url:'PGPS0061.do?df_method_nm=processGetGridSttusList&searchCondition='+searchCondition
	                		+'&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
                		datatype: "json",
                		colNames:colN,
                	   	colModel:ColModel1,
                        height: "auto",
                	    rowNum:"${entprsSize}",
                	    gridview: true,
                	    loadonce: false,
                		jsonReader: {
                			repeatitems : false
                		},
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
	
	$.ajax({
        url:'PGPS0061.do?df_method_nm=getClFctr1&from_sel_target_year='+from_sel_target_year+'&to_sel_target_year='+to_sel_target_year,
        dataType: "html",        
        async: true,
        type: 'POST',
        success: function (response) {
        	try {
        		var html = $.parseHTML(response);
        		
        		$.each(html, function(i, el) {            		
           			if(el.nodeType==1){
           		  		var clazz = el.getAttribute('class');		           		  		
           		  		if(clazz == "add_table"){		           		  			
           		  			$("#div_data_table1").html(el);
           		  			//if(!$("#empty_resultList")) {		           		  				
           		  				Util.rowSpan($("#tblStatics1"), [1]);
           		  			//}
           		  			return;
           		  		}
           		  	}
        		});
        		
            } catch (e) {
                if(response != null) {
                	jsSysErrorBox(response);
                } else {
                    jsSysErrorBox(e);
                }
                return;
            }
        }
	});	//ajax end
	
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
	        <table cellpadding="0" cellspacing="0" class="table_search" summary="주요지표 현황 챠트" >
	            <caption>
	            주요지표 현황 표
	            </caption>
	            <colgroup>
	            <col width="15%" />
	            <col width="25%" />
	            <col width="15%" />
	            <col width="25%" />
	            </colgroup>
	            <tr>
	                <th scope="row">기업군</th>
	                <td>일반기업</td>
	                <th scope="row">년도</th>
	                <td>${from_sel_target_year} ~ ${to_sel_target_year}</td>
	            </tr>
	        </table>
	    </div>
	    <!-- // 리스트영역-->
	    <div class="block">	                
	        
	        <div class="list_zone" id="div_data_table1">
            </div>
	        
	        <br />
	        
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

<!-- loading -->
<div style="display:none">
	<div class="loading" id="loading">
		<div class="inner">
			<div class="box">
		    	<p>
		    		<span id="load_msg">조회중입니다.</span>
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