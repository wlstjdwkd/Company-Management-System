/*
 * validate의 기본 속성을 재정의 한다.
 */
$.validator.defaults.errorElement = "div";
$.validator.defaults.errorClass = "hiddden_txt";
$.validator.defaults.errorPlacement = function(error, element) {
    error.appendTo($(element).parent());
};
$.validator.defaults.ignoreTitle=true;
