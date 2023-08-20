/*
 * 리얼그리드 세부설정과 리얼그리드 관련 함수
*/

//필드 생성
var calcPayFields = [
	{
		fieldName: "payItmNm",
		dataType: "text",
	},
	{
		fieldName: "payItmCd",
		dataType: "text",
	},
	{
		fieldName: "empTot",
		dataType: "number",
	},
	{
		fieldName: "treeId"
	}
];

//칼럼 생성
var calcPayColumns = [
	{
		name: "payItmNm",
		fieldName: "payItmNm",
		type: "data",
		width: "200",
		header: {
			text: "급여항목명",
		}
	},
	{
		name: "payItmCd",
		fieldName: "payItmCd",
		type: "data",
		width: "100",
		header: {
			text: "급여항목코드",
		}
	},
	{
		name: "empTot",
		fieldName: "empTot",
		styleName: "align-right",
		type: "data",
		width: "120",
		numberFormat: "#,##0",
		header: {
			text: "합계",
		}
	}
];

var calcPayDataProvider, calcPayGridView;

function calcPayCreate(container) {
	calcPayDataProvider = new RealGrid.LocalTreeDataProvider();
	calcPayGridView = new RealGrid.TreeView(container);
	calcPayGridView.setDataSource(calcPayDataProvider);

	calcPayDataProvider.setFields(calcPayFields);
	calcPayGridView.setColumns(calcPayColumns);

	calcPayGridView.displayOptions.emptyMessage = "표시할 데이타가 없습니다.";
	//calcPayGridView.displayOptions.fitStyle = "evenFill";	// 그리드 너비 자동 조정(비율)
	
	calcPayGridView.setFixedOptions({colCount: 1});		// 왼쪽 (급여항목명) 열 고정
	calcPayGridView.setFixedOptions({rightCount: 1});	// 오른쪽 끝(합계) 열 고정
	calcPayGridView.setCheckBar({visible: false});		// 체크박스 숨기기 - JS파일 createGrid 안에
	calcPayGridView.setStateBar({visible: false});		// 상태바(No. 옆 빈칸) 숨기기 - JS파일 createGrid 안에
	calcPayGridView.setFooter({visible: false});			// 합계 footer 숨기기
	calcPayGridView.setEditOptions({editable: false});	// 편집을 불가능하게 하려면 - JS파일 createGrid 안에
}

window.addEventListener('DOMContentLoaded', function() {
	calcPayCreate("calcPayGrid");
});

//필드,컬럼 동적 생성
function setFieldsNColumns(provider, grid, columnInfo) {
	var fields = [];

	for (var key in columnInfo) {
		var col = columnInfo[key];

	if (!col.fieldName) col.fieldName = col.name;
		if (col && (!col.items)) {
			//field 구성
			var f = {};
			f.fieldName = col.name;
			if (col.tag && col.tag.dataType) f.dataType = col.tag.dataType;

			fields
			fields.push(f);
		};
	};

	provider.setFields(fields);
	grid.setColumns(columnInfo);
 };