<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>INDEX</title>
    <style>

	</style>
	<ap:jsTag type="web" items="jquery,blockUI,colorbox,cookie,flot,form,jqGrid,mutifile,notice,selectbox,timer,tools,ui,validate,mask,multiselect" />
	<ap:jsTag type="tech" items="msg,util" />
   <script type="text/javascript" src="https://www.google.com/jsapi"></script>
   <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
    <script>
   
    
    google.load( 'visualization', '1', { packages:['corechart'] });

    function ChartMarker( options ) {
        this.setValues( options );
        
        this.$inner = $('<div>').css({
            position: 'relative',
            left: '-50%', top: '-50%',
            width: options.width,
            height: options.height,
            fontSize: '1px',
            lineHeight: '1px',
            backgroundColor: 'transparent',
            cursor: 'default'
        });

        this.$div = $('<div>')
            .append( this.$inner )
            .css({
                position: 'absolute',
                display: 'none',
                width:options.width,
                height:options.height
            });
    };

    ChartMarker.prototype = new google.maps.OverlayView;

    ChartMarker.prototype.onAdd = function() {
        $( this.getPanes().overlayMouseTarget ).append( this.$div );
    };

    ChartMarker.prototype.onRemove = function() {
        this.$div.remove();
    };

    ChartMarker.prototype.draw = function() {
        var marker = this;        
        var projection = this.getProjection();        
        var position = projection.fromLatLngToDivPixel( this.get('position') );

        this.$div.css({
            left: position.x,
            top: position.y,
            display: 'block'
        })
        
        var placeholder = this.$inner; 
        $.plot(placeholder, this.get('chartData'), {
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
    	
    };

    function initialize() {
        var latLng = new google.maps.LatLng(37.569182, 126.990237);

        var map = new google.maps.Map( $('#map_canvas')[0], {
            zoom: 5,
            center: latLng,
            mapTypeId: google.maps.MapTypeId.HYBRID
        });
        
        var data = [
             		{ label: "Series1",  data: 10},
             		{ label: "Series2",  data: 30},
             		{ label: "Series3",  data: 90},
             		{ label: "Series4",  data: 70},
             		{ label: "Series5",  data: 80},
             		{ label: "Series6",  data: 110}
             	];
        
        var marker = new ChartMarker({
            map: map,
            position: new google.maps.LatLng(37.569182, 126.990237),
            width: '200px',
            height: '200px',
            chartData: data
        });        

    };

    $( initialize );

    </script>
  </head>
  <body>
    <div id="map_canvas" style="height: 700px; width: 800px"></div>
  </body>
</html>