<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>

<form name="dataForm" id="dataForm" method="post" action="${svcUrl }">
			<c:forEach items="${entResultInfoData}" var="entResultInfoData" varStatus="status">
			<input type="hidden" name="ad_stdyy" value="${entResultInfoData.STDYY}" />
             <input type="hidden" name="ad_assetsSm" value="${entResultInfoData.ASSETS_SM}" />
			  <input type="hidden" name="ad_debt" value="${entResultInfoData.DEBT}" />
			  <input type="hidden" name="ad_caplSm" value="${entResultInfoData.CAPL_SM}" />
			  <input type="hidden" name="ad_selngAm" value="${entResultInfoData.SELNG_AM}" />
			  <input type="hidden" name="ad_bsnProfit" value="${entResultInfoData.BSN_PROFIT}" />
			  <input type="hidden" name="ad_thstrmNtpf" value="${entResultInfoData.THSTRM_NTPF}" />
			 </c:forEach>
 <div class="tabcon" style="display: block;">
                        <div>
                            <div class="part">
                                <div class="leftzone">
                                    <h4>주요 재무상태표</h4>
                                    <div class="chart_box">
                                    <div id="placeholder_1" style="width: 97%; height: 250px;"></div>
                                    <div class="remark">
                                    	<ul>
                                    		<li class="remark2">자산총계(억원)</li>
                                    		<li class="remark3">부채총계(억원)</li>
                                    		<li class="remark1">자본총계(억원)</li>
                                    	</ul>
                                    </div>
                                    </div>
                                    <table cellpadding="0" cellspacing="0" class="table_basic" summary="표로 보기">
                                        <caption>
                                        표로 보기
                                        </caption>
                                        <colgroup>
                                        <col width="20%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <thead>
                                            <tr>
                                                <th scope="col">&nbsp;</th>
                                                <c:forEach items="${entResultInfoData}" var="entResultInfoData" varStatus="status">
                                                <th scope="col"> ${entResultInfoData.STDYY}</th>
                                                </c:forEach>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <th scope="row">자산총계(억원)</th>
                                                <c:forEach items="${entResultInfoData}" var="entResultInfoData" varStatus="status">
                                                <td class="tar"><fmt:formatNumber value = "${entResultInfoData.ASSETS_SM}" pattern = "#,##0.0" /></td>
                                                </c:forEach>
                                            </tr>
                                            <tr>
                                                <th scope="row">부채총계(억원)</th>
                                                <c:forEach items="${entResultInfoData}" var="entResultInfoData" varStatus="status">
                                                <td class="tar"><fmt:formatNumber value = "${entResultInfoData.DEBT}" pattern = "#,##0.0"/></td>
                                                </c:forEach>
                                            </tr>
                                            <tr>
                                                <th scope="row">자본총계(억원)</th>
                                                <c:forEach items="${entResultInfoData}" var="entResultInfoData" varStatus="status">
                                                <td class="tar"><fmt:formatNumber value = "${entResultInfoData.CAPL_SM}" pattern = "#,##0.0"/></td>
                                                </c:forEach>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="rightzone">
                                    <h4 class="mgb10">주요 손익계산서</h4>
                                    <div class="chart_box">
                                    <div id="placeholder_2" style="width: 97%; height: 250px;"></div>
                                    <div class="remark">
                                    	<ul>
                                    		<li class="remark2">매출액(억원)</li>
                                    		<li class="remark3">영업이익(억원)</li>
                                    		<li class="remark1">당기순이익(억원)</li>
                                    	</ul>
                                    </div>
                                    </div>
                                    <table cellpadding="0" cellspacing="0" class="table_basic" summary="표로 보기">
                                        <caption>
                                        표로 보기
                                        </caption>
                                        <colgroup>
                                        <col width="20%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <thead>
                                            <tr>
                                                <th scope="col">&nbsp;</th>
                                                <c:forEach items="${entResultInfoData}" var="entResultInfoData" varStatus="status">
                                                <th scope="col"> ${entResultInfoData.STDYY}</th>
                                                </c:forEach>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <th scope="row">매출액(억원)</th>
                                                <c:forEach items="${entResultInfoData}" var="entResultInfoData" varStatus="status">
                                                <td class="tar"><fmt:formatNumber value = "${entResultInfoData.SELNG_AM}" pattern = "#,##0.0"/></td>
                                                </c:forEach>
                                            </tr>
                                            <tr>
                                                <th scope="row">영업이익(억원)</th>
                                                <c:forEach items="${entResultInfoData}" var="entResultInfoData" varStatus="status">
                                                <td class="tar"><fmt:formatNumber value = "${entResultInfoData.BSN_PROFIT}" pattern = "#,##0.0"/></td>
                                                </c:forEach>
                                            </tr>
                                            <tr>
                                                <th scope="row">당기순이익(억원)</th>
                                                <c:forEach items="${entResultInfoData}" var="entResultInfoData" varStatus="status">
                                                <td class="tar"><fmt:formatNumber value = "${entResultInfoData.THSTRM_NTPF}" type="number" pattern = "#,##0.0"/></td>
                                                </c:forEach>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="part mgt30">
                                <div class="leftzone">
                                    <h4 class="mgb10">동종업종별 지표분석 (전산업 ${stsEntcls[1].ENTRPRS_CO}개, ${entprsInfo.INDUTY_NM } ${stsEntcls[0].ENTRPRS_CO})</h4>
									<div class="chart_box">
									<div class="part">
                               		 <div class="leftzone"  style="width: 49%" >
                                    <div id="placeholder_3" style="width: 90%; height: 200px; margin-left:20px;"></div>
                                    <div class="remark_s">
                                    	<ul>
                                    		<li class="remark1">${entprsInfo.ENTRPRS_NM }</li>
                                    		<li class="remark2">동종업종</li>
                                    		<li class="remark3">전산업</li>
                                    	</ul>
                                    </div>
                                    </div>
                                    <div class="rightzone" style="width: 49%">
                                    <div id="placeholder_4" style="width: 90%; height: 200px; margin-left:20px;"></div>
                                    <div class="remark_s">
                                    	<ul>
                                    		<li class="remark1">${entprsInfo.ENTRPRS_NM }</li>
                                    		<li class="remark2">동종업종</li>
                                    		<li class="remark3">전산업</li>
                                    	</ul>
                                    </div>
                                    </div>
      								</div>
      								</div>
                                    <table cellpadding="0" cellspacing="0" class="table_basic" summary="표로 보기">
                                        <caption>
                                        표로 보기
                                        </caption>
                                        <colgroup>
                                        <col width="20%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <thead>
                                            <tr>
                                                <th scope="col" class="tac">비고</th>
							                    <th scope="col" class="tac">매출액<br>(억원)</th>
							                    <th scope="col" class="tac">영업이익<br>(억원)</th>
							                    <th scope="col" class="tac">당기순이익<br>(억원)</th>
							                    <th scope="col" class="tac">고용(명)</th>
							                    <th scope="col" class="tac">R&amp;D집약도<br>(%)</th>          
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${stsEntcls }" var="stsEntcls" varStatus="status">
							            		<tr>
								                    <th>${remark[status.index] }</th>
								                    <td class="tar"><fmt:formatNumber value = "${stsEntcls.SELNG_AM }" pattern = "#,##0"/></td>
								                    <td class="tar"><fmt:formatNumber value = "${stsEntcls.BSN_PROFIT }" pattern = "#,##0"/></td>
								                    <td class="tar"><fmt:formatNumber value = "${stsEntcls.THSTRM_NTPF }" pattern = "#,##0"/></td>
								                    <td class="tar"><fmt:formatNumber value = "${stsEntcls.ORDTM_LABRR_CO }" pattern = "#,##0"/></td>
								                    <td class="tar">${stsEntcls.RND_CCTRR }</td>                    
								                </tr>
							            	</c:forEach> 
                                        </tbody>
                                    </table>
                                </div>
                                <div class="rightzone">
                                    <h4 class="mgb10">동종업종 상위 5개 기업 분석</h4>
                                    <div class="chart_box">
									<div class="part">
                               		 <div class="leftzone"  style="width: 49%" >
                                    <div id="placeholder_5" style="width: 90%; height: 200px; margin-left:20px;"></div>
                                    <div class="remark_s">
                                    	<ul>
                                    		<li class="remark1">${entprsInfo.ENTRPRS_NM }</li>
                                    		<li class="remark2">동종업종 상위 5개기업</li>
                                    	</ul>
                                    </div>
                                    </div>
                                    <div class="rightzone" style="width: 49%">
                                    <div id="placeholder_6" style="width: 90%; height: 200px; margin-left:20px;"></div>
                                    <div class="remark_s">
                                    	<ul>
                                    		<li class="remark1">${entprsInfo.ENTRPRS_NM }</li>
                                    		<li class="remark2">동종업종 상위 5개기업</li>
                                    	</ul>
                                    </div>
                                    </div>
         							</div>
         							</div>
                                    <table cellpadding="0" cellspacing="0" class="table_basic mgt30" summary="표로 보기">
                                        <caption>
                                        표로 보기
                                        </caption>
                                        <colgroup>
                                        <col width="20%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        <col width="16%" />
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th scope="col" class="tac">비고</th>
							                    <th scope="col" class="tac">매출액<br>(억원)</th>
							                    <th scope="col" class="tac">영업이익<br>(억원)</th>
							                    <th scope="col" class="tac">당기순이익<br>(억원)</th>
							                    <th scope="col" class="tac">고용(명)</th>
							                    <th scope="col" class="tac">R&amp;D집약도<br>(%)</th>     
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
							                    <th>${entprsInfo.ENTRPRS_NM }(총액)</th>
							                    <td class="tar"><fmt:formatNumber value = "${stsEntcls[0].SELNG_AM}" pattern = "#,##0"/></td>
							                    <td class="tar"><fmt:formatNumber value = "${stsEntcls[0].BSN_PROFIT}" pattern = "#,##0"/></td>
							                    <td class="tar"><fmt:formatNumber value = "${stsEntcls[0].THSTRM_NTPF}" pattern = "#,##0"/></td>
							                    <td class="tar"><fmt:formatNumber value = "${stsEntcls[0].ORDTM_LABRR_CO}" pattern = "#,##0"/></td>
							                    <td class="tar">${stsEntcls[0].RND_CCTRR}</td>                    
							                </tr>
							                <tr>
							                    <th>동종업종(평균)</th>
							                    <td class="tar"><fmt:formatNumber value = "${upperCmpnAvg.SELNG_AM}" pattern = "#,##0"/></td>
							                    <td class="tar"><fmt:formatNumber value = "${upperCmpnAvg.BSN_PROFIT}" pattern = "#,##0"/></td>
							                    <td class="tar"><fmt:formatNumber value = "${upperCmpnAvg.THSTRM_NTPF}" pattern = "#,##0"/></td>
							                    <td class="tar"><fmt:formatNumber value = "${upperCmpnAvg.ORDTM_LABRR_CO}" pattern = "#,##0"/></td>
							                    <td class="tar">${upperCmpnAvg.RND_CCTRR}</td>                    
              								</tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    </form>