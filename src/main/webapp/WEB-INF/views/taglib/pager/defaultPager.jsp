<%@ page pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<div class="paginate">
<c:if test="${!pager.isNowFirst()}">

	<c:choose>
	<c:when test="${empty addJsParam}">
		<a href="#none" onclick="${movePageScript}(${pager.firstPageNo})" class="pre_end"><img src="<c:url value="/images2/sub/btn_page_pre_end.png" />" alt="처음"></a><a href="#none" onclick="${movePageScript}(${pager.prevPageNo})" class="pre"><img src="<c:url value="/images2/sub/btn_page_pre.png" />" alt="이전"></a>
	</c:when>
	<c:otherwise>
		<a href="#none" onclick="${movePageScript}(${pager.firstPageNo},${addJsParam})" class="pre_end"><img src="<c:url value="/images2/sub/btn_page_pre_end.png" />" alt="처음"></a><a href="#none" onclick="${movePageScript}(${pager.prevPageNo},${addJsParam})" class="pre"><img src="<c:url value="/images2/sub/btn_page_pre.png" />" alt="이전"></a>
	</c:otherwise>
	</c:choose>
	
</c:if>
    <span>
        <c:forEach var="i" begin="${pager.startPageNo}" end="${pager.endPageNo}" step="1">
            <c:choose>
                <c:when test="${i eq pager.pageNo}"><strong><span>${i}</span></strong></c:when>
                <c:otherwise>
                	<c:choose>
		                <c:when test="${empty addJsParam}">
		                	<a href="#none" onclick="${movePageScript}(${i})"><span>${i}</span></a>
		                </c:when>
		                <c:otherwise>
		                    <a href="#none" onclick="${movePageScript}(${i},${addJsParam})"><span>${i}</span></a>
		                </c:otherwise>
		            </c:choose>
                </c:otherwise>
            </c:choose>            
        </c:forEach>
    </span>
<c:if test="${!pager.isNowFinal()}">        
    
	<c:choose>
	<c:when test="${empty addJsParam}">
		<a href="#none" onclick="${movePageScript}(${pager.nextPageNo})" class="next"><img src="<c:url value="/images2/sub/btn_page_next.png" />" alt="다음"></a><a href="#none" onclick="${movePageScript}(${pager.finalPageNo})" class="next_end"><img src="<c:url value="/images2/sub/btn_page_next_end.png" />" alt="마지막"></a>
	</c:when>
	<c:otherwise>
		<a href="#none" onclick="${movePageScript}(${pager.nextPageNo},${addJsParam})" class="next"><img src="<c:url value="/images2/sub/btn_page_next.png" />" alt="다음"></a><a href="#none" onclick="${movePageScript}(${pager.finalPageNo},${addJsParam})" class="next_end"><img src="<c:url value="/images2/sub/btn_page_next_end.png" />" alt="마지막"></a>
	</c:otherwise>
	</c:choose> 
   
</c:if>    
</div>