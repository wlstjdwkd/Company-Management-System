/*======================================================================================
 메시지 박스 관련함수
=======================================================================================*/

/**
 * 메세지 박스
 * @param $tar 메세지박스가 닫힌 후 포커싱될 jquery object(없을경우 null 필수입력)
 * @param type 메세지 타입(info, warn, error, confirm)
 * @param msg 표시할 내용
 * @param fnc type이 confirm일 경우 실행항 function 또는 function명
 * @returns
 */
var jsMsgBox = function($tar,type,msg,fncY,fncN){
	
	function fnFocusIn(){
		$(".msgButton:first").focus();
	}
	
	function fnFocusOut(){
		if($tar!=null){
			$tar.focus();
		}
	}
	
	function afterClose(){
		if (!Util.isEmpty(fncY)) {
        	if(typeof fncY == "string"){                		
        		eval(fncY+"()");
        	}else if(typeof fncY == "function"){
        		fncY();
        	}        	
        }else{
        	fnFocusOut();
        }
	}
	
	if(type=="confirm"){
		$.msgBox({
			type: type,
	        content: msg,
	        success: function (result) {
                if (result == "Yes") {
                	if (!Util.isEmpty(fncY)) {
                		if(typeof fncY == "string"){                		
                    		eval(fncY+"()");
                    	}else if(typeof fncY == "function"){
                    		fncY();
                    	} 
                	}                	               	
                }else{
                	if (!Util.isEmpty(fncN)) {
                		if(typeof fncN == "string"){                		
                    		eval(fncN+"()");
                    	}else if(typeof fncN == "function"){
                    		fncN();
                    	}
                	}                	
                }
            },
            afterShow: fnFocusIn,
            afterClose:fnFocusOut
            
	    });
	}else if(type=="notice"){
		$.msgBox({
			type: type,
	        content: msg,
	        success: function (result) {
                if (result == "회원가입") {
                	if (!Util.isEmpty(fncY)) {
                		if(typeof fncY == "string"){                		
                    		eval(fncY+"()");
                    	}else if(typeof fncY == "function"){
                    		fncY();
                    	} 
                	}                	               	
                }else{
                	if (!Util.isEmpty(fncN)) {
                		if(typeof fncN == "로그인"){                		
                    		eval(fncN+"()");
                    	}else if(typeof fncN == "function"){
                    		fncN();
                    	}
                	}                	
                }
            },
            afterShow: fnFocusIn,
            afterClose:fnFocusOut
            
	    });
	}else{
		$.msgBox({
			type: type,
	        content: msg,
	        afterShow: fnFocusIn,
	        afterClose:afterClose
	    });
	}
	
	$(".msgButton:last").blur(function() {		
		$(".msgButton:first").focus();
	});
};


var isDebugEnabled = true;
var jsSysErrorBox = function(msg, e, options) {
    if(!options)
        options = {};

    options["type"] = "error";
    options["stay"] = "true";

    var message = "";
    
    if(isDebugEnabled) {
        if(e) {
            message += "JavaScript Error : " + e + " \r <br />";
        }
        if(msg) {
            message += " System Error : " + msg;
        }
        sendMsg(message, options);
    } else {
        sendMsg(Message.msg.processError, options);
    }

    if (message) {
        return true;
    }
    
    return false;
};

/**
 * 일반 알림 메시지
 *
 * @param msg 메시지 내용
 * @param options 메시지 옵션
 * @returns
 */
var jsMessage = function(msg, options) {
    if(!options)
        options = {};

    options["type"] = "message";
    options["stayTime"] = 2000;

    sendMsg(msg, options);

    if (msg) {
        return true;
    }
    return false;
};

/**
 * 프로세스 성공시 알림 메시지
 *
 * @param msg 메시지 내용
 * @param options 메시지 옵션
 * @returns
 */
var jsSuccessBox = function(msg, options) {
    if(!options)
        options = {};

    options["type"] = "success";
    options["stayTime"] = 3000;

    sendMsg(msg, options);

    if (msg) {
        return true;
    }
    return false;
};

/**
 * 프로세스 경고시 알림 메시지
 *
 * @param msg 메시지 내용
 * @param options 메시지 옵션
 * @returns
 */
var jsWarningBox = function(msg, options) {
    if(!options)
        options = {};

    options["type"] = "warning";
    options["stayTime"] = 3000;

    sendMsg(msg, options);

    if (msg) {
        return true;
    }
    return false;
};

/**
 * 프로세스 실패시 알림 메시지
 *
 * @param msg 메시지 내용
 * @param options 메시지 옵션
 * @returns
 */
var jsErrorBox = function(msg, options) {
    if(!options)
        options = {};

    options["type"] = "error";
    options["stay"] = "true";

    sendMsg(msg, options);

    if (msg) {
        return true;
    }
    return false;
};

/**
 * 최상위 창에서 메시지를 띄우기 위한 컨트롤
 *
 * @param msg 메시지 내용
 * @param options 메시지 옵션
 * @returns
 */
var sendMsg = function(msg, options) {
    if(top.mainFrame) {
        top.mainFrame.jsShowMsgBox(msg, options);
    } else {
        jsShowMsgBox(msg, options);
    }
};

/**
 * 옵션을 받아서 메시지 표시
 *
 * @param msg 메시지 내용
 * @param options 메시지 옵션
 * @returns
 */
var jsShowMsgBox = function(msg, options) {
    options["text"] = msg;

    $.noticeAdd(options);
};

/**
 * 팝업 또는 colorbox 윈도우 닫기
 */
var jsCloseWin = function() {
    if(parent.$.fn.colorbox) {
        parent.$.fn.colorbox.close();
    } else if($.fn.colorbox) {
        $.fn.colorbox.close();
    } else {
        self.close();
    }
};



/*======================================================================================
기본 Uril 관련함수
=======================================================================================*/
var Util = {};

