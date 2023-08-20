//각 페이지별 페이지 로딩시 이벤트 함수
var onReadyEventFunctions = function(){

	if(OpenWorks.pageType == "VIEW"){
		//쿠키사용 필드 구분자
		OpenWorks.gubunja = '|:|';
		jsViewProcess();

	}else if((OpenWorks.pageType == "INSERT") 
			|| (OpenWorks.pageType == "UPDATE") 
			|| (OpenWorks.pageType == "REPLY")){

		// 화면단으로 이동
		//jsFormProcess();

	}else if(OpenWorks.pageType == "LIST"){
		//카테고리 저장용
		bbsCtgAry = new Array();
		jsListProcess();

	}else{
		jsErrorBox('Error page not Initialized properly !!');
	}
};


//=========== 목록 페이지 로딩 이벤트 ==================
var jsListProcess = function(){

	//검색어 하이라이팅
	if(OpenWorks.searchVal != "" && OpenWorks.searchKey != "" ){
		$("#contents_area").highlight(OpenWorks.searchVal);
	}

	//검색 옵션값이 있을 경우 검색 옵션을 보여줌
	if(OpenWorks.startDt != "" && OpenWorks.endDt != ""){
		$("#SearchOptionDiv").show();
	}

	//카테고리 체인지 이벤트
	if(OpenWorks.useCategory == "Y") SharedOpenWorks.jsChangeCategoryEvent("LIST");

	//파일 정보 다이얼로그 창
	//SharedOpenWorks.jsFileDialogEvent();

	//전체선택 체크박스
	SharedOpenWorks.jsAllCheckBoxClickEvent();

	//개별선택 체크박스
	$("input[name=seqs]").click(function(){
        if($(this).is(":checked")){
            $(this).parent().parent().addClass("bg_blue");
        }else{
            if($("#noticeYn_" +  $(this).val()).val() == 'Y'){
                $(this).parent().parent().addClass("bg_blue");
            }else{
                $(this).parent().parent().removeClass("bg_blue");
            }
        }
    });

	//필드 정렬 효과
	SharedOpenWorks.jsSetSortEffect();

	//검색 엔터 이벤트
	jsSetSearchEnterEvent();

	//요약 보이기(갤러리일 경우 디폴트 보이게 함)
	if(OpenWorks.boardType == "GALLERY") OpenWorks.showSummaryYn = "Y";

	if(OpenWorks.showSummaryYn == "Y"){
		$("#dataForm input[name=showSummaryYn]").val("Y");
		$("div.tx_blue_s").show();
	}else{
		$("#dataForm input[name=showSummaryYn]").val("N");
		$("div.tx_blue_s").hide();
	}

	//엑셀로 다운 받기
	$("#excelBtn").bind("click", {}, function(){
		$.fn.colorbox({
			open  : true,
			title : "목록 EXCEL 다운",
			href  : "PD_convert.form.do?type=excel&bbsCd=" + OpenWorks.bbsCd,
			width : "650", height:"420",
			iframe: true
		});
	});

	//PDF로 다운 받기
	$("#pdfBtn").bind("click", {}, function(){
		$.fn.colorbox({
			open  : true,
			title : "목록 PDF 다운",
			href  : "PD_convert.form.do?type=pdf&bbsCd=" + OpenWorks.bbsCd,
			width : "650", height:"420",
			iframe: true
		});
	});

	if(OpenWorks.tagYn == "Y"){
		//태그 클라우드 창
		$("#tagCloud").bind("click", {}, function(){
			$.fn.colorbox({
				open  : true,
				title : "태그 클라우드",
				href  : "PD_tagcloud.do?bbsCd=" + OpenWorks.bbsCd,
				width : "650", height:"420",
				iframe: true
			});
		});
	}
};


//=========== 폼 페이지 로딩 이벤트 ==================
var jsFormProcess = function(){

	//파일 업로드 설정
	SharedOpenWorks.jsSetMultiFile();

	//제목 입력박스 도움말
	//SharedOpenWorks.jsInputTextHelpMsg("title", "제목을 입력하세요.", 30, "red");

	//폼 설정 체크
	SharedOpenWorks.jsSetFormValidate();

	//타이틀 엔터 이벤트 금지
	jsSetTitleEnterEvent();

	//제목입력줄 선택
	window.scroll(0, 0);
	$("#title")[0].focus();
};


