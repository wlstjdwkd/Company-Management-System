<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>INDEX</title>
    <style>
      html, body, #map-canvas {
        height: 100%;
        margin: 0px;
        padding: 0px
      }
    </style>
	<style type="text/css">
	* {	padding: 0; margin: 0; vertical-align: top; }
	
	.demo-container {
		position: absolut;
		width: 200px;
		height: 200px;	
	}
	
	#placeholder {
		width: 200px;
		height: 200px;
		font-size: 14px;
	}
	</style>
	<ap:jsTag type="web" items="jquery,blockUI,colorbox,cookie,flot,form,jqGrid,mutifile,notice,selectbox,timer,tools,ui,validate,mask,multiselect" />
	<ap:jsTag type="tech" items="msg,util" />
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp"></script>
    <script>
   
    
function pieChart(){
	 var data = [
	         		{ label: "Series1",  data: 10},
	         		{ label: "Series2",  data: 30},
	         		{ label: "Series3",  data: 90},
	         		{ label: "Series4",  data: 70},
	         		{ label: "Series5",  data: 80},
	         		{ label: "Series6",  data: 110}
	         	];
	var placeholder = $("#placeholder");	
	$.plot(placeholder, data, {
		series: {
			pie: { 
				show: true
			}
		},
		grid: {
			hoverable: true,
			clickable: true
		},
		legend:{
			show:false
		}
	});
	placeholder.bind("plothover", function(event, pos, obj) {
		if (!obj) {
			return;
		}
		var percent = parseFloat(obj.series.percent).toFixed(2);
		$("#hover").html("<span style='font-weight:bold; color:" + obj.series.color + "'>" + obj.series.label + " (" + percent + "%)</span>");
	});
	placeholder.bind("plotclick", function(event, pos, obj) {

		if (!obj) {
			return;
		}

		percent = parseFloat(obj.series.percent).toFixed(2);
		alert(""  + obj.series.label + ": " + percent + "%");
	});	
}

function initialize() {
  var mapOptions = {
    zoom: 8,
    center: new google.maps.LatLng(37.572175, 126.975474)
  };

  var map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);
  
  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(37.572175, 126.975474),
    map: map,
    title: 'Click to zoom'
  });
	
  var infowindow = new google.maps.InfoWindow({
     content: "<div id='content'><div class='demo-container'><div id='placeholder' class='demo-placeholder'>hihihihi</div></div></div>",
     maxWidth: 300
  });

  google.maps.event.addListener(marker, 'click', function(event) {    
    infowindow.open(map, marker);
    pieChart();
    
  });
}

google.maps.event.addDomListener(window, 'load', initialize);

    </script>
  </head>
  <body>
    <div id="map-canvas"></div>
  </body>
</html>