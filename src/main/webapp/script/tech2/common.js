	

	//메뉴
	$(function(){
			$('.menu .oneD').bind("mouseover focusin", function(){
				$('#header').addClass('on2');
				$(".head, #header ").stop().animate({"height":"334px" , "color":"#000000"}, 300);
			});
			$('.menu').bind("mouseout focusout",function(){
				$(".head, #header").stop().animate({"height":79}, 300, function(){
				$("#header").removeClass("on2");
				});
			});
			var jbOffset = $( '#header' ).offset();
			$( window ).scroll( function() {
			  if ( $( document ).scrollTop() > jbOffset.top ) {
				$( '#header' ).addClass( 'on' );
			  }
			  else {
				$( '#header' ).removeClass( 'on' );
			  }
			});
		})
	$(function(){
	  $(".menu01, .s_menu01").mouseover(function(){
		$(".s_menu01").css("background-color","#f5f9fd");
		$(".menu01").addClass("on");
	  });
	  $(".menu01, .s_menu01").mouseout(function(){
		$(".s_menu01").css("background-color","#fff");
		$(".menu01").removeClass("on");
	  });
	  $(".menu02, .s_menu02").mouseover(function(){
		$(".s_menu02").css("background-color","#f5f9fd");
		$(".menu02").addClass("on");
	  });
	  $(".menu02, .s_menu02").mouseout(function(){
		$(".s_menu02").css("background-color","#fff");
		$(".menu02").removeClass("on");
	  });
	  $(".menu03, .s_menu03").mouseover(function(){
		$(".s_menu03").css("background-color","#f5f9fd");
		$(".menu03").addClass("on");
	  });
	  $(".menu03, .s_menu03").mouseout(function(){
		$(".s_menu03").css("background-color","#fff");
		$(".menu03").removeClass("on");
	  });
	  $(".menu04, .s_menu04").mouseover(function(){
		$(".s_menu04").css("background-color","#f5f9fd");
		$(".menu04").addClass("on");
	  });
	  $(".menu04, .s_menu04").mouseout(function(){
		$(".s_menu04").css("background-color","#fff");
		$(".menu04").removeClass("on");
	  });
	  $(".menu05, .s_menu05").mouseover(function(){
		$(".s_menu05").css("background-color","#f5f9fd");
		$(".menu05").addClass("on");
	  });
	  $(".menu05, .s_menu05").mouseout(function(){
		$(".s_menu05").css("background-color","#fff");
		$(".menu05").removeClass("on");
	  });
	});

	//비주얼
	/*$(function(){
		$(' .bxslider ').bxSlider({
		  auto: true,
		  autoControls: true,
		  stopAutoOnClick: true,
		  pager: true
		});
	});
	$(document).ready(function(){
		$(' .bx-stop ').click(function(){
			$(this).css('display','none');
			$(' .bx-start ').css('display','block');
		});
		$(' .bx-start ').click(function(){
			$(this).css('display','none');
			$(' .bx-stop ').css('display','block');
		});
	});*/

	// 마우스 오버, 포커스
	$(function(){
		$('.cont .sec, .muchuse ul li a ').bind('mouseover focusin', function(){
			$(this).addClass('on');
		});
		$('.cont .sec, .muchuse ul li a').bind('mouseleave focusout', function(){
			$(this).removeClass('on');
		});
		$('.sear_sec ul li .sel .sel_option ul li').bind('mouseover focusin', function(){
			$(this).addClass('on');
		});
		$('.sear_sec ul li .sel .sel_option ul li').bind('mouseleave focusout', function(){
			$(this).removeClass('on');
		});

		$('.list_look .sel .sel_option ul li').bind('mouseover focusin', function(){
			$(this).addClass('on');
		});

		$('.list_look .sel .sel_option ul li').bind('mouseleave focusout', function(){
			$(this).removeClass('on');
		});

		$('.paging.pg_bl ul li').bind('mouseover focusin', function(){
			$(this).addClass('on');
			if($(this).hasClass("prev02") == true) {
				$(this).children().children('img').addClass('on').attr("src","/images2/sub/pg_prev_02_on.png");
			}
			else if($(this).hasClass("prev01") == true) {
				$(this).children().children('img').addClass('on').attr("src","/images2/sub/pg_prev_01_on.png");
			}
			else if($(this).hasClass("next01") == true) {
				$(this).children().children('img').addClass('on').attr("src","/images2/sub/pg_next_01_on.png");
			}
			else if($(this).hasClass("next02") == true) {
				$(this).children().children('img').addClass('on').attr("src","/images2/sub/pg_next_02_on.png");
			}
		});

		$('.paging.pg_bl ul li').bind('mouseleave focusout', function(){
			$(this).removeClass('on');
			if($(this).hasClass("prev02") == true) {
				$(this).children().children('img').removeClass('on').attr("src","/images2/sub/pg_prev_02.png");
			}
			else if($(this).hasClass("prev01") == true) {
				$(this).children().children('img').removeClass('on').attr("src","/images2/sub/pg_prev_01.png");
			}
			else if($(this).hasClass("next01") == true) {
				$(this).children().children('img').removeClass('on').attr("src","/images2/sub/pg_next_01.png");
			}
			else if($(this).hasClass("next02") == true) {
				$(this).children().children('img').removeClass('on').attr("src","/images2/sub/pg_next_02.png");
			}
		});
	});