/**---------------------------------------------------------------------
* 기능 : 입력된 값의 null, 빈문자열, undefined 여부 반환
* 인수 : sString : 가운데 부문을 얻어올 원본 문자열
* Return : boolean
----------------------------------------------------------------------*/	
Util.isEmpty = function(objValue) {
	if (objValue === null || objValue === undefined) return true;

	var sChkStr = new String(objValue);
    var sTrim = sChkStr.trim();
    
	if (sTrim.toString().length == 0) return true;

	return false;
}

/**---------------------------------------------------------------------
* 기능 : 인자로 넘긴 숫자를 Round 처리
* 인수 : nValue : round 처리할 숫자값
*         nDigit : round 처리할 자릿수 
* Return : Round 된 숫자값.
----------------------------------------------------------------------*/
Util.round = function(nValue, nDigit) {
	var nRound = 1;
	
	for ( var i = 0; i < nDigit; i++) 
	{
		nRound = nRound * 10;
	}

	var nRetValue = nValue * nRound;
	
	nRetValue = Math.round(nRetValue);
	nRetValue = nRetValue / nRound;

	return nRetValue;
}

/**---------------------------------------------------------------------
* 기능 : 정수인 nStart ~ nEnd의 범위에 있는 숫자에 대하여 random값을 return한다.
* 인수 : nStart : 시작숫자 ( 단, 정수, 만일 정수가 아니면 Math.floor(nStart)를 적용함)
*         nEnd   : 끝숫자 ( 단, 정수, 만일 정수가 아니면 Math.floor(nStart)를 적용함)
* Return : random 숫자값
----------------------------------------------------------------------*/
Util.rand = function(nStart, nEnd) {
	var nRange_unit, nRand, nTmp;

	nStart = Math.floor(nStart);
	nEnd = Math.floor(nEnd);
	
	if( nStart > nEnd )
	{
		nTmp = nStart;
		nStart = nEnd;
		nEnd = nTmp;
	}
	nRange_unit = nEnd-nStart+1;
	nRand = Math.random();
	nRand = Math.random();

	return Math.floor(nRand*nRange_unit)+nStart;
}

/**---------------------------------------------------------------------
* 기능 :  Array 객체여부 반환
* 인수 :  value : 확인 대상
* Return : boolean
----------------------------------------------------------------------*/	
Util.isArray = function (value) {
	if (!value || value.currentstyle) return false;
	
	return value && 
	       typeof value == "object" && 
	       value.constructor === Array;
}


/*======================================================================================
 String 관련함수
=======================================================================================*/
var STR = Util.str = {};

String.prototype.trim = function() {
    return this.replace(/(^\s*)|(\s*$)/gi, "");
}

/**---------------------------------------------------------------------
* 기능 : 문자열의 오른쪽부분을 지정한 길이만큼 Return 한다.
* 인수 : sString : 오른부분을 얻어올 원본 문자열
*         nSize : 얻어올 크기. [Default Value = 0]
* Return : 오른쪽 부분이 얻어진 문자열
----------------------------------------------------------------------*/
STR.right = function(sString, nSize) {
	var nEnd = String(sString).length;
	var nStart = nEnd - Number(nSize);
	var sVal = sString.substring(nStart, nEnd);

	return sVal;
}

/**---------------------------------------------------------------------
* 기능 : 입력된 문자열에서 가운데 부분을 주어진 길이만큼 Return 한다.
* 인수 : sString : 가운데 부문을 얻어올 원본 문자열
*         nIndex : 얻어올 첫 글자의 Index
*         nSize : 얻어올 글자수      
* Return : 가운데 부분이 얻어진 문자열
----------------------------------------------------------------------*/
STR.mid = function(sString, nIndex, nSize) {
	var nStart = ((nIndex == null) ? 0 : ((nIndex.toString().length <= 0) ? 0 : nIndex-1));
	var nEnd   = ((nSize  == null) ? sString.toString().length : ((nSize.toString().length <= 0) ? sString.toString().length : nSize));
	var sVal   = sString.substr(nStart, nEnd);

	return String(sVal);
}

/**---------------------------------------------------------------------
 * 기능 : 문자열의 왼쪽부분을 지정한 길이만큼 Return 한다.
 * 인수 : oString : 왼쪽부분을 얻어올 원본 문자열
 *         nSize : 얻어올 크기. [Default Value = 0]
 * return : 왼쪽 부분이 얻어진 문자열.
----------------------------------------------------------------------*/
STR.left = function(oString, nSize) {
	var sVal = "";
	var sString = new String(oString);

	if (nSize > String(sString).length || nSize == null) {    
		sVal = sString;
	} else {
		sVal = sString.substring(0, nSize);
	}

	return sVal;
}

STR.leftB = function(sString, nSize) {
	var sVal = "";
	var nCnt = 0;
	var nSizeB = this.getLengthB(sString);
	if (nSize > nSizeB || nSize == null) {    
		sVal = sString;
	} else {
		for (var i=0; i<sString.length; i++) {
			if (sString.charCodeAt(i) > 127) {
				nCnt += 2;
			} else {
				nCnt += 1;
			}
			if (nCnt > nSize) { break; }
			sVal += sString.substr(i, 1);
		}
	}

	return sVal;
}

/**---------------------------------------------------------------------
 * 기능 : undefined을 ""로 리턴한다.
 * 인수 : oParam : object나 문자열
 * return : undefined이면 ""(널 스트링)
----------------------------------------------------------------------*/
STR.blankStr = function(oParam) {
	var sParam = new String(oParam);

	if (sParam.valueOf() == "undefined") {
		return "";
	}

	return oParam;
}

