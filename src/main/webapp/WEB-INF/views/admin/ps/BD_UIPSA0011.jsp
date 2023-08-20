<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<title>기업종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form, flot" />
<ap:jsTag type="tech" items="util,acm,ps" />	

<script type="text/javascript">

function ck(divNum){
	var divNum = divNum;
	var form = document.all;
	
	for(num=0; num < form.div1.length; num++){
		if(num==divNum){
			form.div1[num].style.display='block';
		}else{
			form.div1[num].style.display='none';
		}
	}
}

$(document).ready(function() {
	$("#gnb > li").click(function() {
		//alert($(this).attr("id"));
		$("#gnb > li").removeClass("on");
		$(this).addClass("on");
	});	
	
	if(${resultInfo.ENTRPRS_OTHBC_STLE == 'KS' or resultInfo.ENTRPRS_OTHBC_STLE == 'KQ' or resultInfo.ENTRPRS_OTHBC_STLE == 'KN'}){
	// 주가정보
	setStkData();
	}
		
	// 주요재무정보
	setMainData_1();
	setMainData_2();
	setMainData_3();
	// 주요 통계 지표 툴팁 
	$("#placeholder_1").UseTooltip(1);
	$("#placeholder_2").UseTooltip(1);
	$("#placeholder_3").UseTooltip(2);
	$("#placeholder_4").UseTooltip(2);
	$("#placeholder_5").UseTooltip(2);
	$("#placeholder_6").UseTooltip(2);
});

//주요재무정보1 시작
function setMainData_1() {

	 var assetsDatas = [];					//자산총계
	 var debtDatas = [];						//부채총계
	 var caplSmDatas =[];					//자본총계
	
	var ad_stdyy = document.getElementsByName("ad_stdyy");
	var ad_assetsSm = document.getElementsByName("ad_assetsSm");
	var ad_debt = document.getElementsByName("ad_debt");
	var ad_caplSm = document.getElementsByName("ad_caplSm");
	
	for( var i = 0; i < ${fn:length(entResultInfoData)}; i++) {
		
		assetsDatas.push([ad_stdyy[i].value, ad_assetsSm[i].value]);
		debtDatas.push([ad_stdyy[i].value, ad_debt[i].value]);
		caplSmDatas.push([ad_stdyy[i].value, ad_caplSm[i].value]);
	}
	
	
	var data = [];
		
	// chart
    var options = {
    	lines: {
    		show: true
    	},
    	points: {
    		show: true
    	}, 
    	legend : {
			show : false,
			backgroundColor: null,
			backgroundOpacity: 0
		},   		  		
    	xaxis: {
    		tickDecimals: 0,
    		tickSize: 1    		
    	}, 
    	valueLabels : {
			show : true
		},
    	grid: {
    		hoverable: true, 
			clickable: false, 
			mouseActiveRadius: 30,
			borderWidth : 0.2
    	},
    	yaxis: {
			tickFormatter : function numberWithCommas(x) {
				return x.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
			}
    	}
    };
	
    var series1 = {
    	label: "자산총계",
        data: assetsDatas,
        color : "#ffb200"
    };
    var series2 = {
    	label: "부채총계",
        data: debtDatas,
        color : "#fd3303"
    };
    var series3 = {
    	label: "자본총계",
        data: caplSmDatas,
        color : "#69077e"
    };
 
    data.push(series1);
    data.push(series2);
    data.push(series3);
    
	if(${existChartData}) {
    	$.plot("#placeholder_1", data, options);
	}
    
}
// 주요재무정보_1 끝



