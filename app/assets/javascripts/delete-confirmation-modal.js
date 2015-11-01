var timeMillisecs = 500;
var timeSecs = timeMillisecs / 1000;

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
    .css('opacity', 0.5)
    .fadeIn(timeMillisecs)
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
      .fadeIn(timeMillisecs);

      blurElement($('.modal').siblings(), 2);

    $('.confirm').click(function() {
      $.rails.confirmed(link);
    });

    $('.cancel').click(function() {
      removeModal();
    });
};

function blurElement(element, blurSize) {
  var filterVal = 'blur(' + blurSize + 'px)';
  $(element)
    .css('filter', filterVal)
    .css('webkitFilter', filterVal)
    .css('mozFilter', filterVal)
    .css('oFilter', filterVal)
    .css('msFilter', filterVal)
    transition(element, 'ease-out');
}

function transition(element, effect) {
  var transitionVal = 'all ' + timeSecs + 's ' + effect
  $(element)
    .css('transition', transitionVal)
    .css('-webkit-transition', transitionVal)
    .css('-moz-transition', transitionVal)
    .css('-o-transition', transitionVal)
    .css('-ms-transition', transitionVal);
}

$(document).mouseup(function (e)
{
  var container = $('.modal');
  if (!container.is(e.target) && container.has(e.target).length === 0)
  {
    removeModal();
  }
});

function removeModal() {
  blurElement($('.modal').siblings(), 0, timeSecs);

  $('.overlay, .modal')
    .fadeOut(timeMillisecs, function() {
      $(this).remove();
      $('body').css('overflow-y', 'auto');
    });
}
