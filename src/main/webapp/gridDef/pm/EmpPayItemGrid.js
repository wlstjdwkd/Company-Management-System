/*
 * 개인별월급여항목
 * 
 * 자동 집계와 수정 기록 DB 저장
 *
 * 1 그리드에 data 적용
 * 2 수정 제한
 * 2-1 사용 수정 제한
 * 2-2 금액 수정 제한
 * 3 금액집계
 * 3-1 수정한 금액란이 비었으면 0 채우기
 * 3-2 부모가 같은 항목 합산해 최상위 부모까지의 금액 수정
 * 3-3 세율 일괄적용 항목 자동 계산
 * 3-3-1 TB_PAY_TAX_LST 항목 계산
 * 3-3-2 예외 계산
 * 3-3-2-1 갑근세
 * 3-3-2-2 주민세
 * 3-3-2-3 고용보험.회사부담금
 * 3-4 예외사항 집계
 * 3-4-1 본인공제총액
 * 3-4-2 회사부담총액
 * 3-4-3 차인지급액 집계
 * 4 유효성 검사 
 * 5 footer 수식
 * 
 * (공용1) grid 행(절대 위치) 찾기
 * (공용2) 세금계산
 */

// 필드 생성
var empPayFields = [
	{
		fieldName: "payItmNm"
	},
	{
		fieldName: "payItmCd"
	},
	{
		fieldName: "itmBasAmt",
		dataType : "number"
	},
	{
		fieldName: "useYN"
	},
	{
		fieldName: "rmk"
	},
	{
		fieldName: "modDt"
	},
	{
		fieldName: "enrtDay"
	},
	{
		fieldName: "upItmCd"
	},
	{
		fieldName: "treeId"
	}
];

// 칼럼 생성
var empPayColumns = [
	{
		name: "payItmNm",
		fieldName: "payItmNm",
		styleName: "payItmNm",
		type: "data",
		width: "20",
		editable: false,
		header: {
			text: "급여항목명"
		},
		footer: {
			text: "차인지급액"
		}
	},
	{
		name: "payItmCd",
		fieldName: "payItmCd",
		styleName: "align-center",
		type: "data",
		width: "8",
		editable: false,
		header: {
			styleName: "align-center",
			text: "급여항목코드"
		},
		footer: {
			styleName: "align-right",
			text: "900000000"			// 차인지급액 항목 코드
		}
	},
	{
		name: "itmBasAmt",
		fieldName: "itmBasAmt",
		styleName: "align-right",
		type: "data",
		width: "10",
		editable: false,
		numberFormat: "#,##0",
		editor: {
			inputCharacters: "0-9"
		},
		header: {
			text: "금액"
		},
		footer: {
			styleName: "align-right",
			numberFormat: "#,##0",
			suffix: " 원"
		}
	},
	{
		name: "useYN",
		fieldName: "useYN",
		styleName: "useYN",
		type: "data",
		width: "4",
		editable: false,
		editor : {
			"type" : "dropdown",
			"dropDownCount" : 2,
			"domainOnly" : true,
			"textReadOnly" : true,
			"values" : ["Y", "N"],
			"labels" : ["<Y>", "<N>"]
		},
		header: {
			text: "사용"
		}
	},
	{
		name: "rmk",
		fieldName: "rmk",
		styleName: "align-left",
		type: "data",
		width: "30",
		editable: false,
		header: {
			text: "비고"
		}
	},
	{
		name: "modDt",
		fieldName: "modDt",
		styleName: "modDt",
		type: "data",
		width: "8",
		editable: false,
		header: {
			text: "수정일자"
		}
	},
	{
		name: "enrtDay",
		fieldName: "enrtDay",
		styleName: "enrtDay",
		type: "data",
		width: "8",
		editable: false,
		header: {
			text: "등록일자"
		}
	},
	{
		name: "upItmCd",
		fieldName: "upItmCd",
		styleName: "upItmCd",
		type: "data",
		visible: false,
		editable: false
	}
];

var empPayDataProvider, empPayView;

