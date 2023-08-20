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
		var timeWarnMessage = "종료 시간은 시작 시간 보다 이후의 시간이 되어야 합니다"; 
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
			
			$('#end_dt').datepicker(
					'setDate',
					Util.isEmpty($('#end_dt').val()) ? new Date() : $('#end_dt').val()
			);
			
			/* $('#start_dt').datepicker('option', 'maxDate', $('#start_dt').val());
			
			$('#end_dt').datepicker('option', 'minDate', $('#end_dt').val()); */
			
			var	prevStartDt = $('#start_dt').val();		
			
			var prevEndDt = $('#end_dt').val();
			
			/* $('#start_dt').datepicker('option', 'onClose', function (selectedDate){
				var dateChecker = new Date(selectedDate);
				if(dateChecker.getTime() == dateChecker.getTime()){
				if(selectedDate == $('#end_dt').val()){ // 시작 날짜가 종료 날짜와 똑같지만 시작 시간 값이 종료 시간보다 값이 놓으면 거부
					var initStartTime = document.getElementById("start_time").value;
       			 	var initEndTime = document.getElementById("end_time").value;
       			 	if(initStartTime > initEndTime){	
       					$('#start_dt').val(prevStartDt);
       					jsMsgBox(null,'info',timeWarnMessage);
       					return;
       			 	}
				} 	
					//	$('#end_dt').datepicker('option', 'minDate', selectedDate);	
					prevStartDt = selectedDate;
				}else {
					$('#start_dt').val(prevStartDt);
					jsMsgBox(null,'info',"날짜를 다시 선택해주세요");
   					return
				}
		    });
			
			$('#end_dt').datepicker('option', 'onClose', function (selectedDate){
				var dateChecker = new Date(selectedDate);
				if(dateChecker.getTime() == dateChecker.getTime()){
					console.log("True path");
					if(selectedDate <= $('#start_dt').val()){
						var initStartTime = document.getElementById("start_time").value;
						var initEndTime = document.getElementById("end_time").value;
						if(initStartTime > initEndTime){
							$("#end_dt").val(prevEndDt);
							jsMsgBox(null,'info',timeWarnMessage);
	       					return;
						}
					}
			        //	$('#start_dt').datepicker('option', 'maxDate', selectedDate);
			        prevEndDt = selectedDate;
			        console.log("New endDt: ", prevEndDt);	
				}else{
					$("#end_dt").val(prevEndDt);
					jsMsgBox(null,'info',"날짜를 다시 선택해주세요");
   					return;
				}
		        
		    }); */ 																			//protoType
		    
			$('#start_dt').datepicker('option', 'onClose', function (selectedDate){
				var dateChecker = new Date(selectedDate);
				if(dateChecker.getTime() == dateChecker.getTime()){ 						//날짜 유효 확인 체크
					if(selectedDate < $('#end_dt').val()){									//시작 날짜가 종료 날짜보다 더 이전이면 OK
						prevStartDt = selectedDate;
						return;
					} else if(selectedDate == $('#end_dt').val()){ 							//시작 날짜가 종료 날짜와 똑같으면 시간 확인
						var initStartTime = document.getElementById("start_time").value;
						var initEndTime = document.getElementById("end_time").value;
						if(initStartTime <= initEndTime){ 									//시작 시간이 종료 시간보다 이전이면 OK
							prevStartDt = selectedDate;
							return;
						} else{																//시작 시간 종료 시간 후 경고 
							$("#start_dt").val(prevStartDt);
							jsMsgBox(null,'info',timeWarnMessage);
	       					return;
						}
					}
					$("#start_dt").val(prevStartDt);										//시작 날짜 종료 날짜 후 경고
					jsMsgBox(null,'info',"시작일이 종료일보다 이후가 될수 없습니다.");
	  				return;
				}
				$("#start_dt").val(prevStartDt);											//날짜 유호 경고
				jsMsgBox(null,'info',"시작일이 유효하지 않습니다");
  				return;
		    });
			
			$('#end_dt').datepicker('option', 'onClose', function (selectedDate){
				var dateChecker = new Date(selectedDate);
				if(dateChecker.getTime() == dateChecker.getTime()){							//날짜 유효 확인 체크
					if(selectedDate > $('#start_dt').val()){
						prevEndDt = selectedDate;
						return;
					} else if(selectedDate == $('#start_dt').val()){						//시작 날짜가 종료 날짜와 똑같으면 시간 확인
						var initStartTime = document.getElementById("start_time").value;
						var initEndTime = document.getElementById("end_time").value;
						if(initStartTime <= initEndTime){									//시작 시간이 종료 시간보다 이전이면 OK
							prevEndDt = selectedDate;
							return;
						} else{																//종료 시간 시작 시간 전 경고 
							$("#end_dt").val(prevEndDt);
							jsMsgBox(null,'info',timeWarnMessage);
	       					return;
						}
					}
					$("#end_dt").val(prevEndDt);											//종료 날짜 시작 날짜 전 경고
					jsMsgBox(null,'info',"종료일이 시작일보다 이전이 될수 없습니다.");
	  				return;
				}
				$("#end_dt").val(prevEndDt);												//날짜 유호 경고
				jsMsgBox(null,'info',"종료일이 유효하지 않습니다");
  				return;
		    });
		    
		    
		}
		
        $('ul.tabs li').click(function(){
    		$('ul.tabs li').removeClass('on');
    		$(this).addClass('on');
    		var tab_id = $(this).attr('data_tab');
    		var checker = document.getElementById("start_dt").value;
    		console.log(checker);
    		$('.tab_content').removeClass('on');
    		$('#'+tab_id).addClass('on');
    	});
        
        timeRestriction();
        
        function timeRestriction(){
        	$("select[name=start_time]").focus(function(){
             	previous =this.value;														//시간 바꾸기 전 값을 저장
             }).change(function(){
            	 var startDate = document.getElementById("start_dt").value;
        		 var endDate = document.getElementById("end_dt").value;
        		 if(startDate == endDate){													//종료와 시작 날짜가 같으면
        			 var initStartTime = Number(document.getElementById("start_time").value);
        			 var initEndTime = Number(document.getElementById("end_time").value);
        			 if(initStartTime > initEndTime){										//시작 시간이 종료시간보다 더 후면 경고
        				document.getElementById("start_time").value= previous;
        				jsMsgBox(null,'info',timeWarnMessage);
        				return;
        			 }
        		 }
             }); 																			// 시작 시간 끝
            
            $("select[name=end_time]").focus(function(){
             	previous = this.value;														//시간 바꾸기 전 값을 저장
             }).change(function (){
            	 var startDate = document.getElementById("start_dt").value;
        		 var endDate = document.getElementById("end_dt").value;
        		 if(startDate == endDate){													//종료와 시작 날짜가 같으면
        			 var initStartTime = Number(document.getElementById("start_time").value);
        			 var initEndTime = Number(document.getElementById("end_time").value);
        			 if(initStartTime > initEndTime){										//종료 시간이 시작시간보다 더 전이면 경고
        				 document.getElementById("end_time").value = previous;
        				 jsMsgBox(null,'info',timeWarnMessage);
        				 return;
        			 }
        		 }
             }); 																			//	종료 시간 끝	
        }; 																					//	timeRestriction 끝
	});
	
	function onSubmit(){ 																	//조회 버튼이 있고 누를때
		var initStartTime = document.getElementById("start_time");
		var initEndTime = document.getElementById("end_time");	
	
		var startDate = document.getElementById("start_dt").value;
		var endDate = document.getElementById("end_dt").value;
		
		var startTime = initStartTime.options[initStartTime.selectedIndex].text + ":00";
		var endTime = initEndTime.options[initEndTime.selectedIndex].text + ":00";
		
		var completeStart = startDate + " " + startTime;
		var completeEnd = endDate + " " + endTime;
		
		console.log("completeStart: ", completeStart);
		console.log("completeEnd: ", completeEnd);
	} 
	
		 
	/*function timeLimit(type, selection){	 
			if(type === 1){
			var h;
			for(h = 0; h<48; h++){ 
				$("#end_time option[value=" + h + "]").show();
			}
			var i;
			var durationCounter = selection.value;
			for(i = 0; i<durationCounter; i++){
				//	select.options[0] = null;
				$("#end_time option[value=" + i + "]").hide();
			}
			document.getElementById("end_time").selectedIndex = i;
		}
		if(type == 2){
			var h;
			for(h = 0; h<48; h++){
				$("#start_time option[value=" + h + "]").show();
			}
			var i;
			var select = document.getElementById("start_time");
			var durationCounter = select.options.length - 1 - selection.value;
			console.log("durationCounter", durationCounter);
			var identifier;
			for(i = 0; i<durationCounter; i++){
				identifier = select.options.length- 1 - i;
				//	select.options[lengthMinOne] = null;
				$("#start_time option[value=" + identifier + "]").hide();
			}
		} 
	}*/																						//시간 바꾸기 prototype
	   
