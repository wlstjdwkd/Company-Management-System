//
//  Softcamp KeyStroke Web Standard Javascript
//  Control - SCWSControl.exe and SCSKLS.exe
//  Yang-JM
//  Javascript Version : 19.8.30.1;
//
SCWSCon_VERSION = "1.0.0.12";
SCWSCon_INSTALLPAGE = '/PGCMLOGIO0010.do?df_method_nm=keyboardEnc'; // 설치페이지 경로


var SCWSCon_WSS_HOST = "wss://scskls.softcamp.co.kr:";
var SCWSCon_WSS_PORT = 49160;
var SCWSCon_SXHR_HOST = "https://scskls.softcamp.co.kr:";
var SCWSCon_SXHR_PORT = 49170;
var SCWSCon_XHR_HOST = "http://scskls.softcamp.co.kr:";
var SCWSCon_XHR_PORT = 49180;

var PORT_CHANGE_TERM = 8000; // 포트 문제일 때, 연결 재시도 포트 증가 Term

var PORT_WAIT_TIME = 2000; // 500~3000사이로 너무 낮으면 연결도중에 끊김, 너무 늦으면 사용자가 싫어함

var bUseSSL = (document.location.href.indexOf("https") == -1) ? false : true;

var console = window.console || {
	log : function() {
	}
};

var browserName;
var browserVersion;
var isXHR = false;

var DEBUG = 0;
var SCWSCon_USEXHR = 0;

var USEFIREWALL = 0;
var USESCSKLS = 1;
var USEVACCINE = 0;

var SCWSCon_bConnected = false;
var SCWSCon_CONNNAME;
var SCWSCon_WEBSOCKET;

function CreateRequest() {
	try {
		return new XDomainRequest();
	} catch (exception) {
		try {
			return new XMLHttpRequest(); // 다른 서버로 접근 불가. 동일 서버 내에서만 접근이 가능함.
			// 애초에 설계가 그렇게 되어 있음.
		} catch (exception) {
			var versions = [ "Msxml2.XMLHTTP.6.0", "Msxml2.XMLHTTP.5.0",
					"Msxml2.XMLHTTP.4.0", "Msxml2.XMLHTTP.3.0",
					"Msxml2.XMLHTTP", "Microsoft.XMLHttp" ];
			for (var i = 0; i < versions.length; i++) {
				try {
					return new ActiveXObject(versions[i]);
				} catch (e) {

				}
			}
		}
	}
}

function SCWSCon_GetVersion() {
	SCWSCon_SEND('3' + SCWSCon_CONNNAME + "|version|" + location.href);
}

var SCWSCon_bXHRINIT = false;
function SCWSCon_Start() {
	toggleInputEnable(true); // 181114
	SCWSCon_WebSocketConnect();
	if (SCWSCon_USEXHR) {
		SCWSCon_CONNNAME = new Date().getTime();
		SCWSCon_GetVersion();
	}
}

function SCWSCon_ConnectCheck() {
	if (SCWSCon_USEXHR) {
		if (SCWSCon_bXHRINIT == true) {
			return true;
		} else {
			outputtext("not connected");
			return false;
		}
	}

	if (SCWSCon_bConnected == false) {
		outputtext("not connected");
		return false;
	}

	return true;
}

function SCWSCon_onXHRMessage(msg) {

	var str = "";
	str = msg;
	var id = str.substr(0, 1);
	var params = str.substr(1);
	var args = params.split("|");

	var arg1 = args[0];
	var arg2 = args[1];
	var arg3 = args[2];
	var arg4 = args[3];

	if (id == "4") {
		if (arg2 == "version") {
			SCWSCon_VERSION_Check(arg3);
		} else if (arg2 == "control") {
			if (arg3 == "OK") {
				outputtext("Init OK");

				if (USESCSKLS) {
					document.onunload = SCSKLS_OnUnload;
					window.onbeforeunload = SCSKLS_OnUnload;
					SCSKLSStart();
				}
			} else {
				outputtext("ERROR!!");
				SCWSCon_open_installpage(1);
			}
		} else if (arg2 == "ALIVE") {
			outputtext("ALIVE");
		}
	}
}

var SCWSCon_bXHRWAITING = false;

function SCWSCon_XHRSend(data) {
	var request;

	// setTimeout은 XHR 객체 생성보다 먼저 실행되어야 한다.
	var setTimeoutID = setTimeout(function() {
		if (bUseSSL) {
			SCWSCon_SXHR_PORT += PORT_CHANGE_TERM;
			if (SCWSCon_SXHR_PORT > 65535) {
				SCWSCon_open_installpage(2);
				return;
			}
			outputtext("SCWSControl SXHR " + PORT_WAIT_TIME / 1000
					+ "초 동안 응답이 없어서 " + SCWSCon_SXHR_PORT + " 포트로 연결 재시도");
		} else {
			SCWSCon_XHR_PORT += PORT_CHANGE_TERM;
			if (SCWSCon_XHR_PORT > 65535) {
				SCWSCon_open_installpage(3);
				return;
			}
			outputtext("SCWSControl XHR " + PORT_WAIT_TIME / 1000
					+ "초 동안 응답이 없어서 " + SCWSCon_XHR_PORT + " 포트로 연결 재시도");
		}

		request.abort();
		SCWSCon_XHRSend(data);
	}, PORT_WAIT_TIME);

	request = CreateRequest();

	// onreadystatechange
	request.onreadystatechange = function(event) {
		if (request.readyState == 4) {
			if (request.status == 200) {
				clearTimeout(setTimeoutID);
				SCWSCon_bXHRWAITING = false;
				SCWSCon_onXHRMessage(request.responseText);
			} else {
				outputtext("SCWSControl XHRSend Error status[" + request.status
						+ "]");
			}
		} else {
			outputtext("SCWSControl XHRSend Error readyState["
					+ request.readyState + "]");
		}
	}

	if (bUseSSL) {
		request.open("GET", SCWSCon_SXHR_HOST + SCWSCon_SXHR_PORT + "?" + data
				+ "|" + new Date().getTime(), true);
	} else {
		request.open("GET", SCWSCon_XHR_HOST + SCWSCon_XHR_PORT + "?" + data
				+ "|" + new Date().getTime(), true);
	}

	// send
	request.send();

	// onerror
	request.onerror = function(event) {
		clearTimeout(setTimeoutID);
		if (bUseSSL) {
			SCWSCon_SXHR_PORT += PORT_CHANGE_TERM;
			if (SCWSCon_SXHR_PORT > 65535) {
				SCWSCon_open_installpage(4);
				return;
			}
		} else {
			SCWSCon_XHR_PORT += PORT_CHANGE_TERM;
			if (SCWSCon_XHR_PORT > 65535) {
				SCWSCon_open_installpage(5);
				return;
			}
		}

		request.abort();
		SCWSCon_XHRSend(data);
	};

	// onload
	request.onload = function(event) {
		clearTimeout(setTimeoutID);
		SCWSCon_bXHRWAITING = false;
		SCWSCon_onXHRMessage(request.responseText);
	};
}

