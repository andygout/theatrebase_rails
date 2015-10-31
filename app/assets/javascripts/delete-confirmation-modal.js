$.rails.allowAction = function(link) {
  if (!link.attr('data-confirm')) {
    return true;
  }
  $.rails.showConfirmDialog(link);
  return false;
};

$.rails.confirmed = function(link) {
  link.removeAttr('data-confirm');
  return link.trigger('click.rails');
};

$.rails.showConfirmDialog = function(link) {
  $('body').css('overflow-y', 'hidden');

  $('<div class="overlay"></div>')
    .css('top', $(document).scrollTop())
    .css('opacity', '0')
    .animate({'opacity': '0.5'}, 'slow')
    .appendTo('body');

  var model = link.attr('data-model');
  var modalHTML = "<div class='modal'><h1 class='header-text'>Really delete this " + model + "?</h1><button class='button confirm'>OK</button><button class='button cancel'>Cancel</button></div>";
  $(modalHTML)
    .hide()
    .appendTo('body');
    var top = ($(window).height() - $('.modal').height()) / 2;
    var left = ($(window).width() - $('.modal').width()) / 2;
    $('.modal')
      .css({
        'top': top + $(document).scrollTop(),
        'left': left
      })
      .fadeIn();

    $('.confirm').click(function() {
      $.rails.confirmed(link);
    });

    $('.cancel').click(function() {
      removeModal();
    });
};

$(document).mouseup(function (e)
{
  var container = $('.modal');
  if (!container.is(e.target) && container.has(e.target).length === 0)
  {
    removeModal();
  }
});

function removeModal() {
  $('.overlay, .modal')
    .fadeOut('slow', function() {
      $(this).remove();
      $('body').css('overflow-y', 'auto');
    });
}