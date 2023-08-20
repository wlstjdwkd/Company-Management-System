<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@	taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
                    <!--// 리스트 -->
                    <div class="list_zone">                    	
                        <table cellpadding="0" cellspacing="0" class="table_search mgt20" summary="판정정보" >
                            <caption>
                            판정정보 리스트
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
	                        <col/>
	                        <col/>
	                        </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준년도</th>
                                    <th scope="col">주업종</th>
                                    <th scope="col">판정결과</th>
                                    <th scope="col">규모기준</th>
                                    <th scope="col">상한_천명</th>
                                    <th scope="col">상한자산</th>
                                    <th scope="col">상한자본</th>
                                    <th scope="col">상한3년매출</th>
                                    <th scope="col">독립성직접30</th>
                                    <th scope="col">독립성간접30</th>
                                    <th scope="col">독립성_관계기업</th>
                                    <th scope="col">상호출자제한</th>
                                    <th scope="col">금융업_보험업</th>
                                    <th scope="col">중소기업</th>
                                    <th scope="col">유예기업1</th>
                                    <th scope="col">유예기업2</th>
                                    <th scope="col">유예기업3</th>
                                    <th scope="col">제외법인</th>
                                    <th scope="col">외국계대기업</th>
                                </tr>
                            </thead>
                            <tbody>                            	
								<c:forEach items="${jdgmntResultInfo}" var="jdgmntData" varStatus="status">
								<tr>
									<td>${jdgmntData.STDYY}</td>
									<td>${jdgmntData.KOREAN_NM}</td>
									<c:if test="${jdgmntData.JDGMNT_NM eq '기업'}">
										<td class="bold" style="color:#00F;">${jdgmntData.JDGMNT_NM}</td>
									</c:if>
									<c:if test="${jdgmntData.JDGMNT_NM ne '기업'}">
										<td>${jdgmntData.JDGMNT_NM}</td>
									</c:if>
									<td>${jdgmntData.SCALE_STDR}</td>
									<td>${jdgmntData.UPLMT_1000}</td>
									<td>${jdgmntData.UPLMT_ASSETS}</td>
									<td>${jdgmntData.UPLMT_CAPL}</td>
									<td>${jdgmntData.UPLMT_SELNG_3Y}</td>
									<td>${jdgmntData.INDPNDNCY_DIRECT_30}</td>
									<td>${jdgmntData.INDPNDNCY_INDRT_30}</td>
									<td>${jdgmntData.INDPNDNCY_RCPY}</td>
									<td>${jdgmntData.MTLTY_INVSTMNT_LMTT}</td>
									<td>${jdgmntData.FNCBIZ_ISCS}</td>
									<td>${jdgmntData.SMLPZ}</td>
									<td>${jdgmntData.POSTPNE_ENTRPRS1}</td>
									<td>${jdgmntData.POSTPNE_ENTRPRS2}</td>
									<td>${jdgmntData.POSTPNE_ENTRPRS3}</td>
									<td>${jdgmntData.EXCL_CPR}</td>
									<td>${jdgmntData.FRNTN_SM_LTRS}</td>
								</tr>								
								</c:forEach>						   		
							</tbody>
						</table>                    	
					</div>
                    <!-- 리스트// -->