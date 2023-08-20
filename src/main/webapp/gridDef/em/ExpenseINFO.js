/*
 * 리얼그리도 세부설정과 리얼그리드 관련 함수
 */
 
 //필드
 var ExpInfoFields = [
	{
		fieldName: "DOCU_NO",
		dataType: "text",
	},
	{
		fieldName: "DATE",
		dataType: "text",
	},
	{
		fieldName: "DEPT_NM",
		dataType: "text",
	},
	{
	 	fieldName: "PRICE",
	 	dataType: "text",
	},
	{
		fieldName: "EMP_NM",
		dataType: "text",
	}
];

//칼럼
var ExpInfoColumns = [
	{	
		name: "DOCU_NO",
		fieldName: "DOCU_NO",
		type: "data",
		width: "100",
		header: {
			text: "문서 번호",
		}
	},
	{
		name: "DATE",
		fieldName: "DATE",
		type: "data",
		width: "80",
		header: {
			text: "등록 일자",
		}
	},
	{
		name: "DEPT_NM",
		fieldName: "DEPT_NM",
		type: "data",
		width: "80",
		header: {
			text: "관리 부서",
		}
	},
	{
		name: "PRICE",
		fieldName: "PRICE",
		type: "data",
		width: "100",
		header: {
			text: "총	액",
		},
		numberFormat: "#,##0",
		suffix: " 원"
	},
	{
		name: "EMP_NM",
		fieldName: "EMP_NM",
		type: "data",
		width: "80",
		header: {
			text: "담당사원",
		}
	}
];

var ExpInfoDataProvider, ExpInfoGridView;

function ExpInfoCreate(container) {
	ExpInfoDataProvider = new RealGrid.LocalDataProvider();
	ExpInfogridView = new RealGrid.GridView(container);
	ExpInfogridView.setDataSource(ExpInfoDataProvider);
	
	ExpInfoDataProvider.setFields(ExpInfoFields);
	ExpInfogridView.setColumns(ExpInfoColumns);
	
	ExpInfoDataProvider.clearRows();
	
	$.ajax({
		type : "POST",
		url : "PGEM0020.do",
		data : { "df_method_nm" : "countSess" 
			, "search_year" : $("#search_year").val()
			, "search_month" : $("#search_month").val()
			, "search_year2" : $("#search_year2").val()
			, "search_month2" : '12'
			, "department" : $("#department").val()
			, "ad_search_word" : $("#search_word").val()
			, "limitFrom" : 0 , "limitTo" : 100},
		error : function(error) {
			console.log("error");
		},
		success : function(data) {
			console.log("success");
			var ddd = JSON.parse(data);
			ExpInfoDataProvider.fillJsonData(ddd, {fillMode: "set"});
		}
	}); 
	
	registerCallback();
	
	ExpInfogridView.displayOptions.emptyMessage = "표시할 데이터가 없습니다.";
	
	ExpInfogridView.displayOptions.fitStyle = "evenFill";
	
	ExpInfogridView.setCheckBar({visible: false});
	ExpInfogridView.setStateBar({visible: false});
	ExpInfogridView.setFooter({visible: false});
	ExpInfogridView.setEditOptions({editable: false});
}

window.addEventListener('DOMContentLoaded', function() {
	ExpInfoCreate("ExpInfogrid");
});