// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery.min
//= require jquery_ujs
//= require turbolinks
//= require bootstrap.min
//= require moment
//= require moment-timezone

function showLocalTime(container, zoneString, formatString){
  if($('#' + container).length > 0) {
  	var thisobj=this
  	this.container=document.getElementById(container)
  	this.localtime = moment.tz(new Date(), zoneString)
  	this.formatString = formatString
  	this.container.innerHTML = this.localtime.format( this.formatString )
  	setInterval(function(){thisobj.updateContainer()}, 1000) //update container every second
  }
}

showLocalTime.prototype.updateContainer=function(){
	this.localtime.second(this.localtime.seconds() + 1 )
	this.container.innerHTML = this.localtime.format( this.formatString )
}

$(document).on("change", "#query_show_deleted_resources", function() {
  $(".simple_form.query").submit();
});

$(document).on("click", "#menu-toggle", function(e) {
    e.preventDefault();
    $("#wrapper").toggleClass("toggled");
});

$(document).on("click", "#menu-toggle-2", function(e) {
    e.preventDefault();
    collapseMenu();
});

function collapseMenu() {
  $("#wrapper").toggleClass("toggled-2");
  $('#menu ul').hide();
  if($(".toggled-2").length > 0) {
    $("#menu-toggle-2 .material-icons").text("chevron_right");
  }else{
    $("#menu-toggle-2 .material-icons").text("chevron_left");
  }
}

function initMenu() {
  $('#menu ul').hide();
  $('#menu ul').children('.current').parent().show();
  //$('#menu ul:first').show();
  $('#menu li a').click(
    function() {
      var checkElement = $(this).next();
      if((checkElement.is('ul')) && (checkElement.is(':visible'))) {
        return false;
        }
      if((checkElement.is('ul')) && (!checkElement.is(':visible'))) {
        $('#menu ul:visible').slideUp('normal');
        checkElement.slideDown('normal');
        return false;
        }
      }
    );
}

function initTimezones() {
  new showLocalTime("utc", "UTC", "hh:mm:ss A (ddd)");
  new showLocalTime("los_angeles", "America/Los_Angeles", "hh:mm:ss A (ddd)");
  new showLocalTime("new_york", "America/New_York", "hh:mm:ss A (ddd)");
  new showLocalTime("hong_kong", "Asia/Hong_Kong", "hh:mm:ss A (ddd)");
}



document.addEventListener("turbolinks:load", function() {
  initTimezones();
  //setTimeout(function(){ if (!$("#wrapper").hasClass("toggled-2")) {collapseMenu();} }, 15000);
});
