<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<title>고객지원</title>
<ap:jsTag type="web" items="jquery,tools,ui" />
<ap:jsTag type="tech" items="util,mv" />
<script type="text/javascript">
	$(document).ready(function() {
		$("#btn_get_list").click(function() {
			$("#df_method_nm").val("index");
			$("#dataForm").submit();
		});

	});

	function fn_notice_info(seq) {
		document.getElementById("df_method_nm").value = "noticeForm";
		document.getElementById("ad_listSeq").value = seq;
		document.dataForm.submit();
	}
	
	//첨부파일 다운로드
	function downAttFile(fileId){
		jsFiledownload("/PGCM0040.do","df_method_nm=updateFileDown&id="+fileId);
	}
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}' />" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<input type="hidden" name="ad_listSeq" id="ad_listSeq" />

		<!--//내용영역-->
		<section class="notice">
			<div class="sub_con">
				<!--//본문-->
				<div class="tit">
					<p>${noticeList.title}</p>
					<span>작성일1 : ${noticeList.regDt}</span>
				</div>
				<div class="read">
				<!--  -->
					<%-- ${noticeList.contents} --%>
					<table>
                  <tbody>                        
                     
                     <tr>
                        <td class="cont" id="emailCnHtml"></td>
                               <input type="hidden" id="email_cn_html" value="${noticeList.contents }" />
                               <script type="text/javascript">$("#emailCnHtml").html($("#email_cn_html").val());</script>
                     </tr>
                     
                  </tbody>
               </table>
				<!--  -->
					<c:if test="${!empty noticeList.fileList}">
						<br />
						<br />
						<br />
						첨부파일 : 
						<ul>
							<c:choose>
								<c:when test="${fn:length(noticeList.fileList) > 0}">
									<c:forEach items="${noticeList.fileList}" var="fileVo">
										<li>
											<a href="#none" onclick="downAttFile('${fileVo.fileId}')" class="dw_fild" title="${fileVo.fileDesc}">
												<img src="<c:url value="/images/ucm/icon_file.png" />" alt="파일" />
												${fileVo.localNm}
											</a>
											[${fileVo.fileSize} byte]
										</li>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<li>첨부파일이 없습니다.</li>
								</c:otherwise>
							</c:choose>
						</ul>
					</c:if>
				</div>
				<!--//본문-->

				<!--//버튼-->
				<div class="btn">
					<a href="#none" id="btn_get_list" class="btn_blue">목록</a>
				</div>
				<!--버튼//-->

				<!--//글목록-->
				<div class="simply_list">
					<dl>
						<dt>다음글</dt>
						<dd>
							<c:if test="${empty noticeList.nextVO}">다음글이 없습니다</c:if>
							<c:if test="${!empty noticeList.nextVO}">
								<a href="#none" onclick="fn_notice_info('${noticeList.nextVO.seq}')">
									${noticeList.nextVO.title}
									<c:if test="${noticeList.nextVO.fileCnt > 0}">
										<span class="t_file" title="첨부파일이 ${noticeList.nextVO.fileCnt}개 존재합니다.">(${noticeList.nextVO.fileCnt})</span>
									</c:if>
								</a>
							</c:if>
						</dd>
					</dl>
					<dl>
						<dt>이전글</dt>
						<dd>
							<c:if test="${empty noticeList.prevVO}">이전글이 없습니다.</c:if>
							<c:if test="${!empty noticeList.prevVO}">
								<a href="#none" onclick="fn_notice_info('${noticeList.prevVO.seq}')">
									${noticeList.prevVO.title}
									<c:if test="${noticeList.prevVO.fileCnt > 0}">
										<span class="t_file" title="첨부파일이 ${noticeList.prevVO.fileCnt}개 존재합니다.">(${noticeList.prevVO.fileCnt})</span>
									</c:if>
								</a>
							</c:if>
						</dd>
					</dl>
				</div>
				<!--글목록//-->
			</div>
		</section>
		<!--내용영역//-->
	</form>
</body>
</html>