function SCWSCon_SEND(data) {
	if (SCWSCon_USEXHR) {
		if (SCWSCon_bXHRWAITING == false || SCWSCon_bXHRINIT == false) {
			SCWSCon_bXHRWAITING = true;
			SCWSCon_XHRSend(data);
		} else if (SCWSCon_bXHRWAITING == true) {
			setTimeout(function() {
				SCWSCon_SEND(data)
			}, 100);
		}
	} else {
		SCWSCon_WEBSOCKET.send(data);
	}
}

function SCWSCon_INIT(sitecode) {
	outputtext("SCWSControl INIT");
	if (SCWSCon_ConnectCheck() == false) {
		return;
	}

	var strinit = "3";
	strinit = strinit + SCWSCon_CONNNAME + "|";
	strinit = strinit + "control|";
	strinit = strinit + sitecode + "|";

	if (USESCSKLS) {
		strinit = strinit + "SCSKLS;";
	}
	if (USEFIREWALL) {
		strinit = strinit + "FIREWALL;";
	}
	if (USEVACCINE) {
		strinit = strinit + "VACCINE;";
	}

	strinit = strinit + "|" + location.href + "|";

	outputtext("SCWSControl request data[" + strinit + "]");
	// alert("sitecode ["+strinit+"]");
	SCWSCon_SEND(strinit);

}

function SCSKInitAjaxData() {
	if (HTTPRequestObject.readyState == 4) {
		if (HTTPRequestObject.responseText.indexOf('invalid') == -1) {
			var seed = HTTPRequestObject.responseText;
			// alert("seed : "+seed);
			SEEDDATA = seed.replace(/(^\s*)|(\s*$)/gi, "");
			outputtext("seed [" + seed + "]");
			// alert("seed:" + seed);
			SCSKLS_WebSocketConnect();
			
        	if(USEXHR)
        	{
        		SCSKLS_CONNNAME=new Date().getTime();
        		SCSKLS_GetVersion();
        	}
        	SetSCSKLS_PAGE_SYN();
        	
		} else {
			setTimeout("SCSKInitAjaxData();", 100);
		}
	}
}

function SCSKInitAjax() {
	// 1. E??
	if (window.XMLHttpRequest) {
		HTTPRequestObject = new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		HTTPRequestObject = new ActiveXObject("Microsoft.XMLHTTP");
	}

	var seedUrl = SEEDURL;
	outputtext("seedUrl : [" + seedUrl + "]");
	// alert("seedUrl : "+seedUrl);
	HTTPRequestObject.onreadystatechange = SCSKInitAjaxData;
	HTTPRequestObject.open("GET", seedUrl + "?dummy=" + new Date().getTime(),
			true);
	HTTPRequestObject.send();
}

function SCWSCon_Unload() {
	if (typeof (SCWSCon_CONNAME) != "undefined") {
		outputtext("unload");
		SCWSCon_SEND('3' + SCWSCon_CONNNAME + "|unload|" + location.href);
		SCWSCon_CONNAME = "undefined";
	}
}

function SCWSCon_ALIVE() {
	if (SCWSCon_USEXHR) {
		if (SCWSCon_bXHRINIT == false) {
			SCWSCon_GetVersion();
		} else {
			SCWSCon_SEND('3' + SCWSCon_CONNNAME + '|' + "ALIVE");
		}
	} else {
		if (SCWSCon_ConnectCheck() == false) {
			SCWSCon_WebSocketConnect();
		}
	}
	return;
}

var SCWSCon_timerAlive = 0;

function SetSCWSCon_PAGE_SYN() {
	SCWSCon_timerAlive = setInterval("SCWSCon_ALIVE()", 1000);
}

function ClearSCWSCon_PAGE_SYN() {
	clearInterval(SCWSCon_timerAlive);
}

function SCWSCon_CHECKSTART() {
	if (SCWSCon_ConnectCheck() == false) {
		return;
	}

	SCWSCon_SEND('3' + SCWSCon_CONNNAME + '|' + "ALIVE");
}

function SCWSCon_VERSION_Check(veragent) {
	SCWSCon_bXHRINIT = true;
	outputtext("SCWSControl VERSION_Check");
	outputtext("veragent : " + veragent);
	var firever = veragent;
	var verCurrent = SCWSCon_VERSION;

	var temparr = firever.split(".");
	var temparr2 = verCurrent.split(".");
	var bReInstall = false;

	for (i = 0; i < 4; i++) {
		var itemp = temparr[i] * 1;
		var itemp2 = temparr2[i] * 1;

		outputtext("SCWSControl 모듈 버전[" + itemp + "] : [" + itemp2
				+ "] 파일에 기재된 버전");
		if (itemp < itemp2) {
			bReInstall = true;
			break;
		}
	}

	if (bReInstall == true) {
		SCWSCon_open_installpage(6);
	} else {
		SCWSCon_bConnected = true;
		SCWSCon_INIT("softcamp");
	}

	return true;
}

function outputtext(data) {
	if (DEBUG) {
		document.getElementById("SCDebugTextarea").value += ("● " + data + "\n");
	}
	/*console.log("● " + data);*/
}

function SCWSCon_open_installpage(code) {

	toggleInputEnable(false);// 20181114 로딩바 출력
	window.top.location = SCWSCon_INSTALLPAGE; // 4444
	// clearTimeout(setTimeoutID);
	outputtext("install go !! : " + code);

}

function SCWSCon_WssOnOpen(rvt, setTimeoutID) {
	clearTimeout(setTimeoutID);
	outputtext("SCWSCon_WssOnOpen readyState[" + SCWSCon_WEBSOCKET.readyState
			+ "] (WebSocket onOpen)");
	SCWSCon_CONNNAME = new Date().getTime();
	SCWSCon_GetVersion();
}

function SCWSCon_WssOnMessage(msg) {
	var str = "";
	str = msg.data;
	var id = str.substr(0, 1);
	var params = str.substr(1);
	var args = params.split("|");

	var arg1 = args[0];
	var arg2 = args[1];
	var arg3 = args[2];
	var arg4 = args[3];

	if (id == "4") {
		if (arg2 == "version") {
			SCWSCon_VERSION_Check(arg3);
		} else if (arg2 == "control") {
			if (arg3 == "OK") {
				outputtext("arg3 : " + arg3);

				if (USESCSKLS) {
					document.onunload = SCSKLS_OnUnload;
					window.onbeforeunload = SCSKLS_OnUnload;
					SCSKLSStart();
				}
			} else {
				outputtext(arg3);
				SCWSCon_open_installpage(7);
			}
		} else if (arg2 == "ALIVE") {
			outputtext("ALIVE");
		}
	}
}

function SCWSCon_WssOnClose(evt) {
	outputtext("SCWSCon_WssOnClose readyState[" + SCWSCon_WEBSOCKET.readyState
			+ "] (WebSocket onClose)");
	SCWSCon_bConnected = false;
	SCSKClearInputs();
}

