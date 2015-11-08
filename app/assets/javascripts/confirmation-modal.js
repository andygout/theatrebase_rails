var timeMillisecs = 500;
var timeSecs = timeMillisecs / 1000;

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
  $('body').addClass('overflow-y-hidden');

  createOverlay();

  createModal(link);

  blurContainer(2);

  windowResizeListener();

  $(document).mouseup(function (e)
  {
    var modal = $('.modal');
    if (!modal.is(e.target) && modal.has(e.target).length === 0)
    {
      removeEffect();
    }
  });

  $('.confirm').click(function() {
    $.rails.confirmed(link);
  });

  $('.cancel').click(function() {
    removeEffect();
  });
};

function removeEffect() {
  blurContainer(0);

  $('.overlay, .modal')
    .fadeOut(timeMillisecs, function() {
      $(this).remove();
      $('body').removeClass('overflow-y-hidden');
    });
}

function createOverlay() {
  $('<div></div>')
    .addClass('overlay')
    .fadeTo(timeMillisecs, 0.5)
    .appendTo('body');
}

function createModal(link) {
  var modalHTML = "<div class='modal'>" +
                  "<h1 class='header-text'>" + link.attr('data-confirm') + "</h1>" +
                  "<button class='button confirm'>OK</button>" +
                  "<button class='button cancel'>Cancel</button>" +
                  "</div>";

  $(modalHTML)
    .hide()
    .fadeIn(timeMillisecs)
    .appendTo('body')
    .css({
      'top': acquireModalTop(),
      'left': acquireModalLeft()
    });
}

function windowResizeListener() {
  $(window).resize(function() {
    clearTimeout(window.resizeEvt);
    window.resizeEvt = setTimeout(function() {
      repositionModal();
    }, 250);
  });
}

function repositionModal() {
  $('.modal').animate({top: acquireModalTop(), left: acquireModalLeft()}, 250);
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
    });

  containerTransition('ease-out');
}

function containerTransition(effect) {
  var transitionVal = 'all ' + timeSecs + 's ' + effect;

  $('.container')
    .css({
      'transition': transitionVal,
      '-webkit-transition': transitionVal,
      '-moz-transition': transitionVal,
      '-o-transition': transitionVal,
      '-ms-transition': transitionVal
    });
}