//=========== 뷰 페이지 로딩 이벤트 ==================
var jsViewProcess = function(){

	$("#dataForm").attr("action", "BD_board.form.do");

	//만족도 평가
	SharedOpenWorks.jsSetScoreFormValidate();

	//코멘트 목록
	if(OpenWorks.commentYn == "Y"){
		//cmtTabz = $("#tab_div").tabs();
		jsOpenComment();
	}

	//다음글이 목록 보기일경우
	if(OpenWorks.listViewCd == "1003"){
		//검색어 하이라이팅
		if(OpenWorks.searchVal != "" && OpenWorks.searchKey != "")
			$("#contents_area").highlight(OpenWorks.searchVal);

		//카테고리 체인지 이벤트
		if(OpenWorks.useCategory == "Y") SharedOpenWorks.jsChangeCategoryEvent("VIEW");

		//파일 정보 다이얼로그 창
		//SharedOpenWorks.jsFileDialogEvent();

		//전체선택 체크박스
		//SharedOpenWorks.jsAllCheckBoxClickEvent();

		//요약 보이기
		if(OpenWorks.showSummaryYn == "Y"){
			$("#dataForm input[name=showSummaryYn]").val("Y");
			$("div.tx_blue_s").show();
		}else{
			$("#dataForm input[name=showSummaryYn]").val("N");
			$("div.tx_blue_s").hide();
		}

		//필드 정렬 효과
		SharedOpenWorks.jsSetSortEffect();

		// 페이지 이동 버튼 엔터 이벤트
		//jsSetGoTextKeyEvent();
	}

};


//--------- 목록 사용 함수 --------------//

//검색 옵션 보기 토글
var jsToggleSearchOption = function(btn){
	if($("#SearchOptionDiv").is(":visible")){
		$("#SearchOptionDiv").slideUp(500, function(){
			$("#q_startDt").val("");
			$("#q_endDt").val("");
		});
	}else{
		$("#SearchOptionDiv").slideDown(500, function(){
		});
	}
};

//atom, rss 다운로드
var jsConvertAction = function(type){

	var url = OpenWorks.serverNm + "?type=" + type + "&bbsCd=" + OpenWorks.bbsCd;

	if(window.clipboardData){
		var copyYn = window.confirm("URL : " + url + " \n클립보드에 복사하시겠습니까?");
		if(copyYn){
			window.clipboardData.setData("Text", url);
			jsSuccessBox('클립보드에 URL이 복사되었습니다. ');
		}
	}else if(window.netscape){
		//alert(url, {sticky:true});

		return false;
		//브라우져의 주소창에 about:config 를 치면 해당 설정 내용이 쭉 나타나는데 
		//그 중에서 Signed.applets.codebase_principal_support 라는 부분을 찾아서 
		//true로 바꿔주면 문제없이 작동할 것이다. 

		//dit is belangrijk maar staat nergens duidelijk vermeld: 
		//you have to sign the code to enable this, or see notes below 
		netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');

		//maak een interface naar het clipboard 
		var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard); 
		if(!clip) return; 

		//maak een transferable 
		var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable); 
		if(!trans) return; 

		//specificeer wat voor soort data we op willen halen; text in dit geval
		trans.addDataFlavor('text/unicode');

		//om de data uit de transferable te halen hebben we 2 nieuwe objecten nodig om het in op te slaan
		var str = new Object();
		var len = new Object();
		var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
		var copytext=url;
		str.data=copytext;
		trans.setTransferData("text/unicode",str,copytext.length*2);

		var clipid=Components.interfaces.nsIClipboard;
		if(!clip) return false;
		clip.setData(trans,null,clipid.kGlobalClipboard); 
		jsSuccessBox('클립보드에 URL이 복사되었습니다. ');
	}
	//jsMsgBox('클립보드에 URL이 복사되었습니다 ');
};

