/*
 * 리얼그리드 세부설정과 리얼그리드 관련 함수
*/

//필드 생성
var payMntFields = [
	{
		fieldName: "PAY_ITM_NM",
		dataType: "text",
	},
	{
		fieldName: "PAY_ITM_CD",
		dataType: "text",
	},
	{
		fieldName: "RL_ACCT_YN",
		dataType: "text",
	},
	{
		fieldName: "SUM_LV",
		dataType: "text",
	},
	{
		fieldName: "ITM_LV",
		dataType: "text",
	},
	{
		fieldName: "UP_ITM_CD",
		dataType: "text",
	},
	{
		fieldName: "ITM_SEQ",
		dataType: "text",
	},
	{
		fieldName: "USE_YN",
		dataType: "text",
	},
	{
		fieldName: "RMRK",
		dataType: "text",
	},
	{
		fieldName: "ENRT_DT",
		dataType: "text",
	},
	{
		fieldName: "ITM_AMT_01",
		dataType: "number",
	},
	{
		fieldName: "ITM_AMT_02",
		dataType: "number",
	},
	{
		fieldName: "ITM_AMT_03",
		dataType: "number",
	},
	{
		fieldName: "ITM_AMT_04",
		dataType: "number",
	},
	{
		fieldName: "ITM_AMT_05",
		dataType: "number",
	},
	{
		fieldName: "ITM_AMT_06",
		dataType: "number",
	},
	{
		fieldName: "ITM_AMT_07",
		dataType: "number",
	},
	{
		fieldName: "ITM_AMT_08",
		dataType: "number",
	},
	{
		fieldName: "ITM_AMT_09",
		dataType: "number",
	},
	{
		fieldName: "ITM_AMT_10",
		dataType: "number",
	},
	{
		fieldName: "ITM_AMT_11",
		dataType: "number",
	},
	{
		fieldName: "ITM_AMT_12",
		dataType: "number",
	},
	{
		fieldName: "ITM_AMT_TOT",
		dataType: "number",
	},
	{
		fieldName: "treeId"
	}
];

//칼럼 생성
var payMntColumns = [
	{
		name: "PAY_ITM_NM",
		fieldName: "PAY_ITM_NM",
		type: "data",
		width: "200",
		header: {
			text: "급여항목명",
		},
	},
	{
		name: "PAY_ITM_CD",
		fieldName: "PAY_ITM_CD",
		type: "data",
		width: "100",
		header: {
			text: "급여항목코드",
		},
	},
	{
		name: "ITM_AMT_01",
		fieldName: "ITM_AMT_01",
		styleName: "align-right",
		type: "data",
		width: "100",
		numberFormat: "#,##0",
		header: {
			text: "1월",
		},
	},
	{
		name: "ITM_AMT_02",
		fieldName: "ITM_AMT_02",
		styleName: "align-right",
		type: "data",
		width: "100",
		numberFormat: "#,##0",
		header: {
			text: "2월",
		},
	},
	{
	    name: "ITM_AMT_03",
		fieldName: "ITM_AMT_03",
		styleName: "align-right",
	    type: "data",
		width: "100",
		numberFormat: "#,##0",
		header: {
			text: "3월",
		},
	},
	{
		name: "ITM_AMT_04",
		fieldName: "ITM_AMT_04",
		styleName: "align-right",
		type: "data",
		width: "100",
		numberFormat: "#,##0",
		header: {
			text: "4월",
		},
	},
	{
		name: "ITM_AMT_05",
		fieldName: "ITM_AMT_05",
		styleName: "align-right",
		type: "data",
		width: "100",
		numberFormat: "#,##0",
		header: {
			text: "5월",
		},
	},
	{
		name: "ITM_AMT_06",
		fieldName: "ITM_AMT_06",
		styleName: "align-right",
		type: "data",
		width: "100",
		numberFormat: "#,##0",
		header: {
			text: "6월",
		},
	},
	{
		name: "ITM_AMT_07",
		fieldName: "ITM_AMT_07",
		styleName: "align-right",
		type: "data",
		width: "100",
		numberFormat: "#,##0",
		header: {
			text: "7월",
		},
	},
	{
		name: "ITM_AMT_08",
		fieldName: "ITM_AMT_08",
		styleName: "align-right",
		type: "data",
		width: "100",
		numberFormat: "#,##0",
		header: {
			text: "8월",
		},
	},
	{
		name: "ITM_AMT_09",
		fieldName: "ITM_AMT_09",
		styleName: "align-right",
		type: "data",
		width: "100",
		numberFormat: "#,##0",
		header: {
			text: "9월",
		},
	},
	{
		name: "ITM_AMT_10",
		fieldName: "ITM_AMT_10",
		styleName: "align-right",
		type: "data",
		width: "100",
		numberFormat: "#,##0",
		header: {
			text: "10월",
		},
	},
	{
		name: "ITM_AMT_11",
		fieldName: "ITM_AMT_11",
		styleName: "align-right",
		type: "data",
		width: "100",
		numberFormat: "#,##0",
		header: {
			text: "11월",
		},
	},
	{
		name: "ITM_AMT_12",
		fieldName: "ITM_AMT_12",
		styleName: "align-right",
		type: "data",
		width: "100",
		numberFormat: "#,##0",
		header: {
			text: "12월",
		},
	},
	{
		name: "ITM_AMT_TOT",
		fieldName: "ITM_AMT_TOT",
		styleName: "align-right",
		type: "data",
		width: "120",
		numberFormat: "#,##0",
		header: {
			text: "합계",
		},
	}
];

var payMntDataProvider, payMntGridView;

function payMntCreate(container) {
	payMntDataProvider = new RealGrid.LocalTreeDataProvider();
	payMntGridView = new RealGrid.TreeView(container);
	payMntGridView.setDataSource(payMntDataProvider);

	payMntDataProvider.setFields(payMntFields);
	payMntGridView.setColumns(payMntColumns);
	
	//registerCallback();

	payMntGridView.displayOptions.emptyMessage = "표시할 데이타가 없습니다.";
	//payMntGridView.displayOptions.fitStyle = "evenFill";	//그리드 너비 자동 조정(비율)
	
	payMntGridView.setFixedOptions({colCount: 1});		// 왼쪽 (급여항목명) 열 고정
	payMntGridView.setFixedOptions({rightCount: 1});	// 오른쪽 끝(합계) 열 고정
	payMntGridView.setCheckBar({visible: false});		// 체크박스 숨기기 - JS파일 createGrid 안에
	payMntGridView.setStateBar({visible: false});		// 상태바(No. 옆 빈칸) 숨기기 - JS파일 createGrid 안에
	payMntGridView.setFooter({visible: false});			// 합계 footer 숨기기
	payMntGridView.setEditOptions({editable: false});	// 편집을 불가능하게 하려면 - JS파일 createGrid 안에
}

window.addEventListener('DOMContentLoaded', function() {
	payMntCreate("MNTpaygrid");
});