// 주요재무정보2 시작
function setMainData_2() {

	 var selngDatas = [];					//매출액
	 var bsnProfitDatas = [];				//영업이익
	 var thstrmNtpfDatas =[];				//당기순이익
	
	var ad_stdyy1 = document.getElementsByName("ad_stdyy");
	var ad_selngAm = document.getElementsByName("ad_selngAm");
	var ad_bsnProfit = document.getElementsByName("ad_bsnProfit");
	var ad_thstrmNtpf = document.getElementsByName("ad_thstrmNtpf");
	
	for( var i = 0; i < ${fn:length(entResultInfoData)}; i++) {
		selngDatas.push([ad_stdyy1[i].value, ad_selngAm[i].value]);
		bsnProfitDatas.push([ad_stdyy1[i].value, ad_bsnProfit[i].value]);
		thstrmNtpfDatas.push([ad_stdyy1[i].value, ad_thstrmNtpf[i].value]);
	}
	
	var data = [];
		
	// chart
    var options = {
    	lines: {
    		show: true
    	},
    	points: {
    		show: true
    	}, 
    	legend : {
			show : false,
			position: "ne",
			backgroundColor: null,
			backgroundOpacity: 0
		},   		
    	xaxis: {
    		tickDecimals: 0,
    		tickSize: 1    		
    	}, 
    	valueLabels : {
			show : true
		},
    	grid: {
    		hoverable : true,
			margin: 10,
			clickable: false, 
			mouseActiveRadius: 30,
			borderWidth : 0.2
    	},
    	yaxis: {
			tickFormatter : function numberWithCommas(x) {
				return x.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
			}
    	}
    };
	
    var series1 = {
    	"label": "매출액",
        "data": selngDatas,
        color : "#ffb200"
    };
    var series2 = {
    	"label": "영업이익",
        "data": bsnProfitDatas,
        color : "#fd3303"
    };
    var series3 = {
    	"label": "당기순이익",
        "data": thstrmNtpfDatas,
        color : "#69077e"
    };
 
    data.push(series1);
    data.push(series2);
    data.push(series3);
    
	if(${existChartData}) {
    	$.plot("#placeholder_2", data, options);
	}
    
}
//주요재무정보_2 끝

 // 주요재무정보_3 시작
