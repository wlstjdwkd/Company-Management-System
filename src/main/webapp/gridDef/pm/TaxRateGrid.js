/*
 * 리얼그리드 세부설정과 리얼그리드 관련 함수
 * Tree View 구현
 */

//필드 생성
var taxFields = [
	{
		fieldName: "payItmNm"
	},
	{
		fieldName: "payItmCd"
	},
	{
		fieldName: "refItmNm"
	},
	{
		fieldName: "refItmCd"
	},
	{
		fieldName: "taxRate"
	},
	{
		fieldName: "rmrk"
	}
];

//칼럼 생성
var taxColumns = [
	{
		name: "payItmNm",
		fieldName: "payItmNm",
		type: "data",
		width: "10",
		editable: false,
		header: {
			text: "급여항목명",
		},
	},
	{
		name: "payItmCd",
		fieldName: "payItmCd",
		type: "data",
		width: "10",
		editable: false,
		header: {
			text: "급여항목코드",
			styleName: "align-center"
		},
	},
	{
		name: "refItmNm",
		fieldName: "refItmNm",
		type: "data",
		width: "10",
		editable: false,
		header: {
			text: "참고항목명",
		},
	},
	{
		name: "refItmCd",
		fieldName: "refItmCd",
		type: "data",
		width: "10",
		editable: false,
		header: {
			text: "참고항목코드",
			styleName: "align-center"
		},
	},
	{
		name: "taxRate",
		fieldName: "taxRate",
		styleName: "align-right",
		type: "data",
		width: "10",
		editable: false,
		suffix: " %",
		header: {
			text: "세율(%)",
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

var taxDataProvider, taxView;

function createTaxRateGrid(container) {

	taxDataProvider = new RealGrid.LocalDataProvider();
	taxView = new RealGrid.GridView(container);
	taxView.setDataSource(taxDataProvider);

	taxDataProvider.setFields(taxFields);
	taxView.setColumns(taxColumns);

	taxView.displayOptions.emptyMessage = "표시할 데이타가 없습니다.";
	//그리드 너비 자동 조정(비율)
	taxView.displayOptions.fitStyle = "evenFill";
		
	$.ajax({
			type : "POST",
			url : "PGPM0060.do",
			data : { "df_method_nm" : "getTaxItemList" },
			error : function(error) {
				console.log("error");
			},
			success : function(data) {
				console.log("success");
				var taxData = JSON.parse(data);
				taxDataProvider.fillJsonData(taxData, { fillMode: "set" });
				
				taxView.expandAll();
				
				taxView.setStateBar({visible: false});
				taxView.setCheckBar({visible: false});
				taxView.setFooter({visible: false});
			}
	});
	
	registerCallback();
}

function start() {
	createTaxRateGrid("taxRateGrid");
}

// $.document.ready(start);
window.onload = start;
// domloaded를 대신 써도 됩니다.

window.onunload = function() {
	taxDataProvider.clearRows();

	taxView.destroy();
	taxDataProvider.destroy();

	taxView = null;
	taxDataProvider = null;
}