//검색 엔터 이벤트
var jsSetSearchEnterEvent = function(){
	$("#searchVal").keyup(function(event){
		if(event.keyCode == 13) {
			$(this).next().click();
			return false;
		}
	});
};


//타이틀 엔터 이벤트 금지
var jsSetTitleEnterEvent = function(){
	$("#title").keypress(function(event){
		if(event.keyCode == 13){
			return false;
		}
	});
};

//요약 보기 토글
var jsSummaryShow = function(){
	if($("#dataForm input[name=showSummaryYn]").val() == "Y"){
		$("div.tx_blue_s").slideUp(200, function(){
			$("#dataForm input[name=showSummaryYn]").val("N");
		});
	}else{
		$("div.tx_blue_s").slideDown(200, function(){
			$("#dataForm input[name=showSummaryYn]").val("Y");
		});
	}
};	

//지정 날짜 설정
var jsSetDay = function( smonth, sday, eday){	
	if(eval(smonth < 0)){
		$('#q_startDt').val("");
		$('#q_endDt').val("");
		return false;
	}
	sday = eval(sday) -1;
	var today = new Date();
	if($('#q_endDt').val() != ""){
		var dayVal = $('#q_endDt').val();
		if(dayVal.indexOf("-") > -1) dayVal = dayVal.replace(/[-]/g, "");

		var vyear = dayVal.substring(0, 4);
		var vmonth = dayVal.substring(4, 6);
		var vday = dayVal.substring(6, 8);
		var sDay = new Date( Number(vyear), Number(vmonth) -1 , Number(vday));
		$('#q_startDt').datepicker('setDate', new Date( sDay.getFullYear(), sDay.getMonth() - eval(smonth), sDay.getDate() - eval(sday)));
	}else if($('#q_startDt').val() != ""){
		var dayVal = $('#q_startDt').val();
		if(dayVal.indexOf("-") > -1) dayVal = dayVal.replace(/[-]/g, "");

		var vyear = dayVal.substring(0, 4);
		var vmonth = dayVal.substring(4, 6);
		var vday = dayVal.substring(6, 8);
		var sDay = new Date( Number(vyear), Number(vmonth) -1 , Number(vday));
		$('#endDtVal').datepicker('setDate', new Date( sDay.getFullYear(), sDay.getMonth() + eval(smonth), sDay.getDate() + eval(sday)));
	}else{		
		$('#q_startDt').datepicker('setDate', new Date(  today.getFullYear(), today.getMonth() - eval(smonth),  today.getDate() - eval(sday)));
		$('#q_endDt').datepicker('setDate', new Date( today.getFullYear(), today.getMonth(), today.getDate() - eval(eday)));
	}
};	

//목록 완전 삭제 버튼
var jsDeleteList = function(bbsCode){
	var selectedSeqs = jsCheckedArray();
	if(selectedSeqs.length == 0){
		jsWarningBox("삭제 대상 게시물을 1개 이상 선택하세요.");
		return false;
	}

	if(!confirm("선택한 " + selectedSeqs.length + "개의 게시물을 정말 삭제하시겠습니까?\n삭제 후 복구는 불가능 합니다.")) return false;

	var msg = "목록 보기 삭제";

	$("#dataForm input[name=delDesc]").val(msg);	
	//jsRequest("dataForm", "ND_board.list.delete.do", "post");
	$("#df_method_nm").val("boardDeleteList");
	jsRequest("dataForm", "PGMS0081.do", "post");	
};

//목록 플래그 삭제 버튼
var jsFlagDeleteList = function(bbsCode){
	var selectedSeqs = jsCheckedArray();
	if(selectedSeqs.length == 0){
		jsWarningBox("삭제 대상 게시물을 1개 이상 선택하세요.");
		return false;
	}

	if(!confirm("선택한 " + selectedSeqs.length + "개의 게시물을 삭제하시겠습니까?\n삭제 후 사용자화면에서 관리자 삭제글로 표시됩니다.")) return false;

	jsRequest("dataForm", "ND_board.list.flag.delete.do", "post");
};

