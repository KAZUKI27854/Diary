/* フラッシュ表示時のみカウントダウンが動くよう別ファイルで作成 */
/* 目標レベル100達成時のフラッシュ演出 */
var timeleft = 59;

/* global $*/
$(function(){
  var Timer = setInterval(function(){

    timeleft -= 1;
    $("#js-countdown").html(timeleft + "秒後に自動的にマイページへ戻ります");
    if(timeleft <= 0){
      clearInterval(Timer);
    }
  }, 1000);
});

$(function(){
  setTimeout("$('.clear__back').fadeOut('slow')", 59000
  );
});