// 생성 메서드
function createSearchPayItemGrid(container) {
	empPayDataProvider = new RealGrid.LocalTreeDataProvider();
	empPayView = new RealGrid.TreeView(container);
	empPayView.setDataSource(empPayDataProvider);

	empPayDataProvider.setFields(empPayFields);
	empPayView.setColumns(empPayColumns);

	empPayView.displayOptions.emptyMessage = "표시할 데이타가 없습니다.";
	// 그리드 너비 자동 조정(비율)
	empPayView.displayOptions.fitStyle = "evenFill";
		
	$.ajax({
			type : "POST",
			//항목이 비어있는 초기화면 불러오기
			url : "PGPM0030.do",
			data : { "df_method_nm" : "getUsePayItemList" },
			error : function(error) {
				console.log("error");
			},
			// 1 그리드에 data 적용
			// 2 수정 제한
			// 3 금액집계
			// 4 유효성 검사 
			// 5 footer 수식
			success : function(data) {
				//// 1 그리드에 data 적용
				// treeId열을 통해 트리뷰를 구현할 데이터 넣기
				console.log("success");
				var treeData = JSON.parse(data);
				empPayDataProvider.setRows(treeData, "treeId", true);	
				
				//// 2 수정 제한
				// 2-1 사용 수정 제한
				// 2-2 금액 수정 제한
				
				// 2-1 사용 수정 제한
				const sumEditFalse = function(grid, dataCell) {	
					return restrictUseEdit(dataCell);			// 부모와 최상위 항목 모두 수정 금지(조건)
				}
				let colYn = empPayView.columnByName("useYN");
				colYn.styleCallback = sumEditFalse;				// 사용 수정 제한
				
				//// 2-2 금액 수정 제한
				// TB_PAY_TAX_LST 항목의 금액 추가 제한
				// 테이블에 있는 값들은 자동 집계 됨으로 수정이 불가 하게 한다
				$.ajax({
					type : "POST",
					url : "PGPM0060.do",
					data : { "df_method_nm" : "getTaxItemList" },
					error : function(error) {
						console.log("error");
					},
					success : function(data) {
						var taxList  = JSON.parse(data);
						var taxListSize = taxList.length;
						
						//예외 세율계산 항목코드 추가
						//taxList.push({"payItmCd" : "203020200"});	//고용보험.회사부담금
						
						var codeEditFalse = function(grid, dataCell) {
							return restrictCertainEdit(dataCell, taxList);
						}
						let codeCol = empPayView.columnByName("itmBasAmt");
						codeCol.styleCallback = codeEditFalse;
					}
				});
				
				//// 3 금액집계
				// 호출 상황: 수정이 완료된면 호출되는 callBack
				// 3-1 수정한 금액란이 비었으면 0 채우기
				// 3-2 부모가 같은 항목 합산해 최상위 부모까지의 금액 수정
				// 3-3 세율 일괄적용 항목 자동 계산
				// 3-4 예외사항 집계
				empPayView.onCellEdited = function editPay(grid, itemIndex, row, field) {
					var payField = 2;		//금액 필드(열) 위치
					var useField = 3;		//사용 필드(열) 위치
				     
					if(field == payField || field == useField) {	//금액(항목기본금액) 또는 사용(사용여부)이 수정 되었을 때
						
						// 3-1 수정한 금액란이 비었으면 0 채우기
						empPayView.commit();
						if(!(empPayDataProvider.getValue(row, payField))) {	//금액란이 비었다면 (NaN, 0, null, "" 중 하나라면)
							empPayDataProvider.setValue(row, payField, 0);
						} 
						
						// 3-2 부모가 같은 항목 합산해 최상위 부모까지의 금액 수정
						aggregatePay(itemIndex, row, payField);	//수정된 항부터 최상위 부모 항까지 및 관련 항목 재집계
						
						// 3-3 세율 일괄적용 항목 자동 계산
						aggregateTax(payField);
												
						// 3-4 예외사항 집계
						aggregateException();
					}
				}
				
				/*
				//// 4  유효성 검사
				// !! 3-1로 해당 상황이 발생하지 않아 사용 안함
				// 금액란을 비울 수 없게
				// @author 이유진
				empPayView.onValidateColumn = function(grid, column, inserting, value) {
					var error = {};
					if (column.fieldName === "itmBasAmt") {
						if (value == "" || value == null) {
							error.level = "error";
							error.message = "금액은 0 이상이여야 합니다.";
						}
					}
					
					return error;
				}
				*/
				
				// 5 footer 수식 
				// !! 현재 footer를 사용하지 않아 노출되지 않음
				// footer에 차인지급액  적용
				empPayView.columnByName("itmBasAmt").footer.valueCallback = function(grid, column, footerIndex, columnFooter, value) {
					return calcFooter();	//차인지급액 계산
				}
				
				empPayView.expandAll();
				empPayView.setStateBar({visible: true});
				empPayView.setCheckBar({visible: false});
				empPayView.setFooter({visible: false});
			}
	});
}

