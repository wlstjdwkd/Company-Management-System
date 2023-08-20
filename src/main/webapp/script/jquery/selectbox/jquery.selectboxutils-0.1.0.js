/**
 * selectbox-utils for jQuery
 * 
 * Copyright (c) 2007 Yoshiomi KURISU
 * Licensed under the MIT (MIT-LICENSE.txt)  licenses.
 *  
 * @example  $('#year1').numericOptions({from:2007,to:2011});
 * @example  $('#year1').numericOptions({from:2007,to:2011,sort:"desc"});
 * @example  $('#month1').numericOptions({from:1,to:12});
 * @example  $('#date1').numericOptions().datePulldown({year:$('#year1'),month:$('#month1')});
 * @example  $('#date1').numericOptions().datePulldownCst({month:$('#month1')});
 */
(function() {  
	$.fn.numericOptions = function(settings){
		settings = jQuery.extend({
			remove:true
			,from:1
			,to:31
			,selectedIndex:0
			,valuePadding:0
			,namePadding:0
			,sort:"asc"
		},settings);
		//error check
		if(!(settings.from+'').match(/^\d+$/)||!(settings.to+'').match(/^\d+$/)||!(settings.selectedIndex+'').match(/^\d+$/)||!(settings.valuePadding+'').match(/^\d+$/)||!(settings.namePadding+'').match(/^\d+$/)) return;
		if(settings.from > settings.to) return;
		if(settings.to - settings.from < settings.selectedIndex) return;
		//add options
		if(settings.remove) this.children().remove();
		var padfunc = function(v,p){
			if((''+v).length < p){
				for(var i = 0,l = p - (v+'').length;i < l ;i++){
					v = '0' + v;
				}
			}
			return v;			
		}
		
		if(settings.sort=="asc"){
			for(var i=settings.from,j=0;i<=settings.to;i++,j++){
				this.each(function(){
					this.options[j] = new Option(padfunc(i,settings.namePadding),padfunc(i,settings.valuePadding));
					});
			}
		}else{		
			for(var i=settings.to,j=0;i>=settings.from;i--,j++){
				this.each(function(){
					this.options[j] = new Option(padfunc(i,settings.namePadding),padfunc(i,settings.valuePadding));
					});
			}
		}
		
		this.each(function(){this.selectedIndex = settings.selectedIndex;})
		return this;
	};
	//
	$.fn.datePulldown = function(settings){
		if(!settings.year || !settings.month) return ;
		var y = settings.year;
		var m = settings.month;
		if(!y.val() || !m.val()) return;
		if(!y.val().match(/^\d{1,4}$/)) return;
		if(!m.val().match(/^[0][1-9]$|^[1][1,2]$|^[0-9]$/)) return;

		var self = this;
		var fnc = function(){
			var tmp = new Date(new Date(y.val(),m.val()).getTime() - 1000);
			var lastDay = tmp.getDate() - 0;
			self.each(function(){
				var ind = (this.selectedIndex<lastDay-1)?this.selectedIndex:lastDay-1;
				this.selectedIndex = ind;
				$(this).numericOptions({to:lastDay,selectedIndex:ind});
			});
		}
		y.change(fnc);
		m.change(fnc);
		return this;	
	};
	//
	$.fn.datePulldownCst = function(settings){
		if(!settings.month) return ;
		var y = new Date().getFullYear();
		var m = settings.month;
		if(!m.val()) return;
		if(!m.val().match(/^[0][1-9]$|^[1][1,2]$|^[0-9]$/)) return;

		var self = this;
		var fnc = function(){
			var tmp = new Date(new Date(y,m.val()).getTime() - 1000);
			var lastDay = tmp.getDate() - 0;
			self.each(function(){
				var ind = (this.selectedIndex<lastDay-1)?this.selectedIndex:lastDay-1;
				this.selectedIndex = ind;
				$(this).numericOptions({to:lastDay,selectedIndex:ind});
			});
		}
		m.change(fnc);
		return this;	
	};
})(jQuery);