var OntimeRestartSCSKCon = 0; // SCSKCon 동작을 안할 경우 한번 더 체크
function SCWSCon_WebSocketConnect() {
	if (isXHR) {
		SCWSCon_USEXHR = true;
		return;
	}

	// setTimeout은 new WebSocket보다 먼저 실행되어야 한다.
	var setTimeoutID = setTimeout(function() {
		SCWSCon_WSS_PORT += PORT_CHANGE_TERM;

		SCWSCon_WEBSOCKET.close();

		if (SCWSCon_WSS_PORT <= 65535) {
			outputtext("SCWSControl WebSocket " + PORT_WAIT_TIME / 1000
					+ "초 동안 응답이 없어서 " + SCWSCon_WSS_PORT + " 포트로 연결 재시도");
			SCWSCon_WebSocketConnect();
		} else {
			// 8000번씩 포트를 증가를 시키고 65535을 넘어 설때
			// 설치는 제대로 되어있고 로드가 안될수 있으니 다시환번 49160포트로 넘어가 설치 체크를 한다.
			OntimeRestartSCSKCon += 1;
			if (OntimeRestartSCSKCon > 1) {
				SCWSCon_open_installpage(8);
				OntimeRestartSCSKCon = 0;
			} else {
				SCWSCon_WSS_PORT = 49160;
				SCWSCon_Start();
				OntimeRestartSCSKCon += 1;
			}
			return;
		}
	}, PORT_WAIT_TIME);

	try {
		outputtext(SCWSCon_WSS_PORT + " 포트로 SCWSControl WebSocket 연결 시도.");
		SCWSCon_WEBSOCKET = new WebSocket(SCWSCon_WSS_HOST + SCWSCon_WSS_PORT);
		SCWSCon_WEBSOCKET.onopen = function(evt) {
			SCWSCon_WssOnOpen(evt, setTimeoutID)
		};
		SCWSCon_WEBSOCKET.onclose = function(evt) {
			SCWSCon_WssOnClose(evt)
		};
		SCWSCon_WEBSOCKET.onmessage = function(evt) {
			SCWSCon_WssOnMessage(evt)
		};
	} catch (exception) {
		outputtext("SCWSControl WebSocket Connect exception - " + exception);
		clearTimeout(setTimeoutID);
		SCWSCon_USEXHR = true;
	}
}

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SecureKeyStroke LS
// 보호된 필드 색깔 변경 가능 / RGB 변경
BKCOLOR_PROTECT_FIELD = "#aa0000"
BKCOLOR_PROTECT_ENABLE = "#ff5555"
VERSION_SCSKLS = "1.0.0.13";

ETEMODE_SCSKLS = 0; // 0:noete, 1:softcamp, 2:initech(현재 1번은 안씀)

var host = "wss://scskls.softcamp.co.kr:";
var host_PORT = 49200;
var XHRSURL = "https://scskls.softcamp.co.kr:";
var XHRSURL_PORT = 49210;
var XHRURL = "http://scskls.softcamp.co.kr:";
var XHRURL_PORT = 49220;

var url = document.location.href;

var protocal = (url.indexOf("https") == -1) ? "http://" : "https://";
SEEDURL = protocal + location.host + "/SCSK_SELFE2E/req_seed.jsp";

var SEEDDATA = "";
var UseBlockScreen = false; // 키보드보안 로드 시 화면을 잠금 설정(true 사용 / false 비사용)

CUSTOMCODE = "108"; // 고객사별로 코드 상이하게 주어야 함
ETETAG = "_ExtE2E123_"; // _EXTE2E123_(대소문자 구분할것)
// SEEDURL = "SOCAM_X509V3"; //자체생성 테스트용.
var USEXHR = 0;

// 기본적으로 패스워드 필드는 암호화가 되어있음
// 다른부분도 암호화가 필요할시 "listProtectText"부분에 input key값을 추가해주면 암호화 가능
listProtectText = new Array("userID", "userPW", "readonlyname");

listProtectTextID = new Array('secuid', 'secuid2', 'nomalpw', 'onlyid',
		'readonlyid')

listMoneyField = new Array('money', 'money2', 'money3');

var bConnected = false;
var SCSKLS_CONNNAME;
var SCSKLS_WEBSOCKET;
var focuselememt;
var bHangleDown = false;
var lastfocus = 0;
var savelastfocus = 0;

var protectelement = 0;
var inputTextMaxLength = 1024; // 입력 가능한 문자열의 최대 길이.
var g_orgfocus;

var Base64 = {
	// private property
	_keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",

	// public method for encoding
	encode : function(input) {
		var output = "";
		var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
		var i = 0;

		while (i < input.length) {
			chr1 = input.charCodeAt(i++);
			chr2 = input.charCodeAt(i++);
			chr3 = input.charCodeAt(i++);

			enc1 = chr1 >> 2;
			enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
			enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
			enc4 = chr3 & 63;

			if (isNaN(chr2)) {
				enc3 = enc4 = 64;
			} else if (isNaN(chr3)) {
				enc4 = 64;
			}

			output = output + this._keyStr.charAt(enc1)
					+ this._keyStr.charAt(enc2) + this._keyStr.charAt(enc3)
					+ this._keyStr.charAt(enc4);
		}
		return output;
	},

	// public method for decoding
	decode : function(input) {
		var output = "";
		var chr1, chr2, chr3;
		var enc1, enc2, enc3, enc4;
		var i = 0;

		if (input == null) {
			return output;
		}

		var tempinput = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
		input = tempinput;

		while (i < input.length) {
			enc1 = this._keyStr.indexOf(input.charAt(i++));
			enc2 = this._keyStr.indexOf(input.charAt(i++));
			enc3 = this._keyStr.indexOf(input.charAt(i++));
			enc4 = this._keyStr.indexOf(input.charAt(i++));

			chr1 = (enc1 << 2) | (enc2 >> 4);
			chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
			chr3 = ((enc3 & 3) << 6) | enc4;

			output = output + String.fromCharCode(chr1);

			if (enc3 != 64) {
				output = output + String.fromCharCode(chr2);
			}
			if (enc4 != 64) {
				output = output + String.fromCharCode(chr3);
			}
		}

		return output;
	}
}

function changeSourceView(obj) {
	var encodeStr = Base64.encode(obj.value);
	var decodeStr = Base64.decode(encodeStr)
	document.mainForm.resultEncode.value = encodeStr;
	document.mainForm.resultDecode.value = decodeStr;
}

