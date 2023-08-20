<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset=UTF-8">
<title>정보</title>
<c:set var="svcUrl" value=" ${requestScope[SVC_URL_NAME]}"/>
<ap:globalConst/>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin,mask,jqGrid,css"/>
<ap:jsTag type="tech" items="acm,msg,util"/>
<ap:include page="param/dispParam.jsp"/>
<style type="text/css">
	.tab_content{
		display: none;
	}
	.tab_content.on{
		display: inherit;
	}
</style>
<script type='text/javascript'>
	$(document).ready(function() {
		
		initDatepicker();
		
		function initDatepicker() {
			$('.datepicker').datepicker({
				showOtherMonths: true,
				showOn : 'both',
				buttonImage : '<c:url value="/images/acm/icon_cal.png"/>',
				buttonImageOnly : true,
				changeYear : true,
				changeMonth : true,
				yearRange : '2000:2030'
			});
			
			$('.datepicker').mask('0000-00-00');
			
			$('#start_dt').datepicker(
					'setDate',
					Util.isEmpty($('#start_dt').val()) ? new Date() : $('#start_dt').val()
			);
		
			$('#start_dt').datepicker('option', 'onClose', function (selectedDate){
		        $('#end_dt').datepicker('option', 'minDate', selectedDate);
		    });
		}
        
        $('ul.tabs li').click(function(){
    		$('ul.tabs li').removeClass('on');
    		$(this).addClass('on');
    		var tab_id = $(this).attr('data_tab');
    		$('.tab_content').removeClass('on');
    		$('#'+tab_id).addClass('on');
    	});
	});
	
</script>
</head>
<body>
<div id="wrap">
	<div class="wrap_inn">
		<div class="contents">
			<!-- 타이틀 영역 -->
			<h2 class="menu_title">달력 컴포넌트 (날짜 하나 입력)</h2>
			<!-- 날짜 영역 -->
			<table cellpadding="0" cellspacing="0" class="table_search" summary="달력">
				<caption>달력</caption>
				<colgroup>
					<col width="10%"/>
				</colgroup>
				<tr>
					<th scope="row">날짜</th>
					<td>
						<input type="text" id="start_dt" name="start_dt" class="datepicker" style="width:70px;"/>
					</td>
				</tr>
			</table>
			<div class="tabwrap" style="margin:70px;">
				<div class="tab">
					<ul class="tabs">
                        <li class="on" data_tab="tab_1">jsp</li>
                        <li data_tab="tab_2">js</li>
                    </ul>
                   	<div id="tab_1" class="tab_content on">
                   	<c:set var="string1" value='
                   	
<body>
<div id="wrap">
   <div class="wrap_inn">
      <div class="contents">
        <!-- 타이틀 영역 -->
        <h2 class="menu_title">달력</h2>
        <!-- 날짜 영역 -->
        <table cellpadding="0" cellspacing="0" class="table_search" summary="달력">
          <caption>달력</caption>
          <colgroup>
            <col width="10%"/>
          </colgroup>
          <tr>
            <th scope="row">날짜</th>
            <td>
              <input type="text" id="start_dt" name="start_dt" class="datepicker" style="width:70px;"/>
            </td>
          </tr>
        </table>
      </div>
   </div>
</div>
</body>
                   	'/>
                   	<pre>${fn:escapeXml(string1)}</pre>
                   	</div>
                   	<div id="tab_2" class="tab_content">
                   	<c:set var="string2" value="
                   	
<script type='text/javascript'>
    $(document).ready(function() {
                   		
    	initDatepicker();
    											//	https://api.jqueryui.com/datepicker/
    	function initDatepicker() {
    		$('.datepicker').datepicker({
    			showOn : 'button',						//버튼을 눌러서 출력
    			buttonImage : '<c:url value='/images/acm/icon_cal.png' />',	//이미지 링크
    			buttonImageOnly : true,
    			changeYear : true,
    			changeMonth : true,
    			yearRange : '2000:2030' 					//2000-2030 까지만 선택 가능
    		});
    		$('.datepicker').mask('0000-00-00'); 					// '0000-00-00'를 숨기기
    		
    		$('#start_dt').datepicker(
    			'setDate',
    			Util.isEmpty($('#start_dt').val()) ? new Date() : $('#start_dt').val()
    		);
    		
    	}
    });
</script>
                   	"/>
                   	<pre>${fn:escapeXml(string2)}</pre>
                   	</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>