/**---------------------------------------------------------------------
 * 기능 : 입력값 형태에 따라서 길이 또는 범위를 구하는 함수
 * 인수 : 객체, 문자열, 배열
 * return : Type에 따라 구해진 길이 또는 범위
----------------------------------------------------------------------*/
STR.length = function() {
	var nRtnValue = 0;
	
	if (arguments.length < 1) return 0; 
	
	if (Util.isEmpty(arguments[0])) return 0;
	
	if (typeof arguments[0] == "string") {
		nRtnValue = arguments[0].toString().length;
	} else {
		nRtnValue = arguments[0].length;
	}
	
	return nRtnValue;
}

/**---------------------------------------------------------------------
 * 기능 : 입력받은 전체 길이를 계산
 *         문자, 숫자, 특수문자 	: 1 로 Count	
 *         그외 한글/한자 		: 2 로 count 되어 합산한다.
 * 인수 : sValue : String원본 문자열
 * return : 입력받은 전체 길이
----------------------------------------------------------------------*/
STR.getLengthB = function(sValue) {
	if (new String(sValue).valueOf() == "undefined") sValue = "";

	var sChkStr = sValue.toString();
	var nCnt = 0;

	for (var i=0; i<sChkStr.length; i++) {
		if (sChkStr.charCodeAt(i) > 127) {
			nCnt += 2;
		} else {
			nCnt += 1;
		}
	}

	return nCnt;
}

/**---------------------------------------------------------------------
 * 기능 : 입력된 문자열의 일부분을 다른 문자열로 치환하는 함수
 * 인수 : sString : 원본 문자열
 *         strOld : 원본 문자열에서 찾을 문자열. 
 *         strNew : 새로 바꿀 문자열.
 * return : 대체된 문자열
----------------------------------------------------------------------*/
STR.replace = function() {
	var sRtnValue = null;

	if (arguments.length < 3) {
		sRtnValue = arguments[0];
	} else {
		if (Util.isEmpty(arguments[0])) return sRtnValue;
		
		sRtnValue = arguments[0].toString().replace(arguments[1], arguments[2]);
	}

	return sRtnValue;
}

/**---------------------------------------------------------------------
 * 기능 : 지정한 인덱스에 해당하는 문자를 반환하는 Method 입니다.
 * 인수 : nIndex : 유효한 범위는 0부터 문자열의 길이-1 까지 입니다.
 * return : 지정한 인덱스에 해당하는 문자 입니다.
 ----------------------------------------------------------------------*/
STR.charAt = function() {
	var sRtnValue = null;

	if (arguments.length < 2) {
		sRtnValue = "";
	} else {
		var nIndex = parseInt(arguments[1]);
		sRtnValue = arguments[0].toString().charAt(nIndex);
	}

	return sRtnValue;
}

/**---------------------------------------------------------------------
 * 기능 : 문자열이 지정된 길이가 되도록 왼쪽을 채우는 Basic API 입니다.
 * 인수 : sString : 원본 문자열. 
 *         sPadChar : 채울 문자. 
 *         nCount : 출력될 문자열의 길이.
 * return : 대체된 문자열
 ----------------------------------------------------------------------*/ 
STR.lPad = function(sString, sPadChar, nCount) {
	var sStr = "";
	
	if (sString == null) return sString; 
	
	sString = sString.toString();
	nCount = parseInt(nCount);
	
	if (this.length(sString) < nCount) {
		var sStrPad = "";
		var nCnt = nCount - this.length(sString);
		
		for (var i=0; i<nCnt; i++) {
			sStrPad += sPadChar;
		}
		
		sStr = sStrPad + sString;
	} else {
		sStr = sString
	}
	
	return sStr;
}

/**---------------------------------------------------------------------
 * 기능 : 문자열이 지정된 길이가 되도록 오른쪽을 채우는 Basic API 입니다.
 * 인수 : sString :원본 문자열. 
 *         sPadChar : 채울 문자. 
 *         nCount : 출력될 문자열의 길이.
 * return : 대체된 문자열
 ----------------------------------------------------------------------*/ 
STR.rPad = function(sString, sPadChar, nCount) {
	var sStr = "";
	
	if (sString == null) return sString; 
	
	sString = sString.toString();
	
	nCount = parseInt(nCount);
	
	if (sString.length < nCount) {
		var sStrPad = "";
		var nCnt = nCount - sString.length;
		
		for (var i=0; i<nCnt; i++) {
			sStrPad += sPadChar;
		}
		
		sStr = sString + sStrPad;
	} else {
		sStr = sString
	}
	
	return sStr;
}

/**---------------------------------------------------------------------
 * 기능 : 문자열을 지정한 형태로 Parsing 한 후 배열로 만드는 함수
 * 인수 : sString : Parsing 해야될 문자열.  
 *         sDelimiter : Parsing 할 때 분리의 기준이 되는 문자들의 문자열. 
 * return : Split 처리결과의 문자열 배열
 ----------------------------------------------------------------------*/ 
STR.split = function() {
	var arrArr = new Array();

	if (arguments.length < 1) {
	} else if (arguments.length < 2) {
		if (!Util.isEmpty(arguments[0])) {
			arrArr[0] = arguments[0];
		}
	} else {
		if (!Util.isEmpty(arguments[0])) {
			arrArr = arguments[0].toString().split(arguments[1]);
		}
	}
	
	return arrArr;
}

/**---------------------------------------------------------------------
 * 기능 : 입력된 실수를 문자열 표현법으로 표현하는 함수
 * 인수 : nNumber : 문자열로 출력할 실수
 *         nDetail : 출력시 소숫점 이하의 자릿수(Default : 0)
 * return : 문자열로 바뀐 실수
 *          출력되는 실수는 정수부분에 3자리마다 ',' 가 삽입됩니다.
 ----------------------------------------------------------------------*/ 
STR.numFormat = function(nNumber, nDetail) {
	var sStr;
	
	if (Util.isEmpty(nDetail) != false)  nDetail = 0;
 
	sStr = nNumber.toFixedLocaleString(nDetail);

	return sStr;
}