function VERSION_Check(veragent) {
	bXHRINIT = true;
	outputtext("SCSKLSSvc VERSION_Check");
	outputtext(veragent);
	var firever = veragent;
	var verCurrent = VERSION_SCSKLS;

	var temparr = firever.split(".");
	var temparr2 = verCurrent.split(".");
	var bReInstall = false;

	for (i = 0; i < 4; i++) {
		var itemp = temparr[i] * 1;
		var itemp2 = temparr2[i] * 1;

		outputtext("SCSKLSSvc 모듈 버전[" + itemp + "] : [" + itemp2
				+ "] 파일에 기재된 버전");
		if (itemp < itemp2) {
			bReInstall = true;
			break;
		}
	}

	if (bReInstall == true) {
		SCWSCon_open_installpage(9);
	} else {
		bConnected = true;
		SCSKLS_INIT("softcamp");
	}

	return true;
}

var bXHRINIT = false;
function SCSKLSStart() {

	SCSKInit();

	if (ETEMODE_SCSKLS != 0)
		SCSKInitAjax();
	// 2018.10.12 hsy move SCSKInitAjax callback!!

	else {
		SCSKLS_WebSocketConnect();
		if (USEXHR) {
			SCSKLS_CONNNAME = new Date().getTime();
			SCSKLS_GetVersion();
		}
		SetSCSKLS_PAGE_SYN();

	}
}

function ConnectCheck() {
	if (USEXHR) {
		if (bXHRINIT == true) {
			return true;
		} else {
			outputtext("not connected");
			return false;
		}
	}

	if (bConnected == false) {
		outputtext("not connected");
		return false;
	}

	return true;
}

function onXHRMessage(msg) {
	outputtext('onXHRMessage msg  :' + msg);
	var str = "";
	str = msg;
	var id = str.substr(0, 1);
	var params = str.substr(1);
	var args = params.split("|");

	var arg1 = args[0];
	var arg2 = args[1];
	var arg3 = args[2];
	var arg4 = args[3];

	if (id == "4") {
		if (arg2 == "version") {
			outputtext('xhr msg:' + arg2);
			VERSION_Check(arg3);
		} else if (arg2 == "start") {
			outputtext('xhr msg:' + arg2);
			try {
				lastfocus.onpaste = function(e) {
					outputtext("lastfocus onpaste not : " + lastfocus.name);
					return false;
				};
				lastfocus.style.imeMode = "disabled";
				lastfocus.style.backgroundColor = BKCOLOR_PROTECT_ENABLE;
				savelastfocus = lastfocus;
				protectelement = lastfocus;

				if (arg3 == "USEETE_CLEAR") {
					if (protectelement) {
						protectelement.value = "";
						SetEncDatatohidden(protectelement, "");
					}
				} else if (arg3 == "START_FAIL") {
					outputtext("START_FAIL");
				}
			} catch (e) {
			}
		} else if (arg2 == "stop") {
			outputtext('xhr msg:' + arg2);

			if (savelastfocus.style != null) {
				savelastfocus.style.backgroundColor = BKCOLOR_PROTECT_FIELD;
			}
		} else if (arg2 == "ERROR") {
			if (savelastfocus.style != null) {
				savelastfocus.style.backgroundColor = BKCOLOR_PROTECT_FIELD;
			}
			alert("Secure KeyStroke Error");
		} else if (arg2 == "NOETE") {
			outputtext('xhr msg:' + arg2);

			if (lastfocus) {
				// html에서 maxlength를 지정하여 한경우
				if (protectelement.maxLength < parseInt(protectelement.value.length) + 1
						&& protectelement.maxLength != -1) {
					return;
				}
				var orgdata = protectelement.value;
				var getdata = 0;
				// html에 maxlength가 지정이 안되 javascript에서 지정할 경우
				if (orgdata.length < inputTextMaxLength) {
					protectelement.value = orgdata + Base64.decode(arg3);
				} else {
					protectelement.value.substr(0, inputTextMaxLength - 1);
				}
			}
		} else if (arg2 == "USEETE") {
			outputtext('xhr msg:' + arg2);

			if (protectelement) {
				if (typeof (arg3) == "undefined") {
					protectelement.value = "";
				} else {
					protectelement.value = Base64.decode(arg3);
				}

				SetEncDatatohidden(protectelement, arg4);

				var next = getnextfocus(protectelement);

				if (typeof (next) != "undefined") {
					autoFocus(protectelement, next);
				}

				if (protectelement == document.getElementById('money')) {
					insertCommaForMoneyValue(protectelement);
				}
			}
		} else if (arg2 == "USEETE_BK") {
			outputtext('xhr msg:' + arg2);

			if (protectelement) {
				var orgdata = protectelement.value;
				var len = orgdata.length;
				var newdata = orgdata.substr(0, len);
				protectelement.value = newdata;
				SetEncDatatohidden(protectelement, arg4);
			}
		} else if (arg2 == "USEETE_CLEAR") {
			outputtext('xhr msg:' + arg2);
			if (protectelement) {
				protectelement.value = "";
				SetEncDatatohidden(protectelement, "");
			}
		} else if (arg2 == "CALLETEDATA") {
			SCSKLS_GETENCDATA(protectelement.name, protectelement.value, 'a',
					protectelement.type);
		} else if (arg2 == "CHECKSTART") {
			SCSKLS_CHECKSTART();
		} else if (arg2 == "Init" || arg2 == "ALIVE") {
			// outputtext("Arg2 ======= : " + arg2);
		}
	}
}

var bXHRWAITING = false;

function XHRSend(data) {
	var request;

	var setTimeoutID = setTimeout(function() {
		if (bUseSSL) {
			XHRSURL_PORT += PORT_CHANGE_TERM;
			if (XHRSURL_PORT > 65535) {
				SCWSCon_open_installpage(10);
				return;
			}
			outputtext("SCSKLSSvc XHRS " + PORT_WAIT_TIME / 1000
					+ "초 동안 응답이 없어서 " + XHRSURL_PORT + " 포트로 연결 재시도");
		} else {
			XHRURL_PORT += PORT_CHANGE_TERM;
			if (XHRURL_PORT > 65535) {
				SCWSCon_open_installpage(11);
				return;
			}
			outputtext("SCSKLSSvc XHR " + PORT_WAIT_TIME / 1000
					+ "초 동안 응답이 없어서 " + XHRURL_PORT + " 포트로 연결 재시도");
		}

		request.abort();
		XHRSend(data);
	}, PORT_WAIT_TIME);

	request = CreateRequest();

	// onreadystatechange
	request.onreadystatechange = function(event) {
		if (request.readyState == 4) {
			if (request.status == 200) {
				clearTimeout(setTimeoutID);
				bXHRWAITING = false;
				onXHRMessage(request.responseText);
			} else {
				outputtext("SCSKLSSvc XHRSend Error status[" + request.status
						+ "]");
			}
		} else {
			outputtext("SCSKLSSvc XHRSend Error readyState["
					+ request.readyState + "]");
		}
	};

	if (bUseSSL) {
		request.open("GET", XHRSURL + XHRSURL_PORT + "?" + data + "|"
				+ new Date().getTime(), true);
	} else {
		request.open("GET", XHRURL + XHRURL_PORT + "?" + data + "|"
				+ new Date().getTime(), true);
	}

	// send
	request.send();

	// onerror
	request.onerror = function(event) {
		clearTimeout(setTimeoutID);

		if (bUseSSL) {
			XHRSURL_PORT += PORT_CHANGE_TERM;
			if (XHRSURL_PORT > 65535) {
				SCWSCon_open_installpage(12);
				return;
			}
		} else {
			XHRURL_PORT += PORT_CHANGE_TERM;
			if (XHRURL_PORT > 65535) {
				SCWSCon_open_installpage(13);
				return;
			}
		}

		request.abort();
		XHRSend(data);
	};

	// onload
	request.onload = function(event) {
		clearTimeout(setTimeoutID);
		bXHRWAITING = false;
		onXHRMessage(request.responseText);
	};
}