function setMainData_3() {
	var ticks1 = [[0, "매출액"], [1, "영업이익"], [2, "당기순이익"]];
	var ticks2 = [[0, "고용"], [1, "R&D집약도"]];
	var ticks3 = [[1, "R&D집약도"]];
	
	var flotOption1 = {
			
		series: {
            bars: {
                show: true,
                barWidth: 0.13,
                order: 1
            }
        },
        valueLabels: {
            show: true
        },
        xaxis: {
        	ticks: ticks1,
        	autoscaleMargin:0.1
       	},
       	yaxis: {
       	    
       	},
        legend : {
			show : false
        },
       	grid : {
       		hoverable: true, 
			clickable: false, 
			mouseActiveRadius: 30,
			borderWidth : 0.2
		},
	};
	
	var flotOption2 = {
			
		series: {
            bars: {
                show: true,
                barWidth: 0.13,
                order: 1
            }
        },
        valueLabels: {
            show: true
        },
        xaxis: {
        	ticks: ticks2,
        	autoscaleMargin:0.1
       	},
       	yaxes: [
	{
				
			  },
	{
				 position: "right"			    
			  }],
        legend : {
			show : false
        },
       	grid : {
       		hoverable: true, 
			clickable: false, 
			mouseActiveRadius: 30,
			borderWidth : 0.2
		},
	};
	
	// 매출액, 영업이익, 당기순이익
    var chData1_1 = [[0,${stsEntcls[0].SELNG_AM}],[1,${stsEntcls[0].BSN_PROFIT}],[2,${stsEntcls[0].THSTRM_NTPF}]];	// 기업
    var chData1_2 = [[0,${stsEntcls[1].SELNG_AM}],[1,${stsEntcls[1].BSN_PROFIT}],[2,${stsEntcls[1].THSTRM_NTPF}]];	// 업종 
    var chData1_3 = [[0,${stsEntcls[2].SELNG_AM}],[1,${stsEntcls[2].BSN_PROFIT}],[2,${stsEntcls[2].THSTRM_NTPF}]];	// 전산업
    var chData1_4 = [[0,${upperCmpnAvg.SELNG_AM}],[1,${upperCmpnAvg.BSN_PROFIT}],[2,${upperCmpnAvg.THSTRM_NTPF}]];	// 상위5개업체
    
    // 고용
    var chData2_1 = [[0,${stsEntcls[0].ORDTM_LABRR_CO}]];	// 기업
    var chData2_2 = [[0,${stsEntcls[1].ORDTM_LABRR_CO}]];	// 업종
    var chData2_3 = [[0,${stsEntcls[2].ORDTM_LABRR_CO}]];	// 전산업
    var chData2_4 = [[0,${upperCmpnAvg.ORDTM_LABRR_CO}]];	// 상위5개업체
    
    // R&D집약도
    var chData3_1 = [[1,${stsEntcls[0].RND_CCTRR}]];	// 기업
    var chData3_2 = [[1,${stsEntcls[1].RND_CCTRR}]];	// 업종
    var chData3_3 = [[1,${stsEntcls[2].RND_CCTRR}]];	// 전산업
    var chData3_4 = [[1,${upperCmpnAvg.RND_CCTRR}]];	// 상위5개업체

    var flot1_data = [
        {
            label: "${entprsInfo.ENTRPRS_NM }",
            color : "#91017c",
            bars: {
				barWidth : 0.1,
        		show : true,
				order : 1,
				fillColor : "#91017c"
        	},
            data: chData1_1
        },
        {
            label: "동종업종",
            color: "#ffb200",
            bars: {
				barWidth : 0.1,
        		show : true,
				order : 2,
				fillColor : "#ffb200"
        	},
            data: chData1_2
        },
        {
            label: "전산업",
            color : "#75bc2e",
            bars: {
				barWidth : 0.1,
        		show : true,
				order : 3,
				fillColor : "#75bc2e"
        	},
            data: chData1_3
        }
    ];
    
    var flot2_data = [
       {
           label: "${entprsInfo.ENTRPRS_NM }",
           color : "#91017c",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 1,
			fillColor : "#91017c"
       		},
           data: chData2_1
       },
       {
           label: "동종업종",
           color: "#ffb200",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 2,
			fillColor : "#ffb200"
       	},
           data: chData2_2
       },
       {
           label: "전산업",
           color : "#75bc2e",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 3,
			fillColor : "#75bc2e"
       	},
           data: chData2_3
       },
       {
           label: "${entprsInfo.ENTRPRS_NM }",
           color : "#91017c",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 1,
			fillColor : "#91017c"
       		},
       	   yaxis: 2,
           data: chData3_1
       },
       {
           label: "동종업종",
           color: "#ffb200",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 2,
			fillColor : "#ffb200"
       		},
       	   yaxis: 2,
           data: chData3_2
       },
       {
           label: "전산업",
           color : "#75bc2e",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 3,
			fillColor : "#75bc2e"
       		},
       	   yaxis: 2,
           data: chData3_3
       }
    ];
    
    var flot3_data = [
        {
            label: "${entprsInfo.ENTRPRS_NM }",
            color : "#91017c",
            bars: {
				barWidth : 0.1,
        		show : true,
				order : 1,
				fillColor : "#91017c"
        	},
            data: chData1_1
        },
        {
            label: "동종업종 상위5개기업",
            color: "#ffb200",
            bars: {
				barWidth : 0.1,
        		show : true,
				order : 2,
				fillColor : "#ffb200"
        	},
            data: chData1_4
        }
    ];
    
    var flot4_data = [
       {
           label: "${entprsInfo.ENTRPRS_NM }",
           color : "#91017c",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 1,
			fillColor : "#91017c"
       		},
           data: chData2_1
       },
       {
           label: "동종업종 상위5개기업",
           color: "#ffb200",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 2,
			fillColor : "#ffb200"
       	},
           data: chData2_4
       },       
       {
           label: "${entprsInfo.ENTRPRS_NM }",
           color : "#91017c",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 1,
			fillColor : "#91017c"
       		},
       	   yaxis: 2,
           data: chData3_1
       },
       {
           label: "동종업종 상위5개기업",
           color: "#ffb200",
           bars: {
			barWidth : 0.1,
       		show : true,
			order : 2,
			fillColor : "#ffb200"
       		},
       	   yaxis: 2,
           data: chData3_4
       }       
    ];

    $.plot($("#placeholder_3"), flot1_data, flotOption1);
    $.plot($("#placeholder_4"), flot2_data, flotOption2);
    $.plot($("#placeholder_5"), flot3_data, flotOption1);
    $.plot($("#placeholder_6"), flot4_data, flotOption2);
    
}
// 주요재무정보_3 끝 

// 툴팁
$.fn.UseTooltip = function (num) {
    var previousPoint = null;
     
    $(this).bind("plothover", function (event, pos, item) {         
        if (item) { 
        	if (previousPoint != item.datapoint) {
				previousPoint = item.datapoint;
				$("#tooltip").remove();
				var x = item.datapoint[0], y = item.datapoint[1];
				
				if(num == 1) {
					showTooltip(item.pageX, item.pageY, x+ "년 " + y + "("+ item.series.label + ")");
				}
				else {
					if(pos.pageX > 900) {
						item.pageX = item.pageX - 50;
					}
					showTooltip(item.pageX, item.pageY, y + "("+ item.series.label + ")");
				}
			}
		} else {
			$("#tooltip").remove();
			previousPoint = null;
		}
    });
}