//목록보기에서 이동폼을 호출
var jsTransferList = function(bbsCode){
	var selectedSeqs = jsCheckedArray();
	if(selectedSeqs.length == 0){
		jsWarningBox("이동할 대상 게시물을 1개 이상 선택하세요.");
		return false;
	}
	var urlStr = "PD_transfer.form.do?bbsCd=" + bbsCode;
	for(var i=0; i<selectedSeqs.length; i++){
		urlStr += ("&seqs=" + selectedSeqs[i]);
	}
	$.fn.colorbox({
		open  : true,
		title : "게시글 이동",
		href  : urlStr,
		width : "800", height:"500",
		iframe: true
	});
};

//체크된 게시판 글 목록을 가져온다.
var jsCheckedArray = function(){
	var selectedSeqs = new Array();
	$("tbody input.checkbox:checked").each(function(i){
		selectedSeqs[i] = $(this).val();
	});
	return selectedSeqs;
};	


//------------------ 목록 함수 끝 --------------- //	



//------------------ 뷰 함수  --------------- //	

//추천 버튼  
var jsClickRecommAction = function(btn, bbsCode, seq, readCookieHour){
	if((timeWait = jsCheckCookieTime("recommendCookie:" + bbsCode + ":" + seq)) > 0){
	    jsWarningBox(timeWait + "시간 후 다시 추천하실 수 있습니다.");
		return false;
	}

	var confirm = window.confirm("이 게시물을 추천하시겠습니까?");
	if(confirm != true) return;

	$.post("ND_recom.action.do", {
		bbsCd : bbsCode,
		seq : seq
	}, function(result){
		if(result > 0){
			if(OpenWorks.pageType == "VIEW") $(btn).val("추천 " + result);
			else $(btn).val("추천");
			jsSetCookieExpTime("recommendCookie:"+bbsCode+":"+seq, readCookieHour);
		}else{
			jsWarningBox('지금은 추천하실 수 없습니다.');
		}
	}, 'json');
};

//신고 버튼
var jsClickAccuseAction = function(btn, bbsCode, seq, readCookieHour){
	if((timeWait = jsCheckCookieTime("accuseCookie:" + bbsCode + ":" + seq)) > 0){
	    jsWarningBox(timeWait + "시간 후 다시 신고하실 수 있습니다.");
		return false;
	}
	var confirm = window.confirm("이 게시물을 신고하시겠습니까?");
	if(confirm != true) return;
	$.post("ND_accuse.action.do", {
		bbsCd : bbsCode,
		seq : seq
	}, function(result){
		if(result > 0){
			$(btn).val("신고 " + result);
			jsSetCookieExpTime("accuseCookie:" + bbsCode + ":" + seq, readCookieHour);
		}else{
			jsWarningBox('지금은 신고하실 수 없습니다.');
		}
	}, 'json');
};

//수정폼버튼(bbsCd, seq로 구분 refSeq = null)
var jsUpdateForm = function(pageType){
	$("#dataForm input[name=refSeq]").val("");
	$("#dataForm input[name=pageType]").val(pageType);
	//jsRequest("dataForm", "BD_board.update.form.do", "get");
	$("#df_method_nm").val("boardWriteForm");
	jsRequest("dataForm", "PGMS0081.do", "get");
};

//답글폼버튼(bbsCd, refSeq로 구분 seq = null)
var jsReplyForm = function(pageType, seq){
	//$("#dataForm input[name=seq]").val("");
	$("#dataForm input[name=pageType]").val(pageType);
	//$("#dataForm input[name=refSeq]").val(seq);
	//alert($("#dataForm input[name=refSeq]").val());
	jsRequest("dataForm", "BD_board.reply.form.do", "get");
};

//상세보기에서 이동 폼을 호출
var jsTransfer = function(bbsCode){
	var urlStr = "PD_transfer.form.do?bbsCd=" + bbsCode + "&seqs=" + $("#dataForm input[name=seq]").val();
	$.fn.colorbox({
		open  : true,
		title : "게시글 이동",
		href  : urlStr,
		width : "700", height:"350", 
		iframe: true
	});
};