function SCSKLS_SEND(data) {
	if (USEXHR) {
		if (bXHRWAITING == false || bXHRINIT == false) {
			bXHRWAITING = true;
			XHRSend(data);
		} else if (bXHRWAITING == true) {
			setTimeout(function() {
				SCSKLS_SEND(data)
			}, 100);
		}
	} else {
		SCSKLS_WEBSOCKET.send(data);
	}
}

function SCSKLS_GetVersion() {
	SCSKLS_SEND('3' + SCSKLS_CONNNAME + "|version|" + location.href);
}

function SCSKLS_INIT(sitecode) {
	outputtext("SCSKLSSvc INIT");

	if (ConnectCheck() == false) {
		return;
	}

	toggleInputEnable(false); // 2018.11.02

	var strinit = "3";
	strinit = strinit + SCSKLS_CONNNAME + "|";
	strinit = strinit + "Init|";

	if (USEXHR) {
		strinit = strinit + "UseDummy|";
	} else {
		strinit = strinit + "NotUseDummy|";
	}

	strinit = strinit + location.href + "|";

	if (ETEMODE_SCSKLS == 0) // non e2e
	{
		strinit = strinit + "NOETE";
	} else if (ETEMODE_SCSKLS == 1) {
		strinit = strinit + "USEETE_SC|" + SEEDDATA + '|' + CUSTOMCODE;
	} else if (ETEMODE_SCSKLS == 2) {
		strinit = strinit + "USEETE_INI|" + SEEDDATA + '|' + CUSTOMCODE;
	}

	outputtext("SCSKLSSvc request data[" + strinit + "]");

	SCSKLS_SEND(strinit, false);
}

function SCSKLS_START(e) {
	protectelement = 0;

	if (ConnectCheck() == false) {
		return;
	}

	var strismoneyfield;

	if (IsMoneyField(e)) {
		strismoneyfield = "MONEYFIELD";
	} else {
		strismoneyfield = "NOTMONEYFIELD";
	}
	
	var Base64val = Base64.encode(e.value);

	// 1 2 3 4 5 6 7 8
	SCSKLS_SEND('3' + SCSKLS_CONNNAME + "|start|" + e.name + '|' + Base64val
			+ '|' + e.type + '|' + location.href + '|' + e.maxLength + '|'
			+ strismoneyfield, false);

	e.selectionStart = e.selectionEnd = e.value.length;
}

function SCSKLS_STOP(name) {
	if (ConnectCheck() == false) {
		return;
	}

	SCSKLS_SEND('3' + SCSKLS_CONNNAME + "|stop|" + location.href, false);
}

function SCSKLS_Unload() {
	if (typeof (SCSKLS_CONNAME) != "undefined") {
		SCSKLS_SEND('3' + SCSKLS_CONNNAME + "|unload|" + location.href, false);
	}
}

function SCSKLS_ALIVE() {
	if (USEXHR) {
		if (bXHRINIT == false) {
			SCSKLS_GetVersion();
		} else {
			SCSKLS_SEND('3' + SCSKLS_CONNNAME + '|' + "ALIVE", true);
		}
	}
	// else {
	// if (ConnectCheck() == false) {
	// SCSKLS_WebSocketConnect(); // 이 코드 추가되면 오동작.
	// }
	// }
}

var timerAlive = 0;
function SetSCSKLS_PAGE_SYN() {
	timerAlive = setInterval("SCSKLS_ALIVE()", 1000);
}

function ClearSCSKLS_PAGE_SYN() {
	clearInterval(timerAlive);
}

function SCSKLS_GETDATA(name, value, keycode) {
	if (ConnectCheck() == false) {
		return;
	}

	outputtext("SCSKLS_GETDATA");
	var Base64val = Base64.encode(keycode);
	SCSKLS_SEND('3' + SCSKLS_CONNNAME + '|' + "getdata" + '|' + name + '|'
			+ Base64val, false);
}

function SCSKLS_GETENCDATA(name, value, keycode, type) {
	if (ConnectCheck() == false) {
		return;
	}

	var Base64val = Base64.encode(value);
	SCSKLS_SEND('3' + SCSKLS_CONNNAME + '|' + "getencdata" + '|' + name + '|'
			+ Base64val + '|' + keycode + '|' + type, false);
}

function SCSKLS_CHECKSTART() {
	if (ConnectCheck() == false) {
		return;
	}

	SCSKLS_SEND('3' + SCSKLS_CONNNAME + '|' + "ALIVE", false);
}

function IsProtectText(elem) {
	for (i = 0; i < listProtectText.length; i++) {
		if (listProtectText[i] == elem.name
				&& !document.getElementsByName(listProtectText[i])[0].readOnly) {
			return true;
		}
	}

	return false;
}

function IsProtectTextID(elem) {
	for (i = 0; i < listProtectTextID.length; i++) {
		if (listProtectTextID[i] == elem.id
				&& !document.getElementById(listProtectTextID[i]).readOnly)
			return true;
	}
	return false;
}

function IsMoneyField(elem) {
	for (i = 0; i < listMoneyField.length; i++) {
		if (listMoneyField[i] == elem.name) {
			return true;
		}
	}

	return false;
}

function SCSKAddEvent(elem, eventName, handler) {
	
	if (typeof (elem[eventName]) == "function") {
		var oldEvent = elem[eventName];

		elem[eventName] = function(e) {
			oldEvent(e);
			return handler(e);
		}
	} else {
		//alert(elem.name + " - " + eventName);
		elem[eventName] = handler;
	}
}
// 181108 포커스를 맨뒤에다가 둔다, 마우스로 전체 선택시 페이지 뒤로 가지는 문제
var selectionText = "";
// ETE일 경우 입력 중에 포커스를 중간에 두면 맨앞으로 가고 포커스가 안움직이는 문제 수정
function SCSKEleClick(e) {
	this.selectionStart = this.selectionEnd = this.value.length;

	selectionText = "";

	// 마우스로 전체 선택인지 일부인지 판단하는 로직
	this.onmouseup = function() {
		selectionText = GetSelect();

	}

	return true;
}

