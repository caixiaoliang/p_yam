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
//= require_tree .
 
// data = { account: account, env: $sendBtn.data("env") }
//  reqVerify = $.post "/users/send_verify_code", data, (res)->
//         if res.code != 200
//           $(".js-login-form .error").text("您的手机号码发送次数过多，暂不可用")


  // $.ajax({
  //     url: "../web/VerifyLoginServlet.php", // 进行二次验证
  //     type: "post",
  //     dataType: "json",
  //     data: {
  //         type: "pc",
  //         username: $('#username1').val(),
  //         password: $('#password1').val(),
  //         geetest_challenge: validate.geetest_challenge,
  //         geetest_validate: validate.geetest_validate,
  //         geetest_seccode: validate.geetest_seccode
  //     },
  //     success: function (data) {
  //         if (data && (data.status === "success")) {
  //             $(document.body).html('<h1>登录成功</h1>');
  //         } else {
  //             $(document.body).html('<h1>登录失败</h1>');
  //         }
  //     }
  // });
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



