var _boardSvcUrl = "/PGMS0080.do";

/**
 * 목록
 */
var jsList = function(){
	/*location.href = "BD_boardconf.list.do?" + jsSearchQueryString("dataForm");*/
	/*var dForm = document.getElementById("dataForm");
	
	dForm.df_method_nm.value="getBoardConfList";
	dForm.submit();*/
	location.href = _boardSvcUrl;
	
};

/**
 * 검색
 */
var jsSearch = function(){
	
	/*if($("#df_method_nm").val() != "") {
		return;
	}*/
	
    var searchKey = $("#q_searchKey");
    var searchVal = $("#q_searchVal");

    if("" == $.trim(searchKey.val()) && "" != $.trim(searchVal.val())){
        jsWarningBox("검색 필터를 선택하세요.");
        searchKey.focus();
        return false;
    }

    if("" != $.trim(searchKey.val()) && "" == $.trim(searchVal.val())){
        jsWarningBox("검색어를 입력하세요.");
        searchVal.focus();
        return false;
    }
    return true;
    //location.href = "BD_boardconf.list.do?" + jsSearchQueryString("dataForm");
};

/**
 * 검색 초기화
 */
var jsSearchReset = function() {
    document.dataForm.action = _boardSvcUrl;//"BD_boardconf.list.do";    
    document.dataForm.elements["q_searchKey"].value = "";
    document.dataForm.elements["q_searchVal"].value = "";
    document.dataForm.elements["df_method_nm"].value = "1";
    
    document.dataForm.submit();
};

/**
 * 상세
 */
var jsView = function(bbsCd){
	$("#bbsCd").val(bbsCd);
	location.href = "BD_boardconf.view.do?" + jsSearchQueryString("dataForm");
};

/**
 * 등록 폼
 */
var jsInsertForm = function(){
	/*$("#q_seq").val("");
	location.href = "BD_boardconf.insert.form.do?" + jsSearchQueryString("dataForm");*/
	var dForm = document.dataForm;
		
	dForm.df_method_nm.value="boardConfRegist";
	dForm.submit();		
};

/**
 * 수정 폼
 */
var jsUpdateForm = function(bbsCd){
	/*$("#q_bbsCd").val(bbsCd);
	location.href = "BD_boardconf.update.form.do?" + jsSearchQueryString("dataForm");*/
	
	$("#q_bbsCd").val(bbsCd);
	
	var dForm = document.dataForm;
	
	dForm.df_method_nm.value="boardConfUpdate";
	dForm.submit();
};

/**
 * 삭제
 */
var jsDelete = function(){
	$("#dataForm").attr("action", "ND_boardconf.delete.do");
	$("#dataForm").submit();
};

/**
 * 목록 삭제
 */
var jsDeleteList = function(){
	var url = _boardSvcUrl + "?";	//ND_boardconf.list.delete.do?";
	var selectedBbsCds = new Array();
	$(".checkbox:checked").each(function (i){
		selectedBbsCds[i] = $(this).val();
		url += "bbsCds=" + $(this).val() + "&"
		url += "df_method_nm=boardConfListDelete&";
	});

	if(selectedBbsCds.length == 0){
		jsWarningBox("삭제 대상 게시판을 1개 이상 선택하세요.");
		return false;
	}else{
		if(confirm("선택한 " + selectedBbsCds.length + "개의 게시판을 정말 삭제하시겠습니까?\n\n게시물이 있는 경우 삭제하실 수 없으며 삭제 후 복구는 불가능합니다.")){
			$.post(url,
			function(response){
				if(isNaN(response)){
					alert(response);
				}else{
					alert(selectedBbsCds.length + "개 중 " + response + "개의 게시판을 성공적으로 삭제했습니다.");
				}
				document.location.reload();
			});
			//$("#dataForm").attr("action", "ND_boardconf.list.delete.do");
			//$("#dataForm").submit();
		}
	}
};

/**
 * 사용/미사용 전환
 */
var jsYnAction = function(el, bbsCd, gubunCd, listSkin){
	var element = $(el).children();
	var fieldYn = element.attr("yn") == "Y" ? "N" : "Y";

	var isProcessing = true;
	if(element.attr("id") == "useYn" && fieldYn == "N"){
		if(!confirm("사용여부를 미사용으로 설정 시에는 본 게시판이 서비스되지 않습니다.\n\n계속 진행하시겠습니까?")){
			isProcessing = false;
		}
	}

	if(listSkin != undefined && listSkin != 'basic'){
        alert("해당게시판 유형은 공지글을 사용 할 수 없습니다.");
        return;
    }

    if(isProcessing){
		element.text("....");

		$.post("PGMS0080.do", { 
			bbsCd   : bbsCd,
			gubunCd : gubunCd,
			fieldColumn : element.attr("id"),
			fieldYn : fieldYn,
			df_method_nm : 'updateynModAction'
		},
		function(result){
			element.removeClass();
			if(fieldYn == "Y"){
				element.text("사 용");
				element.attr("class", "use");
				element.attr("yn", "Y");
			}else{
				element.text("미사용");
				element.attr("class", "notUse");
				element.attr("yn", "N");
			}
		}, "json");
	}
};

/**
 * tab reload
 */
var jsReloadTab = function(){
    if(confTabz){
        confTabz.refresh();
    }
};