$.fn.useTooltip1 = function () {
    var previousPoint = null;
     
    $(this).bind("plothover", function (event, pos, item) {        
        if (item) {
			if (previousPoint != item.datapoint) {
				previousPoint = item.datapoint;
				$("#tooltip").remove();

				var x = item.datapoint[0], y = item.datapoint[1];
				if(pos.pageX > 900) {
					item.pageX = item.pageX - 50;
				}
				showTooltip(item.pageX, item.pageY, y + "("+ item.series.label + ")");
			}
		} else {
			$("#tooltip").remove();
			previousPoint = null;
		}
    });
    
}
// 주가정보
function setStkData() {
	var ticks1 = [];
	var x_data = [];
	var ad_std = document.getElementsByName("ad_std");
	var ad_stkPc = document.getElementsByName("ad_stkPc");
	for( var i = 0; i < ${fn:length(stkResultInfo)}; i++) {
		x_data.push([i, ad_std[i].value]);
		ticks1.push([i, ad_stkPc[i].value]);
	}
	
	var options = {
			lines : {
				show : true,
				lineWidth : 0.5
			}, series : {
				lines: { show: false, fill: false, fillColor: "#fd3303" },
		        points: { show: false, fill: false },
				shadowSize : 1
			}, points : {
				show : true
			}, xaxis : {
				autoscaleMargin :0,
				ticks : x_data,
			}, yaxis: {
				tickFormatter : function numberWithCommas(x) {
					return x.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
				}
			},legend : {
				show : false
			}, grid : {
				hoverable : true,
				margin: 50,
				labelMargin: 50,
				borderWidth : 0.1
			}, valueLabels : {
				show : true
			}, 
		};
	
	// 주요 통계 지표 데이터 입력
	var data = [ {
		label : "주가정보",
		data : ticks1,
		lines: {
			lineWidth :3,
    		show: true,
    		order : 1
    	}, point : {
    		show: true
    	}, 
		color : "#fd3303"
	}]
	
	$.plot("#placeholder1", data, options);

	// 주요 통계 지표 툴팁 
	$("#placeholder1").bind("plothover", function(event, pos, item) {
				if (item) { if (previousPoint != item.datapoint) {
						previousPoint = item.datapoint;
						$("#tooltip").remove();
						var x = item.datapoint[0], y = item.datapoint[1];

						showTooltip(item.pageX, item.pageY,  "<b>" + item.series.label + "</b><br />" +  y);
					}
				} else {
			$("#tooltip").remove();
			previousPoint = null;
		}
	});
}
// 주가정보끝


//툴팁 이벤트
function showTooltip(x, y, contents) {
	$('<div id = "tooltip" style = "z-index: 999;">' +contents +' </div>').css( {
        position: 'absolute',
        display: 'none',
        top: y  - 40,
        left: x ,
        border: '1px solid #fdd',
        padding: '2px',
        'background-color': '#fee',
        opacity: 0.80,
    }).appendTo("body").show();
}

</script>
 
