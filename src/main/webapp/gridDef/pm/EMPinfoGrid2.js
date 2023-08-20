/*
 * 리얼그리드 세부설정과 리얼그리드 관련 함수
*/

//필드 생성
var EMPinfofields = [
	{
		fieldName: "EMP_NO",
		dataType: "text",
	},
	{
		fieldName: "EMP_NM",
		dataType: "text",
	},
	{
		fieldName: "INCO_DT",
		dataType: "text",
	},
	{
		fieldName: "OUTCO_DT",
		dataType: "text",
	},
	{
		fieldName: "EMP_YOS",
		dataType: "number",
	},
	{
		fieldName: "HD_USED",
		dataType: "number",
	},
	{
		fieldName: "HD_LEFT",
		dataType: "number",
	}
];


//칼럼 생성
var EMPinfocolumns = [
	{
		name: "EMP_NO",
		fieldName: "EMP_NO",
		type: "data",
		width: "50",
		header: {
			text: "직원번호",
		},
	},
	{
		name: "EMP_NM",
		fieldName: "EMP_NM",
		type: "data",
		width: "50",
		header: {
			text: "이름",
		},
	},
	{
		name: "INCO_DT",
		fieldName: "INCO_DT",
		type: "data",
		width: "70",
		header: {
			text: "입사일",
		},
	},
	{
		name: "OUTCO_DT",
		fieldName: "OUTCO_DT",
		type: "data",
		width: "70",
		header: {
			text: "퇴사일",
		},
	},
	{
		name: "EMP_YOS",
		fieldName: "EMP_YOS",
		type: "data",
		width: "50",
		header: {
			text: "발생 휴가 일수",
		},
	},
	{
		name: "HD_USED",
		fieldName: "HD_USED",
		type: "data",
		width: "50",
		header: {
			text: "누적 사용 일수",
		},
	},
	{
		name: "HD_LEFT",
		fieldName: "HD_LEFT",
		type: "data",
		width: "50",
		header: {
			text: "잔여 일수",
		},
	}
];

var EMPinfodataProvider, EMPinfogridView;

function EMPinfoCreate(container) {
	EMPinfodataProvider = new RealGrid.LocalDataProvider();
	EMPinfogridView = new RealGrid.GridView(container);
	EMPinfogridView.setDataSource(EMPinfodataProvider);

	EMPinfodataProvider.setFields(EMPinfofields);
	EMPinfogridView.setColumns(EMPinfocolumns);
	
	EMPinfodataProvider.clearRows();

	$.ajax({
		type : "POST",
		url : "PGPM0080.do",
		data : { "df_method_nm" : "countSess" 
			, "ad_search_word" : $("#ad_search_word").val() 
			, "limitFrom" : 0 , "limitTo" : 100},
		error : function(error) {
			console.log("error");
		},
		success : function(data) {
			console.log("success");
			var ddd = JSON.parse(data);
			EMPinfodataProvider.fillJsonData(ddd, {fillMode: "set"});
		}
	});
	
	registerCallback();

	EMPinfogridView.displayOptions.emptyMessage = "표시할 데이타가 없습니다.";
	//그리드 너비 자동 조정(비율)
	EMPinfogridView.displayOptions.fitStyle = "evenFill";	
	
	// 체크박스 숨기기 - JS파일 createGrid 안에
	EMPinfogridView.setCheckBar({visible: false});

	// 상태바(No. 옆 빈칸) 숨기기 - JS파일 createGrid 안에
	EMPinfogridView.setStateBar({visible: false});
	
	// 합계 footer 숨기기
	EMPinfogridView.setFooter({visible: false});
	
	// 편집을 불가능하게 하려면 - JS파일 createGrid 안에
	EMPinfogridView.setEditOptions({editable: false});
}

window.addEventListener('DOMContentLoaded', function() {
	EMPinfoCreate("EMPinfogrid");
});