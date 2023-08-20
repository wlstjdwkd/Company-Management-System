/*
 * 리얼그리드 세부설정과 리얼그리드 관련 함수
 */

//필드 생성
var mailFields = [
	{
		fieldName: "empNo",
		dataType: "text",
	},
	{
		fieldName: "empNm",
		dataType: "text",
	},
	{
		fieldName: "comMail",
		dataType: "text",
	},
	{
		fieldName: "fileName",
		dataType: "text",
	},
	{
		fieldName: "filePath",
		dataType: "text",
	},
	{
		fieldName: "makeExcelYn",
		dataType: "text",
	},
	{
		fieldName: "sendDate",
		dataType: "text",
	}
];

//칼럼 생성
var mailColumns = [
	{
		name: "empNo",
		fieldName: "empNo",
		type: "data",
		width: "10",
		editable: false,
		header: {
			text: "사원번호",
			styleName: "align-center",
		},
		visible: true
	},
	{
		name: "empNm",
		fieldName: "empNm",
		type: "data",
		width: "10",
		editable: false,
		header: {
			text: "이름",
			styleName: "align-center",
		},
	},
	{
		name: "comMail",
		fieldName: "comMail",
		styleName: "align-left",
		type: "data",
		width: "20",
		editable: false,
		header: {
			text: "회사메일",
			styleName: "align-center",
		},
	},
	{
		name: "makeExcelYn",
		fieldName: "makeExcelYn",
		styleName: "align-left",
		type: "data",
		width: "10",
		editable: false,
		header: {
			text: "엑셀 생성",
			styleName: "align-center",
		},
	},
	{
		name: "fileName",
		fieldName: "fileName",
		styleName: "align-left",
		type: "data",
		width: "40",
		editable: false,
		header: {
			text: "첨부파일",
			styleName: "align-center",
		},
	},
	{
		name: "filePath",
		fieldName: "filePath",
		styleName: "align-left",
		type: "data",
		width: "40",
		editable: false,
		header: {
			text: "첨부파일",
			styleName: "align-center",
		},
		visible: false
	},
	{
		name: "sendDate",
		fieldName: "sendDate",
		type: "data",
		width: "20",
		editable: false,
		header: {
			text: "전송일",
			styleName: "align-center",
		},
	}
];

var mailDataProvider, mailGridView;

function createMailGrid(container) {
	mailDataProvider = new RealGrid.LocalDataProvider();
	mailGridView = new RealGrid.GridView(container);
	mailGridView.setDataSource(mailDataProvider);

	mailDataProvider.setFields(mailFields);
	mailGridView.setColumns(mailColumns);

	mailGridView.displayOptions.emptyMessage = "표시할 데이타가 없습니다.";
	//그리드 너비 자동 조정(비율)
	mailGridView.displayOptions.fitStyle = "evenFill";
			
	/*
	$.ajax({
			type : "POST",
			url : "PGPM0030.do",
			data : { "df_method_nm" : "getEmpList" },
			error : function(error) {
				console.log("error");
			},
			success : function(data) {
				console.log("success");
				var ddd = JSON.parse(data);
				//RealGrid parse (일반)
				mailDataProvider.fillJsonData(ddd, { fillMode: "set" });
			}
	});
	*/
			
	mailGridView.setStateBar({visible: false});
	mailGridView.setCheckBar({visible: true});
	mailGridView.setFooter({visible: false});
				
	//registerCallback();
}

function start() {
	createMailGrid("mailGrid");
}

// $.document.ready(start);
window.onload = start;
// domloaded를 대신 써도 됩니다.

window.onunload = function() {
	mailDataProvider.clearRows();

	mailGridView.destroy();
	mailDataProvider.destroy();

	mailGridView = null;
	mailDataProvider = null;
}