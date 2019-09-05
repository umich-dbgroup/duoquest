function get_num_cols() {
  return parseInt($('#tsq').attr('data-num-cols'));
}

function get_num_rows() {
  return parseInt($('#tsq-values-head').attr('rowspan'));
}

function refresh_table() {
  $('#tsq').editableTableWidget();
}

refresh_table();

$('#tsq-add-col').on('click', function (e) {
  var num_cols = get_num_cols();

  $('#tsq-type-row').append('<td data-toggle="tooltip" title="`text` OR `number`"></td>');

  $('#tsq-value-head-row').append('<td></td>');
  $('.tsq-value-row').append('<td></td>');
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
  var num_rows = get_num_rows();
  $('#tsq-values-head').attr('rowspan', num_rows + 1);
  $('#tsq').append("<tr class='tsq-value-row'></tr>");
  for (var i = 0; i < $('#tsq').attr('data-num-cols'); i++) {
    $('#tsq .tsq-value-row:last-child').append('<td></td>');
  }
  $('#tsq-del-row').removeAttr('disabled');
  refresh_table();
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

$(document).on('validate', '#tsq-type-row td', function(e, val) {
	if (val !== 'text' && val !== 'number') {
		return false;
	}
});
