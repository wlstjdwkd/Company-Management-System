<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<script type="text/javascript">
   	function getUrlParam(paramName) {
   		var reParam = new RegExp('(?:[\?&]|&)' + paramName + '=([^&]+)', 'i');
    	var match = window.location.search.match(reParam);
   		
   		return (match && match.length > 1) ? match[1] : null;
   	}
   	
   	var funcNum = getUrlParam('CKEditorFuncNum');
   	var fileUrl = "${fileUrl}";
   	
   	window.parent.CKEDITOR.tools.callFunction(funcNum, fileUrl);
</script>