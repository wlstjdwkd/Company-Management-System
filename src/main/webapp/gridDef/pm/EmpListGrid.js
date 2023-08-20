/*
 * 리얼그리드 세부설정과 리얼그리드 관련 함수
 */

//필드 생성
var empFields = [
	{
		fieldName: "empNo",
		dataType: "text",
	},
	{
		fieldName: "empNm",
		dataType: "text",
	},
	{
		fieldName: "rmrk",
		dataType: "text",
	}
];

//칼럼 생성
var empColumns = [
	{
		name: "empNo",
		fieldName: "empNo",
		type: "data",
		width: "10",
		editable: false,
		header: {
			text: "코드",
		},
	},
	{
		name: "empNm",
		fieldName: "empNm",
		type: "data",
		width: "20",
		editable: false,
		header: {
			text: "이름",
			styleName: "align-center"
		},
	},
	{
		name: "rmrk",
		fieldName: "rmrk",
		styleName: "align-left",
		type: "data",
		width: "20",
		editable: false,
		header: {
			text: "비고",
		},
	}
];

var empDataProvider, empView;

function createEmpListGrid(container) {
	empDataProvider = new RealGrid.LocalDataProvider();
	empView = new RealGrid.GridView(container);
	empView.setDataSource(empDataProvider);

	empDataProvider.setFields(empFields);
	empView.setColumns(empColumns);

	empView.displayOptions.emptyMessage = "표시할 데이타가 없습니다.";
	//그리드 너비 자동 조정(비율)
	empView.displayOptions.fitStyle = "evenFill";
		
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
				empDataProvider.fillJsonData(ddd, { fillMode: "set" });
				
				empView.setStateBar({visible: false});
				empView.setCheckBar({visible: false});
				empView.setFooter({visible: false});
			}
	});
	
	registerCallback();
}

function start() {
	createEmpListGrid("empListGrid");
}

// $.document.ready(start);
window.onload = start;
// domloaded를 대신 써도 됩니다.

window.onunload = function() {
	empDataProvider.clearRows();

	empView.destroy();
	empDataProvider.destroy();

	empView = null;
	empDataProvider = null;
}