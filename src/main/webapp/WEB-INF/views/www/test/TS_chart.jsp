<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>INDEX</title>

<style type="text/css">
* {	padding: 0; margin: 0; vertical-align: top; }

.demo-container {
		position: absolut;
		width: 200px;
		height: 200px;	
}
#chart01 {
	width: 100px;
	height: 100px;
	font-size: 14px;
}
#chart02 {
	width: 100px;
	height: 100px;
	font-size: 14px;
}


</style>
	
<ap:jsTag type="web" items="jquery,blockUI,colorbox,cookie,flot,form,jqGrid,mutifile,notice,selectbox,timer,tools,ui,validate,mask,multiselect" />
<ap:jsTag type="tech" items="msg,util" />
<script type="text/javascript">
$(function() {

 	var data = [
     		{ label: "Series1",  data: 10},
     		{ label: "Series2",  data: 30},
     		{ label: "Series3",  data: 90},
     		{ label: "Series4",  data: 70},
     		{ label: "Series5",  data: 80},
     		{ label: "Series6",  data: 110}
     	];

	var chart01 = $("#chart01");	
	$.plot(chart01, data, {
		series: {
			pie: { 
				show: true,
				radius: 'auto',
				stroke: {
					color: '#FFF',
					width: 1
				},
				label: {
					show: true,
					formatter: function(label, slice){
						return '<div style="font-size:15px;text-align:center;padding:2px;color:'+slice.color+';">'+Math.round(slice.percent)+'%</div>';
					},
					radius: 1,
					background: {
						color: null,
						opacity: 0
					},
					threshold: 0
				},
			}	
		},		
		legend:{
			show:false			
		}
	});
	
	
	
	var chart02 = $("#chart02");	
	$.plot(chart02, data, {
		series: {
			pie: { 
				show: true,
				radius: 'auto',
				stroke: {
					color: '#FFF',
					width: 1
				},
				label: {
					show: true,
					formatter: function(label, slice){
						return '<div style="font-size:15px;text-align:center;padding:2px;color:#FFF;">'+Math.round(slice.percent)+'%</div>';
					},
					radius: 1,
					background: {
						color: null,
						opacity: 0
					},
					threshold: 0
				},
			}	
		},		
		legend:{
			show:false			
		}
	});
});

</script>
</head>
<body>	
	
	
	<div id="content">
		<div id="map" style="width:900px; height:900px; background:url('/images/ts/krmap.gif') no-repeat; border:solid red 1px;">
			<div id="chart01" class="demo-placeholder" style="border:0px solid red;position:relative;left:100px;top:50px;"></div>
			<div id="chart02" class="demo-placeholder" style="border:0px solid red;position:relative;left:100px;top:200px;"></div>
		</div>
	</div>
	
</body>
</html>