/**
 * 게시판 관리창
 */
var jsViewBbs = function(bbsCd, domCd){
	$("button[name=boardViewBtn]").colorbox({
		title : "게시판",
		href  : "<c:url value='/intra/board/ND_board.list.do?bbsCd=' />" + bbsCd + "&" + domCd,
		width : "100%", height:"100%",
		iframe: true
	});
};

/**
 * 입력 변경 사항 체크
 */
var jsChkValueChange = function(type, nm, val){
    var thisVal = "";
    if(type == "text" || type == "textarea"){
        thisVal = $("#" + nm).val();
    }else if(type == "select"){
        thisVal = $("#" + nm + " option:selected").val();
    }else if(type == "radio" || type == "checkbox"){
        thisVal = $("input[name=" + nm + "]:checked").val();
    }
    if(thisVal != val) changeFlag = true;
};

/**
 * 프레임워크 Tab UI 헨들러
 * @param option 대상 패널 명과 URI 파라미터를 전달 할 수 있다.
 *         미 지정시 기본 값이 사용된다.
 */
(function($) {
    $.extend($.fn, {
        jsTabUi : function(options) {

            /* option 설정 */
            var defaultTabOption = {
                tabContainer : "tabContainer",
                baseParam: {}
            };
            if(!options) {
                options = defaultTabOption;
            }

            var prefix_tab_id = "op_tabs_id_";
            /* class 를 강제로 생성(디자인 적용) */
            $(this).find("ul, ol").addClass("tab");

            /* Tab 대상 링크 객체 수집 및 고유 ID 생성*/
            var items = [];
            $(this).find("li").each(function(index) {
                $(this).addClass("tab-link");
                $(this).attr("id", prefix_tab_id + index);
                items[index] = $(this);
            });

            /* Tab 컨텐츠 패널 생성 */
            if($("#"+options.tabContainer).length < 1) {
                $("<div id='"+options.tabContainer+"'></div>").insertAfter($(this));
            }

            /** Tabs 객체생성 */
            var jsTabs = function(tabOptions, tabItems) {

                this.options = tabOptions;
                this.items = tabItems;

                /** 현재 선택된 Tab Index */
                this.selectedIndex = 0;
                this.currentPanel = "";
                this.currentUrl = "";

                /* Tab 대상 링크 객체 수집 */
                for(var i=0 ; i < this.items.length ; i++) {
                    this.items[i].bind("click", {idx : i}, function(event) {
                        tab.loadTab(event.data.idx);
                        return false;
                    });
                }

                ///////////////// 이벤트 설정 //////////////

                /** Tab 로드 전 이벤트 */
                this.beforeLoad = function(event, item) {
                    return true;
                };
                /** Tab 로드 후 이벤트 */
                this.afterLoad = function(event, item) {
                    return true;
                };

                /** 이벤트 설정(Tab 로드전과 로드후) */
                if(tabOptions.beforeLoad) {
                    this.beforeLoad = tabOptions.beforeLoad;
                }
                if(tabOptions.afterLoad) {
                    this.afterLoad = tabOptions.afterLoad;
                }

                ///////////////// 기능 설정 //////////////

                /** 대상 Tab객체 id에 해당하는 Tab load */
                this.loadTab = function(idx, event) {

                    var before = this.beforeLoad(event, this.items[idx]);
                    if(!before) {
                        return false;
                    }

                    /* 모든 Tab를 초기화 한다.*/
                    this.clearTab();
                    this.selectedIndex = idx;

                    this.items[idx].addClass("on");

                    var $panel = this.viewTab(idx);
                    $panel.show();

                    this.currentPanel = $panel;

                    this.afterLoad(event, this.items[idx]);
                };

                /** Tab 대상 컨텐츠를 표시하고 현재 컨텐츠를 표시하는 panel을 반환한다. */
                this.viewTab = function(idx) {
                    var $href = this.items[idx].children().attr("href");

                    var $panel;
                    if($href.indexOf("#", 0) == 0) {
                        var container = $href.substring(1);
                        $panel = $("#"+container);
                    } else {
                        $("#"+this.options.tabContainer).load(
                            $href,
                            options.baseParam,
                            function(data) {
                            }
                        );
                        $panel = $("#"+this.options.tabContainer);
                    }
                    this.currentUrl = $href;
                    return $panel;
                };

                /** 현재 선택된 Tab 일련번호 반환 */
                this.currentIndex = function() {
                    return this.selectedIndex;
                };

                /** 지정된 일련번호(idx) Tab의 URL을 변경 */
                this.changeUrl = function(idx, url) {
                    this.items[idx].attr("href",url);
                };

                /** Tab 이동 */
                this.moveTab = function(index) {
                    var $tab = this.items[index];
                    $tab.trigger("click");
                };

                /** 현재 Tab 새로 고침 */
                this.refresh = function() {
                    this.loadTab(this.selectedIndex);
                };

                /** 모든 텝 초기화 */
                this.clearTab = function() {
                    $(".tab-link").removeClass("on");
                    // 선택전 화면을 보이지 않도록 한다.
                    if(this.currentPanel) {
                        this.currentPanel.hide();
                    }
                };
                
            };

            /* 초기화 후 반환 */
            var tab = new jsTabs(options, items, arguments);
            tab.loadTab(0);

            return tab;
        }
    });
})(jQuery);
