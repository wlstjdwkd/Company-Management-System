<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
                    <!--// 리스트 -->
                    <div class="list_zone">                    	
                        <table cellpadding="0" cellspacing="0" class="table_search mgt20" summary="기업 수출정보" >
                            <caption>
                            수출정보 리스트
                            </caption>
                            <colgroup>
	                        <col width="20%" />
	                        <col width="25%" />
	                        <col width="25%" />
	                        <col width="25%" />
	                        </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준년도</th>
                                    <th scope="col">수출액(원화)</th>
                                    <th scope="col">수출액(달러화)</th>
                                    <th scope="col">년평균환율(원달러)</th>
                                </tr>
                            </thead>
                            <tbody>
								<c:forEach items="${patentExpInfo}" var="patentExpData" varStatus="status">
								<tr>
									<td>${patentExpData.STDYY}</td>
									<td><fmt:formatNumber value="${patentExpData.XPORT_AM_WON}" /></td>
									<td><fmt:formatNumber value="${patentExpData.XPORT_AM_DOLLAR}" /></td>
									<td>${patentExpData.EHGT_USD}</td>
								</tr>								
								</c:forEach>
							</tbody>
						</table>                    	
					</div>
                    <!-- 리스트// -->