/**---------------------------------------------------------------------
 * 기능   : 문자열 중 "=" 좌우의 빈공백을 제거하는 함수
 *           ※ fn_str_transaction 에서 사용
 * 인수   : sArg : 문자열
 * return : "=" 좌우의 빈공백 제거된 문자열
 ----------------------------------------------------------------------*/ 
STR.stripBlank = function(sArg) {
	var nChrPos;
	var sLeft;
	var sRight = sArg;
	var sChr;
	var sVal = "";

	while(true) {
		nChrPos = sRight.indexOf("=");
		
		if (nChrPos == -1) { 
			sVal += sRight;
			break;
		}

		sLeft  = sRight.substr(0, nChrPos).trimRight();
		sRight = sRight.substr(nChrPos + 1).trimLeft();
		sChr   = sRight.charAt(0);

		sVal += sLeft + "=";

		if (sChr != "\"" && sChr != "'") sChr = " ";

		nChrPos = sRight.indexOf(sChr, 1);

		if (nChrPos > -1) {
			sVal  += sRight.slice(0, nChrPos + 1);
			sRight = sRight.substr(nChrPos + 1);
		} else {
			sVal  += sRight;
			sRight = "";
		}
	}

	return sVal;
}

/**---------------------------------------------------------------------
 * 기능   : 입력된 문자열의 양쪽에 쌍따옴표를 붙여 반환합니다.
 * 인수   : sString 대상 문자열
 * return : 쌍따옴표가 붙여진 문자열
 ----------------------------------------------------------------------*/ 
STR.quote = function() {
	var sVal = '""';

	if ((arguments != null) && (arguments.length >= 1) && (!Util.isEmpty(arguments[0]))) {
		sVal = wrapQuote(new String(arguments[0]));
	}

	return sVal;
}


/**---------------------------------------------------------------------
 * 기능   : arguments 형식으로 값에 쌍따옴표가 붙여서 반환한다.
 * 인수   : sKey : argument명, sValue : arguments값
 * return :  이름="값" 형식으로 반환
 ----------------------------------------------------------------------*/ 
STR.setArgument = function(sKey, sValue) {
	if ((sKey != null) && (sKey.length >= 1) && (!Util.isEmpty(sKey))) {
		return " " + sKey + "=" + wrapQuote(sValue);
	}
}

/**---------------------------------------------------------------------
 * 기능   : 지정한 위치에서 시작하고 지정한 길이를 갖는 부분 문자열을 반환하는 Method 입니다.
 * 인수   : sString : String  가운데 부문을 얻어올 원본 문자열. 
			 nIndex  : Integer 얻어올 첫 글자의 Index. 
			 nSize   : Integer 얻어올 글자수. [Default length(해당 개채의 길이)] 
 * return : 가운데 부분이 얻어진 문자열.
 ----------------------------------------------------------------------*/ 
STR.subStr = function() {
	var sVal    = "";
	var sString = "";
	var nIndex  = 0;
	var nSize   = 0;

	if (arguments.length >= 1)  sString = arguments[0]; 
	
	if (arguments.length >= 2)  nIndex = parseInt(arguments[1]); 
	
	if (arguments.length >= 3) {
		nSize = parseInt(arguments[2]); 
	} else { 
		nSize = this.length(arguments[0]); 
	}

	if (!Util.isEmpty(sString)) {
		sVal = sString.substr(nIndex, nSize);
	}

	return sVal;
}

/**---------------------------------------------------------------------
 * 기능  : 문자열의 위치를 대소문자 구별하여 찾는다
 * 인수  : sOrg : 원래 문자열( 예 : "aaBBbbcc" )
			sFind : 찾고자 하는 문자열( 예 : "bb" )
			nStart : 검색 시작위치 (옵션 : Default=0) ( 예 : 1 )
 * return : 성공 = 찾고자 하는 문자열의 시작위치 ( 예 : 4 )
			실패 = -1
 ----------------------------------------------------------------------*/ 
STR.pos = function(sOrg, sFind, nStart) {
	nStart = this.nvl(nStart, 0);

	return sOrg.indexOf(sFind, nStart);
}

/**---------------------------------------------------------------------
 * 기능   : Null값을 실제 값으로 변환
 * 인수   : expr1 : Null을 포함하는 소스 값
			 expr2 : Null을 대치할 값
 * return : Null값이 실제값으로 대치된 값을 포함하는 변환된 값
 ----------------------------------------------------------------------*/ 
STR.nvl = function(a, b) {
	var sVal    = "";

	if (arguments.length == 1) {
		if (!Util.isEmpty(arguments[0])) sVal = arguments[0]; 
	} else if (arguments.length == 2) {
		if (Util.isEmpty(arguments[0])) {
			sVal = arguments[1];
		} else {
			sVal = arguments[0];
		}
	}

	return sVal;
}

/**---------------------------------------------------------------------
 * 기능   : get New Line Ascii Value
 * 인수   : 
 * return : New Line Ascii Value
 ----------------------------------------------------------------------*/
STR.newLine = function() {
	return String.fromCharCode(13) + String.fromCharCode(10);
}

/**---------------------------------------------------------------------
 * 기능   : 입력된 문자열의 좌우측 공백을 제거한 문자열을 구함.
 * 인수   : sString : 좌우측 공백문자를 제거하려는 문자열
 * return : 입력된 문자열에서 좌우측 공백이 제거된 문자열
 ----------------------------------------------------------------------*/ 
STR.trim = function(sString) {
	if (sString === null || sString === undefined ) {
		return ""; 
	} else {
		return sString.toString().trim();
	}
	
	//var sArg = sString.toString();
	
	//return sArg.replace(/(^\s*)|(\s*$)/g, "");
}