function SCSKEleKeyDown(e) {
	if (!bConnected) {
		return true;
	}

	if (!e) {
		e = window.event;
	}
	
	var keycode = e.keyCode;
 
	var retval = true;
	outputtext('keydown:' + keycode);

	switch (keycode) {
	// 2018.11.05 수정
	// 전체 선택 후 삭제 가능
	case 8:
	case 46:
		if (ETEMODE_SCSKLS != 0 && this.value != "") {
			if (GetSelect() || selectionText != "") { // 181108 수정 마우스로 전체선택시
				// 페이지가 뒤로 넘어가는 문제
				if (protectelement) {
					protectelement.value = "";
					SetEncDatatohidden(protectelement, "");
					getdata = SCSKLS_GETENCDATA(this.name, "", "BACKSPACE",
							this.type);
				}
			} else {
				getdata = SCSKLS_GETENCDATA(this.name, this.value, "BACKSPACE",
						this.type);
			}
			e.preventDefault();
		}
		break;
	// 2018.11.05 수정

	case 36: // home
	case 37:
	case 38:
	case 39:
	case 40:
		retval = false;
		break;
	// 2018.11.07 ETE일 경우 숫자 "0"을 누르고 다음 숫자를 누르면 삭제되는 문제
	// 우측 키보드는 96~105로 시작이 됨(96은 숫자 0인데 키보드영향인지, PC영향인지 문자로 인식함. 48로 바꾸어 암호화)
	case 96:
		keycode = 48;
		break;
	case 48:
	// case 197:
	case 229: {
		// outputtext('keydown:'+keycode);
		bHangleDown = true;
	}
		break;
	default:
		bHangleDown = false;
		break;
	}
	return retval;
}

// 18.11.05 완전 삭제 수정
function GetSelect() {
	if (window.getSelection) { // all browsers, except IE before version 9
		if (document.activeElement
				&& (document.activeElement.tagName.toLowerCase() == "textarea" || document.activeElement.tagName
						.toLowerCase() == "input")) {
			var text = document.activeElement.value;
			return text.substring(document.activeElement.selectionStart,
					document.activeElement.selectionEnd);
		} else {
			var selRange = window.getSelection();
			return selRange.toString();
		}
	} else {
		if (document.selection.createRange) { // Internet Explorer
			var range = document.selection.createRange();
			return range.text;
		}
	}
}
// 18.11.05

function SCSKEleKeyUp(e) {
	if (!bConnected) {
		return true;
	}

	if (!e) {
		e = window.event;
	}

	var keycode = e.keyCode;

	var retval = true;
	// opera ??.
	// outputtext('keyup:'+keycode);
	switch (keycode) {
	case 36: // home
	case 37:
	case 38:
	case 39:
	case 40:
		retval = false;
		break;
	default:
		if (bHangleDown) {
			// outputtext('keyup:'+keycode);
			bHangleDown = false;
			alert("한글은 입력할 수 없습니다.");
			this.value = "";
		}
		break;
	}
	return retval;
}

function SCSKEleKeyPress(e) {
	if (!bConnected) {
		return true;
	}

	var lkeycode;
	if (window.event) {
		e = window.event
		lkeycode = e.keyCode;
	} else {
		lkeycode = e.charCode;
	}

	outputtext('keypress:' + protectelement.name + '=' + this.name);

	// enter 처리
	if (lkeycode == 13) {
		return true;
	}
	var charcode = String.fromCharCode(lkeycode);
	
	outputtext('keypress:[a' + charcode + 'b]');
	if (charcode != '0' || charcode == ' ') {
		outputtext('test : ' + charcode);
		if (ETEMODE_SCSKLS == 0) {
			if (USEXHR) {
				SCSKLS_GETDATA(this.name, this.value, charcode);
				return false;
			} else
				return true;
		}
		if (this.value.length < 24) {
			SCSKLS_GETENCDATA(this.name, this.value, charcode, this.type);
		}
		return false;
	}
	return true;
}

function SCSKWinFocus(e) {
	var curactive = document.activeElement;
	// outputtext('winfoucs(activeelement):'+document.activeElement);
	if (curactive == "[object HTMLInputElement]") {
		if (curactive.type == "password" || IsProtectText(curactive)) {
			// outputtext('winfocus:'+curactive.name);
			
			SCSKLS_START(curactive);
			lastfocus = curactive;
		}
		// else
		// outputtext('winfocus:type not match');

	}
	// else
	// outputtext('winfocus:curactive!=[object HTMLInputElement]');
}

function SCSKEleFocus() {
	// outputtext('focus:' + this.name);
	
	SCSKLS_START(this);
	lastfocus = this;
}

function SCSKEleFocus(e) {
	// outputtext('focus:' + this.name);
	SCSKLS_START(e.target);
	lastfocus = e.target;
}

function SCSKWinBlur(e) {

	if (lastfocus != 0) {
		outputtext('winblur:' + lastfocus.name);
		SCSKLS_STOP(lastfocus.name);
		lastfocus = 0;
		protectelement = 0;
	}
}

function SCSKEleBlur() {
	// outputtext('blur:' + this.name);
	SCSKLS_STOP(this.name);
	lastfocus = 0;
	protectelement = 0;
}

function SCSKSetEleHandler(e) {
	outputtext("SCSKSetEleHandler param name[" + e.name + "]");
	SCSKAddEvent(e, "onfocus", SCSKEleFocus);
	SCSKAddEvent(e, "onblur", SCSKEleBlur);
	SCSKAddEvent(e, "onkeypress", SCSKEleKeyPress);
	SCSKAddEvent(e, "onkeydown", SCSKEleKeyDown);
	// SCSKAddEvent(e, "onkeyup", SCSKEleKeyUp);
	SCSKAddEvent(e, "onclick", SCSKEleClick);
	e.style.imeMode = "disabled";
	e.style.backgroundColor = BKCOLOR_PROTECT_FIELD;
}

function SCSKSetHandlerForm(form) {
	
	for (var i = 0; i < form.elements.length; i++) {
		var e = form.elements[i];
		
		if (e.type == "password" || IsProtectText(e)) {
			

			SCSKSetEleHandler(e);
			e.value = "";
			var hidden = document.createElement("input");
			if (!DEBUG) {
				hidden.setAttribute("type", "hidden");
			}

			hidden.setAttribute("id", ETETAG + e.name);
			hidden.setAttribute("name", ETETAG + e.name);

			form.appendChild(hidden);
		}
	}
}
function SCSKSetHandler() {
	
	var allforms = document.forms;
	for (var i = 0; i < allforms.length; i++) {
		SCSKSetHandlerForm(allforms[i]);
	}
	toggleInputEnable(true); // 2018.11.02

	// name값이 없는 id
	var inputArray = document.getElementsByTagName("input");

	for (var index = 0; index < inputArray.length; index++) {
		var ide = inputArray[index];
		if (IsProtectTextID(ide))
			SCSKSetEleHandler(ide);
	}

	SCSKAddEvent(window, "onblur", SCSKWinBlur);
	SCSKAddEvent(window, "onfocus", SCSKWinFocus);
}

