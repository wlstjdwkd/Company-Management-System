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
		}
        
        $('ul.tabs li').click(function(){
    		$('ul.tabs li').removeClass('on');
    		$(this).addClass('on');
    		var tab_id = $(this).attr('data_tab');
    		$('.tab_content').removeClass('on');
    		$('#'+tab_id).addClass('on');
    	});    
	});
	
	function onSubmit(){ 																			//조회 버튼이 있고 누를때
		var initStartTime = document.getElementById("start_time");	
		var startDate = document.getElementById("start_dt").value;
		var startTime = initStartTime.options[initStartTime.selectedIndex].text + ":00";
		var completeStart = startDate + " " + startTime;
		console.log("completeStart: ", completeStart);
	} 
	
</script>
</head>
<body>
<div id="wrap">
	<div class="wrap_inn">
		<div class="contents">
			<!-- 타이틀 영역 -->
			<h2 class="menu_title">달력 컴포넌트 (날짜 + 시간 선택하는 달력)</h2>
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
						<select size="1" name = "start_time" id="start_time">
							<option value = 0>00:00</option>
							<option value = 1>00:30</option>
							<option value = 2>01:00</option>
							<option value = 3>01:30</option>
							<option value = 4>02:00</option>
							<option value = 5>02:30</option>
							<option value = 6>03:00</option>
							<option value = 7>03:30</option>
							<option value = 8>04:00</option>
							<option value = 9>04:30</option>
							<option value = 10>05:00</option>
							<option value = 11>05:30</option>
							<option value = 12>06:00</option>
							<option value = 13>06:30</option>
							<option value = 14>07:00</option>
							<option value = 15>07:30</option>
							<option value = 16>08:00</option>
							<option value = 17>08:30</option>
							<option value = 18>09:00</option>
							<option value = 19>09:30</option>
							<option value = 20>10:00</option>
							<option value = 21>10:30</option>
							<option value = 22>11:00</option>
							<option value = 23>11:30</option>
							<option value = 24>12:00</option>
							<option value = 25>12:30</option>
							<option value = 26>13:00</option>
							<option value = 27>13:30</option>
							<option value = 28>14:00</option>
							<option value = 29>14:30</option>
							<option value = 30>15:00</option>
							<option value = 31>15:30</option>
							<option value = 32>16:00</option>
							<option value = 33>16:30</option>
							<option value = 34>17:00</option>
							<option value = 35>17:30</option>
							<option value = 36>18:00</option>
							<option value = 37>18:30</option>
							<option value = 38>19:00</option>
							<option value = 39>19:30</option>
							<option value = 40>20:00</option>
							<option value = 41>20:30</option>
							<option value = 42>21:00</option>
							<option value = 43>21:30</option>
							<option value = 44>22:00</option>
							<option value = 45>22:30</option>
							<option value = 46>23:00</option>
							<option value = 47>23:30</option>
						</select>
					</td>
				</tr>
			</table>
			<div class="btn_page_search">
               <a class="btn_page_admin" href="#none" onclick = "onSubmit();"><span>콘솔 결과 확인</span></a>
            </div>
			<div class="tabwrap" style="margin:70px;">
				<div class="tab">
					<ul class="tabs">
                        <li class="on" data_tab="tab_1">JSP</li>
                        <li data_tab="tab_2">JS</li>
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
              <select size="1" name = "start_time" id="start_time">
              	//더 좋은 방법이 있으면 좋고, 없으면 이 화면을 공통으로 움직여서 include 사용?
				<option value = 0>00:00</option>
				<option value = 1>00:30</option>
				<option value = 2>01:00</option>
				<option value = 3>01:30</option>
				<option value = 4>02:00</option>
				<option value = 5>02:30</option>
				<option value = 6>03:00</option>
				<option value = 7>03:30</option>
				<option value = 8>04:00</option>
				<option value = 9>04:30</option>
				<option value = 10>05:00</option>
				<option value = 11>05:30</option>
				<option value = 12>06:00</option>
				<option value = 13>06:30</option>
				<option value = 14>07:00</option>
				<option value = 15>07:30</option>
				<option value = 16>08:00</option>
				<option value = 17>08:30</option>
				<option value = 18>09:00</option>
				<option value = 19>09:30</option>
				<option value = 20>10:00</option>
				<option value = 21>10:30</option>
				<option value = 22>11:00</option>
				<option value = 23>11:30</option>
				<option value = 24>12:00</option>
				<option value = 25>12:30</option>
				<option value = 26>13:00</option>
				<option value = 27>13:30</option>
				<option value = 28>14:00</option>
				<option value = 29>14:30</option>
				<option value = 30>15:00</option>
				<option value = 31>15:30</option>
				<option value = 32>16:00</option>
				<option value = 33>16:30</option>
				<option value = 34>17:00</option>
				<option value = 35>17:30</option>
				<option value = 36>18:00</option>
				<option value = 37>18:30</option>
				<option value = 38>19:00</option>
				<option value = 39>19:30</option>
				<option value = 40>20:00</option>
				<option value = 41>20:30</option>
				<option value = 42>21:00</option>
				<option value = 43>21:30</option>
				<option value = 44>22:00</option>
				<option value = 45>22:30</option>
				<option value = 46>23:00</option>
				<option value = 47>23:30</option>
			  </select>
            </td>
          </tr>
        </table>
        <div class="btn_page_search">
          <a class="btn_page_admin" href="#none" onclick = "onSubmit();"><span>콘솔 결과 확인</span></a>
        </div>
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
    			showOn : 'button',	//버튼을 눌러서 출력
    			buttonImage : '<c:url value='/images/acm/icon_cal.png' />',	//이미지 링크
    			buttonImageOnly : true,
    			changeYear : true,
    			changeMonth : true,
    			yearRange : '2000:2030' 					//2000-2030 까지만 선택 가능
    		});
    		$('.datepicker').mask('0000-00-00');					// '0000-00-00'를 숨기기
    		
    		$('#start_dt').datepicker(
    			'setDate',
    			Util.isEmpty($('#start_dt').val()) ? new Date() : $('#start_dt').val()
    		);
    		
    	}
    });
    function onSubmit(){ 								//조회 버튼이 있고 누를때
		var initStartTime = document.getElementById('start_time');	
		var startDate = document.getElementById('start_dt').value;
		var startTime = initStartTime.options[initStartTime.selectedIndex].text + ':00';
		var completeStart = startDate + ' ' + startTime;
		console.log('completeStart: ', completeStart);
	} 
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