function start() {
	createSearchPayItemGrid("empPayGrid");
}

// $.document.ready(start);
window.onload = start;
// domloaded를 대신 써도 됩니다.

window.onunload = function() {
	empPayDataProvider.clearRows();

	empPayView.destroy();
	empPayDataProvider.destroy();

	empPayView = null;
	empPayDataProvider = null;
}

//// 공용1 행(절대 위치) 찾기
// field 열에서 cmpValue값과 같은 행 찾기
function findRow(cmpValue, field) {
	var rowCount = empPayDataProvider.getRowCount();
	var i;
	for(i = 1; i <= rowCount; i++) {
		if(cmpValue == empPayDataProvider.getValue(i, field)) {
			break;		
		}
	}
	
	// 찾지 못한 경우
	if(i > rowCount) {
		i = -1;
	}

	return i;	
}

// 2 수정 제한
//// 2-1 사용 수정 제한
// 조건 1. 최상위 항목일 때
// 조건 2. 자식이 있을때 (부모 항목일 때)
// @author 이유진
function restrictUseEdit(dataCell) {
	var itemIndex = dataCell.index.itemIndex;
	var itemRow = empPayView.getDataRow(itemIndex);
	var ret = {};
	
	// 자식이 있거나 최상위항목일 때				
	if(empPayView.getChildren(itemIndex).length > 0 || empPayDataProvider.getValue(itemRow, "upItmCd") < 1) {
		ret.editable = false;	//수정 불가
	}
	
	return ret;
}

//// 2-2 금액 수정 제한
// 조건 1. 최상위 항목일 때
// 조건 2. 자식이 있을때 (부모 항목일 때)
// 조건 3. itemList에 있는 코드값과 같은 항목들은 수정 불가
function restrictCertainEdit(dataCell, itemList) {
	var itemIndex = dataCell.index.itemIndex;
	var itemRow = empPayView.getDataRow(itemIndex);
	var ret = {};

	// itemList의 항목코드와 같을때
	for(var i = 0; i < itemList.length; i++) {
		if(empPayDataProvider.getValue(itemRow, "payItmCd") == itemList[i].payItmCd) {	// 항목코드 값이 같을 때
			ret.editable = false;	//수정 불가
		}
	}
	
	// 자식이 있거나 최상위항목일 때				
	if(empPayView.getChildren(itemIndex).length > 0 || empPayDataProvider.getValue(itemRow, "upItmCd") < 1) {
		ret.editable = false;	//수정 불가
	}
	
	return ret;
}

