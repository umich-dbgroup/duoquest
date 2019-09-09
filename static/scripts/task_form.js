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
			};
		editor.blur(function () {
			setActiveText();
			editor.hide();
		}).keydown(function (e) {
			if (e.which === ENTER) {
				setActiveText();
				editor.hide();
				active.focus();
				e.preventDefault();
				e.stopPropagation();
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

  append_val_cell('#tsq-value-head-row');
  append_val_cell('.tsq-value-row');
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

$('#task-form').on('submit', function(e) {
  $("<input />").attr("type", "hidden")
          .attr("name", "num_cols")
          .attr("value", parseInt($('#tsq').attr('data-num-cols')))
          .appendTo("#task-form");

  var types = [];
  $('#tsq-type-row td').each(function (i) {
    type_input = $(this).text();
    if (type_input !== 'text' && type_input !== 'number') {
      // TODO: send error message! Bootstrap toast?
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

  $("<input />").attr("type", "hidden")
          .attr("name", "types")
          .attr("value", JSON.stringify(types))
          .appendTo("#task-form");
  $("<input />").attr("type", "hidden")
          .attr("name", "values")
          .attr("value", JSON.stringify(values))
          .appendTo("#task-form");
  return true;
});

function init_addons(active, editor) {
	if (active.attr('data-toggle') && active.attr('title')) {
		editor.attr('data-toggle', active.attr('data-toggle'))
					.attr('title', active.attr('title'))
					.tooltip();
	}

	if (active.parents('#tsq-type-row').length) {
		editor.autocomplete({
			minLength: 0,
			source: ['text', 'number']
		});
		editor.autocomplete('search', '');
	} else {
		var db_name = $('#db-name option:selected').text();
		editor.autocomplete({
			source: `/databases/${db_name}/autocomplete`
		});
	}
}

function reset_addons(editor) {
	editor.tooltip('dispose');
	if (editor.autocomplete('instance')) {
		editor.autocomplete('destroy');
	}
}
