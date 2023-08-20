<%@ page contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.openworks.kr/jsp/jstl" prefix="op" %>
    
<html>
<head>
	<title>jQuery Tag Cloud</title>  

	<script type="text/javascript">CTX_PATH="<%=request.getContextPath()%>";</script>
	<op:jsTag type="spi" items="jquery,notice,colorbox,printpreview" />
	<op:jsTag type="openworks" items="web-core" />

    <script type="text/javascript">
    $(function(){   
    	//get tag feed   
        $.getJSON("INC_tagcloud.do?bbsCd=${param.bbsCd}", function(result){
            var data = eval(result);

            if($(data.tags).size() <= 0){
                parent.$.fn.colorbox.close();
                jsWarningBox("태그가 없습니다.");
                return false;
            }

            var level1;
            var level2;
            var level3;
            //create tags
            var levelDiff = data.tagMaxCnt - data.tagMinCnt;
            if(levelDiff > 1){
                level1 = levelDiff / 4;   
                level2 = levelDiff / 2;   
                level3 = levelDiff * 3 / 4;   
            }else{
            	level1 = level2 = level3 = data.tagMaxCnt;
            }

            $(data.tags).each(function(i, val){
				var tagLink = $("<a href='#' onclick=\"jsShowBbsListByTag('" + val.tag + "')\"></a>");

			    if(val.freq <= level1) tagLink.text(val.tag);
			    else if(val.freq <= level2) tagLink.html("<span class='tag_03'>" + val.tag + "</span>");
			    else if(val.freq <= level3) tagLink.html("<span class='tag_02'>" + val.tag + "</span>");
			    else tagLink.html("<span class='tag_01'>" + val.tag + "</span>");

                tagLink.appendTo("#tagList");
                $("#tagList").append(" | ");
            });
        });
    });	//end of onReady()

    //태그 목록 불러오기
    var jsShowBbsListByTag = function(tag){
        var pbody = parent.document.body;

        //parent.document.getElementById("searchKey").value = 1005;
        parent.jsSetSearchOption();

        $("input[name=q_searchVal]", pbody).val(tag);
        $("[name=q_searchKeyType]", pbody).val('TAG___1005');
        $("#dataForm input[name=q_currPage]", pbody).val(1);
        parent.document.dataForm.action = "BD_board.list.do";
        parent.document.dataForm.method = "get";
        parent.document.dataForm.submit();
    };
    </script>
</head>
  
<body>  

	<div id="popup" style="width:360px;">
		<div class="pop_pad">
			<h1><img src="/resources/web/theme/default/images/community/pop_tit_tag.gif" alt="태그클라우드"/></h1>
			<div id="tagList" class="p_tag"></div>
		</div>
		<div id="bottom">
			<div class="close">
				<a href="#" onclick="parent.$.fn.colorbox.close();"><img src="/resources/web/theme/default/images/btn/pop_close.gif" alt="닫기"/></a>
			</div>
		</div>
	</div>

</body> 
  
</html>