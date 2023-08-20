<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
                    <!--// 리스트 -->
                    <div class="list_zone">                    	
                        <table cellpadding="0" cellspacing="0" class="table_search mgt20" summary="특허정보" >
                            <caption>
                            특허정보 리스트
                            </caption>
                            <colgroup>
	                        <col width="20%" />
	                        <col width="40%" />
	                        <col width="40%" />
	                        </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준년도</th>
                                    <th scope="col">국내특허등록권</th>
                                    <th scope="col">국내출원특허권</th>
                                </tr>
                            </thead>
                            <tbody>
								<c:forEach items="${patentResultInfo}" var="patentData" varStatus="status">
								<tr>
									<td>${patentData.STDYY}</td>
									<td>${patentData.DMSTC_PATENT_REGIST_VLM}</td>
									<td>${patentData.DMSTC_APLC_PATNTRT}</td>
								</tr>								
								</c:forEach>
							</tbody>
						</table>                    	
					</div>
                    <!-- 리스트// -->