//// 3-2 집계 기능 수행
// 부모코드가 같고 사용여부가 Y인 항목들을 집계
// 집계된 금액으로 부모 항목의 금액 수정
// 이에 따라, 부모값도 수정돼 조부모도 달라지기 때문에 최상위 부모까지 recursion
function aggregatePay(itemIndex, row, fieldNum) {
	var parentRow = empPayView.getDataRow(empPayView.getParent(itemIndex));		// index 위치를 row 위치로 변환
	//console.log('Edit done! index at ' + itemIndex + ', Field : ' + fieldNum + ', row: ' + row + ', parentRow: ' + parentRow);
	
	if(parentRow > 0) {	// 최상위 항목이 아닐때
		empPayView.commit();	// 새로운 위치에 수정을 하기 위해선 commit이나 cancel 후에 가능
		
		// 전체 테이블에서 부모 코드가 같은 것끼리 합산해 부모에 지정
		var sum = 0;	// 자식 집계값
		var upCd = empPayDataProvider.getValue(row, "upItmCd");					// 부모 코드 기준
		for(var i = 1; i <= empPayDataProvider.getRowCount(); i++) {	// 전체 테이블에서
			var parentCode = empPayDataProvider.getValue(i, "upItmCd");			// 확인하는 행의 부모 코드
			var isUse = empPayDataProvider.getValue(i, "useYN");				// 사용여부
			if(parentCode == upCd && isUse == "Y") {					// 부모코드 같고, 사용여부 Y일 때
				sum += empPayDataProvider.getValue(i, fieldNum);		// 금액을 모두 더한다
			}
		}
		empPayDataProvider.setValue(parentRow, fieldNum, sum);			// 부모 금액 수정
		
		aggregatePay(empPayView.getParent(itemIndex), parentRow, fieldNum);	// 부모 행으로 재집계 recursion
	}
}

//// 3-3 세율 일괄적용 항목 자동 계산
// 3-3-1 TB_PAY_TAX_LST 항목 계산
// 3-3-2 예외 계산
// 모든 사원에게 일괄적용되는 항목 목록을 받아 수정
function aggregateTax(fieldNum) {
	$.ajax({
		type : "POST",
		url : "PGPM0060.do",
		async : false,
		data : { "df_method_nm" : "getTaxItemList" },
		error : function(error) {
			console.log("error");
		},
		success : function(data) {
			// 3-3-1 TB_PAY_TAX_LST 항목 계산
			var taxList  = JSON.parse(data);
						
			var taxListSize = taxList.length;
			for(var i=0; i < taxListSize; i++) {
				var tax = taxList[i];
				
				// 값 받아서 계산
				// 목표 금액의 위치(세율계산(참고항목 코드, 세율))
				empPayView.commit();
				
				var rstAmt = spExecCalAmt(tax.refItmCd, tax.taxRate);				// 세율 적용된 항목금액
				
				// 테이블에 등록된 세율들 계산
				//console.log(rstAmt);
				if(rstAmt >= 0) {															// 금액이 정상일 때 
					var rowNum = findRow(tax.payItmCd, "payItmCd");					// 행 번호
					if(rowNum > 0) {														// 위치를 찾았을 때
						empPayView.commit();
								
						empPayDataProvider.setValue(rowNum, fieldNum, rstAmt);				// 집계액 기입
						aggregatePay(empPayView.getItemIndex(rowNum), rowNum, fieldNum);	// 재집계
					}
				}
			}
			
			//// 3-3-2 예외 계산
			// 3-3-2-1  갑근세
			// 3-3-2-2  주민세
			// 3-3-2-3 고용보험.회사부담금
			var rstAmt;		// 계산된 항목금액
			var rowNum;		// 행번호
			
			//// 3-3-2-1 갑근세(201010000)
			// 지급항목(100000000) * 공제세율%(DC_RT, DB에 존재)
			/*
			$.ajax({
				type : "POST",
				url : "PGPM0030.do",
				async : false,
				data : {	"df_method_nm" : "getDcRt"
						,	"empNo" : $("#ad_employee_code").val()},
				error : function(error) {
					console.log("error");
				},
				success : function(employeeData) {					
					var empList  = JSON.parse(employeeData);
					var dcRt = empList[0].dcRt;									// 공제세율
					
					empPayView.commit();
										
					rstAmt = spExecCalAmt("100000000", dcRt);							// 지급항목 * 공제세율%
					rowNum = findRow("201010000", "payItmCd");					// 갑근세 행번호
					empPayDataProvider.setValue(rowNum, fieldNum, rstAmt);				// 기입
					aggregatePay(empPayView.getItemIndex(rowNum), rowNum, fieldNum);	// 재집계
			
					//// 3-3-2-2 주민세(201020000)
					// 갑근세 * 10%
					empPayView.commit();
					
					rstAmt = spExecCalAmt("201010000", 10);								// 갑근세 * 10%
					rowNum = findRow("201020000", "payItmCd");					// 주민세 행번호
					empPayDataProvider.setValue(rowNum, fieldNum, rstAmt);				// 기입
					aggregatePay(empPayView.getItemIndex(rowNum), rowNum, fieldNum);	// 재집계
				}
			});
			*/
			
			//// 3-3-2-3 고용보험.회사부담금(203020200)
			// 지급항목 * 0.25% + 직원예수금(203020100)
			/* !! 프로그래머가 직접 수정해야하는데 매년 바뀔수 있어서 미사용
			empPayView.commit();
			
			rowNum = findRow("203020100", "payItmCd");							// 직원예수금 행번호
			rstAmt = spExecCalAmt("100000000", 0.25);					// 지급항목 * 0.25%
			rstAmt += empPayDataProvider.getValue(rowNum, fieldNum);	// + 직원예수금
			rowNum = findRow("203020200", "payItmCd");							// 고용보험.회사부담금 행번호
			empPayDataProvider.setValue(rowNum, fieldNum, rstAmt);		// 기입
			aggregatePay(empPayView.getItemIndex(rowNum), rowNum, fieldNum);	// 재집계
			*/
		}
	});
	
}