//완전 삭제 버튼
var jsDelete = function(){
	if(!confirm("자료를 삭제하시면 첨부파일 및 코멘트들도 모두 삭제됩니다.\n삭제 하시겠습니까?")) return false;
	var msg = "상세 보기 삭제";
	$("#dataForm input[name=delDesc]").val(msg);
	$("#df_method_nm").val("deleteBoardOne");
//	jsRequest("dataForm", "ND_board.delete.do", "post");
	jsRequest("dataForm", "PGMS0081.do", "post");	
	
};

//플래그 삭제 버튼
var jsFlagDelete = function(){
	if(!confirm("이 글을 삭제 하시겠습니까?\n삭제 후 사용자화면에서 관리자 삭제글로 표시됩니다.")) return false;
	jsRequest("dataForm", "ND_board.flag.delete.do", "post");
};

//코멘트 열기
var jsOpenComment = function(){
	var target = $("#attachedCommentsDiv");
	$.get("INC_cmt.list.do", {
		bbsCd : $("#dataForm input[name=bbsCd]").val(),
		seq : $("#dataForm input[name=seq]").val(),
		q_currPage : 1
	},
	function(result){
		target.empty();
		target.append(result);
		target.slideDown(500);
	});
};



var SharedOpenWorks = {

	//카테고리 체인지 이벤트 등록
	jsChangeCategoryEvent : function(pageType){
		if(OpenWorks.useCategory == "Y"){
			if(pageType == "LIST")
				$("#q_ctgCd").bind("change", {}, function() {jsListReq(1);});
			if(pageType == "VIEW")
				$("#q_ctgCd").bind("change", {}, function() {jsViewReq(1);});
		}
	},

	//파일 정보창 보여주기 이벤트 등록
	jsFileDialogEvent : function(){
		$("a.fileDown").cluetip({
			  width		  : 450,
			  //hoverClass	 : 'highlight',
			  sticky		 : true,
			  closePosition  : 'bottom',
			  closeText	  : '<img src="styles/cross.png" alt="" />',
			  truncate	   : 0,
			  mouseOutClose  : true,
			  clickThrough   : true,
			  waitImage	  : true,
			  arrows		 : true,	// if true, displays arrow on appropriate side of clueTip. more info below [8]
			  dropShadow	 : true,	 // set to false if you don't want the drop-shadow effect on the clueTip
			  dropShadowSteps: 6,
			  closePosition  : 'top',	// location of close text for sticky cluetips; can be 'top' or 'bottom' or 'title'
			  closeText	  : '닫기',
			  cluetipClass   : 'jtip',
			  activation	 : 'click'
			});
	},

	//전체선택 체크박스
	jsAllCheckBoxClickEvent : function(){
		$("input[name=chk-all]").click(function(){
			var isChecked = this.checked;
			$("input[name=seqs]").attr('checked', isChecked);
			if(isChecked){
				$(":checkbox").parent().parent().addClass("bg_blue");
			}else{
			    $(":checkbox").parent().parent().removeClass("bg_blue");
			    //공지사항 목록에는 원래의 class 추가
			    $("input[name=chkNoticeYn]").each(function(){
			        $(this).parent().parent().addClass("bg_blue");
	            });
			}
		});
	},

	//멀티파일 업로드
	jsSetMultiFile : function(){
		if(OpenWorks.fileYn == "Y"){
			$('input:file').MultiFile({
				accept: OpenWorks.fileExts,
				max: OpenWorks.maxFileCnt,
				list: '#multiFilesListDiv',
				STRING: {
					remove: '<img src="' + OpenWorks.closeFileIcon + '" class="vm" />',
					denied: '$ext 는(은) 업로드 할 수 없는 파일확장자입니다!',  //확장자 제한 문구
					duplicate: '$file 는(은) 이미 추가된 파일입니다!'		   //중복 파일 문구
				},
				onFileRemove: function(element, value, master_element){
				},
				afterFileRemove: function(element, value, master_element){
					if(eval($("#uploadFileCnt").val()) > 0)
						$("#uploadFileCnt").val(eval($("#uploadFileCnt").val()) - 1);
					else $("#uploadFileCnt").val(0);

					if(eval($("#uploadFileCnt").val()) < OpenWorks.maxFileCnt)
						$.fn.MultiFile.reEnableEmpty();
				},
				onFileAppend: function(element, value, master_element){
					alert($("input:file").length);//$("input:file").length
				},
				afterFileAppend: function(element, value, master_element){
					if(eval($("#uploadFileCnt").val()) < 0){
						$("#uploadFileCnt").val(1);
					}else{
						$("#uploadFileCnt").val(eval($("#uploadFileCnt").val()) + 1);
					}

					if(eval($("#uploadFileCnt").val()) >= OpenWorks.maxFileCnt)
						$.fn.MultiFile.disableEmpty();
				},
				onFileSelect: function(element, value, master_element){
				},
				afterFileSelect: function(element, value, master_element){
				}
			});
		};

		//폼 파일 업로더를 초기화 시킨후, 파일 갯수가 초과시엔 디스에이블 시킨다.
		//alert(eval($("#uploadFileCnt").val()));
		if(OpenWorks.maxFileCnt <= eval($("#uploadFileCnt").val())){
			$.fn.MultiFile.disableEmpty();
		}
	},

	//입력창 도움말
	jsInputTextHelpMsg : function(id, msg, len, color){
		var element = $("#" + id);
		var msgColor = "#a9ede7";

		if($.trim(element.val()) == ""){
			 element.css("color", msgColor);	
			 element.val(msg);
		}

		element.bind("blur", {}, function(){
			if($.trim(element.val()) == ""){
				element.css("color", msgColor);
				//element.val(msg);
			}else if(length > 0 && $.trim(element.val()).length > len){
				element.val($.trim(element.val()).substring(0,len));
			}
		}).bind("focus", {}, function(){
			if($.trim(element.val()) == "" || $.trim(element.val()) == msg){
				element.css("color", color);
				element.val("");
			}
		});
	},

	//필드 정렬시 정렬효과 보여줌
	jsSetSortEffect : function(){
		if(OpenWorks.sortName != "" && OpenWorks.sortOrder != ""){
			if((OpenWorks.boardType == "GALLERY") && (OpenWorks.listShowType == "gallery")){
				$('span[id=th-'+OpenWorks.sortName+']').addClass('sorted-'+OpenWorks.sortOrder);
			}else{
				$('thead th[id=th-'+OpenWorks.sortName+']').addClass('m_over');
				$('th[id=th-'+OpenWorks.sortName+'] span').addClass('sorted-'+OpenWorks.sortOrder);
			}
		}
	},

	//scoreForm 유효성 체크 (보기페이지에서 별점수)
	jsSetScoreFormValidate : function(){
		$("#scoreForm").validate({
			submitHandler: function(form){
				$(form).ajaxSubmit({
					url	  : "ND_score.action.do",
					type	 : "POST",
					dataType : "json",
					beforeSubmit : function(arr, $form, options){
									if((timeWait = jsCheckCookieTime("scoreCookie:" + OpenWorks.bbsCd + ":" + OpenWorks.seq)) > 0){
										$("#scoreForm select[name=scoreSum]").val("0");
										jsWarningBox(timeWait + "시간 후 다시 평가하실 수 있습니다.");
										return false;
									}else{
										var confirm = window.confirm("이 게시물을 평가하시겠습니까?");
										if(confirm != true) return false;
										return true;
									}
								},
					success  : function(data){
						if(data.value != 0){
							$("#boardScoreAvgSapn").html(data.value);
							jsSetCookieExpTime("scoreCookie:" + OpenWorks.bbsCd + ":" + OpenWorks.seq, OpenWorks.readCookieHour);
						}else{
							jsWarningBox('지금은 평가하실 수 없습니다.');
						}
						$("#scoreForm select[name=scoreSum]").val("0");
					}
				});
				return false;
			}
		});
	}

};