/**---------------------------------------------------------------------
 * 기능  : 입력된 문자열의 왼쪽 공백을 제거한 문자열을 구함.
 * 인수  : sString : 왼쪽 공백문자를 제거하려는 문자열
 * return : 입력된 문자열에서 왼쪽 공백이 제거된 문자열
 ----------------------------------------------------------------------*/ 
STR.lTrim = function(sString) {
	var sArg = sString.toString();
	
	return sArg.replace(/(^\s*)/, "");
}

/**---------------------------------------------------------------------
 * 기능  : 입력된 문자열의 오른쪽 공백을 제거한 문자열을 구함.
 * 인수  : sString : 오른쪽 공백문자를 제거하려는 문자열
 * return : 입력된 문자열에서 오른쪽 공백이 제거된 문자열
 ----------------------------------------------------------------------*/ 
STR.rTrim = function(sString) {
	var sArg = sString.toString();
	
	return sArg.replace(/(\s*$)/, "");    
}

/**---------------------------------------------------------------------
 * 기능   : 입력된 값 또는 수식을 검사해 적당한 값을 Return하는 함수.
 * 인수   : vaValue : 비교 대상이 되는 값. 
 *           vaCase : vaValue와 비교될 값. 2n (n>1)위치의 값입니다 
 *           vaRetValue : Return 값. 2n+1 (n>1)위치의 값입니다. 
 *           vaDefault : vaCase 중에 값이 없는 경우 Return 될 값. 2n (n>1)위치의 값입니다. [Default Value = null ] 
 * return : Decode에 의해서 선택된 값
 ----------------------------------------------------------------------*/ 
STR.decode = function() {
	var vaRtnValue = null;
	var vaValue = arguments[0];
	var bIsDefault = false;
	var nCount = 0;
	 
	if ((arguments.length % 2) == 0) {
		nCount = arguments.length - 1;
		bIsDefault = true;
	} else {
		nCount = arguments.length;
		bIsDefault = false;
	}

	for (var i=1; i<nCount; i+=2) {
		if (vaValue == arguments[i]) {
			vaRtnValue = arguments[i+1];
			i = nCount;
		}
	}

	if (vaRtnValue == null && bIsDefault) {
		vaRtnValue = arguments[arguments.length-1];
	}

	return vaRtnValue;
}

/**---------------------------------------------------------------------
 * 기능   : 문자열에 있는 모든 영어를 대문자로 바꾸는 함수.
 * 인수   : sString : 영문자를 모두 대문자로 바꿀 문자열
 * return : 영어 대문자와 다른 문자로 구성된 문자열
 ----------------------------------------------------------------------*/ 
STR.toUpperCase = function(sString) {
	if (sString === null || sString === undefined ) {
		return ""; 
	} else {
		return sString.toString().toUpperCase();
	}
}

/**---------------------------------------------------------------------
 * 기능   : 문자열에 있는 모든 영어를 소문자로 바꾸는 함수.
 * 인수   : sString : 영문자를 모두 소문자로 바꿀 문자열
 * return : 영어 소문자와 다른 문자로 구성된 문자열
 ----------------------------------------------------------------------*/ 
STR.toLowerCase = function(sString) {
	if (sString === null || sString === undefined ) {
		return ""; 
	} else {
		return sString.toString().toLowerCase();
	}
}

/*======================================================================================
 Date 관련함수
=======================================================================================*/
var DATE = Util.date = {};

Date.prototype.toFormatString = function(f) {
    if (!this.valueOf()) return " ";
 
    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var d = this;
     
    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).zf(2);
            case "MM": return (d.getMonth() + 1).zf(2);
            case "dd": return d.getDate().zf(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().zf(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm": return d.getMinutes().zf(2);
            case "ss": return d.getSeconds().zf(2);
            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
            default: return $1;
        }
    });
};
 
String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};

/**---------------------------------------------------------------------
* 기능 : 오늘 날짜(연월일)를 가져온다.
* 인수 : 
* Return : 오늘날짜 String
----------------------------------------------------------------------*/	
DATE.getLocalToday = function() {
	var objDate = new Date();
	return objDate.toFormatString("yyyyMMdd");
}

/**---------------------------------------------------------------------
* 기능 : 현재시간(연월일시분초)을 가져온다.
* 인수 : 
* Return : 현재시간 String
----------------------------------------------------------------------*/
DATE.getLocalDateTime = function() {
	var objDate = new Date();
	return objDate.toFormatString("yyyyMMddmmss");
}

/**---------------------------------------------------------------------
* 기능 : 현재시간(시분초)을 가져온다.
* 인수 : 
* Return : 현재시간 String
----------------------------------------------------------------------*/
DATE.getLocalTime = function() {
	var objDate = new Date();
	return objDate.toFormatString("HHmmss");
}

/**---------------------------------------------------------------------
* 기능 : 현재 년도를 가져온다.
* 인수 : 
* Return : 현재 년도 String
----------------------------------------------------------------------*/	
DATE.getLocalYear = function() {
	var objDate = new Date();
	return objDate.toFormatString("yyyy");
}

/**---------------------------------------------------------------------
* 기능 : 현재 월
* 인수 : 
* Return : 현재 월 String
----------------------------------------------------------------------*/	
DATE.getLocalMonth = function() {
	var objDate = new Date();
	return objDate.toFormatString("MM");
}

/**---------------------------------------------------------------------
* 기능 : 현재 일
* 인수 : 
* Return : 현재 일 String
----------------------------------------------------------------------*/	
DATE.getLocalDay = function() {
	var objDate = new Date();
	return objDate.toFormatString("dd");
}

/**---------------------------------------------------------------------
* 기능 : 오늘 날짜를 지정된 format형태로 반환한다.
* 인수 : formatString : 원하는 format. ex) "yyyyMMdd"
* Return : 오늘날짜 String (default - 연월일 8자리)
----------------------------------------------------------------------*/	
DATE.getDateWithFormat = function(formatString) {
	var objDate = new Date();
	return objDate.toFormatString(formatString);
}