</script>
</head>
<body>
<div id="wrap">
	<div class="wrap_inn">
		<div class="contents">
			<!-- 타이틀 영역 -->
			<h2 class="menu_title">달력 컴포넌트 (시작/종료일 + 시간을 선택하는 달력)</h2>
			<!-- 날짜 영역 -->
			<table cellpadding="0" cellspacing="0" class="table_search" summary="달력">
				<caption>달력</caption>
				<colgroup>
					<col width="10%"/>
				</colgroup>
				<tr>
					<th scope="row">날짜</th>
					<td>
						<input type="text" id="start_dt" name="start_dt" class="datepicker" style="width:70px"/>
						<select size="1" name = "start_time" id="start_time" style="width: 70px;">
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
						<strong> ~ </strong>
						<input type="text" id="end_dt" name="end_dt" class="datepicker" style="width:70px;"/>
						<select size="1" name = "end_time" id="end_time" style="width:70px">
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
              <select size="1" name = "start_time" id="start_time" style="width: 70px;">
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
              <strong> ~ </strong>
              <input type="text" id="end_dt" name="end_dt" class="datepicker" style="width:70px;"/>
              <select size="1" name = "end_time" id="end_time" style="width:70px">
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
                   	
$(document).ready(function() {
		
		initDatepicker();
		var timeWarnMessage = '종료 시간은 시작 시간 보다 이후의 시간이 되어야 합니다'; 
		function initDatepicker() {
			
			$('.datepicker').datepicker({
				showOtherMonths: true,
				showOn : 'both',
				buttonImage : '<c:url value='/images/acm/icon_cal.png'/>',
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
			
			var	prevStartDt = $('#start_dt').val();		
			
			var prevEndDt = $('#end_dt').val();
		    
			$('#start_dt').datepicker('option', 'onClose', function (selectedDate){
				var dateChecker = new Date(selectedDate);
				if(dateChecker.getTime() == dateChecker.getTime()){ 						//날짜 유효 확인 체크
					if(selectedDate < $('#end_dt').val()){							//시작 날짜가 종료 날짜보다 더 이전이면 OK
						prevStartDt = selectedDate;
						return;
					} else if(selectedDate == $('#end_dt').val()){ 						//시작 날짜가 종료 날짜와 똑같으면 시간 확인
						var initStartTime = document.getElementById('start_time').value;
						var initEndTime = document.getElementById('end_time').value;
						if(initStartTime <= initEndTime){ 						//시작 시간이 종료 시간보다 이전이면 OK
							prevStartDt = selectedDate;
							return;
						} else{										//시작 시간 종료 시간 후 경고 
							$('#start_dt').val(prevStartDt);
							jsMsgBox(null,'info',timeWarnMessage);
	       					return;
						}
					}
					$('#start_dt').val(prevStartDt);							//시작 날짜 종료 날짜 후 경고
					jsMsgBox(null,'info','시작일이 종료일보다 이후가 될수 없습니다.');
	  				return;
				}
				$('#start_dt').val(prevStartDt);								//날짜 유호 경고
				jsMsgBox(null,'info','시작일이 유효하지 않습니다');
  				return;
		    });
			
			$('#end_dt').datepicker('option', 'onClose', function (selectedDate){
				var dateChecker = new Date(selectedDate);
				if(dateChecker.getTime() == dateChecker.getTime()){						//날짜 유효 확인 체크
					if(selectedDate > $('#start_dt').val()){
						prevEndDt = selectedDate;
						return;
					} else if(selectedDate == $('#start_dt').val()){					//시작 날짜가 종료 날짜와 똑같으면 시간 확인
						var initStartTime = document.getElementById('start_time').value;
						var initEndTime = document.getElementById('end_time').value;
						if(initStartTime <= initEndTime){						//시작 시간이 종료 시간보다 이전이면 OK
							prevEndDt = selectedDate;
							return;
						} else{										//종료 시간 시작 시간 전 경고 
							$('#end_dt').val(prevEndDt);
							jsMsgBox(null,'info',timeWarnMessage);
	       					return;
						}
					}
					$('#end_dt').val(prevEndDt);								//종료 날짜 시작 날짜 전 경고
					jsMsgBox(null,'info','종료일이 시작일보다 이전이 될수 없습니다.');
	  				return;
				}
				$('#end_dt').val(prevEndDt);									//날짜 유호 경고
				jsMsgBox(null,'info','종료일이 유효하지 않습니다');
  				return;
		        
		    });
		    
		    
		}
		
        $('ul.tabs li').click(function(){
    		$('ul.tabs li').removeClass('on');
    		$(this).addClass('on');
    		var tab_id = $(this).attr('data_tab');
    		var checker = document.getElementById('start_dt').value;
    		console.log(checker);
    		$('.tab_content').removeClass('on');
    		$('#'+tab_id).addClass('on');
    	});
        
        timeRestriction();
        
        function timeRestriction(){
        	$('select[name=start_time]').focus(function(){
             	previous =this.value;												//시간 바꾸기 전 값을 저장
             }).change(function(){
            	 var startDate = document.getElementById('start_dt').value;
        		 var endDate = document.getElementById('end_dt').value;
        		 if(startDate == endDate){										//종료와 시작 날짜가 같으면
        			 var initStartTime = Number(document.getElementById('start_time').value);
        			 var initEndTime = Number(document.getElementById('end_time').value);
        			 if(initStartTime > initEndTime){								//시작 시간이 종료시간보다 더 후면 경고
        				document.getElementById('start_time').value= previous;
        				jsMsgBox(null,'info',timeWarnMessage);
        				return;
        			 }
        		 }
             }); 														// 시작 시간 끝
            
            $('select[name=end_time]').focus(function(){
             	previous = this.value;												//시간 바꾸기 전 값을 저장
             }).change(function (){
            	 var startDate = document.getElementById('start_dt').value;
        		 var endDate = document.getElementById('end_dt').value;
        		 if(startDate == endDate){										//종료와 시작 날짜가 같으면
        			 var initStartTime = Number(document.getElementById('start_time').value);
        			 var initEndTime = Number(document.getElementById('end_time').value);
        			 if(initStartTime > initEndTime){								//종료 시간이 시작시간보다 더 전이면 경고
        				 document.getElementById('end_time').value = previous;
        				 jsMsgBox(null,'info',timeWarnMessage);
        				 return;
        			 }
        		 }
             }); 														//종료 시간 끝	
        }; 															//timeRestriction 끝
	});
	
	function onSubmit(){ 													//조회 버튼이 있고 누를때
		var initStartTime = document.getElementById('start_time');
		var initEndTime = document.getElementById('end_time');	
	
		var startDate = document.getElementById('start_dt').value;
		var endDate = document.getElementById('end_dt').value;
		
		var startTime = initStartTime.options[initStartTime.selectedIndex].text + ':00';
		var endTime = initEndTime.options[initEndTime.selectedIndex].text + ':00';
		
		var completeStart = startDate + ' ' + startTime;
		var completeEnd = endDate + ' ' + endTime;
		
		console.log('completeStart: ', completeStart);
		console.log('completeEnd: ', completeEnd);
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