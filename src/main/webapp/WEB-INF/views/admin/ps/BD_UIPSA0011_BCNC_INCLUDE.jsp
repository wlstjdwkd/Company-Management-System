<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
                    <!--// 리스트 -->
                    <div class="list_zone">                    	
                        <table cellpadding="0" cellspacing="0" class="table_search mgt20" summary="거래처정보" >
                            <caption>
                            거래처정보 리스트
                            </caption>
                            <colgroup>
	                        <col width="5%" />
	                        <col width="7%" />
	                        <col width="5%" />
	                        <col/>
	                        <col/>
	                        <col/>
	                        <col/>
	                        <col/>
	                        <col/>
	                        <col/>
	                        <col/>
	                        <col/>
	                        </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준년도</th>
                                    <th scope="col">거래처구분</th>
                                    <th scope="col">순위</th>
                                    <th scope="col">사업자번호</th>
                                    <th scope="col">업체명</th>
                                    <th scope="col">대표자명</th>
                                    <th scope="col">거래비중</th>
                                    <th scope="col">결산년</th>
                                    <th scope="col">자본금</th>
                                    <th scope="col">자산총계</th>
                                    <th scope="col">매출액</th>
                                    <th scope="col">순이익</th>
                                </tr>
                            </thead>
                            <tbody>
								<c:forEach items="${bcncResultInfo}" var="bcncData" varStatus="status">
								<tr>
									<td>${bcncData.STDYY}</td>
									<td>${bcncData.DELNG_NM}</td>
									<td>${bcncData.SN}</td>
									<td>${bcncData.BIZRNO}</td>
									<td>${bcncData.ENTRPRS_NM}</td>
									<td>${bcncData.RPRSNTV_NM}</td>
									<td>${bcncData.DELNG_RELIMP}</td>
									<td>${bcncData.PSACNT}</td>
									<td>${bcncData.CAPL}</td>
									<td>${bcncData.ASSETS_SM}</td>
									<td>${bcncData.SELNG_AM}</td>
									<td>${bcncData.NTPF}</td>
								</tr>								
								</c:forEach>
							</tbody>
						</table>                    	
					</div>
                    <!-- 리스트// -->