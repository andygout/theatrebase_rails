var timeMillisecs = 500;
var timeSecs = millisecsToSecs(timeMillisecs);

function millisecsToSecs(millisecs) {
  return millisecs / 1000;
}

$.rails.allowAction = function(link) {
  if (!link.attr('data-confirm')) {
    return true;
  }
  $.rails.activateModal(link);
  return false;
};

$.rails.confirmed = function(link) {
  link.removeAttr('data-confirm');
  return link.trigger('click.rails');
};

$.rails.activateModal = function(link) {
  setBodyOverflowY('hidden');

  createOverlay();

  var modalHTML = acquireModalHTML(link);

  $(modalHTML)
    .hide()
    .appendTo('body');

    showModal();

    $('.confirm').click(function() {
      $.rails.confirmed(link);
    });

    $('.cancel').click(function() {
      removeModal();
    });
};

function setBodyOverflowY(value) {
  $('body').css('overflow-y', value);
}

function createOverlay() {
  $('<div class="overlay"></div>')
    .css('opacity', 0.5)
    .fadeIn(timeMillisecs)
    .appendTo('body');
}

function acquireModalHTML(link) {
  var model = link.attr('data-model');
  return "<div class='modal'><h1 class='header-text'>Really delete this " + model + "?</h1><button class='button confirm'>OK</button><button class='button cancel'>Cancel</button></div>";
}

function showModal() {
  $('.modal')
    .css({
      'top': acquireModalTop(),
      'left': acquireModalLeft()
    })
    .fadeIn(timeMillisecs);

    blurContainer(2);
}

function acquireModalTop() {
  return ($(window).height() - $('.modal').outerHeight()) / 2;
}

function acquireModalLeft() {
  return ($(window).width() - $('.modal').outerWidth()) / 2;
}

function blurContainer(blurSize) {
  var filterVal = 'blur(' + blurSize + 'px)';
  $('.container')
    .css({
      'filter': filterVal,
      'webkitFilter': filterVal,
      'mozFilter': filterVal,
      'oFilter': filterVal,
      'msFilter': filterVal
    })
    containerTransition('ease-out');
}

function containerTransition(effect) {
  var transitionVal = 'all ' + timeSecs + 's ' + effect
  $('.container')
    .css({
      'transition': transitionVal,
      '-webkit-transition': transitionVal,
      '-moz-transition': transitionVal,
      '-o-transition': transitionVal,
      '-ms-transition': transitionVal
    })
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
  blurContainer(0);

  $('.overlay, .modal')
    .fadeOut(timeMillisecs, function() {
      $(this).remove();
      setBodyOverflowY('auto');
    });
}
