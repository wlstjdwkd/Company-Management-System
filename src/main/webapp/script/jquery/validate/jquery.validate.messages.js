/*
 * Translated default messages for the jQuery validation plugin.
 * Locale: ko-Kr
 */
jQuery.extend(jQuery.validator.messages, {
    required    : "필수입력 항목입니다.",
    email       : "올바른 이메일 주소를 입력하세요.",
    url         : "올바른 URL 값을 입력하세요.",
    date        : "올바른 날짜를 입력하세요. (YYYY-MM-DD)",
    number      : "올바른 숫자값을 입력하세요.",
    digits      : "올바른 숫자값을 입력하세요.",
    equalTo     : "동일한 값을 입력하셔야 합니다.",

    maxlength   : $.validator.format("{0}자를 초과할 수 없습니다."),
    minlength   : $.validator.format("최소 {0}자 이상이어야 합니다."),
    rangelength : $.validator.format("{0}자에서 {1}자 이내여야 합니다."),
    range       : $.validator.format("{0}과 {1} 사이의 값을 입력하세요."),
    max         : $.validator.format("{0} 이하의 값을 입력하세요."),
    min         : $.validator.format("{0} 이상의 값을 입력하세요."),

    alphabetic  : "영문자만 입력하세요.",
    alphalower  : "영문자(소문자)만 입력하세요.",
    alphanumeric: "영문자와 숫자만 입력하세요.",
    alphaupper  : "영문자(대문자)만 입력하세요.",

    nowhitespace: "공백문자는 허용되지 않습니다.",

    pattern     : "정규표현식에 일치하지 않습니다.",
    remote      : "값이 올바르지 않습니다.",
    dateISO     : "올바른 날짜를 입력하세요. (YYYY-MM-DD)",
    creditcard  : "올바른 신용카드 번호를 입력하세요.",
    accept      : "허용되지 않는 파일 형식입니다.",
    	
    extension	: $.validator.format("첨부가능한 확장자를 확인하세요. ({0})"),

});