</head>
<body>
<div id="header">
    <!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title">기업검색 – 상세정보 > 개황및재무</h2>
                <!-- 타이틀 영역 //-->
                <!--<div class="btn_page_first">  <a class="btn_page_admin" href="#"><span>엑셀다운로드</span></a> </div> -->
                <!--// 조회 조건 -->
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="기업전체 정보(개황, 재무정보, 수출정보 등) 를 한개의 Excel 파일로 다운로드를 할수 있는 표" >
                        <caption>
                        기업개황
                        </caption>
                        <colgroup>
                        <col width="20%" />
                        <col width="30%" />
                        <col width="20%" />
                        <col width="30%" />
                        </colgroup>
                        <tr>    
                            <th scope="row">기업군</th>
                            <td>
                            	<c:choose>
                            	<c:when test="${resultInfo.ENTRGROUP_CD eq 'EA1'}">전체중견</c:when>
                            	<c:when test="${resultInfo.ENTRGROUP_CD eq 'EA2'}">일반중견</c:when>
                            	<c:when test="${resultInfo.ENTRGROUP_CD eq 'EA3'}">관계기업</c:when>
                            	<c:when test="${resultInfo.ENTRGROUP_CD eq 'EA4'}">후보기업</c:when>
                            	<c:when test="${resultInfo.ENTRGROUP_CD eq 'EA5'}">가젤형기업</c:when>
                            	</c:choose>
                            </td>
                            <th scope="row">판정사유</th>
                            <td>${resultInfo.ENTRGROUP_RESN}</td>
                        </tr>
                        <tr>
                            <th scope="row">기업명</th>
                            <td>${resultInfo.ENTRPRS_NM}</td>
                            <th scope="row">자료 기준년도</th>
                            <td>${resultInfo.STDYY}</td>
                        </tr>
                        <tr>
                            <th scope="row">사업자번호</th>
                            <td>${resultInfo.BIZRNO_FMT}</td>
                            <th scope="row">법인번호</th>
                            <td>${resultInfo.JURIRNO_FMT}</td>
                        </tr>
                        <tr>
                            <th scope="row">주소</th>
                            <td>${resultInfo.HEDOFC_ADRES}</td>
                            <th scope="row">전화번호</th>
                            <td>${resultInfo.REPRSNT_TLPHON}</td>
                        </tr>
                        <tr>
                            <th scope="row">기업형태</th>
                            <td>${resultInfo.ENTRPRS_OTHBC_STLE_NM}</td>
                            <th scope="row">대표자명</th>
                            <td>${resultInfo.RPRSNTV_NM}</td>
                        </tr>
                        <tr>
                            <th scope="row">설립일자</th>
                            <td>${resultInfo.FOND_DE}</td>
                            <th scope="row">휴폐업여부(일자)</th>
                            <td>${resultInfo.SPCSS_DE}</td>
                        </tr>
                        <tr>
                            <th scope="row">결산일</th>
                            <td>${resultInfo.PSACNT}</td>
                            <th scope="row">상장일</th>
                            <td>${resultInfo.LST_DE}</td>
                        </tr>
                        <tr>
                            <th scope="row">소속그룹</th>
                            <td>${resultInfo.PSITN_GROUP}</td>
                            <th scope="row">업종명</th>
                            <td>${resultInfo.INDUTY_NM}</td>
                        </tr>
                        <tr>
                            <th scope="row">기업특성</th>
                            <td>${resultInfo.ENTPRS_S}</td>
                            <th scope="row">주생산품</th>
                            <td>${resultInfo.MAIN_PRODUCT}</td>
                        </tr>
                    </table>
                </div>
                <!--// tab -->
                <div class="tabwrap">
                    <div class="tab">
                        <ul id="gnb">
                            <li class="on" onclick="ck('0')">주요재무정보</li><li onclick="ck('1')">재무정보</li><!-- <li onclick="ck('2')">수출정보</li> --><li onclick="ck('3')">특허정보</li><li onclick="ck('4')">출자/피출자</li><li onclick="ck('5')">거래처정보</li><li onclick="ck('6')">판정정보</li><c:if test="${resultInfo.ENTRPRS_OTHBC_STLE == 'KS' or resultInfo.ENTRPRS_OTHBC_STLE == 'KQ' or resultInfo.ENTRPRS_OTHBC_STLE == 'KN'}"><li onclick="ck('7')">주가정보</li></c:if>
                        </ul>
                    </div>
                    <div id="div1" class="tabcon" style="display: block;">                    	
                    	<ap:include page="../admin/ps/BD_UIPSA0011_INFO_INCLUDE.jsp"/>
                    </div>
                    <div id="div1" class="tabcon" style="display: none;">                    	
                    	<ap:include page="../admin/ps/BD_UIPSA0011_FNNR_INCLUDE.jsp"/>
                    </div>
                    <div id="div1" class="tabcon" style="display: none;">
                        <ap:include page="../admin/ps/BD_UIPSA0011_XPORT_INCLUDE.jsp"/>
                    </div>
                    <div id="div1" class="tabcon" style="display: none;">
                        <ap:include page="../admin/ps/BD_UIPSA0011_PATENT_INCLUDE.jsp"/>
                    </div>
                    <div id="div1" class="tabcon" style="display: none;">
                        <ap:include page="../admin/ps/BD_UIPSA0011_INVSTMNT_INCLUDE.jsp"/>
                    </div>
                    <div id="div1" class="tabcon" style="display: none;">
                        <ap:include page="../admin/ps/BD_UIPSA0011_BCNC_INCLUDE.jsp"/>
                    </div>
                    <div id="div1" class="tabcon" style="display: none;">
                        <ap:include page="../admin/ps/BD_UIPSA0011_JDGMNT_INCLUDE.jsp"/>
                    </div>            
                    <c:if test="${resultInfo.ENTRPRS_OTHBC_STLE == 'KS' or resultInfo.ENTRPRS_OTHBC_STLE == 'KQ' or resultInfo.ENTRPRS_OTHBC_STLE == 'KN'}">
                    <div id="div1" class="tabcon" style="display: none;">
                    	<ap:include page="../admin/ps/BD_UIPSA0011_STK_INCLUDE.jsp"/>
                    </div>
                    </c:if> 
                </div>
                <!--tab //-->
            </div>
        </div>
    </div>
    <!--content//-->
</div>
</body>
</html>