/**---------------------------------------------------------------------
* 기능 : 숫자로 된 년, 월, 일을 yyyyMMdd형의 문자열 날짜로 만든다.
* 인수 : nYear  : 년도 ( 예 : 2012 )
*         nMonth : 월 ( 예 : 11 )
*         nDate   : 일 ( 예 : 22 ) 
* Return : 성공 = yyyyMMdd형태의 날짜 ( 예 : "20121122" )
		   실패 = ""
----------------------------------------------------------------------*/
DATE.makeDate = function(nYear, nMonth, nDate) {
	if (Util.isEmpty(nYear) || Util.isEmpty(nMonth) || Util.isEmpty(nDate) )	return "";
	
	var objDate = new Date(nYear, nMonth-1, nDate);

	return objDate.toFormatString("yyyyMMdd");
}

/**---------------------------------------------------------------------
* 기능 : 해당월의 마지막 날짜를 숫자로 구하기
* 인수 : sDate : yyyyMMdd형태의 날짜 ( 예 : "20121122" )
* Return : 성공 = 마지막 날짜 숫자값 ( 예 : 30 )
		   실패 = -1
----------------------------------------------------------------------*/
DATE.lastDateNum = function(sDate) {
	var nMonth, nLastDate;

	if (Util.isEmpty(sDate))  return -1; 

	nMonth = parseInt(sDate.substr(4,2), 10);
	
	if (nMonth == 1 || nMonth == 3 || nMonth == 5 || nMonth == 7
	    || nMonth == 8 || nMonth == 10 || nMonth == 12) {
		nLastDate = 31;
	} else if (nMonth == 2) {
		if (this.isLeapYear(sDate) == true )  nLastDate = 29;
		else								  nLastDate = 28;
	} else {
		nLastDate = 30;
	}
		
	return nLastDate;
}

/**---------------------------------------------------------------------
* 기능 : 윤년여부 확인
* 인수 : sDate : yyyyMMdd형태의 날짜 ( 예 : "20121122" )
* Return : sDate가 윤년인 경우 = true
		   sDate가 윤년이 아닌 경우 = false
		   sDate가 입력되지 않은 경우 = false
----------------------------------------------------------------------*/
DATE.isLeapYear = function(sDate) {
	var bRet;
	var nY;
	
	if (Util.isEmpty(sDate))  return false; 

	nY = parseInt(sDate.substring(0,4), 10);

	if ((nY % 4) == 0) {
		if ((nY % 100) != 0 || (nY % 400) == 0)  bRet = true;
		else 									 bRet = false;
	} else {
		bRet = false;
	}

	return bRet ;
}

/**---------------------------------------------------------------------
* 기능 : 입력된 날자에 nOffset 으로 지정된 만큼의 월을 증감한다.
* 인수 : sDate : 날짜 ( 예 : "20121122" )
*         nOffset : 월 증감값 ( 예 : 1 또는 -1 ) 
* Return : 성공 = yyyyMMdd형태의 증감된 날짜 ( 예 : "20121202" 또는 "20121022" )
		   실패 = ""
----------------------------------------------------------------------*/
DATE.addYear = function(sDate, nOffSet) {
	var nYear = parseInt(sDate.substr(0, 4))+ nOffSet;
	var nMonth = parseInt(sDate.substr(4, 2)); 
	var nDate = parseInt(sDate.substr(6, 2));
	
	return this.makeDate(nYear, nMonth, nDate);
}

/**---------------------------------------------------------------------
* 기능 : 입력된 날자에 nOffset 으로 지정된 만큼의 월을 증감한다.
* 인수 : sDate : 날짜 ( 예 : "20121122" )
*         nOffset : 월 증감값 ( 예 : 1 또는 -1 ) 
* Return : 성공 = yyyyMMdd형태의 증감된 날짜 ( 예 : "20121202" 또는 "20121022" )
		   실패 = ""
----------------------------------------------------------------------*/
DATE.addMonth = function(sDate, nOffSet) {
	var nYear = parseInt(sDate.substr(0, 4));
	var nMonth = parseInt(sDate.substr(4, 2)) + nOffSet;
	var nDate = parseInt(sDate.substr(6, 2));
	
	return this.makeDate(nYear, nMonth, nDate);
}

/**---------------------------------------------------------------------
* 기능 : 날짜 계산(특정 일수가 더해진 날짜 구하기) 
* 인수 : sDate : 계산대상 날짜
*         nOffSet : 더할 일수
* Return : 계산된 날짜
----------------------------------------------------------------------*/
DATE.addDate = function(sDate, nOffSet) {
	var nYear  = parseInt(sDate.substr(0, 4));
	var nMonth = parseInt(sDate.substr(4, 2));
	var nDate  = parseInt(sDate.substr(6, 2)) + nOffSet;

	var sRetVal = this.makeDate(nYear, nMonth, nDate);
	
	return sRetVal;
}

/**---------------------------------------------------------------------
* 기능 :  입력된 날짜로 부터 요일을 구함
* 인수 : sDate : 날짜 ( 예 : "20121122" )
* Return : 입력된 날짜의 요일(0부터 6까지의 정수 / 0 일요일 ~ 6 토요일)
----------------------------------------------------------------------*/
DATE.getDay = function(sDate) {
	sDate = sDate.toString();

	var date = new Date();
	date.setYear(sDate.substr(0, 4));
	date.setMonth(sDate.substr(4, 2) - 1);
	date.setDate(sDate.substr(6, 2));

	return date.getDay();
}

