/*
 * 리얼그리도 세부설정과 리얼그리드 관련 함수
 */
 
 //필드
 var ExpInfoFields = [
	{
		fieldName: "DATE",
		DataType: "text",
	},
	{
		fieldName: "DOCU_NM",
		DataType: "text",
	},
	{
		fieldName: "SHOP",
		DataType: "text",
	},
	{
	 	fieldName: "PRICE",
	 	DataType: "number",
	},
	{
		fieldName: "NOTE",
		DataType: "text",
	}
];

//칼럼
var ExpInfoColumns = [
	{
		name: "DATE",
		fieldName: "DATE",
		type: "Data",
		width: "50",
		header: {
			text: "지출 일자",
		}
	},
	{
		name: "DOCU_NM",
		fieldName: "DOCU_NM",
		type: "Data",
		width: "150",
		header: {
			text: "내	역",
		}
	},
	{
		name: "SHOP",
		fieldName: "SHOP",
		type: "Data",
		width: "80",
		header: {
			text: "상	호",
		},
		footer: {
			text : "합 계 => " 
		}
	},
	{
		name: "PRICE",
		fieldName: "PRICE",
		type: "Data",
		width: "80",
		header: {
			text: "금	액",
		},
		numberFormat: "#,##0",
		suffix: " 원",
		footer: {
			text: "합계",
			expression: "sum",
			groupexpression:"sum"
		}
	},
	{
		name: "NOTE",
		fieldName: "NOTE",
		type: "Data",
		width: "120",
		header: {
			text: "비	고",
		},
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
	
	
	ExpInfogridView.displayOptions.emptyMessage = "표시할 데이터가 없습니다.";
	//그리드 너비 자동조정(채우기)
	ExpInfogridView.displayOptions.fitStyle = "evenFill";
	
	//자동 순번
	ExpInfogridView.setRowIndicator({visible: false});
	//체크박스
	ExpInfogridView.setCheckBar({visible: true});
	//상태바
	ExpInfogridView.setStateBar({visible: true});
	//footer
	ExpInfogridView.setFooter({visible: true});
	//셀 편집
	ExpInfogridView.setEditOptions({editable: true});
	//푸터 좌측칸
	ExpInfogridView.setRowIndicator({footText: "정보"});
	
	//행 추가 (ins키로 선택된 행 위에 추가, ins+shift키로 선택된 행 아래에 추가)
	ExpInfogridView.setEditOptions({insertable: true});
	
	//행 추가 (↓키로 맨 마지막줄에 행 추가)
	ExpInfogridView.setEditOptions({appendable: true});
	
	//행 삭제
	ExpInfogridView.setEditOptions({deletable: true});
	
	
}

//행 삽입(지정행 이전), beginInsertRow(itemIndex, shift), shift의 default는 false
function btnBeginInsertRow() {
	var curr = ExpInfogridView.getCurrent();
	ExpInfogridView.beginInsertRow(Math.max(0, curr.itemIndex));
	ExpInfogridView.showEditor();
	ExpInfogridView.setFocus();
}
	
//행 삽입(지정행 이후)
function btnBeginInsertRowShift() {
	var curr = ExpInfogridView.getCurrent();
	ExpInfogridView.beginInsertRow(Math.max(0, curr.itemIndex), true);
	ExpInfogridView.showEditor();
	ExpInfogridView.setFocus();
}

//행 추가(최하단), beginAppendRow:그리드 마지막 데이터행 이후에 새로운 데이터행을 추가한다.
function btnBeginAppendRow() {
	ExpInfogridView.beginAppendRow();
	ExpInfogridView.showEditor();
	ExpInfogridView.setFocus();
}

//행 삭제, getCurrent:현재 포커스를 갖는 셀의 CellIndex 값을 가져온다.
//	 		removeRow: 행 삭제
function btnRemoveRow() {
	var curr = ExpInfogridView.getCurrent();
	ExpInfoDataProvider.removeRow(curr.DataRow);
}
	
window.addEventListener('DOMContentLoaded', function() {
	ExpInfoCreate("ExpInfogrid");
});