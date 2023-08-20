<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<input type="hidden" name="df_curr_page" id="df_curr_page" value="<c:out value="${param.df_curr_page}" default="1" />" />
<input type="hidden" name="df_row_per_page" id="df_row_per_page" value="<c:out value="${param.df_row_per_page}" default="${DEFAULT_ROW_SIZE }" />" />