/**---------------------------------------------------------------------
* 기능 :  입력된 날짜로 부터 요일명으로 변환
* 인수 : sDate : 날짜 ( 예 : "20121122" )
*         sType : 요일명 유형구분(TYPE1 일 / TYPE2 일요일 / TYPE3 日 / TYPE4 Sun / TYPE5 Sunday) 
* Return : 입력된 날짜의 변환된 요일명
----------------------------------------------------------------------*/
DATE.getDayText = function(sDate, sType) {
	var arrType1 = ["일", "월", "화", "수", "목", "금", "토"];
	var arrType2 = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
	var arrType3 = ["日", "月", "火", "水", "木", "金", "土"];
	var arrType4 = ["Sun", "Mon", "The", "Wed", "Thu", "Fri", "Sat"];
	var arrType5 = ["Sunday", "Monday", "Thesday", "Wednesday", "Thursday", "Friday", "Saturday"];

	var sDayText = "";
	sDate = sDate.toString();
	var day = this.getDay(sDate);

	if (sType == "TYPE1") {
		sDayText = arrType1[day];
	} else if (sType == "TYPE2") {
		sDayText = arrType2[day];
	} else if (sType == "TYPE3") {
		sDayText = arrType3[day];
	} else if (sType == "TYPE4") {
		sDayText = arrType4[day];
	} else if (sType == "TYPE5") {
		sDayText = arrType5[day];
	}

	return sDayText;
}

/**---------------------------------------------------------------------
* 기능 :  입력한 날짜가 속한 분기의 시작일,종료일 구함
* 인수 : sDate : 날짜 ( 예 : "20121122" )
* Return : 입력된 날짜가 속한 분기의 시작일,종료일 
----------------------------------------------------------------------*/
DATE.getCurQDate = function(sDate) {
	var arrRtnVal = new Array(2);
	var sYear = sDate.substr(0, 4);
	var sMon1, sMon2;
	var nMonth = parseInt(sDate.substr(4,2));
	
	if ((nMonth >= 1) && (nMonth <= 3)) {
		sMon1 = "01";
		sMon2 = "03";
	} else if ((nMonth >= 4) && (nMonth <= 6)) {
		sMon1 = "04";
		sMon2 = "06";
	} else if((nMonth >= 7) && (nMonth <= 9)) {
		sMon1 = "07";
		sMon2 = "09";
	} else if((nMonth >= 10) && (nMonth <= 12)) {
		sMon1 = "10";
		sMon2 = "12";
	}
	
	arrRtnVal[0] = sYear + sMon1 + "01";
	arrRtnVal[1] = sYear + sMon2 + this.lastDateNum(sYear + sMon2 + "01");
	
	return arrRtnVal;
}

/**---------------------------------------------------------------------
* 기능 : 해당 PC의 오늘 날짜기준으로 현재 주차를 가져온다 
* 인수 : 
* Return : 현재주차
----------------------------------------------------------------------*/
DATE.getCurrentWeek = function() {
	var sDate = this.today();
	
	return this.date2week(sDate);
}

/**---------------------------------------------------------------------
* 기능 : YYYYMMDD 형식의 date를 week 형식으로 변환 
* 인수 : sDate : 날짜
* Return : 날짜에 해당 년도+주차( ex. 201235)
----------------------------------------------------------------------*/
DATE.date2week = function(sDate) {
	var nYear  = toNumber(sDate.substr(0,4));
	var nMonth = toNumber(sDate.substr(4,2));
	var nDay   = toNumber(sDate.substr(6,2));
	var nWeek  = this.weekNbr(nYear, nMonth, nDay);

	if ((nMonth == 1) && (nWeek > 50)) {
		nYear--;
	} else if ((nMonth == 12) && (nWeek < 2)) {
		nYear++;
	}

	return nYear.toString() + nWeek.toString().padLeft(2, '0');
}

/**---------------------------------------------------------------------
* 기능 : 년,월,일을 입력하면 그 날짜에 해당하는 주차를 계산
* 인수 : nYear : 년
*         nMonth : 월
*         nDay : 일
* Return : 날짜에 해당 주차( ex. 35)
----------------------------------------------------------------------*/
DATE.weekNbr = function(nYear, nMonth, nDay) {
	var a = parseInt((14-nMonth) / 12);
	var y = nYear + 4800 - a;
	var m = nMonth + 12 * a - 3;
	var b = parseInt(y/4) - parseInt(y/100) + parseInt(y/400);
	var J = nDay + parseInt((153 * m + 2) / 5) + 365 * y + b - 32045;
	var d4 = (((J + 31741 - (J % 7)) % 146097) % 36524) % 1461;
	var L = parseInt(d4 / 1460);
	var d1 = ((d4 - L) % 365) + L;
	var nWeek = parseInt(d1/7) + 1;
	
	return nWeek;
}

/**---------------------------------------------------------------------
* 기능 : 2개의 날짜간의 Day count
* 인수 : sFdate : 시작일자
*         sTdate : 종료일자
* Return : 양 일자간의 Day count
----------------------------------------------------------------------*/
DATE.getDiffDay = function(sFdate, sTdate) {
	sFdate = new String(sFdate);
	sFdate = sFdate.replace(" ", "").replace("-", "").replace("/", "");
	sTdate = new String(sTdate);
	sTdate = sTdate.replace(" ", "").replace("-", "").replace("/", "");

	sFdate = this.STR.left(sFdate, 8);
	sTdate = this.STR.left(sTdate, 8);

	if (sFdate.length != 8 		   || 
		sTdate.length != 8 		   || 
		isNumeric(sFdate) == false || 
		isNumeric(sTdate) == false || 
		this.getDay(sFdate) == -1    || 
		this.getDay(sTdate) == -1) 
	{
		return null;
	}

	var nDiffDate = this.str2Date(sTdate) - this.str2Date(sFdate);
	var nDay      = 1000*60*60*24;

	nDiffDate = parseInt(nDiffDate/nDay);
	
	if (nDiffDate < 0) {
		nDiffDate = nDiffDate - 1;
	} else {
		nDiffDate = nDiffDate + 1;
	}

	return nDiffDate;
}

