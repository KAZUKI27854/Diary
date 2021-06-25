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
//= stub countdown
//= require_tree .

/*global $*/
document.addEventListener("turbolinks:load", function(){
  /*global cssVars*/
  /* IEでカスタムプロパティを使用する為 */
  cssVars({
    rootElement: document
  });

  /*global objectFitImages*/
  /* IEでobject-fitプロパティを使用する為 */
  $(function () {
    objectFitImages();
  });

  /* ヘッダー */
  $('.js-menu-trigger').on('click', function() {
    $(this).toggleClass('header__trigger--active');
    $('.js-menu').fadeToggle();
    event.preventDefault();

    if($(this).hasClass('header__trigger--active')) {
      $('.js-menu-trigger').html('CLOSE');
    } else {
      $('.js-menu-trigger').html('MENU');
    }
    return false;
  });

  /* トップ画面の画像フェードイン、アウト */
  $(function(){
    setTimeout("$('.top__title--area').fadeIn('slow')", 2200
    );
  });

  $(function(){
    setTimeout("$('.top__img').fadeIn('slow')", 2500
    );
  });

  $(function(){
    setTimeout("$('.top__img--cloud-area').fadeOut('slow')", 1500
    );
  });

  /* チュートリアルページのタブボックス */
  $(function() {
    $('#js-tabBoxes .tutorial__tabBox[id != "tabBox1"]').hide();
    $('#js-header .tutorial__header[id != "header1"]').hide();
  });

  $(function() {
    $('.tutorial__tabBox a').on('click', function() {
      $('#js-tabBoxes .tutorial__tabBox').hide();
      $('#js-header .tutorial__header').hide();
      $($(this).attr("href")).show();
      $($(this).attr("class")).show();
      event.preventDefault();
    });
  });

  /* モーダルウインドウ */
  $(function(){
    $('.js-modal-open').on('click', function(){
      var target = $(this).data('target');
      var modal = document.getElementById(target);
      $(modal).fadeIn();
      return false;
    });

    $('.js-modal-close').on('click', function(){
      $('.error__message').replaceWith('<div class="js-message-errors"></div>');
      $('.js-modal').fadeOut();
      return false;
    });
  });

  /* global gon */
  /* ユーザーの目標数、ドキュメント数が０の場合に、次に進む箇所をバウンドアニメーションで明示*/
  $(function(){
    if(typeof gon == 'undefined'){
      return;
    }

    if (gon.goals == 0) {
      /* バウンドアニメーションの為のクラス付与 */
      $('.my-page__menu--icon--goal').addClass('js-bound');
      /* 目標設定後に進むべきアイコン表示を薄くする */
      $('.js-save-icon, .js-todo-list-icon').css('opacity', 0.5 );
      /* 目標設定後に進むべきアイコンのhover時のカーソル表示無効化 */
      $('.js-save-link, .js-todo-list-link').css('pointer-events', 'none' );
      /* 上記記述だけではモーダルリンクが有効な為、リンクも合わせて無効化 */
      $('.js-save-link, .js-todo-list-link').click(function(){
        return false;
      });
    } else if (gon.goals >= 1 && gon.documents == 0) {
      $('.my-page__menu--icon--goal').removeClass('js-bound');
      $('.my-page__link--create-doc').addClass('js-bound');
      $('.js-todo-list-icon').css('opacity', 0.5 );
      $('.js-todo-list-link').css('pointer-events', 'none' );
      $('.js-todo-list-link').click(function(){
        return false;
      });
    } else {
      $('.my-page__link--create-doc').removeClass('js-bound');
    }
  });

  /* マイページ */
  $(function(){
    setTimeout("$('.my-page__message').fadeOut('slow')", 3500
    );
  });

  $(function() {
    $('.my-page__menu').hide();
  });

  $(function(){
    $('.js-menu-icon').on('click', function(){
      $(this).next().slideToggle();
      $(this).children('.my-page__menu--text').toggleClass('active');
    });
  });

  /* ユーザー編集<=>退会確認画面切り替え */
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
    if(typeof gon == 'undefined'){
      return;
    }

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

  /* レベルアップ時のフラッシュ演出 */
  $(function(){
      $('.levelup__text').html("<span>L</span><span>E</span><span>V</span><span>E</span><span>L</span><span>_</span><span>U</span><span>P</span><span>!</span>");
  });

  $(function(){
    setTimeout("$('.levelup__back').fadeOut('slow')", 1500
    );
  });

  $(function(){
    $('.js-close-flash').on('click', function () {
      $('.clear__back').fadeOut('slow');
      event.preventDefault();
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