/*
 * 리얼그리드 세부설정과 리얼그리드 관련 함수
 * Tree View 구현
 */

//필드 생성
var treeFields = [
	{
		fieldName: "payItmNm"
	},
	{
		fieldName: "payItmCd"
	},
	{
		fieldName: "upItmCd"
	},
	{
		fieldName: "itmSeq"
	},
	{
		fieldName: "useYn"
	},
	{
		fieldName: "rmrk"
	},
	{
		fieldName: "treeId"
	}
];

//칼럼 생성
var treeColumns = [
	{
		name: "payItmNm",
		fieldName: "payItmNm",
		type: "data",
		width: "20",
		editable: false,
		header: {
			text: "급여항목명",
		},
	},
	{
		name: "payItmCd",
		fieldName: "payItmCd",
		styleName: "align-center",
		type: "data",
		width: "10",
		editable: false,
		header: {
			text: "급여항목코드",
			styleName: "align-center"
		},
	},
	{
		name: "upItmCd",
		fieldName: "upItmCd",
		type: "data",
		width: "10",
		editable: false,
		header: {
			text: "상위항목코드",
		},
	},
	{
		name: "itmSeq",
		fieldName: "itmSeq",
		type: "data",
		width: "10",
		editable: false,
		header: {
			text: "항목 순번",
		},
	},
	{
		name: "useYn",
		fieldName: "useYn",
		type: "data",
		width: "5",
		editable: false,
		header: {
			text: "사용",
		},
	},
	{
		name: "rmrk",
		fieldName: "rmrk",
		styleName: "align-left",
		type: "data",
		width: "40",
		editable: false,
		header: {
			text: "비고",
		},
	}
];

var treeDataProvider, treeView;

function createSearchPayItemGrid(container) {

	treeDataProvider = new RealGrid.LocalTreeDataProvider();
	treeView = new RealGrid.TreeView(container);
	treeView.setDataSource(treeDataProvider);

	treeDataProvider.setFields(treeFields);
	treeView.setColumns(treeColumns);

	treeView.displayOptions.emptyMessage = "표시할 데이타가 없습니다.";
	//그리드 너비 자동 조정(비율)
	treeView.displayOptions.fitStyle = "evenFill";
		
	$.ajax({
			type : "POST",
			url : "PGPM0020.do",
			data : { "df_method_nm" : "getPayItemList" },
			error : function(error) {
				console.log("error");
			},
			success : function(data) {
				console.log("success");
				console.log("JSON TREE DATA\n\n" + data);
				var treeData = JSON.parse(data);
				treeDataProvider.setRows(treeData, "treeId", true);
				
				treeView.expandAll();
				
				treeView.setStateBar({visible: false});
				treeView.setCheckBar({visible: false});
				treeView.setFooter({visible: false});
			}
	});
	
	registerCallback();
}

function start() {
	createSearchPayItemGrid("payItemTreeGrid");
}

// $.document.ready(start);
window.onload = start;
// domloaded를 대신 써도 됩니다.

window.onunload = function() {
	treeDataProvider.clearRows();

	treeView.destroy();
	treeDataProvider.destroy();

	treeView = null;
	treeDataProvider = null;
}