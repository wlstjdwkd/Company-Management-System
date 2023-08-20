<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
                    <!--// 리스트 -->
                    <div class="list_zone">                    	
                        <table cellpadding="0" cellspacing="0" class="table_search mgt20" summary="검색어 기업형태 판정사유 별로 검색조건을 입력하는 표" >
                            <caption>
                            재무정보 리스트
                            </caption>
                            <colgroup>
	                        <col width="10%" />
	                        <col width="15%" />
	                        <col width="15%" />
	                        <col width="15%" />
	                        <col width="15%" />
	                        <col width="15%" />
	                        <col width="15%" />
	                        </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준년도</th>
                                    <th scope="col">종업원수(명)</th>
                                    <th scope="col">자산총계(천)</th>
                                    <th scope="col">자본총계(천)</th>
                                    <th scope="col">매출액(천)</th>
                                    <th scope="col">당기순이익(천)</th>
                                    <th scope="col">영업이익(천)</th>
                                </tr>
                            </thead>
                            <tbody>                           	                           
								<c:forEach items="${fnnrResultInfo}" var="fnnrData" varStatus="status">
								<tr>
									<td>${fnnrData.STDYY}</td>
									<td><fmt:formatNumber value="${fnnrData.ORDTM_LABRR_CO}" /></td>
									<td><fmt:formatNumber value="${fnnrData.ASSETS_SM}" /></td>
									<td><fmt:formatNumber value="${fnnrData.CAPL_SM}" /></td>
									<td><fmt:formatNumber value="${fnnrData.SELNG_AM}" /></td>
									<td><fmt:formatNumber value="${fnnrData.THSTRM_NTPF}" /></td>
									<td><fmt:formatNumber value="${fnnrData.BSN_PROFIT}" /></td>
								</tr>					
								</c:forEach>
							</tbody>
						</table>                    	
					</div>
                    <!-- 리스트// -->
