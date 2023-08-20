<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset=UTF-8">
<title>기업정보</title>
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
					Util.isEmpty($('#start_dt').val()) ? new Date() : $('#start_dt').val()			// 시작 데이트를 현재 날짜 값을 이용 하니면 선택된 날짜 값을 이용
			);
			
			$('#end_dt').datepicker(
					'setDate',
					Util.isEmpty($('#end_dt').val()) ? new Date() : $('#end_dt').val()				// 종료 데이트를 현재 날짜 값을 이용 하니면 선택된 날짜 값을 이용
			);
			
			$('#start_dt').datepicker('option', 'onClose', function (selectedDate){
				var dateChecker = new Date(selectedDate);
				if(dateChecker.getTime() == dateChecker.getTime()){ 								//날짜 유효 확인 체크
					if(selectedDate < $('#end_dt').val()){											//시작 날짜가 종료 날짜보다 더 이전이면 OK
						prevStartDt = selectedDate;
						return;
					} 
					$("#start_dt").val(prevStartDt);												//시작 날짜 종료 날짜 후 경고
					jsMsgBox(null,'info',"시작일이 종료일보다 이후가 될수 없습니다.");
	  				return;
				}
				$("#start_dt").val(prevStartDt);													//날짜 유호 경고
				jsMsgBox(null,'info',"시작일이 유효하지 않습니다");
  				return;
		    });
			
			$('#end_dt').datepicker('option', 'onClose', function (selectedDate){
				var dateChecker = new Date(selectedDate);
				if(dateChecker.getTime() == dateChecker.getTime()){									//날짜 유효 확인 체크
					if(selectedDate > $('#start_dt').val()){
						prevEndDt = selectedDate;
						return;
					} 
					$("#end_dt").val(prevEndDt);													//종료 날짜 시작 날짜 전 경고
					jsMsgBox(null,'info',"종료일이 시작일보다 이전이 될수 없습니다.");
	  				return;
				}
				$("#end_dt").val(prevEndDt);														//날짜 유호 경고
				jsMsgBox(null,'info',"종료일이 유효하지 않습니다");
  				return;
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
			<h2 class="menu_title">달력 컴포넌트 (시작/종료일을 선택하는 달력)</h2>
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
						<strong> ~ </strong>
						<input type="text" id="end_dt" name="end_dt" class="datepicker" style="width:70px;"/>
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
              <strong> ~ </strong>
              <input type="text" id="end_dt" name="end_dt" class="datepicker" style="width:70px;"/>
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
    	
    	function initDatepicker() {
    		$('.datepicker').datepicker({
    			showOn : 'button',
    			buttonImage : '<c:url value='/images/acm/icon_cal.png' />',
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
    		
    		$('#end_dt').datepicker(
    			'setDate',
    			Util.isEmpty($('#end_dt').val()) ? new Date() : $('#end_dt').val()
    		);
    		
    		$('#start_dt').datepicker('option', 'onClose', function (selectedDate){
    			$('#end_dt').datepicker('option', 'minDate', selectedDate);
    		});
    		
    		$('#end_dt').datepicker('option', 'onClose', function (selectedDate){
    			$('#start_dt').datepicker('option', 'maxDate', selectedDate);
    		});
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