//// 공용2 세금계산
// 참조항목 금액 * 세율, 일의 자리는 반올림
function spExecCalAmt(refItmCode, taxRate) {
	var tax = -1;			// 결과값
	var refItmAmt = -1;		// 참조항목의 금액
	var rowNum = -1;		// 행번호
	
	//console.log("refItmCode: " + refItmCode + " taxRate: " + taxRate);
	
	// refItmCode로 해당 항목의 금액을 찾아
	rowNum = findRow(refItmCode, "payItmCd");
	if(rowNum > 0) {
		refItmAmt = empPayDataProvider.getValue(rowNum, "itmBasAmt");
	}
	
	// 일의 자리에서 반올림하는 결과를 낸다
	if(refItmAmt => 0) {
		// 소수점아래 첫 자리 반올림('참조항목 금액' x ('세율' / 100) / 10) * 10
		tax = Math.round(refItmAmt * (taxRate / 1000)) * 10;
	}

	return tax;
}

//// 3-4 예외사항 집계
// 3-4-1 본인공제총액
// 3-4-2 회사부담총액
// 3-4-3 차인지급액 집계
// !! 세율계산이 적용된 이후 예외사항 집계가 사용자가 수정하기 이전 값으로 받는 문제가 발생
//		정확히는 세율계산을 할때만 그렇고 세율계산이 적용되지 않으면 정상 작동
function aggregateException() {
	var payItmRow = -1;		//지급항목  row
	var deductionRow = -1;	//공제항목  row
	var selfPayRow = -1;	//본인공제총액 row
	var corpPayRow = -1;	//회사부담총액 row
	var netAmountRow = -1;	//차인지급액 row
	var selfPaySum = 0;		//본인공제총액 집계액
	var corpPaySum = 0;		//회사부담총액 집계액
	
	empPayView.commit();
	for(var i = 1; i <= empPayDataProvider.getRowCount(); i++) {				// 전체 테이블에서
		
		// 집계에 필요한 항목 row 위치
		var itmNm = empPayDataProvider.getValue(i, "payItmNm")
		switch(itmNm) {
			//항목 row 찾기
			case "지급항목":
				payItmRow = i;
				break;
			case "공제항목":
				deductionRow = i;
				break;
			case "본인공제총액":
				selfPayRow = i;
				break;
			case "회사부담총액":
				corpPayRow = i;
				break;
			case "차인지급액":
				netAmountRow = i;
				break;
			
			//// 예외사항 계산
			// 3-4-1 본인공제총액 집계
			// 본인공제총액 = 갑근세 + 주민세 + 사우회비 + (4대보험)직원예수금 합계 + 정산금액
			case "갑근세":
				if(empPayDataProvider.getValue(i, "useYN") == 'Y') {			// 사용여부가 Y인
					selfPaySum += empPayDataProvider.getValue(i, "itmBasAmt");	// 갑근세
				}
				break;
			case "주민세":
				if(empPayDataProvider.getValue(i, "useYN") == 'Y') {			// 사용여부가 Y인
					selfPaySum += empPayDataProvider.getValue(i, "itmBasAmt");	// 주민세
				}
				break;
			case "사우회비":
				if(empPayDataProvider.getValue(i, "useYN") == 'Y') {			// 사용여부가 Y인
					selfPaySum += empPayDataProvider.getValue(i, "itmBasAmt");	// 사우회비
				}
				break;
			case "직원예수금":
				if(empPayDataProvider.getValue(i, "useYN") == 'Y') {			// 사용여부가 Y인
					selfPaySum += empPayDataProvider.getValue(i, "itmBasAmt");	// 직원예수금의 합
				}
				break;
			case "정산금액":
				if(empPayDataProvider.getValue(i, "useYN") == 'Y') {			// 사용여부가 Y인
					selfPaySum += empPayDataProvider.getValue(i, "itmBasAmt");	// 정산금액
				}
				break;
			// 3-4-2 회사부담총액 집계			
			case "회사부담금":
				if(empPayDataProvider.getValue(i, "useYN") == 'Y') {			// 사용여부가 Y인
					corpPaySum += empPayDataProvider.getValue(i, "itmBasAmt");	// 회사부담금의 합
				}
				break;
			default:
				break;
		}
	}
	
	if(selfPayRow > 0){															// 본인공제총액 row 위치가 확인되면
		empPayView.commit();
		empPayDataProvider.setValue(selfPayRow, "itmBasAmt", selfPaySum);		// 집계액 기입
	}
	
	if(corpPayRow > 0){															// 회사부담총액 row 위치가 확인되면
		empPayView.commit();
		empPayDataProvider.setValue(corpPayRow, "itmBasAmt", corpPaySum);		// 집계액 기입
	}
	
	// 3-4-3 차인지급액 집계
	// 차인지급액, 지급항목, 공제항목, 회사부담총액 의 row 위치가 다 확인되면
	if(netAmountRow > 0 && payItmRow > 0 && deductionRow > 0 && corpPayRow > 0) {
		empPayView.commit();
		
		// 차인지급액 = 지급항목 - (공제항목 - 회사부담총액)
		// '차인지급액 = 지급항목 - 공제항목' 으로 변경됨
		var payItm		= empPayDataProvider.getValue(payItmRow, "itmBasAmt");		// 지급항목
		var deduction	= empPayDataProvider.getValue(deductionRow, "itmBasAmt");	// 공제항목
		//var corpPay		= empPayDataProvider.getValue(corpPayRow, "itmBasAmt");	// 회사부담총액
		
		var netAmount = payItm - deduction; 	 			
		empPayDataProvider.setValue(netAmountRow, "itmBasAmt", netAmount);			// 집계액 기입
	}
}

//// 5 footer 수식 
// footer에 차인지급액 수식 적용
// @author 이유진
function calcFooter() {
	empPayView.commit();

	var sum, sum1, sum2; //, sum3;
	sum = sum1 = sum2 = 0 // sum3 = 0;
	var rowCount = empPayDataProvider.getRowCount();
	for(var i = 1; i <= rowCount; i++){
    	if(empPayDataProvider.getValue(i, "payItmCd") == "100000000")
        	sum1 = empPayDataProvider.getValue(i, "itmBasAmt");
		if(empPayDataProvider.getValue(i, "payItmCd") == "200000000")
        	sum2 = empPayDataProvider.getValue(i, "itmBasAmt");
		/*if(empPayDataProvider.getValue(i, "payItmCd") == "800000000")
        	sum3 = empPayDataProvider.getValue(i, "itmBasAmt");*/
	}
	sum = sum1 - sum2;
	
	return sum;
}