//*************** 리퀘스트 함수 ***********************//	
//ajax를 제외한 모든 폼(dataForm)의 리퀘스트를 서버로 전송.
var jsRequest = function(formId, action, method){
	document.dataForm.action = action;
	document.dataForm.method = method;
	document.dataForm.submit();
};

//page번호로 목록 페이지를 호출한다.(bbsCd는 기본 셋팅값 사용)
var jsListReq = function(page){
	/*$("#dataForm input[name=q_currPage]").val(page);
	jsRequest("dataForm", "BD_board.list.do", "get");*/
	
	$("#df_curr_page").val(page);
	$("#df_method_nm").val("");	
	jsRequest("dataForm", "PGMS0081.do", "post");
};

//page번호로 상세보기 페이지를 호출한다.(seq는 기본 셋팅값 사용)
var jsViewReq = function(page){
	//$("#dataForm input[name=q_currPage]").val(page);
	$("#df_curr_page").val(page);
	jsRequest("dataForm", "PGMS0081.do", "get");
};

//페이지별 리로드
var refreshPage = function(){
	if(OpenWorks.pageType == "LIST") jsListReq(1);
	else if(OpenWorks.pageType == "VIEW") jsViewReq(1);
};



//*********************** 쿠키관련 함수 ***************************//		 
//쿠키에 저장된 값으로 앞으로 얼마나 유효한지 확인
var jsCheckCookieTime = function(cookieName){
	var cukie = $.cookie(cookieName);
	if(cukie == null) return 0;	// 쿠키가 없다
	var nowTime = new Date();
	var expTime = new Date(eval(cukie));
	if((expTime.getTime() - nowTime.getTime()) > 0) return (Math.ceil((expTime.getTime() - nowTime.getTime())/1000/60/60));
	else return 0;
};