/**---------------------------------------------------------------------
* 기능 : 날짜형식의 문자열을 date type으로 전환 
* 인수 : sDate : 날짜형식의 문자열
* Return : date type의 날짜
----------------------------------------------------------------------*/
DATE.str2Date = function(sDate) {
	var objDate = "";

	if (!Util.isEmpty(sDate)) {
		objDate = new Date(parseInt(sDate.substr(0,4)),
		                   parseInt(sDate.substr(4,2))-1,
		                   parseInt(sDate.substr(6,2)));
	}

	return objDate;
}

/**---------------------------------------------------------------------
* 기능 : 날짜형식의 문자열을 date type으로 전환 
* 인수 : sDate : 날짜형식의 문자열
* Return : date type의 날짜
----------------------------------------------------------------------*/
DATE.str2DateTime = function(sDateTime) {
	var objDate = "";

	if (!Util.isEmpty(sDateTime)) {
		objDate = new Date(parseInt(sDateTime.substr(0,4)),
		                   parseInt(sDateTime.substr(4,2))-1,
		                   parseInt(sDateTime.substr(6,2)),
		                   sDateTime.substr(8,2),
	                       sDateTime.substr(10,2),
	                       sDateTime.substr(12,2));
	}

	return objDate;
}

/**---------------------------------------------------------------------
* 기능 : date type의 날짜를 문자열로 전환 
* 인수 : objDate : date type의 날짜
* Return : 날짜형식의 문자열
----------------------------------------------------------------------*/
DATE.date2Str = function(objDate) {
	var sDate = "";

	if (Util.isEmpty(objDate)) {
		sDate = "";
	} else if (typeof objDate == "string") {
		if (objDate.length > 8)  sDate = objDate.substr(0, 8);
		else                     sDate = objDate;
	} else {
		sDate = (new Date(objDate)).getFullYear() + 
				(((new Date(objDate)).getMonth() + 1) + "").padLeft(2, '0') + 
				(((new Date(objDate)).getDate()) + "").padLeft(2, '0');
	}

	return sDate;
}

/**---------------------------------------------------------------------
* 기능 : 날짜의 유효성 체크
* 인수 : param : date type의 날짜
* Return : 유효한 경우 true, 아니면 false
----------------------------------------------------------------------*/
DATE.validateDate = function(param) {
	try
	{
		param = param.replace(/-/g,'');

		// 자리수가 맞지않을때
		if( isNaN(param) || param.length!=8 ) {
			return false;
		}

		var year = Number(param.substring(0, 4));
		var month = Number(param.substring(4, 6));
		var day = Number(param.substring(6, 8));

		var dd = day / 0;
         
		if( month<1 || month>12 ) {
			return false;
		}
         
		var maxDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		var maxDay = maxDaysInMonth[month-1];
         
		// 윤년 체크
		if( month==2 && ( year%4==0 && year%100!=0 || year%400==0 ) ) {
			maxDay = 29;
		}
		 
		if( day<=0 || day>maxDay ) {
			return false;
		}
		return true;

	} catch (err) {
    	return false;
	}                     
}


/*======================================================================================
URL 관련함수
=======================================================================================*/
/**---------------------------------------------------------------------
* 기능 : URL 파싱
* 인수 : url 파싱할 url
* Return : 
----------------------------------------------------------------------*/
/*
var parser = new Util.urlParser();
parser.setUrl("http://example.com:3000/pathname/?search=test#hash"); 
parser.getProtocol(); // => "http:"
parser.getHostName(); // => "example.com"
parser.getPathname(); // => "/pathname/"
*/

Util.urlParser = function(){
	var url;
	var href;
	var a;
	var existPrtc;
}

Util.urlParser.prototype.setUrl =  function(url){		
	var httpCheck = /(http|https):\/\/.*/;
	this.url = url;
	if(httpCheck.test(url)){
		this.href = url;
		this.existPrtc = true;
	}else{			
		this.href = 'http://' + url;
		this.existPrtc = false;
	}
	this.a = document.createElement('a');
	this.a.href = this.href;
};

Util.urlParser.prototype.getParams = function(){		
	var urlParamString = this.a.search;		 
	var urlParameter = new Array;
	if(urlParamString.length > 1 && urlParamString.charAt(0) == '?'){
		var urlParamArray = urlParamString.substring(1).split('&');
		var i, len, eIdx, urlParam;
		for(i=0, len=urlParamArray.length; i < len; i++){
			urlParam = urlParamArray[i];
			eIdx = urlParam.indexOf('=');			
			var paramSet = new Array(urlParam.substring(0, eIdx),decodeURIComponent(urlParam.substring(eIdx+1)));
			urlParameter.push(paramSet);
		}		 
	}
	return urlParameter;
};

Util.urlParser.prototype.getProtocol = function(){
	return this.a.protocol;
};

Util.urlParser.prototype.getHostName = function(){
	return this.a.hostname;
};

Util.urlParser.prototype.getPathname = function(){
	return this.a.pathname;
};

/**---------------------------------------------------------------------
* 기능 : 테이블 rowSpan
* 인수 : rowSpan할 테이블 id, rowSpan 처리할 컬럼 Array
* Return : 
----------------------------------------------------------------------*/
Util.rowSpan = function(table, cols) {
	table.each(function() {
		var table = this;
		$.each(cols /* 합칠 칸 번호 */, function(c, v) {
			var tds = $('>tbody>tr>td:nth-child(' + v + ')', table).toArray(), i = 0, j = 0;
			for(j = 1; j < tds.length; j ++) {
				if(tds[i].innerHTML != tds[j].innerHTML) {
					$(tds[i]).attr('rowspan', j - i);
					i = j;
					continue;
				}
				$(tds[j]).hide();
			}
			j --;
			if(tds[i].innerHTML == tds[j].innerHTML) {
				$(tds[i]).attr('rowspan', j - i + 1);
			}
		});
	});
};
