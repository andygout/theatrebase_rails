function getTransitionEndEventName() {
  var el = document.createElement('fake'),
    transitionEndEventNames = {
      'transition'        : 'transitionend',                  // IE 10+, Opera 12.10+, Chrome, Firefox 15+, Safari 7+
      'MozTransition'     : 'transitionend',                  // Firefox < 15
      'WebkitTransition'  : 'webkitTransitionEnd',            // Safari 6, Android Browser
      'msTransition'      : 'MSTransitionEnd',                // old IE versions
      'OTransition'       : 'oTransitionEnd otransitionend'   // #1: Opera ≥ 10.5 < 12; #2: Opera ≥ 12.0 < 12.10
    };

  for (var t in transitionEndEventNames) {
    if (el.style[t] !== undefined) {
      return transitionEndEventNames[t];
    }
  }
}

var transitionEndEventName = getTransitionEndEventName();

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
  createOverlay();
  createModal(link);

  $('body').addClass('blur overflow-y-hidden');
  $('.overlay').addClass('veil');
  $('.modal').addClass('display');

  $(document).mouseup(function (ev) {
    if (!$('.modal').is(ev.target) && $('.modal').has(ev.target).length === 0) {
      removeModalEffect();
    }
  });

  $('.cancel').click(function() {
    removeModalEffect();
  });

  $('.confirm').click(function() {
    $.rails.confirmed(link);
  });
};

function createOverlay() {
  $("<div class='overlay'></div>")
    .appendTo('html')
    .focus(); // prevents batched reflow by browser (which skips CSS transition)
}

function createModal(link) {
  $("<div class='modal'>" +
    "<h1 class='title-text'>" + link.attr('data-confirm') + "</h1>" +
    "<button class='button confirm'>OK</button>" +
    "<button class='button cancel'>Cancel</button>" +
    "</div>")
    .appendTo('html')
    .css({
      'top': getModalPosition($(window).height(), $('.modal').outerHeight()),
      'left': getModalPosition($(window).width(), $('.modal').outerWidth())
    })
    .focus(); // prevents batched reflow by browser (which skips CSS transition)
}

function getModalPosition(windowDimension, modalDimension) {
  return (windowDimension - modalDimension) / 2;
}

function removeModalEffect() {
  $(document).unbind('mouseup');
  $('.modal').removeClass('display');
  $('.overlay').removeClass('veil');
  $('body').removeClass('blur overflow-y-hidden')
    .one(transitionEndEventName, function() {
      $('.overlay, .modal').remove();
    });
}