//쿠키이름과 시간설정
var jsSetCookieExpTime = function(cookieName, readCookieHour){
	var expDate = new Date();
	expDate.setTime(expDate.getTime() + (60 * 60 * 1000) * readCookieHour);
	$.cookie(cookieName, expDate.getTime(), { path: '/', expires: expDate });
};   
   
//*********************** 쿠키관련 함수 끝 ***************************//			 


//*************** VIEW/LIST 공용 사용 함수 ***********************//

//pagerInfo 리셋시사용
var jsRppReset = function() {
	refreshPage();
};

//검색 버튼
var jsSearch = function(){
	var searchKey = $("#q_searchKeyType");
	var searchVal = $("#q_searchVal");

	if(("" != $.trim(searchKey.val())) && ("" == $.trim(searchVal.val()))){
	    jsWarningBox("검색어를 입력하세요.");
		searchVal[0].focus();
		return false;
	}
	if("" == $.trim(searchKey.val())){
		searchVal.val("");
	}
	$("#dataForm input[name=q_sortName]").val("");
	$("#dataForm input[name=q_sortOrder]").val("");

	refreshPage();
};

//검색 초기화버튼
var jsSearchReset = function(){
	if(OpenWorks.useCategory == "Y") document.dataForm.elements["q_ctgCd"].value = "";
	document.dataForm.elements["q_searchKeyType"].value = "";
	//$("#dataForm input[name=q_searchKey]").val("");
	$("#dataForm input[name=q_searchVal]").val("");
	$("#dataForm input[name=q_startDt]").val("");
	$("#dataForm input[name=q_endDt]").val("");
	$("#dataForm input[name=q_sortName]").val("");
	$("#dataForm input[name=q_sortOrder]").val("");
	refreshPage();
};

//테이블 상단 정렬 클릭시
var jsSort = function(item){
	//alert($("#dataForm input[name=q_sortOrder]").val());
	$("#dataForm input[name=q_sortName]").val(item);
	if($("#dataForm input[name=q_sortOrder]").val() == "ASC"){
		$("#dataForm input[name=q_sortOrder]").val("DESC");
	}else{
		$("#dataForm input[name=q_sortOrder]").val("ASC");
	}
	refreshPage();
};	