//푸터 패밀리사이트
$(function(){
	$('.f_btn').click(function(){
		if($('.family_on').css("display") == "none"){
			$('.family_on').show();
			$('.f_btn span').css({"background":"url(/images2/common/f_plus_off.png)", 'background-repeat' : 'no-repeat', 'background-position':'100% 8px'});
		}else{
			$('.family_on').hide();
			$('.f_btn span').css({"background":"url(/images2/common/f_plus_on.png)", 'background-repeat' : 'no-repeat', 'background-position':'100% 2px'});
		}
	});
	$('.family_on button').click(function(){
		$('.family_on').css('display','none');
		$('.f_btn span').css({"background":"url(/images2/common/f_plus_off.png)", 'background-repeat' : 'no-repeat', 'background-position':'100% center'});
	});
});

//셀렉트 박스
$(function(){
	sel_box();
});
	 
function sel_box(){

	$('.sel').click(function(){
		$(this).find('.option').toggle();
		//$('.sear_sec.st_bl01 .sel1 p').toggleClass('on');
		//$('.sear_sec.st_box01 ul .sel1').toggleClass('on');
	})
	
	$('.sel1').click(function(){
		$('.sel1 .option1').toggle();
		$('.sear_sec.st_bl01 .sel1 p').toggleClass('on');
		$('.sear_sec.st_box01 ul .sel1').toggleClass('on');
	})

	$('.sel2').click(function(){
		$('.sel2 .option2').toggle();
		$('.sear_sec.st_bl01 .sel2 p').toggleClass('on');
		$('.sear_sec.st_box01 ul .sel2').toggleClass('on');
	})

	$('.sel3').click(function(){
		$('.sel3 .option3').toggle();
		$('.sear_sec.st_bl01 .sel3 p').toggleClass('on');
		$('.sear_sec.st_box01 ul .sel3').toggleClass('on');
	})

	$('.sel4').click(function(){
		$('.sel4 .option4').toggle();
		$('.sear_sec.st_bl01 .sel4 p').toggleClass('on');
		$('.sear_sec.st_box01 ul .sel4').toggleClass('on');
	})

	$('.sel5').click(function(){
		$('.sel5 .option5').toggle();
		$('.sear_sec.st_bl01 .sel5 p').toggleClass('on');
		$('.sear_sec.st_box01 ul .sel5').toggleClass('on');
	})

	$('.sel6').click(function(){
		$('.sel6 .option6').toggle();
		$('.sear_sec.st_bl01 .sel6 p').toggleClass('on');
		$('.sear_sec.st_box01 ul .sel6').toggleClass('on');
	})

	$('.sel7').click(function(){
		$('.sel7 .option7').toggle();
		$('.sear_sec.st_bl01 .sel7 p').toggleClass('on');
		$('.sear_sec.st_box01 ul .sel7').toggleClass('on');
	})

	$('.sel8').click(function(){
		$('.sel8 .option8').toggle();
		$('.sear_sec.st_bl01 .sel8 p').toggleClass('on');
		$('.sear_sec.st_box01 ul .sel8').toggleClass('on');
	})

	$('.sel9').click(function(){
		$('.sel9 .option9').toggle();
		$('.sear_sec.st_bl01 .sel9 p').toggleClass('on');
		$('.sear_sec.st_box01 ul .sel9').toggleClass('on');
	})
	$('.sel10').click(function(){
		$('.sel10 .option10').toggle();
		$('.sear_sec.st_bl01 .sel10 p').toggleClass('on');
		$('.sear_sec.st_box01 ul .sel10').toggleClass('on');
	})
}
function selectRadio1(value, name)
{
	$("#title_layer1 a").html(name);
}
function selectRadio2(value, name)
{
	$("#title_layer2 a").html(name);
}
function selectRadio3(value, name)
{
	$("#title_layer3 a").html(name);
}
function selectRadio4(value, name)
{
	$("#title_layer4 a").html(name);
}
function selectRadio5(value, name)
{
	$("#title_layer5 a").html(name);
}
function selectRadio6(value, name)
{
	$("#title_layer6 a").html(name);
}
function selectRadio7(value, name)
{
	$("#title_layer7 a").html(name);
}
function selectRadio8(value, name)
{
	$("#title_layer8 a").html(name);
}
function selectRadio9(value, name)
{
	$("#title_layer9 a").html(name);
}
function selectRadio10(value, name)
{
	$("#title_layer10 a").html(name);
}
function selectRadio11(value, name)
{
	$("#title_layer11 a").html(name);
}
function selectRadio12(value, name)
{
	$("#title_layer12 a").html(name);
}
function selectRadio13(value, name)
{
	$("#title_layer13 a").html(name);
}
function selectRadio14(value, name)
{
	$("#title_layer14 a").html(name);
}
function selectRadio15(value, name)
{
	$("#title_layer15 a").html(name);
}
function selectRadio16(value, name)
{
	$("#title_layer16 a").html(name);
}
function selectRadio17(value, name)
{
	$("#title_layer17 a").html(name);
}

