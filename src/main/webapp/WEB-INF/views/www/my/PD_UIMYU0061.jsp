<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<c:set var="entUserVo" value="${sessionScope[SESSION_ENTUSERINFO_NAME]}" />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,tools,ui,form,validate,notice,msgBox,mask,colorbox" />
<ap:jsTag type="tech" items="msg,util,ucm,my" />

<script type="text/javascript">

//첨부파일 다운로드
function downAttFile(fileSeq){
	jsFiledownload("/PGCM0040.do","df_method_nm=updateFileDownBySeq&seq="+fileSeq);
}

</script>

</head>
<body>

<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">

<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />
<input type="hidden" id="no_lnb" value="true" />
<div id="self_dgs">
	<div class="pop_q_con">
		 <div class="type_zone">
                <c:set var="lastYear" value="${applyEntInfo['applyMaster']['JDGMNT_REQST_YEAR']}" />
                <div class="my_info">
                    <h4>기업정보</h4>
                    <table cellpadding="0" cellspacing="0" class="table_basic pop_table" summary="기업정보">
                        <caption>
                        기업정보
                        </caption>
                        <colgroup>
                        <col style="width:20%" />
                        <col style="width:30%" />
                        <col style="width:20%" />
                        <col style="width:*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row" class="point">기업명</th>
                                <td>${applyEntInfo['reqstRcpyList']['ENTRPRS_NM']}</td>
                                <th scope="row" class="point">법인등록번호</th>
                                <td>${applyEntInfo['reqstRcpyList']['JURIRNO_FIRST']}-${applyEntInfo['reqstRcpyList']['JURIRNO_LAST']}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">대표자명</th>
                                <td>${applyEntInfo['issuBsisInfo']['RPRSNTV_NM']}</td>
                                <th scope="row" class="point">사업자등록번호</th>
                                <td>
                                    ${applyEntInfo['reqstRcpyList']['BIZRNO_FIRST']}-${applyEntInfo['reqstRcpyList']['BIZRNO_MIDDLE']}-${applyEntInfo['reqstRcpyList']['BIZRNO_LAST']} <br>
                                	<c:forEach items="${applyEntInfo['bizrnoFormatList']}" var="item" varStatus="status">
										${item.first}-${item.middle}-${item.last}<br>
									</c:forEach>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">본사주소</th>
                                <td colspan="3">
                                	<c:if test="${not empty applyEntInfo['issuBsisInfo']['ZIP_FIRST']}">
                                	${applyEntInfo['issuBsisInfo']['ZIP_FIRST']} &nbsp;
                                	</c:if>
                                	${applyEntInfo['issuBsisInfo']['HEDOFC_ADRES']}                            
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">표준산업분류코드</th>
                                <td>${lclasCd}${applyEntInfo['reqstRcpyList']['MN_INDUTY_CODE']}</td>
                                <th scope="row" class="point">주업종명</th>
                                <td>${applyEntInfo['reqstRcpyList']['MN_INDUTY_NM']}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">전화번호</th>
                                <td>
                                	${applyEntInfo['issuBsisInfo']['REPRSNT_TLPHON_FIRST']}
                                	- ${applyEntInfo['issuBsisInfo']['REPRSNT_TLPHON_MIDDLE']}
                                	- ${applyEntInfo['issuBsisInfo']['REPRSNT_TLPHON_LAST']}                         
                                </td>
                                <th scope="row" class="point">FAX번호</th>
                                <td>
                                	${applyEntInfo['issuBsisInfo']['FXNUM_FIRST']}
                                	- ${applyEntInfo['issuBsisInfo']['FXNUM_MIDDLE']}
                                	- ${applyEntInfo['issuBsisInfo']['FXNUM_LAST']}
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">결산월</th>
                                <td>${applyEntInfo['issuBsisInfo']['ACCT_MT']}월</td>
                                <th scope="row" class="point">설립년월</th>
                                <td>${applyEntInfo['reqstRcpyList']['FMT_FOND_DE']}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">용도(사업명)</th>
                                <td colspan="3">
                           			<ap:code id="" grpCd="85" selectedCd="${applyEntInfo['issuBsisInfo']['CHK_RECEPDSK']}" type="text"/>
                           			<c:if test="${!empty applyEntInfo['issuBsisInfo']['RECEPDSK']}">
                           				<span>기타 : ${applyEntInfo['issuBsisInfo']['RECEPDSK']}</span>
                           			</c:if>
                           		</td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">특이사항</th>
                                <td colspan="3">${applyEntInfo['reqstRcpyList']['PARTCLR_MATTER']}</td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <!--  -->
                    <h4 class="mgt30">지점 사업자등록증 첨부 </h4>
                    <table class="table_basic table_type">
                    <colgroup>
                            <col style="width:182px" />
                            <col style="width:*" />
                            </colgroup>
						<tbody>
							<tr>
		                        <th scope="row" class="point"><label for="file_ho_rf4"  >파일첨부</label></th>
		                        <td class="b_l_0" colspan="3">
		                        	<c:set var="reqstFileRF" value="${applyEntInfo['reqstFile'][lastYear.toString()]}" />                                            	
		                        	<c:if test="${!empty reqstFileRF['RF4']}">
			                        	<a href="#" class="dw_fild" onclick="downAttFile('${reqstFileRF['RF4']['FILE_SEQ']}')">${reqstFileRF['RF4']['LOCAL_NM']} </a>
		                        	</c:if>                                            	
		                        </td>
		                    </tr>
						</tbody>
					</table>
					
					<!--  -->
					
					<!--  -->
                    
                    <h4 class="mgt30">주주명부 </h4>
                    <table cellpadding="0" cellspacing="0" class="table_basic table_type" summary="지분 소유비율/제출서류/파일첨부" >
                        <caption>
                        입력게시판
                        </caption>
                        <colgroup>
                        <col style="width:18%" />
                        <col style="width:10%" />
                        <col style="width:22%" />
                        <col style="width:20%" />
                        <col style="width:30%" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th rowspan="3" scope="row" class="point">지분 소유비율<br/>
                                    (최대 3개 입력)</th>
                                <th scope="row" class="point"><label for="t2_info16"> 주주명</label></th>
                                <td>${applyEntInfo['reqstInfoQotaPosesn']['SHRHOLDR_NM1']}</td>
                                <th scope="row" class="point"><label for="t2_info17"> 지분소유비율</label></th>
                                <td>${applyEntInfo['reqstInfoQotaPosesn']['QOTA_RT1']}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="point"><label for="t2_info18"> 주주명</label></th>
                                <td>${applyEntInfo['reqstInfoQotaPosesn']['SHRHOLDR_NM2']}</td>
                                <th scope="row" class="point"><label for="t2_info19"> 지분소유비율</label></th>
                                <td>${applyEntInfo['reqstInfoQotaPosesn']['QOTA_RT2']}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="point"><label for="t2_info20"> 주주명</label></th>
                                <td>${applyEntInfo['reqstInfoQotaPosesn']['SHRHOLDR_NM3']}</td>
                                <th scope="row" class="point"><label for="t2_info21"> 지분소유비율</label></th>
                                <td>${applyEntInfo['reqstInfoQotaPosesn']['QOTA_RT3']}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="point" colspan="2">제출서류 1) </th>
                                <td colspan="3">
                                	<c:set var="reqstFileRF" value="${applyEntInfo['reqstFile'][lastYear.toString()]}" />
                                	<c:if test="${!empty reqstFileRF['RF2']}">
                                	<a href="#" class="dw_fild" onclick="downAttFile('${reqstFileRF['RF2']['FILE_SEQ']}')">${reqstFileRF['RF2']['LOCAL_NM']} </a>[${reqstFileRF['RF2']['FILE_SIZE']} byte]
                                	</c:if>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                                        
                    <h4 class="mgt30">재무정보</h4>
                    <c:set var="reqstFnnrData" value="${applyEntInfo['reqstFnnrData']}"/>
                    <span class="fr" style="margin-top:-22px;">
                    [단위 : 원]
                    <%-- <c:choose>
	                    <c:when test="${reqstFnnrData[(lastYear-n).toString()]['AMOUNT_UNIT'] eq 1}">
	                    [단위 : 원]
	                    </c:when>
	                    <c:otherwise>
	                    [단위 : 백만원]
	                    </c:otherwise>
                    </c:choose>  --%>
                    </span>
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="지표/매출액/영업이익/단기순이익/고용/R&D닙약도/인건비">
                            <caption>
                            목록게시판
                            </caption>
                            <colgroup>
                            <col style="width:105px" />
                            <col style="width:105px" />
                            <col style="width:105px" />
                            <col style="width:105px" />
                            <col style="width:105px" />
                            <col style="width:105px" />
                            <col style="width:*" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">&nbsp;</th>
                                    <th scope="col">매출액</th>
                                    <th scope="col">자본금</th>
                                    <th scope="col">자본잉여금</th>
                                    <th scope="col">자본총계</th>
                                    <th scope="col">자산총액</th>
                                    <th scope="col">상시근로자수</th>
                                </tr>
                            </thead>
                            <tbody>
                            	<c:forEach var="n" begin="0" end="3">
                            		<c:set var="year" value="${lastYear-n}" />
                            		<tr>
	                                    <th scope="row">${year}년</th>
	                                    <td class="tar"><fmt:formatNumber value = "${reqstFnnrData[year.toString()]['SELNG_AM']}" pattern = "#,##0"/></td>
	                                    <td class="tar"><fmt:formatNumber value = "${reqstFnnrData[year.toString()]['CAPL']}" pattern = "#,##0"/></td>
	                                    <td class="tar"><fmt:formatNumber value = "${reqstFnnrData[year.toString()]['CLPL']}" pattern = "#,##0"/></td>
	                                    <td class="tar"><fmt:formatNumber value = "${reqstFnnrData[year.toString()]['CAPL_SM']}" pattern = "#,##0"/></td>
	                                    <td class="tar"><fmt:formatNumber value = "${reqstFnnrData[year.toString()]['ASSETS_TOTAMT']}" pattern = "#,##0"/></td>
	                                    <td class="tar"><fmt:formatNumber value = "${reqstFnnrData[year.toString()]['ORDTM_LABRR_CO']}" pattern = "#,##0"/></td>
	                                </tr>
                            	</c:forEach>                                
                            </tbody>
                        </table>
                    </div>
                    <div class="write mgt12">
                        <table cellpadding="0" cellspacing="0" class="table_basic table_type" summary="제출서류/2011년/2012년/2013년/2014년" >
                            <caption>
                            년도별제출서류입력테이블
                            </caption>
                            <colgroup>
                            <col style="width:105px" />
                            <col style="width:105px" />
                            <col style="width:*" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th class="point" scope="row">제출서류2)</th>
                                    <th class="point" scope="row">국내법인</th>
                                    <td>직전 3개 사업연도 감사보고서 원본1부</td>
                                </tr>
                                <c:forEach var="n" begin="0" end="3">
					        		<c:set var="year" value="${lastYear-n}" />
					        		<tr>
	                                    <th colspan="2" scope="row" class="point"> ${year }년</th>
	                                    <td>
	                                    	<c:set var="reqstFileRF" value="${applyEntInfo['reqstFile'][year.toString()]}" />
	                                    	<c:if test="${!empty reqstFileRF['RF1']}">
	                                    		<a href="#none" class="dw_fild" onclick="downAttFile('${reqstFileRF['RF1']['FILE_SEQ']}')">${reqstFileRF['RF1']['LOCAL_NM']} </a>[${reqstFileRF['RF1']['FILE_SIZE']}byte]
	                                    	</c:if>	                                    	
	                                    </td>
	                                </tr>
					        	</c:forEach>                               
                            </tbody>
                        </table>
                    </div>
                    
                    <!--  -->
                     <h4 class="mgt30">기타 제출 서류 </h4>
                    <table class="table_basic table_type">
                    	<colgroup>
                            <col style="width:210px" />
                            <col style="width:*" />
                         </colgroup>
						<tbody>
							<tr>
		                        <th scope="row" class="point" ><label for="file_ho_rf3"  >파일첨부</label></th>
                                <td >
		                        	<c:set var="reqstFileRF" value="${applyEntInfo['reqstFile'][lastYear.toString()]}" />                                            	
		                        	<c:if test="${!empty reqstFileRF['RF3']}">
			                        	<a href="#" class="dw_fild" onclick="downAttFile('${reqstFileRF['RF3']['FILE_SEQ']}')">${reqstFileRF['RF3']['LOCAL_NM']} </a>
		                        	</c:if>                                            	
		                        </td>
		                    </tr>
						</tbody>
					</table>
                    <!--  -->
                    
                    <div class="table_hrz">
                        <h4 class="mgt30">상시근로자수</h4>
                        <p class="mb7">매월말일 기준의 상시근로자수<span class="fr">[단위 : 명]</span></p>
                        <table cellpadding="0" cellspacing="0" class="table_basic" summary="매출액(천원)/자본금(천원)/자본잉여금(천원)/자본총계(천원)/자산총액(천원)/상시근로자수" >
                            <caption>
                            재무정보년도별입력테이블
                            </caption>
                            <colgroup>
                            <col style="width:105px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />            
                            <col style="width:*" />
                            <col style="width:56px" />
                            </colgroup>
                            <thead>
                            	<tr>
	                         	   <th>&nbsp;</th>
	                                <th>1</th>
	                                <th>2</th>
	                                <th>3</th>
	                                <th>4</th>
	                                <th>5</th>
	                                <th>6</th>
	                                <th>7</th>
	                                <th>8</th>
	                                <th>9</th>
	                                <th>10</th>
	                                <th>11</th>
	                                <th>12</th>
	                                <th>합계</th>
	                                <th>연평균</th>
                            	</tr>
                            </thead>
                            <tbody>
                            	<c:forEach var="n" begin="0" end="3">
					        	<c:set var="year" value="${lastYear-n}" />
					        	<c:if test="${year<=2013}" >				        	
                                <tr>
                                    <th scope="row"><label>${year}년</label></th>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO1']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO2']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO3']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO4']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO5']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO6']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO7']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO8']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO9']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO10']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO11']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO12']}" pattern = "#,##0"/></td>                                    
                                    <td><strong><fmt:formatNumber value = "${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO_SM']}" pattern = "#,##0"/></strong></td>
                                    <td><strong><fmt:formatNumber value = "${reqstOrdtmLabrr[year.toString()]['ORDTM_LABRR_CO']}" pattern = "#,##0"/></strong></td>
                                </tr>
                                </c:if>
                                </c:forEach>                                
                                <tr>
                                    <th scope="row">제출서류3)</th>
                                    <td colspan="14" class="tal">월별 원천징수이행상황신고서 원본1부 </td>
                                </tr>
                                <c:forEach var="n" begin="0" end="3">
				        		<c:set var="year" value="${lastYear-n}" />
				        		<c:if test="${year<=2013}" >
				        		<tr>
                                    <th scope="row"><label>${year}년</label></th>
                                    <td colspan="14" class="tal">
                                    <c:set var="reqstFileRF" value="${applyEntInfo['reqstFile'][year.toString()]}" />
                                    <c:if test="${!empty reqstFileRF['RF0']}">
                                    	<a href="#" class="dw_fild" onclick="downAttFile('${reqstFileRF['RF0']['FILE_SEQ']}')">${reqstFileRF['RF0']['LOCAL_NM']} </a>[${reqstFileRF['RF0']['FILE_SIZE']} byte]
                                    </c:if>                                    
                                    </td>
                                </tr>
				        		</c:if>
				        		</c:forEach>					        	
                            </tbody>
                        </table>
                    </div>
                    
                    
					
                    <h4 class="mgt30">중소기업유예확인정보 </h4>
                    <table cellpadding="0" cellspacing="0" class="table_basic table_type" summary="파일첨부" >
                        <caption>
                        중소기업유예확인정보
                        </caption>
                        <colgroup>
                        <col style="width:28%" />
                        <col style="width:72%" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row" class="point">제출서류 </th>
                                <td>
                                	<c:set var="reqstFileRF" value="${applyEntInfo['reqstFile'][lastYear.toString()]}" />
                                	<c:if test="${!empty reqstFileRF['RF5']}">
                                	<a href="#" class="dw_fild" onclick="downAttFile('${reqstFileRF['RF5']['FILE_SEQ']}')">${reqstFileRF['RF5']['LOCAL_NM']} </a>[${reqstFileRF['RF5']['FILE_SIZE']} byte]
                                	</c:if>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <!--//관계기업정보-->
                    <c:forEach var="relateEntInfo" items="${relateEntInfos}" varStatus="status">
               		<c:set var="reqstFileRelate" value="${relateEntInfo['reqstFileRelate']}" />
               		<c:set var="reqstRcpyListRelate" value="${relateEntInfo['reqstRcpyListRelate']}" />
			    	<c:set var="addRcpyId" value="${reqstRcpyListRelate['SN']}" />
                    <h4 class="mgt30">관계기업${status.index + 1 }</h4>
                    
                    <!--// 1.기업정보-->
                    <table cellpadding="0" cellspacing="0" class="table_basic pop_table" summary="관계기업정보">
                        <caption>
                        관계기업정보
                        </caption>
                        <colgroup>
                        <col style="width:20%" />
                        <col style="width:30%" />
                        <col style="width:20%" />
                        <col style="width:30%" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row" class="point">관계기업구분</th>
                                <td>${reqstRcpyListRelate['RCPY_DIV_NM']}</td>
                                <th scope="row" class="point">지분율</th>
                                <td>${reqstRcpyListRelate['QOTA_RT']}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">기업명</th>
                                <td>${reqstRcpyListRelate['ENTRPRS_NM']}</td>
                                <th scope="row" class="point">법인등록구분</th>
                                <td>
                                	<c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'L'}">국내기업</c:if>
                                	<c:if test="${reqstRcpyListRelate['CPR_REGIST_SE'] eq 'F'}">해외기업</c:if>
                                	&nbsp;&nbsp;통화 : ${reqstRcpyListRelate['CRNCY_CODE_NM']}
                                </td>
                            </tr>
                            <tr>
		                        <th scope="row" class="point">대표자명</th>                        
		                        <td colspan="3">
		                        ${reqstRcpyListRelate['RPRSNTV_NM']}
		                        </td>
		                    </tr>
                            <tr>
                                <th scope="row" class="point">법인등록번호</th>
                                <td>${reqstRcpyListRelate['JURIRNO_FIRST']}-${reqstRcpyListRelate['JURIRNO_LAST']}</td>
                                <th scope="row" class="point">사업자등록번호</th>
                                <td>${reqstRcpyListRelate['BIZRNO_FIRST']}-${reqstRcpyListRelate['BIZRNO_MIDDLE']}-${reqstRcpyListRelate['BIZRNO_LAST']}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">표준산업분류코드</th>
                                <td>${reqstRcpyListRelate['MN_INDUTY_CODE']}</td>
                                <th scope="row" class="point">주업종명</th>
                                <td>${reqstRcpyListRelate['MN_INDUTY_NM']}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">결산월</th>
                                <td>${reqstRcpyListRelate['ACCT_MT']}월</td>
                                <th scope="row" class="point">설립년월</th>
                                <td>${reqstRcpyListRelate['FMT_FOND_DE']}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="point">특이사항</th>
                                <td colspan="3">${reqstRcpyListRelate['PARTCLR_MATTER']}</td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <!--// 2.주주명부-->
                    <c:set var="reqstInfoQotaPosesnRelate" value="${relateEntInfo['reqstInfoQotaPosesnRelate']}" />
                    <table cellpadding="0" cellspacing="0" class="table_basic table_type mgt12" summary="지분 소유비율/제출서류/파일첨부" >
                        <caption>
                        지분소유비율
                        </caption>
                        <colgroup>
                        <col style="width:18%" />
                        <col style="width:10%" />
                        <col style="width:22%" />
                        <col style="width:20%" />
                        <col style="width:30%" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th rowspan="3" scope="row" class="point">지분 소유비율</th>
                                <th scope="row" class="point"><label for="t2_info16"> 주주명</label></th>
                                <td>${reqstInfoQotaPosesnRelate['SHRHOLDR_NM1']}</td>
                                <th scope="row" class="point"><label for="t2_info17"> 지분소유비율</label></th>
                                <td>${reqstInfoQotaPosesnRelate['QOTA_RT1']}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="point"><label for="t2_info18"> 주주명</label></th>
                                <td>${reqstInfoQotaPosesnRelate['SHRHOLDR_NM2']}</td>
                                <th scope="row" class="point"><label for="t2_info19"> 지분소유비율</label></th>
                                <td>${reqstInfoQotaPosesnRelate['QOTA_RT2']}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="point"><label for="t2_info20"> 주주명</label></th>
                                <td>${reqstInfoQotaPosesnRelate['SHRHOLDR_NM3']}</td>
                                <th scope="row" class="point"><label for="t2_info21"> 지분소유비율</label></th>
                                <td>${reqstInfoQotaPosesnRelate['QOTA_RT3']}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="point" colspan="2">제출서류 1) </th>
                                <td colspan="3">
                                	<c:set var="reqstFileRF" value="${reqstFileRelate[lastYear.toString()]}" />
                                	<c:if test="${!empty reqstFileRF['RF2']}">
                                	<a href="#none" class="dw_fild" onclick="downAttFile('${reqstFileRF['RF2']['FILE_SEQ']}')">${reqstFileRF['RF2']['LOCAL_NM']} </a>[${reqstFileRF['RF2']['FILE_SIZE']} byte]
                                	</c:if>                                
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <!-- // 3.매출액 -->
                    <c:set var="reqstFnnrDataRelate" value="${relateEntInfo['reqstFnnrDataRelate']}" />
                    <div class="table_hrz mgt12">
                        <table cellpadding="0" cellspacing="0" class="table_basic table_type" summary="매출액/년도별/합계/3년평균" >
                            <caption>
                            매출액입력
                            </caption>
                            <colgroup>
                            <col style="width:16%" />
                            <col style="width:16%" />
                            <col style="width:16%" />
                            <col style="width:16%" />
                            <col style="width:*" />
                            <col style="width:16%" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th rowspan="2" scope="col">매출액(원)</th>
                                    
                                    <c:forEach var="n" begin="0" end="2">
			        				<c:set var="year" value="${lastYear-n}" />
			        					<th scope="col"><label> ${year}년</label></th>
			        				</c:forEach>                        
                                    <th scope="col"> 합계</th>
                                    
                                    <th scope="col"> 3년 평균</th>
                                    
                                </tr>
                                <tr>
                                	<c:forEach var="n" begin="0" end="2">
			        				<c:set var="year" value="${lastYear-n}" />
                                	<td width="1" height="1"><fmt:formatNumber value = "${reqstFnnrDataRelate[year.toString()]['SELNG_AM']}" pattern = "#,##0"/></td>
                                	</c:forEach>   
                                	<td><fmt:formatNumber value = "${reqstFnnrDataRelate[lastYear.toString()]['Y3SUM_SELNG_AM']}" pattern = "#,##0"/></td>
                                	<td><fmt:formatNumber value = "${reqstFnnrDataRelate[lastYear.toString()]['Y3AVG_SELNG_AM']}" pattern = "#,##0"/></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    
                    <!--// 4.재무정보-->	
                    <div class="list_zone mgt12">
                        <table cellspacing="0" border="0" summary="지표/매출액/영업이익/단기순이익/고용/R&D닙약도/인건비">
                            <caption>
                            목록게시판
                            </caption>
                            <colgroup>
                            <col style="width:87px" />
                          	<col style="width:140px" />
                            <col style="width:140px" />
                            <col style="width:140px" />
                            <col style="width:140px" />
                            <col style="width:*" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">&nbsp;</th>
                                    <th scope="col">자본금</th>
                                    <th scope="col">자본잉여금</th>
                                    <th scope="col">자본총계</th>
                                    <th scope="col">자산총액</th>
                                    <th scope="col">상시근로자수</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th>${lastYear}</th>
                                    <td class="tar">
                                    	<fmt:formatNumber value = "${reqstFnnrDataRelate[lastYear.toString()]['CAPL']}" pattern = "#,##0"/>
                                    	<c:choose>
										<c:when test="${reqstRcpyListRelate['CRNCY_CODE'] eq 'KRW'}">
										(원)
										</c:when>       
										<c:otherwise>
										(${reqstRcpyListRelate['CRNCY_CODE']})
										</c:otherwise>
										</c:choose>
                                    </td>
                                    <td class="tar">
                                    	<fmt:formatNumber value = "${reqstFnnrDataRelate[lastYear.toString()]['CLPL']}" pattern = "#,##0"/>
                                    	<c:choose>
										<c:when test="${reqstRcpyListRelate['CRNCY_CODE'] eq 'KRW'}">
										(원)
										</c:when>
										<c:otherwise>
										(${reqstRcpyListRelate['CRNCY_CODE']})
										</c:otherwise>
										</c:choose>
                                    </td>
                                    <td class="tar">
                                    	<fmt:formatNumber value = "${reqstFnnrDataRelate[lastYear.toString()]['CAPL_SM']}" pattern = "#,##0"/>
                                    	<c:choose>
										<c:when test="${reqstRcpyListRelate['CRNCY_CODE'] eq 'KRW'}">
										(원)
										</c:when>       
										<c:otherwise>
										(${reqstRcpyListRelate['CRNCY_CODE']})
										</c:otherwise>
										</c:choose>
                                    </td>
                                    <td class="tar">
                                    	<fmt:formatNumber value = "${reqstFnnrDataRelate[lastYear.toString()]['ASSETS_TOTAMT']}" pattern = "#,##0"/>
                                    	<c:choose>
										<c:when test="${reqstRcpyListRelate['CRNCY_CODE'] eq 'KRW'}">
										(원)
										</c:when>       
										<c:otherwise>
										(${reqstRcpyListRelate['CRNCY_CODE']})
										</c:otherwise>
										</c:choose>
                                    </td>
                                    <td class="tar"><fmt:formatNumber value = "${reqstFnnrDataRelate[lastYear.toString()]['ORDTM_LABRR_CO']}" pattern = "#,##0"/></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="write mgt12">
                        <table cellpadding="0" cellspacing="0" class="table_basic table_type" summary="제출서류/2011년/2012년/2013년/2014년" >
                            <caption>
                            년도별제출서류입력테이블
                            </caption>
                            <colgroup>
                            <col style="width:20%" />
	                        <col style="width:80%" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th class="point" scope="row">제출서류2)</th>
                                    <td >직전 3개 사업연도 감사보고서 원본1부 </td>
                                </tr>
                                <c:forEach var="n" begin="0" end="3">
			        			<c:set var="year" value="${lastYear-n}" />
			        				<tr>
	                                    <th scope="row" class="point"><label for="add_t3_info6"> ${year}년</label></th>
	                                    <td>
	                                    	<c:set var="reqstFileRF" value="${reqstFileRelate[year.toString()]}" />
	                                    	<c:if test="${!empty reqstFileRF['RF1']}">
	                                    	<a href="#none" class="dw_fild" onclick="downAttFile('${reqstFileRF['RF1']['FILE_SEQ']}')">${reqstFileRF['RF1']['LOCAL_NM']} </a>[${reqstFileRF['RF1']['FILE_SIZE']} byte]
	                                    	</c:if>	                                    	
	                                    </td>
	                                </tr>
			        			</c:forEach>                                
                            </tbody>
                        </table>
                    </div>
                    
                    <!--// 5.상시근로자수-->
                    <c:set var="reqstOrdtmLabrrRelate" value="${relateEntInfo['reqstOrdtmLabrrRelate']}" />
			    	<c:if test="${lastYear <= 2013}">
                    <div class="mgt10"></div>
                    <div class="table_hrz">
                        <p class="mb7"><span class="fr">[단위 : 명]</span></p>
                        <table cellpadding="0" cellspacing="0" class="table_basic" summary="테이블" >
                            <caption>
                            테이블
                            </caption>
                            <colgroup>
                            <col style="width:105px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:45px" />
                            <col style="width:*" />
                            <col style="width:56px" />
                            </colgroup>
                            <thead>
                            	<tr>
                            		<th>&nbsp;</th>
	                                <th>1</th>
	                                <th>2</th>
	                                <th>3</th>
	                                <th>4</th>
	                                <th>5</th>
	                                <th>6</th>
	                                <th>7</th>
	                                <th>8</th>
	                                <th>9</th>
	                                <th>10</th>
	                                <th>11</th>
	                                <th>12</th>
	                                <th>합계</th>
	                                <th>연평균</th>
	                        	</tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th scope="row"><label for="">${lastYear}</label></th>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO1']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO2']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO3']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO4']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO5']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO6']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO7']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO8']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO9']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO10']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO11']}" pattern = "#,##0"/></td>
                                    <td><fmt:formatNumber value = "${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO12']}" pattern = "#,##0"/></td>
                                    <td><strong><fmt:formatNumber value = "${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO_SM']}" pattern = "#,##0"/></strong></td>
                                    <td><strong><fmt:formatNumber value = "${reqstOrdtmLabrrRelate[lastYear.toString()]['ORDTM_LABRR_CO']}" pattern = "#,##0"/></strong></td>
                                </tr>
                                <tr>
                                    <th scope="row">제출서류3)</th>
                                    <td colspan="14" class="tal">월별 원천징수이행상황신고서 원본1부 </td> 
                                </tr>
                                <tr>
                                	<th scope="row">${lastYear}년</th>
                                    <td colspan="14" class="tal">
                                    	<c:set var="reqstFileRF" value="${reqstFileRelate[lastYear.toString()]}" />
                                    	<c:if test="${!empty reqstFileRF['RF0']}">
                                    	<a href="#none" class="dw_fild" onclick="downAttFile('${reqstFileRF['RF0']['FILE_SEQ']}')">${reqstFileRF['RF0']['LOCAL_NM']} </a>[${reqstFileRF['RF0']['FILE_SIZE']} byte]
                                    	</c:if>                                    	
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    </c:if>
                    </c:forEach>
                </div>
 
		</div>
	</div>
</div>
</form>

</body>
</html>