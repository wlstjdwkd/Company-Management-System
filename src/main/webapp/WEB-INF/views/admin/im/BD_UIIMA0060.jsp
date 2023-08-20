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
<c:set var="svcUrl" value=" ${requestScope[SVC_URL_NAME]}"/>
<ap:globalConst/>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,blockUI,msgBoxAdmin,colorboxAdmin,mask,jqGrid,css,selectbox"/>
<ap:jsTag type="tech" items="acm,msg,util"/>
<style type="text/css">
	.tab-content{
		display: none;
	}
	.tab-content.on{
		display: inherit;
	}
	.tab_content{
		display: none;
	}
	.tab_content.on{
		display: inherit;
	}
</style>
<script type='text/javascript'>
	
	$(document).ready(function() {
		
		$('ul.tab-menu li').click(function(){
			$('ul.tab-menu li').removeClass('on');
			$(this).addClass('on');
			
			var tabID = $(this).attr('data-tab');
			
			$('.tab-content').removeClass('on');
			$('#'+tabID).addClass('on');
		});
		
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
			<h2 class="menu_title">탭 (탭 이동 시 상태가 변하지 않는 탭)</h2>
			
			<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}'/>" method="post">
				<ap:include page="param/defaultParam.jsp"/>
				<ap:include page="param/dispParam.jsp"/>
				<ap:include page="param/pagingParam.jsp"/>
				<div class="tabwrap">
					<div class="tab">
						<ul class="tab-menu">
	                        <li class="on" data-tab="tab-1">TAB1</li>
	                        <li data-tab="tab-2">TAB2</li>
	                    </ul>
	                    <div>
		                   	<div id="tab-1" class="tab-content on">
		                   		<div class="search_top" style="margin-top:20px;">
		                   			<table cellpadding="0" cellspacing="0" class="table_search" summary="조회 년도">
		                   				<caption>조회 년도</caption>
		                   				<colgroup>
		                   					<col width="15%" />
		                   					<col width="*" />
		                   				</colgroup>
		                   				<tbody>
		                   					<tr>
		                   						<th scope="row">조회년도</th>
		                   						<td>
		                   							<select id="search_year" name="search_year" title="조회년도" style="width:130px">
		                   								<option>2021년</option>
						                            	<option>2020년</option>
						                            	<option>2019년</option>
						                            	<option>2018년</option>
						                            </select>
						                        </td>
						                        <th scope="row">기업군</th>
		                   						<td>
		                   							<select id="search_year" name="search_year" title="기업군" style="width:130px">
		                   								<option>기업</option>
						                            	<option>일반중견</option>
						                            	<option>관계기업</option>
						                            	<option>후보기업</option>
						                            </select>
						                        </td>
						                    </tr>
						                </tbody>
						            </table>
		                        </div>
		                   	</div>
		                   	<div id="tab-2" class="tab-content">
		                   		<div class="search_top" style="margin-top:20px;">
		                   			<div class="search_top" style="margin-top:20px;">
			                   			<table cellpadding="0" cellspacing="0" class="table_search" summary="조회 년도">
			                   				<caption>조회 년도</caption>
			                   				<colgroup>
			                   					<col width="15%" />
			                   					<col width="*" />
			                   				</colgroup>
			                   				<tbody>
			                   					<tr>
			                   						<th scope="row">기업군</th>
			                   						<td>
			                   							<select id="search_year" name="search_year" title="기업군" style="width:130px">
			                   								<option>기업</option>
							                            	<option>일반중견</option>
							                            	<option>관계기업</option>
							                            	<option>후보기업</option>
							                            </select>
							                        </td>
			                   						<th scope="row">조회년도</th>
			                   						<td>
			                   							<select id="search_year" name="search_year" title="조회년도" style="width:130px">
			                   								<option>2021년</option>
							                            	<option>2020년</option>
							                            	<option>2019년</option>
							                            	<option>2018년</option>
							                            </select>
							                        </td>
							                    </tr>
							                </tbody>
							            </table>
			                        </div>
		                        </div>
		                   	</div>
	                   	</div>
					</div>
				</div>
			</form>
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
         <h2 class="menu_title">탭</h2>
         <div class="tabwrap">
            <div class="tab">
               <ul class="tab-menu">
                  <li class="on" data-tab="tab-1">TAB1</li>
                  <li data-tab="tab-2">TAB2</li>
               </ul>
               <div id="tab-1" class="tab-content on">
                  <!-- contents 영역 -->
               </div>
               <div id="tab-2" class="tab-content">
                  <!-- contents 영역 -->
               </div>
            </div>
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
   
      $('ul.tab-menu li').click(function(){
         $('ul.tab-menu li').removeClass('on');
		 $(this).addClass('on');
			
		 var tabID = $(this).attr('data-tab');
			
		 $('.tab-content').removeClass('on');
		 $('#'+tabID).addClass('on');
	  });
		
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