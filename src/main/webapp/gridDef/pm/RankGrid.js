/*
 * 리얼그리드 세부설정과 리얼그리드 관련 함수
 */

//필드 생성
var rankFields = [
	{
		fieldName: "code",
		dataType: "text",
	},
	{
		fieldName: "codeNm",
		dataType: "text",
	},
	{
		fieldName: "codeDc",
		dataType: "text",
	}
];

//칼럼 생성
var rankColumns = [
	{
		name: "code",
		fieldName: "code",
		type: "data",
		width: "10",
		editable: false,
		header: {
			text: "코드",
		},
	},
	{
		name: "codeNm",
		fieldName: "codeNm",
		type: "data",
		width: "20",
		editable: false,
		header: {
			text: "명칭",
			styleName: "align-center",
		},
	},
	{
		name: "codeDc",
		fieldName: "codeDc",
		styleName: "align-left",
		type: "data",
		width: "20",
		editable: false,
		header: {
			text: "설명",
		},
	}
];

var rankDataProvider, rankGridView;

function createRankGrid(container) {
	rankDataProvider = new RealGrid.LocalDataProvider();
	rankGridView = new RealGrid.GridView(container);
	rankGridView.setDataSource(rankDataProvider);

	rankDataProvider.setFields(rankFields);
	rankGridView.setColumns(rankColumns);

	rankGridView.displayOptions.emptyMessage = "표시할 데이타가 없습니다.";
	//그리드 너비 자동 조정(비율)
	rankGridView.displayOptions.fitStyle = "evenFill";
		
	$.ajax({
			type : "POST",
			url : "PGPM0010.do",
			data : { "df_method_nm" : "getRankList" },
			error : function(error) {
				console.log("error");
			},
			success : function(data) {
				console.log("success");
				var ddd = JSON.parse(data);
				//RealGrid parse (일반)
				rankDataProvider.fillJsonData(ddd, { fillMode: "set" });
				
				rankGridView.setStateBar({visible: false});
				rankGridView.setCheckBar({visible: false});
				rankGridView.setFooter({visible: false});
			}
	});
	
	registerCallback();
}

function start() {
	createRankGrid("rankgrid");
}

// $.document.ready(start);
window.onload = start;
// domloaded를 대신 써도 됩니다.

window.onunload = function() {
	rankDataProvider.clearRows();

	rankGridView.destroy();
	rankDataProvider.destroy();

	rankGridView = null;
	rankDataProvider = null;
}