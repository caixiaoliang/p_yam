// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap.min 
//= require cropbox
//= require_tree .
 

 $(function(){
   $(".js-send-sms").on("click",function(){
      var sendBtn = $(".send-sms")
      $.ajax({
        url: "/users/send_verify_code",
        type: "post",
        dataType: "json",
        data:{
          env: sendBtn.data("env"),
          account: $("#account").val()
        },
        success: function(data){
        }
      });
    });
    var mobile_regx = /^1[0-9]{10}$/
    $(".account").blur(function(){
      if(mobile_regx.test($(this).val())){
        $(".sms").removeClass("hidden");
      }else
      {
        $(".sms").addClass("hidden");
      }
    });
    $(".account")
  })



