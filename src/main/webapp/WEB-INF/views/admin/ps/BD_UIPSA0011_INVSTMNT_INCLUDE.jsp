<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
                    <!--// 리스트 -->
                    <div class="list_zone">                    	
                        <table cellpadding="0" cellspacing="0" class="table_search mgt20" summary="출자/피출자" >
                            <caption>
                            출자/피출자 리스트
                            </caption>
                            <colgroup>
	                        <col width="10%" />
	                        <col width="15%" />
	                        <col width="15%" />
	                        <col width="20%" />
	                        <col width="20%" />
	                        <col width="20%" />
	                        </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준년도</th>
                                    <th scope="col">출자구분</th>
                                    <th scope="col">업체명</th>
                                    <th scope="col">법인번호</th>
                                    <th scope="col">사업자번호</th>
                                    <th scope="col">지분율</th>
                                </tr>
                            </thead>
                            <tbody>
								<c:forEach items="${invstmntResultInfo}" var="invstmntData" varStatus="status">
								<tr>
									<td>${invstmntData.STDYY}</td>
									<td>${invstmntData.INVSTMNT_NM}</td>
									<td>${invstmntData.ENTRPRS_NM}</td>
									<td>${fn:substring(invstmntData.JURIRNO, 0, 6) }-${fn:substring(invstmntData.JURIRNO, 6, 13) }</td>
									<td>${fn:substring(invstmntData.BIZRNO, 0, 3) }-${fn:substring(invstmntData.BIZRNO, 3, 5) }-${fn:substring(invstmntData.BIZRNO, 5, 10) }</td>
									<td>${invstmntData.QOTA_RT}</td>
								</tr>								
								</c:forEach>
							</tbody>
						</table>                    	
					</div>
                    <!-- 리스트// -->