function SCSKClearInputsForm(form) {
	for (var i = 0; i < form.elements.length; i++) {
		var e = form.elements[i];

		if (e.type == "password" || IsProtectText(e)) {
			e.value = "";

		}
	}
}
// connection end clear all
function SCSKClearInputs() {
	var allforms = document.forms;

	// eng.style.imeMode="disabled";
	for (var i = 0; i < allforms.length; i++) {
		SCSKClearInputsForm(allforms[i]);
	}
}

function SCSKInit() {
	outputtext("SCSKLSSvc SCSKInit");
	try {
		if (OntimeReStartSCSKLS < 2) // hidden 핸들러의 생성을 한개로 제한하기위해
			SCSKSetHandler();
	} catch (e) {
		window.location.replace(INSTALLPAGE_PLUGIN);
	}
}

function SetEncDatatohidden(inputele, data) {
	var hiddenname = ETETAG + inputele.name;
	var matchhidden = document.getElementsByName(hiddenname);
	if (typeof (data) == "undefined") {
		matchhidden[0].value = "";
	} else {
		matchhidden[0].value = data;
	}
}

function gotourl(url) {
	try {
		SCSKLSifrm = document.createElement("IFRAME");
		SCSKLSifrm.setAttribute("src", url);
		SCSKLSifrm.style.width = 0 + "px";
		SCSKLSifrm.style.height = 0 + "px";
		document.body.appendChild(SCSKLSifrm);
	} catch (e) {
		SCWSCon_open_installpage(14);
	}
}

var OntimeReStartSCSKLS = 0; // SCSKLSSvc가 동작을 안할 수 있으니 한번만 더 실행
function SCSKLS_WebSocketConnect() {
	if (isXHR) {
		USEXHR = true;
		return;
	}

	// setTimeout은 new WebSocket보다 먼저 실행되어야 한다.
	var setTimeoutID = setTimeout(function() {
		host_PORT += PORT_CHANGE_TERM;

		SCSKLS_WEBSOCKET.close();

		if (host_PORT < 65535) {
			outputtext("SCSKLSSvc WebSocket 1초 동안 응답이 없어서 " + host_PORT
					+ " 포트로 연결 재시도");
			SCSKLS_WebSocketConnect();
		} else {
			OntimeReStartSCSKLS += 1;
			if (OntimeReStartSCSKLS > 1) {
				SCWSCon_open_installpage(15); // 설치 페이지로 이동
				OntimeReStartSCSKLS = 0; // 다음의 같은 이유가 발생할 경우를 위해 0으로 초기화
			} else {
				host_PORT = 49200;
				SCWSCon_INIT("softcamp");
				OntimeReStartSCSKLS += 1;
			}
			return;
		}
	}, PORT_WAIT_TIME);

	try {
		outputtext(host_PORT + " 포트로 SCSKLSSvc WebSocket 연결 시도.");
		SCSKLS_WEBSOCKET = new WebSocket(host + host_PORT);
		SCSKLS_WEBSOCKET.onopen = function(evt) {
			onOpen(evt, setTimeoutID)
		};
		SCSKLS_WEBSOCKET.onclose = function(evt) {
			onClose(evt)
		};
		SCSKLS_WEBSOCKET.onmessage = function(evt) {
			onMessage(evt)
		};
	} catch (exception) {
		outputtext("SCSKLSSvc WebSocket Connect exception - " + exception);
		clearTimeout(setTimeoutID);
		USEXHR = true;
	}
}

function onOpen(rvt, setTimeoutID) {
	clearTimeout(setTimeoutID);
	outputtext('Socket Status: ' + SCSKLS_WEBSOCKET.readyState + ' (open)');

	SCSKLS_CONNNAME = new Date().getTime();
	SCSKLS_GetVersion();

}

function onMessage(msg) {

	var str = "";
	str = msg.data;
	var id = str.substr(0, 1);
	var params = str.substr(1);
	var args = params.split("|");

	var arg1 = args[0];
	var arg2 = args[1];
	var arg3 = args[2];
	var arg4 = args[3];

	outputtext(arg2);
	if (id == "4") {
		if (arg2 == "version") {
			VERSION_Check(arg3);
		} else if (arg2 == "start") {
			try {
				lastfocus.onpaste = function(e) {
					outputtext("lastfocus onpaste not : " + lastfocus.name);
					return false;
				};
				lastfocus.style.backgroundColor = BKCOLOR_PROTECT_ENABLE;
				savelastfocus = lastfocus;
				protectelement = lastfocus;
				if (arg3 == "USEETE_CLEAR") {
					if (protectelement) {
						protectelement.value = "";
						SetEncDatatohidden(protectelement, "");
					}
				} else if (arg3 == "START_FAIL") {
					outputtext("START_FAIL");
				}
			} catch (e) {
			}
		} else if (arg2 == "stop") {
			if (savelastfocus.style != null) {
				savelastfocus.style.backgroundColor = BKCOLOR_PROTECT_FIELD;
			}
		} else if (arg2 == "ERROR") {
			if (savelastfocus.style != null) {
				savelastfocus.style.backgroundColor = BKCOLOR_PROTECT_FIELD;
			}
			alert("Secure KeyStroke Error");
		} else if (arg2 == "NOETE") {
			if (lastfocus) {
				// html에서 maxlength를 지정하여 한경우
				if (protectelement.maxLength < parseInt(protectelement.value.length) + 1
						&& protectelement.maxLength != -1) {
					return;
				}
				var orgdata = protectelement.value;
				var getdata = 0;
				// html에 maxlength가 지정이 안되 javascript에서 지정할 경우
				if (orgdata.length < inputTextMaxLength) {
					protectelement.value = orgdata + Base64.decode(arg3);// window.atob(arg3);
				} else {
					protectelement.value.substr(0, inputTextMaxLength - 1);
				}
			}
		} else if (arg2 == "USEETE") {
			if (protectelement) {
				if (typeof (arg3) == "undefined")
					protectelement.value = "";
				else {
					protectelement.value = Base64.decode(arg3);
				}
				SetEncDatatohidden(protectelement, arg4);

				var next = getnextfocus(protectelement);
				if (typeof (next) != "undefined") {
					autoFocus(protectelement, next);
				}

				if (protectelement == document.getElementById('money')) {
					insertCommaForMoneyValue(protectelement);
				}
			}
		} else if (arg2 == "USEETE_BK") {
			if (protectelement) {
				var orgdata = protectelement.value;
				var len = orgdata.length;
				var newdata = orgdata.substr(0, len);
				protectelement.value = newdata;
				SetEncDatatohidden(protectelement, arg4);
			}

		} else if (arg2 == "USEETE_CLEAR") {
			if (protectelement) {
				protectelement.value = "";
				SetEncDatatohidden(protectelement, "");
			}
		} else if (arg2 == "CALLETEDATA") {
			SCSKLS_GETENCDATA(protectelement.name, protectelement.value, 'a',
					protectelement.type);
		} else if (arg2 == "CHECKSTART") {
			SCSKLS_CHECKSTART();
		}
	}
}

