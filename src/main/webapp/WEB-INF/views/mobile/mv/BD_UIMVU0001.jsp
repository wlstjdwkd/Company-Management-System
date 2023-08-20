<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>INDEX</title>
<ap:jsTag type="web" items="jquery,tools,ui" />
<ap:jsTag type="tech" items="util,mv" />

<script type="text/javascript">
    $(document).ready(function() {
        //비쥬얼 스크롤 생성
        var visualSwiper = new Swiper('.swiper-container.visualWrap', {
            loop:true,
            onSlideChangeStart: function(swiper){ $('#visualIndicator li').removeClass('on').eq(swiper.activeLoopIndex).addClass('on'); }
        });        
    });     
</script>
</head>
<body>

    <!--// container -->
    <div id="container">
        <div class="top_wrap">
            <div class="top_txt">
                대한민국 <span class="t_blue">기업</span>이,</br><em>미래글로벌 챔피언</em> 입니다!
            </div>
        </div>
        <div class="main_icon">
            <ul class="menu">
                <li>
                  <a href="#" onclick="jsMoveMenu('88','92','PGMV0010')" class="m1_01">
                      <p>기업정의</p>
                  </a>
                </li>
                <li>
                  <a href="#" onclick="jsMoveMenu('88','93','PGMV0020')" class="m1_02">
                      <p>기업범위</p>
                  </a>
                </li>
                <li>
                  <a href="#" onclick="jsMoveMenu('89','94','PGMV0030')" class="m1_03">
                      <p>확인업무안내</p>
                  </a>
                </li>
            </ul>
            <ul class="menu">
                <li>
                  <a href="#" onclick="jsMoveMenu('95','90','PGMV0040')" class="m1_04">
                      <p style="margin-top:55px; line-height:1.2em">성장촉진</br>기본계획</p>
                  </a>
                </li>
                <!-- <li>
                  <a href="#" onclick="jsMoveMenu('96','90','PGMV0050')" class="m1_05">
                      <p>기업시책</p>
                  </a>
                </li> -->
                <li>
                  <a href="#" onclick="jsMoveMenu('97','90','PGMV0060')" class="m1_06">
                      <p>지원사업</p>
                  </a>
                </li>
            </ul>
            <ul class="menu">
                <li>
                  <a href="#" onclick="jsMoveMenu('98','91','PGMV0070')" class="m1_07">
                      <p>공지사항</p>
                  </a>
                </li>
                <li>
                  <a href="#" onclick="jsMoveMenu('99','91','PGMV0080')" class="m1_08">
                      <p>채용정보</p>
                  </a>
                </li>
                <li>
                  <a href="#" onclick="jsMoveMenuURL('','','','http://www.motie.go.kr')" class="m1_09">
                      <p>바로가기</p>
                  </a>
                </li>
            </ul>
        </div>
    </div>
    <!-- container //-->

<script type="text/javascript">	
	$(document).ready(function() {
		var swiper = new Swiper('.swiper-container', {
		    pagination: '.swiper-pagination',		    
		    slidesPerView: 1,
		    paginationClickable: true,
		    spaceBetween: 30,
		    loop: true
		});
	}); 
</script>
</body>
</html>