/* 트리구조형 리스트*/
$(function(){
var toggler = document.getElementsByClassName("caret");
var i;



for (i = 0; i < toggler.length; i++) {
  toggler[i].addEventListener("click", function() {
	this.parentElement.querySelector(".nested").classList.toggle("on");
	this.classList.toggle("caret-down");
	
  });
}
});

$(function(){
	var tagName = $('.caret').closest('li');
	console.log(tagName);
});
$(function(){
	$('.caret').parent().css('background', 'none');
});

/* 아코디언 리스트 */
$(function(){
var acc = document.getElementsByClassName("acc_tit");
var i;

for (i = 0; i < acc.length; i++) {
  acc[i].addEventListener("click", function() {
    this.classList.toggle("active");
    var panel = this.nextElementSibling;
    if (panel.style.maxHeight){
      panel.style.maxHeight = null;
    } else {
      panel.style.maxHeight = panel.scrollHeight + "px";
    } 
  });
}
});

/* input file */
$(document).ready(function(){
	var fileTarget = $('.filebox .upload-hidden');

	fileTarget.on('change', function(){ // 값이 변경되면

		if(window.FileReader){ // modern browser
			var filename = $(this)[0].files[0].name;
		}
		else { // old IE
			var filename = $(this).val().split('/').pop().split('\\').pop(); // 파일명만 추출
		}

		// 추출한 파일명 삽입
		$(this).siblings('.upload-name').val(filename);
	});

	$('.addFilebtn').click(function(){
		addRow();

		var length = $(".filebox01").length;

		if($(".filebox01").length == 5){
			$('.addFilebtn').off('click');
		}
	})


});

$(document).ready(function(){
	$('.s_cont02_05 .relay_company .add_company .relay_comBtn').click(function(){
		$('.s_cont02_05 .relay_company .company_wrap').show();
	});

	$('.s_cont02_05 .relay_company .company_wrap .relay_comBtn').click(function(){
		$('.s_cont02_05 .relay_company .company_wrap').hide();
	});

	$('.table_close').click(function(){
		$(this).parent().parent().find('.table_wrap').slideToggle(function(){
			if ($(this).is(':visible')) {
				$(this).parent().find('.fram_bl .table_close').text('닫기');
				$(this).parent().find('.fram_bl .table_close').removeClass('open')
			} else {
				$(this).parent().find('.fram_bl .table_close').text('열기') ;
				$(this).parent().find('.fram_bl .table_close').addClass('open')
			} 
		});
		
	});
});

//서브좌측메뉴_lnb
function lnb(){
	$(".lnb li").click(function(){	
		var $this = jQuery(this);
      	$this.parent("ul").children("li").removeClass("on");
      	$this.addClass("on");
		if($("+.lnb_menu2",this).css("display")=="none"){
			$(".lnb_menu2").slideUp("slow");
			$("+.lnb_menu2",this).slideDown("slow");
		}
		$(this).parent('ul').siblings('li').removeClass('on');
	});
	
	var $lnb_zone = jQuery(".lnb_zone");
	$(".lnb_menu2").css("display","none");
	
	//var cMenuNo = $('#df_menu_no').val();
	var cMenuNo = $('#disp_menu_no').val();	
	
	var dt = $('ul.lnb>li').filter('#'+cMenuNo);
	if(!Util.isEmpty(dt[0])){
		dt.addClass('on');
		dt.next('dd.lnb_menu2').css("display","block");
		return;
	}	
	
	var dts = $('ul.lnb>li');
	for(var i=0;i<dts.length;i++){
		var dt = $(dts[i]);
		var dd = dt.next();
		var li = dd.find('ul>li').filter('#'+cMenuNo);
		if(!Util.isEmpty(li[0])){
			dt.addClass('on');
			dt.next('dd.lnb_menu2').css("display","block");
			return;
		}
	}
	
	var dt = $('ul.lnb>li:first');
	dt.addClass('on');
	dt.next('li.lnb_menu2').css("display","block");

}


$(document).ready(function () {	
	var nolnb = document.getElementById('no_lnb');
	if(Util.isEmpty(nolnb)){
		// lnb
		lnb();
	}
});