function onClose(evt) {
	outputtext('Socket Status: ' + SCSKLS_WEBSOCKET.readyState + ' (Closed)');
	bConnected = false;
	SCSKClearInputs();
}

function SCSKLS_OnUnload() {
	if (lastfocus != 0) {
		SCSKLS_STOP(lastfocus.name);
		lastfocus = 0;
	}
}

function setnextfocuselement(e1, e2, e3, e4) {
	outputtext("setnextfocuselement" + e1.name + "|" + e2.name);
	g_orgfocus = e1;
	g_nextfocus = e2;
	g_tnextfocus = e3;
	g_dnextfocus = e4;
}

function getnextfocus(e) {
	try {
		if (e.name == g_orgfocus.name)
			return g_nextfocus;
		if (e.name == g_nextfocus.name)
			return g_tnextfocus;
		if (e.name == g_tnextfocus.name)
			return g_dnextfocus;
	} catch (e) {
	}
}

function autoFocus(e1, e2) {
	if (e1.value.length == e1.maxLength) {
		e2.focus();
	}
}

function comma(str) {
	str = String(str);
	return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

function uncomma(str) {
	str = String(str);
	return str.replace(/[^\d]+/g, '');
}

function insertCommaForMoneyValue(obj) {
	obj.value = comma(uncomma(obj.value));
}

function get_browser_info() {
	var ua = navigator.userAgent, tem, M = ua
			.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i)
			|| [];

	if (/trident/i.test(M[1])) {
		tem = /\brv[ :]+(\d+)/g.exec(ua) || [];
		return {
			name : 'IE',
			version : (tem[1] || '')
		};
	}
	if (M[1] === 'Chrome') {
		tem = ua.match(/\b(OPR|Edge)\/(\d+)/);
		if (tem != null)
			return tem.slice(1).join(' ').replace('OPR', 'Opera');
	}
	M = M[2] ? [ M[1], M[2] ]
			: [ navigator.appName, navigator.appVersion, '-?' ];
	if ((tem = ua.match(/version\/(\d+)/i)) != null) {
		M.splice(1, 1, tem[1]);
	}
	return {
		name : M[0],
		version : M[1]
	};

}

// parameter : isDisable (Boolean) - 2018.11.02
function toggleInputEnable(isDisable) {

	// 20181114 로딩화면 출력
	if (UseBlockScreen) {
		if (isDisable)
			SCSK_processingbar(isDisable);
		else
			SCSK_processingbar(isDisable);
	}
	// 20181114 로딩화면 출력

	var inputs = document.getElementsByTagName('input');
	outputtext("toggleInputEnable inputs : " + inputs);
	outputtext("toggleInputEnable isDisable : " + isDisable);
	outputtext("toggleInputEnable inputs.length : " + inputs.length);
	for (var i = 0; i < inputs.length; i++) {
		// outputtext("inputs[i].type.toLowerCase() : " +
		// inputs[i].type.toLowerCase());
		// password 필드 toggle 처리
		if (inputs[i].type.toLowerCase() == 'password') {
			inputs[i].disabled = isDisable;
		} else {
			// name으로 지정된 필드 toggle 처리
			for (j = 0; j < listProtectText.length; j++) {
				if (inputs[i].name != null && inputs[i].name != ""
						&& listProtectText[j] != null
						&& listProtectText[j] != "") {
					if (inputs[i].name == listProtectText[j]) {
						inputs[i].disabled = isDisable;
					}
				}
			}
			// id로 지정된 필드 toggle 처리
			for (j = 0; j < listProtectTextID.length; j++) {
				if (inputs[i].id != null && inputs[i].id != ""
						&& listProtectTextID[j] != null
						&& listProtectTextID[j] != "") {
					if (inputs[i].id == listProtectTextID[j]) {
						inputs[i].disabled = isDisable;
					}
				}
			}
		}
	}
}

// 181114 로딩 바 및 화면 어둡게 하여 로딩하는걸 기다리게 하기
var SCSK_waitingbar = "css/loading.gif";
function SCSK_processingbar(isDisable) {

	if (isDisable) {
		if (document.getElementById("SCSK_overtopDiv") != null)
			return true;
		var div = document.createElement("div");
		div.setAttribute("id", "SCSK_overtopDiv");
		document.body.appendChild(div);
		var processingbar = '<div id="SCSK_overtopDiv" style="z-index:999997;position:fixed; width:100%; height:100%; top:0px; left:0px; background-color: #000000; opacity: 0.3; filter: alpha(opacity=30);">';
		processingbar += '<div style="z-index:9999998;position:fixed;top:42%; height:100%;width:100%;">';
		processingbar += '<div style="margin: 0 auto; padding: 5px; width:50%; vertical-align:middle; font-weight:bold; text-align: center; border-radius:5px;">';
		// 해당 아래부분에서 메세지를 입력하시면 됩니다.
		processingbar += '<div style=\"color:white;width:100%;\"><h1>키보드보안 프로그램을 로딩 중 입니다.<br>잠시만 기다려 주십시오.<h1><div>';
		processingbar += '<img src="' + SCSK_waitingbar
				+ '" style="vertical-align:middle"/>';
		processingbar += '</div>';
		processingbar += '</div>';
		processingbar += '</div>';
		document.getElementById("SCSK_overtopDiv").innerHTML = processingbar;
	} else {
		if (document.getElementById("SCSK_overtopDiv") != null)
			document.body.removeChild(document
					.getElementById("SCSK_overtopDiv"));
	}
}

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if (navigator.platform == "Win32" || navigator.platform == "Win64") {
	if (DEBUG) {
		var nodeTextarea = document.createElement("textarea");
		nodeTextarea.setAttribute("id", "SCDebugTextarea");
		nodeTextarea.setAttribute("rows", 50);
		nodeTextarea.setAttribute("cols", "80%");
		document.body.appendChild(nodeTextarea);

		var nodeAppName = document.createElement("p");
		var textnodeAppName = document.createTextNode("appName - "
				+ navigator.appName);
		nodeAppName.appendChild(textnodeAppName);
		document.body.appendChild(nodeAppName);

		var nodeAppVersion = document.createElement("p");
		var textnodeAppVersion = document.createTextNode("appVersion - "
				+ navigator.appVersion);
		nodeAppVersion.appendChild(textnodeAppVersion);
		document.body.appendChild(nodeAppVersion);
	}

	browserName = get_browser_info().name;
	browserVersion = get_browser_info().version;
	if (browserName == "Safari") {
		isXHR = true;
	}

	outputtext("Browser Info : " + browserName + "(" + browserVersion + ")");
	// outputtext("isXHR : " + browserName + " : " + isXHR)

	SCWSCon_Start();
}// win32
else {
	// alert("not Windows OS");
}