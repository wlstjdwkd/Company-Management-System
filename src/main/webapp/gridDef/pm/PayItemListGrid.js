/*
 * 리얼그리드 세부설정과 리얼그리드 관련 함수
 * 팝업용 급여 항목
 */

//필드 생성
var payItemFields = [
	{
		fieldName: "payItmNm",
		dataType: "text",
	},
	{
		fieldName: "payItmCd",
		dataType: "text",
	},
	{
		fieldName: "rmrk",
		dataType: "text",
	},
	{
		fieldName: "treeId"
	}
];

//칼럼 생성
var payItemColumns = [
	{
		name: "payItmNm",
		fieldName: "payItmNm",
		type: "data",
		width: "20",
		editable: false,
		header: {
			text: "명칭",
			styleName: "align-center"
		},
	},
	{
		name: "payItmCd",
		fieldName: "payItmCd",
		styleName: "align-right",
		type: "data",
		width: "10",
		editable: false,
		header: {
			text: "코드",
			styleName: "align-center"
		},
	},
	{
		name: "rmrk",
		fieldName: "rmrk",
		type: "data",
		width: "20",
		editable: false,
		styleName: "align-left",
		header: {
			text: "설명",
		},
	}
];

var payItemDataProvider, payItemGridView;

function createPayItemListGrid(container) {
	payItemDataProvider = new RealGrid.LocalTreeDataProvider();
	payItemGridView = new RealGrid.TreeView(container);
	payItemGridView.setDataSource(payItemDataProvider);

	payItemDataProvider.setFields(payItemFields);
	payItemGridView.setColumns(payItemColumns);

	payItemGridView.displayOptions.emptyMessage = "표시할 데이타가 없습니다.";
	//그리드 너비 자동 조정(비율)
	payItemGridView.displayOptions.fitStyle = "evenFill";
		
	$.ajax({
			type : "POST",
			url : "PGPM0030.do",
			data : { "df_method_nm" : "getUsePayItemList"},
			error : function(error) {
				console.log("error");
			},
			success : function(data) {
				console.log("success");
				var treeData = JSON.parse(data);
				//RealGrid parse (일반)
				payItemDataProvider.setRows(treeData, "treeId", true);	
				
				payItemGridView.expandAll();
				
				payItemGridView.setStateBar({visible: false});
				payItemGridView.setCheckBar({visible: false});
				payItemGridView.setFooter({visible: false});
			}
	});
	
	registerCallback();
}

function start() {
	createPayItemListGrid("payItemListGrid");
}

// $.document.ready(start);
window.onload = start;
// domloaded를 대신 써도 됩니다.

window.onunload = function() {
	payItemDataProvider.clearRows();

	payItemGridView.destroy();
	payItemDataProvider.destroy();

	payItemGridView = null;
	payItemDataProvider = null;
}