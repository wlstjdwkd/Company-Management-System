/**
 * jQuery Validation Plugin 1.9.0
 *
 * http://bassistance.de/jquery-plugins/jquery-plugin-validation/
 * http://docs.jquery.com/Plugins/Validation
 *
 * Copyright (c) 2006 - 2011 Jörn Zaefferer
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 */
(function() {

	function stripHtml(value) {
		// remove html tags and space chars
		return value.replace(/<.[^<>]*?>/g, ' ').replace(/&nbsp;|&#160;/gi, ' ')
		// remove numbers and punctuation
		.replace(/[0-9.(),;:!?%#$'"_+=\/-]*/g,'');
	}
	jQuery.validator.addMethod("maxWords", function(value, element, params) {
	    return this.optional(element) || stripHtml(value).match(/\b\w+\b/g).length < params;
	}, jQuery.validator.format("Please enter {0} words or less."));

	jQuery.validator.addMethod("minWords", function(value, element, params) {
	    return this.optional(element) || stripHtml(value).match(/\b\w+\b/g).length >= params;
	}, jQuery.validator.format("Please enter at least {0} words."));

	jQuery.validator.addMethod("rangeWords", function(value, element, params) {
	    return this.optional(element) || stripHtml(value).match(/\b\w+\b/g).length >= params[0] && value.match(/bw+b/g).length < params[1];
	}, jQuery.validator.format("Please enter between {0} and {1} words."));

})();


jQuery.validator.addMethod("firstAlpha", function(value, element) {
	return this.optional(element) || /^[a-zA-Z]\w*/.test(value);
}, "첫글자는 반드시 영문으로 입력하세요.");

jQuery.validator.addMethod("includeAlphaAtLeast2", function(value, element) {
	return this.optional(element) || /^[a-zA-Z]\w*[a-zA-Z]+\w*$/.test(value);
}, "영문을 2자 이상 포함하여 입력하세요.");

jQuery.validator.addMethod("noDigitsIncOrDec", function(value, element) {
	var isDigitsIncOrDec = /(012|123|234|345|456|567|678|789|987|876|765|654|543|432|321|210)/.test(value);
	if(this.optional(element)||(!isDigitsIncOrDec)){return true;}
}, "3자 이상 연속된 숫자는 입력하실 수 없습니다.");

jQuery.validator.addMethod("noIdenticalNum", function(value, element) {
	var isIdenticalNum	= /(0{3,}|1{3,}|2{3,}|3{3,}|4{3,}|5{3,}|6{3,}|7{3,}|8{3,}|9{3,})/.test(value);
	if(this.optional(element)||(!isIdenticalNum)){return true;}
}, "3자 이상 동일한 숫자는 입력하실 수 없습니다.");

jQuery.validator.addMethod("noAlphaInc", function(value, element) {
	var isAlphaInc = /(abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)/i.test(value);
	if(this.optional(element)||(!isAlphaInc)){return true;}
}, "3자 이상 연속된 영문은 입력하실 수 없습니다.");

jQuery.validator.addMethod("noAlphaDec", function(value, element) {
	var isAlphaDec	= /(zyx|yxw|xwv|wvu|vut|uts|tsr|srq|rqp|qpo|pon|onm|nml|mlk|lkj|kji|jih|ihg|hgf|gfe|fed|edc|dcb|cba)/i.test(value);
	if(this.optional(element)||(!isAlphaDec)){return true;}
}, "3자 이상 연속된 영문은 입력하실 수 없습니다.");

jQuery.validator.addMethod("noIdenticalWord", function(value, element) {
	var isIdenticalWord = /(a{3,}|b{3,}|c{3,}|d{3,}|e{3,}|f{3,}|g{3,}|h{3,}|i{3,}|j{3,}|k{3,}|l{3,}|m{3,}|n{3,}|o{3,}|p{3,}|q{3,}|r{3,}|s{3,}|t{3,}|u{3,}|v{3,}|w{3,}|x{3,}|y{3,}|z{3,})/.test(value);
	if(this.optional(element)||(!isIdenticalWord)){return true;}
}, "3자 이상 동일한 영문은 입력하실 수 없습니다.");

jQuery.validator.addMethod("noRefusedSpeChar", function(value, element) {
	var isRefusedSpeChar = /(<|>|\(|\)|#|\'|\/|\|)/.test(value);
	if(this.optional(element)||(!isRefusedSpeChar)){return true;}
}, "사용하실 수 없는 특수 문자를 입력하셨습니다.");

jQuery.validator.addMethod("noRefusedWord", function(value, element) {
	var isRefusedWord = /(love|happy|qwer|asdf|zxcv|test|hpe)/.test(value);
	if(this.optional(element)||(!isRefusedWord)){return true;}
}, "사용하실 수 없는 단어를 입력하셨습니다.");

jQuery.validator.addMethod("chekDuplWord", function(value, element, param) {	
	if(this.optional(element)){return true;}
	var sourceVal = $('#'+param).val();
	var subStrLen = 3;
	for(var i=0;i<sourceVal.length;i++){
		var dupleWord = sourceVal.substr(i, subStrLen);
		if(dupleWord.length < subStrLen){
			break;
		}
		var result = value.indexOf(dupleWord);
		if(result > -1){
			return false;
		}
	}
	return true;
}, "아이디와 연속 3자리 이상 일치하는 단어는 사용하실 수 없습니다.");

jQuery.validator.addMethod("alphanumeric", function(value, element) {
	return this.optional(element) || /^\w+$/i.test(value);
}, "영문과 숫자만 입력하세요.");

jQuery.validator.addMethod("alphaupper", function(value, element) {
    return this.optional(element) || /^[A-Z]+$/.test(value);
}, " 영문자(대문자)만 입력하세요.");

jQuery.validator.addMethod("alphabetic", function(value, element) {
    return this.optional(element) || /^[a-zA-Z]+$/i.test(value);
}, "영문자만 입력하세요.");

jQuery.validator.addMethod("alphalower", function(value, element) {
    return this.optional(element) || /^[a-z]+$/.test(value);
}, "영문자(소문자)만 입력하세요.");

jQuery.validator.addMethod("directory", function(value, element) {
    return this.optional(element) || /^[\/?a-z]+$/.test(value);
}, "영문 또는 슬래시('/')만 입력하세요.");

jQuery.validator.addMethod("phone", function(value, element) {
    return this.optional(element) || /^[\-?\d]+$/.test(value);
}, "숫자 또는 대시('-')만 입력하세요. (02-111-2222)");

jQuery.validator.addMethod("phoneDivided", function(value, element, params) {
	var first 	= $("#"+params[0]);
	var middle 	= $("#"+params[1]);
	var last 	= $("#"+params[2]);	
	return $.trim(first.val()).length > 0&&$.trim(middle.val()).length > 0&&$.trim(last.val()).length > 0;	
}, "필수입력 항목입니다.");

jQuery.validator.addMethod("nowhitespace", function(value, element) {
    return this.optional(element) || /^\S+$/i.test(value);
}, "공백문자 없이 입력하세요.");

jQuery.validator.addMethod("notnull", function(value, element, param) {
    // check if dependency is met
    if(!this.depend(param, element))
        return "dependency-mismatch";
    switch(element.nodeName.toLowerCase()) {
    case 'select':
        // could be an array for select-multiple or a string, both are fine this
        // way
        var val = $(element).val();
        return val && val.length > 0;
    case 'input':
        if(this.checkable(element))
            return this.getLength(value, element) > 0;
    default:
        return $.trim(value).length > 0;
    }
}, "필수 입력항목입니다.");

jQuery.validator.addMethod("juminno", function(value, element) {

    var result = true;
    if(!value) {
        return true;
    }

    var resNo = value.replace("-", "");
    if(resNo.length < 13) {
        return false;
    }
    for(i = 0, sum = 0; i < 12; i++) {
        sum += (((i % 8) + 2) * (resNo.charAt(i) - "0"));
    }

    sum = 11 - (sum % 11);
    sum = sum % 10;
    if(sum != resNo.charAt(12)) {
        return false;
    }

    return this.optional(element) || result;
}, "올바른 주민등록번호를 입력하세요.");

jQuery.validator.addMethod("contains", function(value, element, param) {

    var result = true;
    if(!value) {
        return true;
    }

    var compareValue = eval(param);

    for( var i = 0; i < compareValue.length; i++) {
        if(value == compareValue[i]) {
            result = true;
            break;
        }
    }

    return this.optional(element) || result;
}, "{0} 값 중에서 입력하세요.");

jQuery.validator.addMethod("requirefrom", function(value, element, param) {

    var val = $("[name='" + param[0] + "']:checked").val();
    if(!val) {
        return true;
    }

    if(val == param[1]) {
        if(this.checkable(element)) {
            var checkedValue = $(element).filter(':checked').val();
            if(!checkedValue) {
                return false;
            }
        } else {
            var val = $(element).val();
            if(val =="") {
                return false;
            }
        }
    }
    return true;

}, "{2} 선택시 필수 입력항목입니다.");

/**
 * Return true if the field value matches the given format RegExp
 *
 * @example jQuery.validator.methods.pattern("AR1004",element,/^AR\d{4}$/)
 * @result true
 *
 * @example jQuery.validator.methods.pattern("BR1004",element,/^AR\d{4}$/)
 * @result false
 *
 * @name jQuery.validator.methods.pattern
 * @type Boolean
 * @cat Plugins/Validate/Methods
 */
jQuery.validator.addMethod("pattern", function(value, element, param) {
   return this.optional(element) || param.test(value);
}, "Invalid format.");

