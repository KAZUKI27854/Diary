// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

/*global $*/
document.addEventListener("turbolinks:load", function(){
  /* チュートリアルページのタブボックス */
  $(function() {
    $('#tabBoxes .tabBox[id != "tabBox1"]').hide();
    $('#js-message .message[id != "message1"]').hide();
  });

  $(function() {
    $('.tabBox a').on('click', function(event) {
      $('#tabBoxes .tabBox').hide();
      $('#js-message .message').hide();
      $($(this).attr("href")).show();
      $($(this).attr("class")).show();
      event.preventDefault();
    });
  });

  /* モーダルウインドウ */
  $(function(){
    $(document).on('click','.js-modal-open', function(){
      var target = $(this).data('target');
      var modal = document.getElementById(target);
      $(modal).fadeIn();
      return false;
    });

    $(document).on('click', '.js-modal-close', function(){
      $('.error__message').replaceWith('<div class="js-message-errors"></div>');
      $('.js-modal').fadeOut();
      return false;
    });
  });

  /* global gon */
  /* ユーザーの目標数、ドキュメント数が０の場合に、次に進む箇所をバウンドアニメーションで明示*/
  $(function(){
    if (gon.goals == 0) {
      $('.my-page__menu--icon--goal').addClass('js-bound');
      $('.js-save-icon, .js-todo-list-icon').css('opacity', 0.5 );
      $('.js-save-link, .js-todo-list-link').css('pointer-events', 'none' );
    } else if (gon.goals >= 1 && gon.documents == 0) {
      $('.my-page__menu--icon--goal').removeClass('js-bound');
      $('.my-page__link--create-doc-img').addClass('js-bound');
      $('.js-todo-list-icon').css('opacity', 0.5 );
      $('.js-todo-list-link').css('pointer-events', 'none' );
    } else {
      $('.my-page__link--create-doc-img').removeClass('js-bound');
    }
  });

  $(function() {
    $('.my-page__menu').hide();
  });

  $(function(){
    $('.my-page__menu--icon').on('click', function(){
      $(this).next().slideToggle();
      $(this).children('.my-page__menu--text').toggleClass('active');
    });
  });

  $(function(){
    $('.js-withdraw-confirm').hide();
  });

  $(function(){
    $('.js-withdraw-btn').on('click', function(){
      $('.js-user-edit').hide();
      $('.js-withdraw-confirm').show();
      event.preventDefault();

      $('.js-user-edit-btn').on('click', function(){
        $('.js-user-edit').show();
        $('.js-withdraw-confirm').hide();
        event.preventDefault();
      });
    });
  });

  /* 目標数が4つ以上の場合、更新順で4番目以降の目標はセレクトボックスに表示*/
  $(function(){
    var goal_select = '.js-menu-goal-select';

    if (gon.goals <= 3) {
      $(goal_select).hide();
    } else {
      $(goal_select).show();
    }
  });

  $(function(){
    $('.js-menu-goal-select').on('change',function(){
      var goal_id = $(this).val();
      var goal_edit_modal = '#modal-goal' + goal_id  + '-edit';

      $(goal_edit_modal).fadeIn();
      return false;
    });
  });

  /* 同一目標で投稿回数が101回以上の場合に、モンスター画像をランダムで表示*/
  $(function(){
    $('.random-monster-img').each(function(i){
      var random_number = Math.floor(Math.random() * ((5 + 1) - 1)) + 1;
      $(this).prop('src','/assets/monster/monster' + random_number + '.png');
    });
  });

  $(function(){
      $('.levelup__text').html("<span>L</span><span>E</span><span>V</span><span>E</span><span>L</span><span>_</span><span>U</span><span>P</span><span>!</span>");
  });

  $(function(){
    setTimeout("$('.levelup__back').fadeOut('slow')", 1200
    );
  });

  $(function(){
    setTimeout("$('.clear__back').fadeOut('slow')", 3500
    );
  });

  $(function(){
    setTimeout("$('.my-page__message').fadeOut('slow')", 3500
    );
  });

  /* ドキュメントのインクリメンタルサーチ */
  $(function() {
    $('.js-doc-search-field').on('keyup', function () {
      var word = $.trim($(this).val());
      var category = $('.js-doc-search-select').val();

      $.ajax({
        type: 'GET',
        url: '/documents/searches',
        data:  { word: word, category: category },
        dataType: 'html'
      })

      .done(function (data) {
          $('.js-card').html(data);
        })

      .fail(function() {
        alert("検索に失敗しました。ページを再読み込みして下さい。");
      });
    });
  });

  $(function () {
    $('.js-doc-search-select').on('change', function () {
      var category = $(this).val();
      var word = $.trim($('.js-doc-search-field').val());

      $.ajax({
        type: 'GET',
        url: '/documents/searches',
        data:  { category: category, word: word },
        dataType: 'html'
      })

      .done(function (data) {
        $('.js-card').html(data);
      })

      .fail(function() {
        alert("絞り込みに失敗しました。ページを再読み込みして下さい。");
      });
    });
  });

  $(function() {
    $('.js-todo-lists-area, .js-write-todo-lists-icon, .js-todo-lists-form').hide();
  });

  /* Todoリスト作成フォーム開閉時の処理 */
  $(function() {
    $('.todo-lists__icon--create').on('click', function(event) {
      $('.js-todo-lists-form').toggleClass('active-form');
      $('.js-todo-lists-form').slideToggle();

      if($('.js-todo-lists-form').hasClass('active-form')) {
        $('.js-write-todo-lists-icon').show();
        $('.js-create-todo-lists-icon').hide();
      } else {
        $('.js-write-todo-lists-icon').hide();
        $('.js-create-todo-lists-icon').show();
        $('#todo_list_body').val("");
        $('.error__message').remove();
      }
    });
  });

  /* Todoリストのインクリメンタルサーチ */
  $(function() {
    $('.js-todo-lists-search-field').on('keyup', function () {
      var word = $.trim($(this).val());
      var category = $('.js-todo-lists-search-select').val();

      $.ajax({
        type: 'GET',
        url: '/todo_lists/searches',
        data:  { word: word, category: category },
        dataType: 'html'
      })

      .done(function (data) {
          $('.js-todo-lists').html(data);
        })

      .fail(function() {
        alert("検索に失敗しました。ページを再読み込みして下さい。");
      });
    });
  });

  $(function() {
    $('.js-todo-lists-search-select').on('change', function () {
      var category = $(this).val();
      var word = $.trim($('.js-todo-lists-search-field').val());

      $.ajax({
        type: 'GET',
        url: '/todo_lists/searches',
        data:  { category: category, word: word },
        dataType: 'html'
      })

      .done(function (data) {
          $('.js-todo-lists').html(data);
        })

      .fail(function() {
        alert("検索に失敗しました。ページを再読み込みして下さい。");
      });
    });
  });




});

