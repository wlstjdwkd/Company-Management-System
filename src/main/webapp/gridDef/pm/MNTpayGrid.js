/*
 * 리얼그리드 세부설정과 리얼그리드 관련 함수
*/

//필드 생성
var MNTpayfields = [
	{
		fieldName: "PAY_ITM_CD",
		dataType: "text",
	},
	{
		fieldName: "PAY_ITM_NM",
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
		dataType: "text",
	},
	{
		fieldName: "ITM_AMT_02",
		dataType: "text",
	},
	{
		fieldName: "ITM_AMT_03",
		dataType: "text",
	},
	{
		fieldName: "ITM_AMT_04",
		dataType: "text",
	},
	{
		fieldName: "ITM_AMT_05",
		dataType: "text",
	},
	{
		fieldName: "ITM_AMT_06",
		dataType: "text",
	},
	{
		fieldName: "ITM_AMT_07",
		dataType: "text",
	},
	{
		fieldName: "ITM_AMT_08",
		dataType: "text",
	},
	{
		fieldName: "ITM_AMT_09",
		dataType: "text",
	},
	{
		fieldName: "ITM_AMT_10",
		dataType: "text",
	},
	{
		fieldName: "ITM_AMT_11",
		dataType: "text",
	},
	{
		fieldName: "ITM_AMT_12",
		dataType: "text",
	},
	{
		fieldName: "ITM_AMT_TOT",
		dataType: "text",
	}
];

//칼럼 생성
var MNTpaycolumns = [
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
		name: "PAY_ITM_NM",
		fieldName: "PAY_ITM_NM",
		type: "data",
		width: "200",
		header: {
			text: "급여항목명",
		},
	},
	{
		name: "ITM_AMT_01",
		fieldName: "ITM_AMT_01",
		type: "data",
		width: "100",
		header: {
			text: "1월",
		},
	},
	{
		name: "ITM_AMT_02",
		fieldName: "ITM_AMT_02",
		type: "data",
		width: "100",
		header: {
			text: "2월",
		},
	},
	{
	    name: "ITM_AMT_03",
		fieldName: "ITM_AMT_03",
	    type: "data",
		width: "100",
		header: {
			text: "3월",
		},
	},
	{
		name: "ITM_AMT_04",
		fieldName: "ITM_AMT_04",
		type: "data",
		width: "100",
		header: {
			text: "4월",
		},
	},
	{
		name: "ITM_AMT_05",
		fieldName: "ITM_AMT_05",
		type: "data",
		width: "100",
		header: {
			text: "5월",
		},
	},
	{
		name: "ITM_AMT_06",
		fieldName: "ITM_AMT_06",
		type: "data",
		width: "100",
		header: {
			text: "6월",
		},
	},
	{
		name: "ITM_AMT_07",
		fieldName: "ITM_AMT_07",
		type: "data",
		width: "100",
		header: {
			text: "7월",
		},
	},
	{
		name: "ITM_AMT_08",
		fieldName: "ITM_AMT_08",
		type: "data",
		width: "100",
		header: {
			text: "8월",
		},
	},
	{
		name: "ITM_AMT_09",
		fieldName: "ITM_AMT_09",
		type: "data",
		width: "100",
		header: {
			text: "9월",
		},
	},
	{
		name: "ITM_AMT_10",
		fieldName: "ITM_AMT_10",
		type: "data",
		width: "100",
		header: {
			text: "10월",
		},
	},
	{
		name: "ITM_AMT_11",
		fieldName: "ITM_AMT_11",
		type: "data",
		width: "100",
		header: {
			text: "11월",
		},
	},
	{
		name: "ITM_AMT_12",
		fieldName: "ITM_AMT_12",
		type: "data",
		width: "100",
		header: {
			text: "12월",
		},
	},
	{
		name: "ITM_AMT_TOT",
		fieldName: "ITM_AMT_TOT",
		type: "data",
		width: "100",
		header: {
			text: "합계",
		},
	}
];

var MNTpaydataProvider, MNTpaygridView;

function MNTpayCreate(container) {
	MNTpaydataProvider = new RealGrid.LocalDataProvider();
	MNTpaygridView = new RealGrid.GridView(container);
	MNTpaygridView.setDataSource(MNTpaydataProvider);

	MNTpaydataProvider.setFields(MNTpayfields);
	MNTpaygridView.setColumns(MNTpaycolumns);
	
	registerCallback();

	MNTpaygridView.displayOptions.emptyMessage = "표시할 데이타가 없습니다.";
	//그리드 너비 자동 조정(비율)
	MNTpaygridView.displayOptions.fitStyle = "evenFill";	
	
	// 체크박스 숨기기 - JS파일 createGrid 안에
	MNTpaygridView.setCheckBar({visible: false});

	// 상태바(No. 옆 빈칸) 숨기기 - JS파일 createGrid 안에
	MNTpaygridView.setStateBar({visible: false});
	
	// 합계 footer 숨기기
	MNTpaygridView.setFooter({visible: false});
	
	// 편집을 불가능하게 하려면 - JS파일 createGrid 안에
	MNTpaygridView.setEditOptions({editable: false});
}

window.addEventListener('DOMContentLoaded', function() {
	MNTpayCreate("MNTpaygrid");
});