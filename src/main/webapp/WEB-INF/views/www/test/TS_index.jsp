<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>INDEX</title>
<style>
.demo-placeholder {
	width: 100%;
	height: 100%;
	font-size: 14px;
	line-height: 1.2em;
}
.demo-container {
	box-sizing: border-box;
	width: 850px;
	height: 450px;
	padding: 20px 15px 15px 15px;
	margin: 15px auto 30px auto;
	border: 1px solid #ddd;
	background: #fff;
	background: linear-gradient(#f6f6f6 0, #fff 50px);
	background: -o-linear-gradient(#f6f6f6 0, #fff 50px);
	background: -ms-linear-gradient(#f6f6f6 0, #fff 50px);
	background: -moz-linear-gradient(#f6f6f6 0, #fff 50px);
	background: -webkit-linear-gradient(#f6f6f6 0, #fff 50px);
	box-shadow: 0 3px 10px rgba(0,0,0,0.15);
	-o-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
	-ms-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
	-moz-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
	-webkit-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
}
</style>
<ap:jsTag type="web" items="jquery,blockUI,colorboxAdmin,cookie,flot,form,jqGrid,multifile,notice,selectbox,timer,tools,ui,validate,mask,multiselect,msgBoxAdmin,filestyle" />
<ap:jsTag type="tech" items="msg,util" />
<ap:globalConst />
<script type="text/javascript">

    var implementInsertForm = function() {	  	
         $.colorbox({
             title : "팝업 테스트",
             href : "PGUM0001.do",
             width : "80%",
             height : "80%",
             //iframe : true,
             overlayClose : false,
             escKey : false
         });
    };
    
    // jqGrid 리사이징
	function resizeJqGridWidth(){
		$.timer(100, function (timer) {
			var grid_id = "list4";
			var div_id = "baseGridWidth";		 	
		 	$('#' + grid_id).setGridWidth($('#' + div_id).width()-10 , true);
    		timer.stop();
    	});
	}
    
	function hohoho(){
		alert('hohoho');
	}
	
	function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){	
		<%--
		roadFullAddr : 도로명주소 전체(포멧)
		roadAddrPart1: 도로명주소           
		addrDetail   : 고객입력 상세주소    
		roadAddrPart2: 참고주소             
		engAddr      : 영문 도로명주소      
		jibunAddr    : 지번 주소            
		zipNo        : 우편번호             
		admCd        : 행정구역코드         
		rnMgtSn      : 도로명코드           
		bdMgtSn      : 건물관리번호
		--%>
		
		var zipArr = Util.str.split(zipNo,'-');	
		$('#ad_zipcod_first').val(zipArr[0]);
		$('#ad_zipcod_last').val(zipArr[1]);
		$('#ad_addr_detail01').val(roadAddrPart1);
		$('#ad_addr_detail02').val(addrDetail);
	}
	
    $(document).ready(function(){
    	// 우편번호검색
    	$('#btn_search_zip').click(function() {
        	var pop = window.open("<c:url value='${SEARCH_ZIP_URL}' />","searchZip","width=570,height=420, scrollbars=yes, resizable=yes");		
        });
    	
    	// msgBox
		$("#msgBox").click(function() {			
			//jsMsgBox($(this),'info','정보');
			//jsMsgBox($(this),'error','에러');
			//jsMsgBox($(this),'warn','경고');			
			jsMsgBox(null,'confirm','확인',function(){alert('예스');});
			//jsMsgBox(null,'confirm','확인',function(){alert('예스');},function(){alert('노');});
			
		});
    	
    	$(window).bind('resize', function() {
    		resizeJqGridWidth(); 
		}).trigger('resize');
    	
       	 $("#signupForm").validate({  
    			rules : {
    				firstname: "required",    			
        			lastname: "required",
        			username: {
        				required: true,
        				minlength: 2
        			},
        			password: {
        				required: true,
        				minlength: 5
        			},
        			confirm_password: {
        				required: true,
        				minlength: 5,
        				equalTo: "#password"
        			},
        			email: {
        				required: true,
        				email: true
        			},
        			topic: {
        				required: "#newsletter:checked",
        				minlength: 2
        			},
        			agree: "required"
    			},
    			submitHandler: function(form) {
    				alert("submit");
    				/*    				
    				// IE 버그 있으므로 사용시
    				// 서버측 content type을 text/plain 로 할것
    				$(form).ajaxSubmit({
    					url      : "ND_UpdateExpertAction.do",
    					type     : "post",
    					dataType : "text",
    					async    : false,
    					success  : function(response) {
    						try {
    							if(eval(response)) {
    								jsSuccessBox(Message.msg.updateOk);
    								jsList("BD_index.do","dataForm");
    							} else {
    								jsErrorBox(Message.msg.processFail);
    							}
    						} catch (e) {
    							jsSysErrorBox(response, e);
    							return;
    						}                            
    					}
    				});
    				 */
    			}
    		});
    	 
    	$("#username").focus(function() {
    		var firstname = $("#firstname").val();
    		var lastname = $("#lastname").val();
    		if (firstname && lastname && !this.value) {
    			this.value = firstname + "." + lastname;
    		}
    	});
    	
		var newsletter = $("#newsletter");
		var inital = newsletter.is(":checked");
		var topics = $("#newsletter_topics")[inital ? "removeClass" : "addClass"]("gray");
		var topicInputs = topics.find("input").attr("disabled", !inital);
		newsletter.click(function() {
			topics[this.checked ? "removeClass" : "addClass"]("gray");
			topicInputs.attr("disabled", !this.checked);
		});
		
		
		// 알림
		$("#notice").click(function() {
			jsMessage("일반 메시지 입니다.");
			jsSuccessBox(Message.msg.insertOk);			
			jsWarningBox(Message.msg.validateFail);
			jsErrorBox(Message.msg.processError);
			alert(Message.template.test("hahaha"));
		}); 		
		
		
		// 달력
		$('#q_pjt_start_dt').datepicker({
            showOn : 'button',
            defaultDate : null,
            buttonImage : '<c:url value="images/ts/icon_cal.gif" />',
            buttonImageOnly : true,
            changeYear: true,
            changeMonth: true,
            yearRange: "1920:+1"
        });
        $('#q_pjt_end_dt').datepicker({
            showOn : 'button',
            defaultDate : null,
            buttonImage : '<c:url value="images/ts/icon_cal.gif" />',
            buttonImageOnly : true,
            changeYear: true,
            changeMonth: true,
            yearRange: "1920:+1"
        });
        
        $("#check_date").click(function() {
        	if($("#q_pjt_start_dt").val() > $("#q_pjt_end_dt").val() || $("#q_pjt_start_dt").val().replace(/-/gi,"") > $("#q_pjt_end_dt").val().replace(/-/gi,"")){
                alert("시작일이 종료일보다 뒤에 날짜로 올수 없습니다.");
                $("#q_pjt_end_dt").focus();
                return false;
            }
        });
        
        
     	// ajax
        $("#ajax_submit").click(function(){
        	// 가공 데이터        	
        	$.ajax({
                url      : "PGTS0002.do",
                type     : "POST",
                dataType : "json",
                data     : { df_method_nm: "jsonRsolver", key1: 'value1', key2: 'value2' },
                //data     : $('#dataForm').formSerialize(),
                async    : false,                
                success  : function(response) {
                	try {
                        if(response.result) {
                        	alert(response.value.data2);
                            //jsSuccessBox("Success");                     
                        } else {
                            jsErrorBox("Fail");
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
        	
        	/*
        	// 폼 데이터
        	$("#dataForm").ajaxSubmit({
                url      : "PGTS0002.do",
                type     : "POST",
                dataType : "json",
                data     : { key1: 'value1', key2: 'value2' },
                async    : false,
                beforeSubmit : function(){
                	$("#df_method_nm").val("jsonRsolver");
                },
                // 데이터 타입: json
                success  : function(response) {
                	try {
                        if(response.result) {
                        	alert(response.value.data1);
                            //jsSuccessBox("Success");                     
                        } else {
                            jsErrorBox("Fail");
                        }
                    } catch (e) {
                        if(response != null) {
                        	jsSysErrorBox(response);
                        } else {
                            jsSysErrorBox(e);
                        }
                        return;
                    }
                // 데이터 타입: text
                    try {
                        if(eval(response)) {
                            jsSuccessBox("Success");                     
                        } else {
                            jsErrorBox("Fail");
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
        	*/
        });
     	
        //$("input:file").jfilestyle();
        
     	// mutifile-upload
        $('input:file').MultiFile({
			accept: 'zip|pdf|js',
			max: '2',
			list: '#multiFilesListDiv',
			STRING: {
				remove: '<img src="http://www.fyneworks.com/i/bin.gif" height="16" width="16" alt="x"/>',
				denied: '$ext 는(은) 업로드 할 수 없는 파일확장자입니다!',  //확장자 제한 문구
				duplicate: '$file 는(은) 이미 추가된 파일입니다!'		   //중복 파일 문구
			},
			onFileRemove: function(element, value, master_element){
			},
			afterFileRemove: function(element, value, master_element){			
			},
			onFileAppend: function(element, value, master_element){			
			},
			afterFileAppend: function(element, value, master_element){			
			},
			onFileSelect: function(element, value, master_element){
			},
			afterFileSelect: function(element, value, master_element){
			}
		});
    	
     	// blockUI
        $('#block').click(function() { 
        	$.blockUI({ 
                fadeIn: 1000, 
                timeout: 3000,
                baseZ: 1000000,
                onBlock: function() { 
                    //alert('Page is now blocked; fadeIn complete'); 
                }        	
            });
        }); 
        
        // chart
        var options = {
        	lines: {
        		show: true
        	},
        	points: {
        		show: true
        	},
        	xaxis: {
        		tickDecimals: 0,
        		tickSize: 1
        	},
        	yaxes: [
		                {
		                    /* First y axis */
		                },
		                {
		                    /* Second y axis */
		                    position: "right"  /* left or right */
		                }
		            ] 
        };
		
        var data = [];
        var series = {
        	"label": "유럽 (EU27)",
            "data": [[1999, 3.0], [2000, 3.9], [2001, 2.0], [2002, 1.2], [2003, 1.3], [2004, 2.5], [2005, 2.0], [2006, 3.1], [2007, 2.9], [2008, 0.9]]
        }
        var series2 = {
           	"label": "아시아 (EU27)",
               "data": [[1999, 2231], [2000, 1000], [2001, 2300], [2002, 1600], [2003, 1700], [2004, 1480], [2005, 1234], [2006, 1222], [2007, 900], [2008, 600]],
               yaxis: 2
           }
        var series3 = {
               	"label": "아시아 (EU27)",
                   "data": [[1999, 2731], [2000, 1500], [2001, 2100], [2002, 1200], [2003, 2700], [2004, 1410], [2005, 1334], [2006, 1522], [2007, 1900], [2008, 200]],
                   yaxis: 2
               }
        data.push(series);
        data.push(series2);
        data.push(series3);
        $.plot("#placeholder", data, options);        
        
        
        // 그리드
        $("#list4").jqGrid({
        	datatype: "local",
        	height: 250,
           	colNames:['Inv No','Date', 'Client', 'Amount','Tax','Total','Notes'],
           	colModel:[
           		{name:'id',index:'id', width:60, sorttype:"int"},
           		{name:'invdate',index:'invdate', width:90, sorttype:"date"},
           		{name:'name',index:'name', width:100},
           		{name:'amount',index:'amount', width:80, align:"right",sorttype:"float"},
           		{name:'tax',index:'tax', width:80, align:"right",sorttype:"float"},		
           		{name:'total',index:'total', width:80,align:"right",sorttype:"float"},		
           		{name:'note',index:'note', width:150, sortable:false}		
           	],
           	multiselect: true,
           	sortable:true,
           	caption: "Manipulating Array Data"
        });
        var mydata = [
        		{id:"1",invdate:"2007-10-01",name:"test",note:"note",amount:"200.00",tax:"10.00",total:"210.00"},
        		{id:"2",invdate:"2007-10-02",name:"test2",note:"note2",amount:"300.00",tax:"20.00",total:"320.00"},
        		{id:"3",invdate:"2007-09-01",name:"test3",note:"note3",amount:"400.00",tax:"30.00",total:"430.00"},
        		{id:"4",invdate:"2007-10-04",name:"test",note:"note",amount:"200.00",tax:"10.00",total:"210.00"},
        		{id:"5",invdate:"2007-10-05",name:"test2",note:"note2",amount:"300.00",tax:"20.00",total:"320.00"},
        		{id:"6",invdate:"2007-09-06",name:"test3",note:"note3",amount:"400.00",tax:"30.00",total:"430.00"},
        		{id:"7",invdate:"2007-10-04",name:"test",note:"note",amount:"200.00",tax:"10.00",total:"210.00"},
        		{id:"8",invdate:"2007-10-03",name:"test2",note:"note2",amount:"300.00",tax:"20.00",total:"320.00"},
        		{id:"9",invdate:"2007-09-01",name:"test3",note:"note3",amount:"400.00",tax:"30.00",total:"430.00"}
        		];
        for(var i=0;i<=mydata.length;i++){
        	$("#list4").jqGrid('addRowData',i+1,mydata[i]);
        }
        
        
        $("#formSerialize").click(function(){        	
        	var queryString = $('#dataForm').formSerialize();
        	alert(queryString);
        });
        
        $("#utilTest").click(function(){        	
        	var str = "";
    		var rtn = "";
    		rtn = Util.str.nvl(str,"hahaha");    		
    		alert(rtn);
        });
        
        $("#validSubmit").click(function(){
        	$("#signupForm").submit();        	
        });
        
        $("#TextView").click(function(){
        	$("#df_method_nm").val("textRsolver");
        	$("#dataForm").attr("action","PGTS0001.do");        	
        	$("#dataForm").submit();        	
        });
        
        // MASK
        $('#timeMask').mask('00:00:00');
        $('#q_pjt_start_dt').mask('0000-00-00');
        
        $("#getTime").click(function(){
        	var time = $('#timeMask').cleanVal();        	
        	alert(time);
        });        
        
        $("#check_date_mask").click(function(){
        	var date = $('#q_pjt_start_dt').cleanVal();        	
        	alert(date);
        }); 
        
        $("#excelDown").click(function(){
        	jsFiledownload("/PGTS0002.do","df_method_nm=excelRsolver");
        });
        
        
      	//멀티 셀렉트
        var multipleSelectSetting = {
        		selectAllText : "전체선택",
            	allSelected : "전체선택",
            	filter: true
        }
              	
        $('#multiSelectGroup').multipleSelect(multipleSelectSetting);
      	
      	$("select[name^='mSelGridGrp']").multipleSelect(multipleSelectSetting);      	            
        
        $("#multiSelectValues").click(function() {
        	alert($("#multiSelectGroup").val());
        });
        
        
        
        
        
        var a1 = [[0,3],[1,19],[2,15],[3,5],[4,11]];
        var a2 = [[0,8],[1,6],[2,12],[3,10],[4,1]];
        var a3 = [[0,3],[1,12],[2,11],[3,2],[4,13]];

        var data = [
            {
                label: "France",
                data: a1
            },
            {
                label: "Germany",
                data: a2
            },
            {
                label: "Italy",
                data: a3
            }
        ];

        $.plot($("#placeholder1"), data, {
            series: {
                bars: {
                    show: true,
                    barWidth: 0.13,
                    order: 1
                }
            },
            valueLabels: {
                show: true
            }
        });
	
    });    

    function noticeMsgBox(){
    	jsMsgBox(null,'notice',"로그인 후 이용하실 수 있습니다.");
    }
</script>
</head>
<body>	
	
	<form name="dataForm" id="dataForm" method="POST" action="PGTS0001.do">
	<ap:include page="param/defaultParam.jsp" />
	<ap:include page="param/pagingParam.jsp" />		
	</form>
	
	<br /><br />
	
	<input type="button" value="로그인 메시지박스" onclick="noticeMsgBox();">
	
	<br /><br />
	
	<fieldset>
	<legend>Polt(Flot) MultiBar Chart</legend>	
	<div id="placeholder1" style="width:700px;height:400px;"></div>
	</fieldset>	
	<br /><br />

	<fieldset>
	<legend>우편번호검색</legend>			
	<table>	
	<tr>
		<th rowspan="4" scope="row"><label for="info8">주소</label></th>
		<td class="rows">
			<input name="ad_zipcod_first" type="text" id="ad_zipcod_first" class="text"style="width:188px;" title="우편번호앞자리" readonly />
			 - 
			<input name="ad_zipcod_last" type="text" id="ad_zipcod_last" class="text"style="width:187px;" title="우편번호뒷자리" readonly />
		</td>
	</tr>
	<tr>
		<td class="rows">
			<input name="ad_addr_detail01" type="text" id="ad_addr_detail01" class="text" style="width:395px;" title="주소상세" readonly />
		</td>
	</tr>
	<tr>
		<td class="rows">
			<input name="ad_addr_detail02" type="text" id="ad_addr_detail02" class="text" style="width:395px;" title="주소상세" />
		</td>
	</tr>
	<tr>
		<td class="rows">
			<input type="button" id="btn_search_zip" value="우편번호검색" style="width:395px;" />
		</td>
	</tr>
	</table>
	</fieldset>	
	
	<br /><br />							
	
	<fieldset>
	<legend>msgBox</legend>	
	<input type="button" id="msgBox" value="msgBox" style="width:100px;" />
	</fieldset>
	
	<br /><br />
	
	<fieldset>
	<legend>GoogleChartLine</legend>	
	<div id="ex0"></div>
	</fieldset>
	
	<br /><br />
	
	<fieldset>
	<legend>GoogleChartPie</legend>
	<div id="map" style="width:900px; height:500px; background:url('/images/ts/krmap.gif') no-repeat; border:solid red 1px;">
	<div id="chart01" ></div>
	<div id="chart02" ></div>	
	</div>
	</fieldset>
	
	
	<fieldset>
	<legend>excelDown</legend>	
	<input type="button" id="excelDown" value="excelDown" style="width:100px;" />
	</fieldset>
	
	<br /><br />
	
	<fieldset>
	<legend>MASK</legend>
	<input type="text" id="timeMask" style="width:100px;" />
	<input type="button" id="getTime" value="getTime" style="width:100px;" />
	</fieldset>
	
	<br /><br />
	
	<fieldset>
	<legend>TextView</legend>
	<input type="button" id="TextView" value="TextView" style="width:100px;" />
	</fieldset>
	
	<br /><br />
	
	<fieldset>
	<legend>utilTest</legend>
	<input type="button" id="utilTest" value="utilTest" style="width:100px;" />
	</fieldset>
	
	<br /><br />
	
	<fieldset id="baseGridWidth">
	<legend>formSerialize</legend>
	<input type="button" id="formSerialize" value="formSerialize" style="width:100px;" />
	</fieldset>
	
	<br /><br />	
	
	<fieldset>
	<legend>그리드</legend>		
	<table id="list4"></table>	
	</fieldset>	

	<br /><br />

	<fieldset>
	<legend>차트</legend>
	<div class="demo-container">
			<div id="placeholder" class="demo-placeholder"></div>
	</div>
	</fieldset>
	
	<br /><br />
	
	<fieldset>
	<legend>block</legend>
	<input type="button" id="block" value="blocking" style="width:100px;" />
	</fieldset>
	
	<br /><br />
	
	<form name="fileForm" id="fileForm" method="POST" enctype="multipart/form-data" action="PGTS0005.do">
	<!-- <input type="hidden" name="df_method_nm" value="insertFile" /> -->
	<input type="hidden" name="df_method_nm" value="updateFile" />
	<fieldset>
	<legend>파일업로드</legend>
	<!-- <input type="file" name="file1" value="찾아보기" /> -->
	<input type="file" name="file" value="찾아보기" />
	<div id="multiFilesListDiv" class="regist-file"></div>
	<input type="submit" value="파일전송" />
	</fieldset>
	</form>
	
	<br /><br />
	 
	<fieldset>
	<legend>ajax</legend>
	<input type="button" id="ajax_submit" value="전송" style="width:100px;" />
	</fieldset>
	
	<br /><br />	
	
	<fieldset>
	<legend>달력</legend>
	<input type="text" name="q_pjt_start_dt" id="q_pjt_start_dt" maxlength="10" title="날짜선택" />
	~
	<input type="text" name="q_pjt_end_dt" id="q_pjt_end_dt" maxlength="10" title="날짜선택" />
	<input type="button" id="check_date" value="확인" style="width:100px;" />
	<input type="button" id="check_date_mask" value="테스트" style="width:100px;" />
	<br /><br />
	<ui>
		<li>PAGE UP: Move to the previous month.</li>
		<li>PAGE DOWN: Move to the next month.</li>
		<li>CTRL + PAGE UP: Move to the previous year.</li>
		<li>CTRL + PAGE DOWN: Move to the next year.</li>
		<li>CTRL + HOME: Open the datepicker if closed.</li>
		<li>CTRL + HOME: Move to the current month.</li>
		<li>CTRL + LEFT: Move to the previous day.</li>
		<li>CTRL + RIGHT: Move to the next day.</li>
		<li>CTRL + UP: Move to the previous week.</li>
		<li>CTRL + DOWN: Move the next week.</li>
		<li>ENTER: Select the focused date.</li>
		<li>CTRL + END: Close the datepicker and erase the date.</li>	
	</ui>
	</fieldset>
	
	<br /><br />
									
	<fieldset>
	<legend>기능 테스트</legend>
	<input type="button" id="notice" value="알림" style="width:100px;" />
	<input type="button" value="팝업" onclick="implementInsertForm();" style="width:100px;" />
	</fieldset>
	
	<br /><br />
	
	<fieldset>
	 <legend>코드 컴포넌트</legend>
	 <ap:code id="code4" grpCd="4" type="select" selectedCd="IC" />
	 <ap:code id="code1" grpCd="1" type="checkbox" />
	 <ap:code id="code3" grpCd="3" type="radio" />
	</fieldset>
	
	<br /><br />	
	
	<fieldset>
	<legend>리스트 & 페이징</legend>
	<ap:pagerParam addJsRowParam="null,'index'" />	
	<table class="boardList" cellspacing="0" border="1" summary="리스트입니다.">
		<caption class="hidden">메뉴 목록</caption>
	    <colgroup>
		<col />
		<col />
		<col />
		<col />
		<col />
		<col />
		<col />
		<col />
		<col />
		<col />		        
	    </colgroup>
	    <thead>
	    	<tr>                    
	            <th>메뉴번호</th>
	            <th>메뉴명</th>
	            <th>메뉴레벨</th>
	            <th>부모메뉴번호</th>
	            <th>최종노드여부</th>
				<th>출력순서</th>
				<th>일반(BD), 팝업(PD)</th>					
				<th>프로그램ID</th>
				<th>사이트구분</th>
				<th>외부 링크</th>
				<th>사용여부</th>                    
	        </tr>
		</thead>
	    <tbody>                
			<c:forEach items="${menuList}" var="menuList" varStatus="status">                	
			<tr>
				<td>${menuList.menu_no}</td>
				<td>${menuList.menu_nm}</td>
				<td>${menuList.menu_level}</td>
				<td>${menuList.parnts_menu_no}</td>						
				<td>${menuList.last_node_at}</td>
				<td>${menuList.outpt_ordr}</td>
				<td>${menuList.outpt_ty}</td>						
				<td>${menuList.progrm_id}</td>
				<td>${menuList.site_se}</td>
				<td>${menuList.url}</td>
				<td>${menuList.use_at}</td>                        
			</tr>
			</c:forEach>                
	    </tbody>
	</table>	
	
	<ap:pager pager="${pager}" />
	<%-- <ap:pager pager="${pager}" addJsParam="'index'"/> --%>
	</fieldset>	
	
	<br /><br />
	
	 <form class="cmxform" id="signupForm" method="POST" action="PGTS0001.do">
		<fieldset>
			<legend>폼 유효성</legend>
			<p>
				<label for="firstname">Firstname</label>
				<input id="firstname" name="firstname" type="text">
			</p>
			<p>
				<label for="lastname">Lastname</label>
				<input id="lastname" name="lastname" type="text">
			</p>
			<p>
				<label for="username">Username</label>
				<input id="username" name="username" type="text">
			</p>
			<p>
				<label for="password">Password</label>
				<input id="password" name="password" type="password">
			</p>
			<p>
				<label for="confirm_password">Confirm password</label>
				<input id="confirm_password" name="confirm_password" type="password">
			</p>
			<p>
				<label for="email">Email</label>
				<input id="email" name="email" type="email">
			</p>
			<p>
				<label for="agree">Please agree to our policy</label>
				<input type="checkbox" class="checkbox" id="agree" name="agree">
			</p>
			<p>
				<label for="newsletter">I'd like to receive the newsletter</label>
				<input type="checkbox" class="checkbox" id="newsletter" name="newsletter">
			</p>
			<fieldset id="newsletter_topics">
				<legend>Topics (select at least two) - note: would be hidden when newsletter isn't selected, but is visible here for the demo</legend>
				<label for="topic_marketflash">
					<input type="checkbox" id="topic_marketflash" value="marketflash" name="topic">Marketflash
				</label>
				<label for="topic_fuzz">
					<input type="checkbox" id="topic_fuzz" value="fuzz" name="topic">Latest fuzz
				</label>
				<label for="topic_digester">
					<input type="checkbox" id="topic_digester" value="digester" name="topic">Mailing list digester
				</label>
				<label for="topic" class="error">Please select at least two topics you'd like to receive.</label>
			</fieldset>
			<p>
				<input class="submit" type="submit" value="Submit">
				<input type="button" id="validSubmit" value="validSubmit" style="width:100px;" />						
			</p>
		</fieldset>
	</form>
	
	<br /><br />	
	
							
	<fieldset>
		<legend>멀티 셀렉트 테스트</legend>
		<form class="cmxform" id="multiSelectForm1" method="POST" action="PGTS0001.do?df_method_nm=textRsolver">
			<select multiple="multiple" id="multiSelectGroup" name="mSelGrp" style="width: 500px">
		        <optgroup label="제조업">
		            <option value="A1">자동차, 트레일러</option>
		            <option value="A2">제조업1</option>
		            <option value="A3">제조업2</option>
		        </optgroup>		        
		        <optgroup label="비제조업">		            
		            <option value="B1">출판통신정보서비스</option>
		            <option value="B2">도소매업</option>
		            <option value="B3">광업</option>
		        </optgroup>
		    </select>
		    <input type="submit" id="mSubmit" value="submit" />
		    <input type="button" id="multiSelectValues" value="getValues" style="width:100px;" />
	    </form>
	    <br /><br />
	    
	    <form class="cmxform" id="multiSelectForm2" method="POST" action="PGTS0003.do">
		    <table class="boardList" cellspacing="0" border="1" summary="리스트입니다.">
				<caption class="hidden">테스트</caption>
			    <colgroup>
				<col />
				<col />
				<col />
				<col />
				<col />
				<col />
				<col />
				<col />
				<col />
				<col />		        
			    </colgroup>
			    <thead>
			    	<tr>                    
			            <th>-</th>
			            <th>-</th>
			            <th>-</th>
			            <th>-</th>
			            <th>-</th>
						<th>-</th>
						<th>-</th>					
						<th>-</th>
						<th>-</th>
						<th>-</th>
						<th>-</th>                    
			        </tr>
				</thead>
			    <tbody>                					                
					<tr>
						<td>
							<select multiple="multiple" id="multiSelectGrid1" name="mSelGridGrp_1" style="width: 500px">
						        <optgroup label="제조업">
						            <option value="A1" selected="selected">자동차, 트레일러</option>
						            <option value="A2">제조업1</option>
						            <option value="A3">제조업2</option>
						        </optgroup>		        
						        <optgroup label="비제조업">		            
						            <option value="B1">출판통신정보서비스</option>
						            <option value="B2">도소매업</option>
						            <option value="B3">광업</option>
						        </optgroup>
						    </select>
						</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>											                      
					</tr>
					<tr>
						<td>
							<select multiple="multiple" id="multiSelectGrid2" name="mSelGridGrp_2" style="width: 500px">
						        <optgroup label="제조업">
						            <option value="A1" selected="selected">자동차, 트레일러</option>
						            <option value="A2">제조업1</option>
						            <option value="A3">제조업2</option>
						        </optgroup>		        
						        <optgroup label="비제조업">		            
						            <option value="B1">출판통신정보서비스</option>
						            <option value="B2">도소매업</option>
						            <option value="B3">광업</option>
						        </optgroup>
						    </select>
						</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>											                      
					</tr>					        
			    </tbody>
			</table>
			
			<br /><br />
			<input type="submit" value="gridSubmit" />		
		</form>	
	</fieldset>	
	
	<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
			
</body>
</html>