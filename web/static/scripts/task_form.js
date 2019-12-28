/* NLQ related code */
var tagify = new Tagify($('#nlq')[0], {
	mode: 'mix',
	pattern: /"/,
	enforceWhiteList: true,

	// Initial loading whitelist
	whitelist: get_initial_whitelist($('#nlq').val())
});

var controller = false;

tagify.on('input', function (e) {
	let m = e.detail && e.detail.textContent.match(/"(.+)/);
	if (m) {
		let value = m[1];
		tagify.settings.whitelist.length = 0; // reset the whitelist

	  // https://developer.mozilla.org/en-US/docs/Web/API/AbortController/abort
	  controller && controller.abort();
	  controller = new AbortController();

		let db_name = $('#db-name option:selected').text();

	  fetch(`/databases/${db_name}/autocomplete?term=${value}`, {signal:controller.signal})
	    .then(RES => RES.json())
	    .then(function(whitelist){
	      tagify.settings.whitelist = whitelist;
	      tagify.dropdown.show.call(tagify, value); // render the suggestions dropdown
	    });
	}
});

tagify.on('add', function (e) {
	let last_tag_found = false;
	$('.tagify span').contents().each(function (i) {
		if ($(this)[0] == $('.tagify tag:last-child')[0]) {
			last_tag_found = true;
		} else if (last_tag_found &&
			$(this)[0].textContent !== String.fromCharCode(8288) &&
			$(this).parents('tag').length === 0) {
			$(this).remove();
		}
	});
	tagify.update();
});

/*global $, window*/
$.fn.editableTableWidget = function (options) {
	'use strict';
	return $(this).each(function () {
		var buildDefaultOptions = function () {
				var opts = $.extend({}, $.fn.editableTableWidget.defaultOptions);
				opts.editor = opts.editor.clone();
				return opts;
			},
			activeOptions = $.extend(buildDefaultOptions(), options),
			ARROW_LEFT = 37, ARROW_UP = 38, ARROW_RIGHT = 39, ARROW_DOWN = 40, ENTER = 13, ESC = 27, TAB = 9,
			element = $(this),
			editor = activeOptions.editor.css('position', 'absolute').hide().appendTo(element.parent()),
			active,
			showEditor = function (select) {
				active = element.find('td:focus');
				if (active.length) {
					// Reset add-ons for TSQ input
					reset_addons(editor);

					editor.val(active.text())
						.removeClass('error')
						.show()
						.offset(active.offset())
						.css(active.css(activeOptions.cloneProperties))
						.width(active.width())
						.height(active.height())
						.focus();

					// Init add-ons for TSQ input
					init_addons(active, editor);
					if (select) {
						editor.select();
					}
				}
			},
			setActiveText = function () {
				var text = editor.val(),
					evt = $.Event('change'),
					originalContent;
				if (active.text() === text || editor.hasClass('error')) {
					return true;
				}
				originalContent = active.html();
				active.text(text).trigger(evt, text);
				if (evt.result === false) {
					active.html(originalContent);
				}
			},
			movement = function (element, keycode) {
				if (keycode === ARROW_RIGHT) {
					return element.next('td');
				} else if (keycode === ARROW_LEFT) {
					return element.prev('td');
				} else if (keycode === ARROW_UP) {
					return element.parent().prev().children().eq(element.index());
				} else if (keycode === ARROW_DOWN) {
					return element.parent().next().children().eq(element.index());
				}
				return [];
			},
			validateAutocomplete = function () {
				if (isNaN(editor.val()) && !editor.val().match(/\[\s*[0-9]+\s*,\s*[0-9]+\s*\]/)) {
					if (!editor.cache || !editor.cache.includes(editor.val())) {
						editor.val('');
					}
				}
				setActiveText();
				editor.hide();
			};
		editor.blur(function () {
			validateAutocomplete();
		}).keydown(function (e) {
			if (e.which === ENTER) {
				/*setActiveText();
				editor.hide();
				active.focus();*/
				e.preventDefault();
				e.stopPropagation();

				validateAutocomplete();
			} else if (e.which === ESC) {
				editor.val(active.text());
				e.preventDefault();
				e.stopPropagation();
				editor.hide();
				active.focus();
			} else if (e.which === TAB) {
				active.focus();
			} else if (this.selectionEnd - this.selectionStart === this.value.length) {
				var possibleMove = movement(active, e.which);
				if (possibleMove.length > 0) {
					possibleMove.focus();
					e.preventDefault();
					e.stopPropagation();
				}
			}
		})
		.on('input paste', function () {
			var evt = $.Event('validate');
			active.trigger(evt, editor.val());
			if (evt.result === false) {
				editor.addClass('error');
			} else {
				editor.removeClass('error');
			}
		});
		element.on('click keypress dblclick', showEditor)
		.css('cursor', 'pointer')
		.keydown(function (e) {
			var prevent = true,
				possibleMove = movement($(e.target), e.which);
			if (possibleMove.length > 0) {
				possibleMove.focus();
			} else if (e.which === ENTER) {
				showEditor(false);
			} else if (e.which === 17 || e.which === 91 || e.which === 93) {
				showEditor(true);
				prevent = false;
			} else {
				prevent = false;
			}
			if (prevent) {
				e.stopPropagation();
				e.preventDefault();
			}
		});

		element.find('td').prop('tabindex', 1);

		$(window).on('resize', function () {
			if (editor.is(':visible')) {
				editor.offset(active.offset())
				.width(active.width())
				.height(active.height());
			}
		});
	});

};
$.fn.editableTableWidget.defaultOptions = {
	cloneProperties: ['padding', 'padding-top', 'padding-bottom', 'padding-left', 'padding-right',
					  'text-align', 'font', 'font-size', 'font-family', 'font-weight',
					  'border', 'border-top', 'border-bottom', 'border-left', 'border-right'],
	editor: $('<input>')
};

function get_num_cols() {
  return parseInt($('#tsq').attr('data-num-cols'));
}

function get_num_rows() {
  return parseInt($('#tsq-values-head').attr('rowspan'));
}

function refresh_table() {
  $('#tsq').editableTableWidget();
}

function add_value_row(values) {
  var num_rows = get_num_rows();
  $('#tsq-values-head').attr('rowspan', num_rows + 1);
  $('#tsq').append("<tr class='tsq-value-row'></tr>");

  if (!values) {
    var values = [];
    for (var i = 0; i < $('#tsq').attr('data-num-cols'); i++) {
      values.push('');
    }
  }

  for (var i = 0; i < values.length; i++) {
    append_val_cell('#tsq .tsq-value-row:last-child', values[i]);
  }
  $('#tsq-del-row').removeAttr('disabled');
  refresh_table();
}

function append_val_cell(selector, val) {
  $(selector).append('<td data-toggle="tooltip" title="e.g. `My Text`, `42`, `[45,62]` (range)">' + val + '</td>');
}

refresh_table();

$('#tsq-add-col').on('click', function (e) {
  var num_cols = get_num_cols();

  $('#tsq-type-row').append('<td data-toggle="tooltip" title="`text` OR `number`"></td>');

  append_val_cell('#tsq-value-head-row', '');
  append_val_cell('.tsq-value-row', '');
  $('#tsq').attr('data-num-cols', num_cols + 1);
  $('#tsq-del-col').removeAttr('disabled');
  refresh_table();
});
$('#tsq-del-col').on('click', function (e) {
  var num_cols = get_num_cols();
  if (num_cols > 1) {
    $('#tsq-type-row td:last-child').remove();
    $('#tsq-value-head-row td:last-child').remove();
    $('.tsq-value-row td:last-child').remove();
    $('#tsq').attr('data-num-cols', num_cols - 1);

    if ((num_cols - 1) <= 1) {
      $('#tsq-del-col').attr('disabled', true);
    }
  }
});
$('#tsq-add-row').on('click', function (e) {
  add_value_row();
});

$('#tsq-del-row').on('click', function (e) {
  var num_rows = get_num_rows();
  if (num_rows > 1) {
    $('#tsq-values-head').attr('rowspan', num_rows - 1);
    $('#tsq tr.tsq-value-row:last-child').remove();

    if ((num_rows - 1) <= 1) {
      $('#tsq-del-row').attr('disabled', true);
    }
  }
});

var submitHandler = function () {
	$("input[name=num_cols]").remove();
  $("<input />").attr("type", "hidden")
          .attr("name", "num_cols")
          .attr("value", parseInt($('#tsq').attr('data-num-cols')))
          .appendTo("#task-form");

  var types = [];
  $('#tsq-type-row td').each(function (i) {
    type_input = $(this).text();
    if (type_input !== 'text' && type_input !== 'number') {
      error_message('Each column in the TSQ requires at least a type.');
      e.preventDefault();
    } else {
      types.push(type_input);
    }
  })

  var values = [];

  var head_row = [];
  $('#tsq-value-head-row td').each(function (i) {
    head_row.push($(this).text());
  });
  values.push(head_row);

  $('.tsq-value-row').each(function (i) {
    var row = [];
    $(this).children('td').each(function (j) {
      row.push($(this).text());
    })
    values.push(row);
  });

	$("input[name=types]").remove();
  $("<input />").attr("type", "hidden")
          .attr("name", "types")
          .attr("value", JSON.stringify(types))
          .appendTo("#task-form");
	$("input[name=values]").remove();
  $("<input />").attr("type", "hidden")
          .attr("name", "values")
          .attr("value", JSON.stringify(values))
          .appendTo("#task-form");

	let nlq = parse_tagify_text($('#nlq').val());
	$("input[name=nlq]").remove();
	$("<input />").attr("type", "hidden")
          .attr("name", "nlq")
          .attr("value", nlq['nlq'])
          .appendTo("#task-form");
	$("input[name=literals]").remove();
	$("<input />").attr("type", "hidden")
          .attr("name", "literals")
          .attr("value", JSON.stringify(nlq['literals']))
          .appendTo("#task-form");
	$("input[name=nlq_with_literals]").remove();
	$("<input />").attr("type", "hidden")
          .attr("name", "nlq_with_literals")
          .attr("value", nlq['nlq_with_literals'])
          .appendTo("#task-form");
}

$('#task-form').on('submit', function(e) {
	var form = $(this);
	var tid_attr = $(this).attr('data-tid');

	if (typeof tid_attr !== typeof undefined && tid_attr !== false) {
		$(this).val('Stopping current query...');
		$(this).prop('disabled', true);
		$.get(`/tasks/${tid}/stop`, function (data) {
	    submitHandler();
			form.submit();
	  });
	}
	submitHandler();
  return true;
});

function init_addons(active, editor) {
	if (active.attr('data-toggle') && active.attr('title')) {
		editor.attr('data-toggle', active.attr('data-toggle'))
					.attr('title', active.attr('title'))
					.tooltip();
	}

	if (active.parents('#tsq-type-row').length) {
		editor.cache = ['text', 'number'];
		editor.autocomplete({
			minLength: 0,
			source: ['text', 'number'],
			response: function (e, ui) {
				ui.content.forEach(function (c) {
					editor.cache.push(c.value);
				})
			}
		});
		editor.autocomplete('search', '');
	} else {
		editor.cache = [];
		var db_name = $('#db-name option:selected').text();
		editor.autocomplete({
			source: `/databases/${db_name}/autocomplete`,
			delay: 100,
			response: function (e, ui) {
				ui.content.forEach(function (c) {
					editor.cache.push(c.value);
				})
			}
		});
	}
}

function reset_addons(editor) {
	editor.tooltip('dispose');
	if (editor.autocomplete('instance')) {
		editor.autocomplete('destroy');
	}
}

function get_initial_whitelist(text) {
	let literals = [];
	let it = text.matchAll(/\[\[([^\]]*)\]\]/g);
	let m = it.next();

	let nlq = text;
	while (!m.done) {
		let parsed = JSON.parse(m.value[1]);
		let literal = {
			'col_id': parsed['data-col-id'],
			'value': parsed['value']
		}
		literals.push(literal);
		m = it.next();
	}
	return literals;
}

function parse_tagify_text(text) {
	let literals = [];
	let it = text.matchAll(/\[\[([^\]]*)\]\]/g);

	let m = it.next();

	let nlq = text;
	while (!m.done) {
		let parsed = JSON.parse(m.value[1]);
		let literal = {
			'col_id': parsed['data-col-id'],
			'value': parsed['value']
		}
		nlq = nlq.replace(m.value[0], literal['value']);
		literals.push(literal);
		m = it.next();
	}

	return {
		'nlq': nlq,
		'literals': literals,
		'nlq_with_literals': text
	};
}

function error_message(msg) {
	$('#alerts').append(`
		<div class="alert alert-danger alert-dismissible fade show" role="alert">
  	${msg}
  	<button type="button" class="close" data-dismiss="alert" aria-label="Close">
    	<span aria-hidden="true">&times;</span>
  	</button>
		</div>`)
}