//내용보기 클릭시
var jsView = function(bbsCd, seq, regPwd, openYn){
	if(seq == ""){
	    jsWarningBox('글이 없습니다.');
		return;
	}
	/*if((OpenWorks.loginGrade != "9") && (regPwd != '') && (openYn == 'N')){
		pwd = window.prompt("게시물 비밀번호를 입력하세요", "");
		if(pwd == null) return;
	}else{
		pwd = "";
	}
	$.post("BD_board.view.do", {
		bbsCd: $("#dataForm input[name=bbsCd]").val(),
		authType : "VIEW",
		seq : seq,
		regPwd : pwd
		}, function(result){
			if(result.value){
				$("#dataForm input[name=bbsCd]").val(bbsCd);
				$("#dataForm input[name=seq]").val(seq);
				$("#dataForm input[name=regPwd]").val(pwd);
				jsRequest("dataForm", "BD_board.view.do", "get");
			}else{
				jsWarningBox('내용보기 권한이 없습니다.');
				return false;
			}
		}, "json");*/
	$("#dataForm input[name=bbsCd]").val(bbsCd);
	$("#dataForm input[name=seq]").val(seq);
	
	if($("#dataForm input[name=df_curr_page]").val() == "") {		
		$("#df_curr_page").val(1);
	}	
	$("#df_method_nm").val("boardView");
	jsRequest("dataForm", "/PGMS0081.do", "post");
};

//날짜가 기일부터 몇일이 지났는지 확인하는 함수
var jsOverDateChk = function(cday , limit){
	d = new Date();
	dval = d.getTime();
	dat = cday + "";
	vyear = cday.substring(0,4);		
	vmonth = cday.substring(4,6);
	vday = cday.substring(6,8);
	dd = new Date( Number(vyear), Number(vmonth)-1, Number(vday));
	ddval = dd.getTime();
	day = (dval - ddval)/(24*60*60*1000);
	dday = Math.floor( day );
	if( dday <= Number(limit))return true;
		return false;
};

//게시판 글 사용 여부 설정 
var jsYnAction = function(el, bbsCd, seq){
	var element = $(el).children();
	var banYn = element.attr("yn") == "Y" ? "N" : "Y";

	element.text("....");

	$.post("JR_ynUpdateAction.do", {
		bbsCd	 : bbsCd,
		seq	 : seq,
		banYn   : banYn
	},
	function(result){
		element.removeClass();
		if( banYn == "Y" ){
			element.addClass("notUse");
			element.attr("yn", "Y");
			element.text("미사용");
		}else{
			element.addClass("use");
			element.attr("yn", "N");
			element.text("사용");
		}
	}, "json");
};


//등록 버튼폼(bbsCd로 구분 refSeq=null, seq=null)
var jsInsertForm = function(pageType){
	$("#dataForm input[name=refSeq]").val("");
	$("#dataForm input[name=seq]").val("");
	$("#dataForm input[name=pageType]").val(pageType);
	
	$("#df_method_nm").val("boardWriteForm");
	jsRequest("dataForm", "PGMS0081.do", "post");
};


// *************** VIEW/LIST 공용 사용 함수  끝 ***********************//



//목록보기 버튼
var jsList = function(page){
	//$("#dataForm").validate().resetForm();
	$("#dataForm input[name=title]").attr("disabled", "disabled");
	$("#dataForm [name=contents]").attr("disabled", "disabled");
	$("#dataForm").unbind("submit", null);
	jsListReq(page);
};

//태그 검색 시 태그 옵션 생성(목록)
var jsSetSearchOption = function(){
	var flag = true;
	$("#q_searchKeyType option").each(function(index){
		if($(this).val() == 'TAG___1005'){
			flag = false;
			return false;
		}
	});
	if(flag){
		$("#q_searchKeyType option").append("<option value='TAG___1005'>태그</option>");
	}
};

//태그 클릭 시 태그 목록 불러오기(뷰화면)
var jsShowBbsListByTag = function(tag){
  var pbody = document.body;

  jsSetSearchOption();

  $("input[name=q_searchVal]", pbody).val(tag);
  $("[name=q_searchKeyType]", pbody).val('TAG___1005');
  $("#dataForm input[name=q_currPage]", pbody).val(1);
  document.dataForm.action = "BD_board.list.do";
  document.dataForm.method = "get";
  document.dataForm.submit();
};
