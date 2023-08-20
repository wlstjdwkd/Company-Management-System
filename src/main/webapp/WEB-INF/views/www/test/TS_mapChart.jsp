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
                display: 'none'
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

        this.$inner
            .html( '<img src="' + this.get('image') + '"/>' )
            .click( function( event ) {
                var events = marker.get('events');
                events && events.click( event );
            });
            
        this.chart = new google.visualization.BarChart( this.$inner[0] );
        this.chart.draw( this.get('chartData'), this.get('chartOptions') );
    };

    function initialize() {
        var latLng = new google.maps.LatLng(37.569182, 126.990237);

        var map = new google.maps.Map( $('#map_canvas')[0], {
            zoom: 15,
            center: latLng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        });
        
        var data = google.visualization.arrayToDataTable([
          ['Year', 'Sales', 'Expenses'],
          ['2004',  1000,      400],
          ['2005',  1170,      460],
          ['2006',  660,       1120],
          ['2007',  1030,      540]
        ]);
     
        var options = {
          title: 'Company Performance',
          vAxis: {title: 'Year',  titleTextStyle: {color: 'red'}}
        };
        
        var marker = new ChartMarker({
            map: map,
            position: new google.maps.LatLng(37.569182, 126.990237),
            width: '80px',
            height: '80px',
            chartData: data,
            chartOptions: options,
            events: {
                click: function( event ) {

                }
            }
        });        

    };

    $( initialize );

    </script>
  </head>
  <body>
    <div id="map_canvas" style="height: 700px; width: 800px"></div>
  </body>
</html>