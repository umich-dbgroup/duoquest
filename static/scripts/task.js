pollResults();
var pollInterval = setInterval(pollResults, 1000);

function errorHandler() {
  clearInterval(pollInterval);
  $('#task-results-error').show();
  $('#task-results-spinner').hide();
  $('#task-results-waiting').hide();
}

function pollResults() {
  var tid = $('#task-results').attr('data-tid');
  var offset = $('#task-results').attr('data-offset');

  $.get(`/tasks/${tid}/results`, {offset: offset}, function (data, i) {
    data = JSON.parse(data);

    $('#task-results').attr('data-status', data['status']);

    if (data['results'].length > 0) {
      data['results'].forEach(function (result, j) {
        var index = j + parseInt(offset) + 1;
        var card = $(
          `<div class="card">
             <div class="card-header">
                <strong>Q${index}:</strong> ${result['query']}
                <button class="btn btn-primary float-right btn-sm run-result-query"
                 data-toggle="collapse" data-target="#result-${result['rid']}" data-rid=${result['rid']}>Query Preview</button>
            </div>
            <div id="result-${result['rid']}" class="result-info collapse" data-parent="#task-results">
              <div id="result-${result['rid']}-spinner" class="text-center"><div class="spinner-border"></div></div>
            </div>
          `);
        $('#task-results').append(card);
        $(card).find('.collapse').collapse({ toggle: false });
      });
      $('#task-results').attr('data-offset', data['results'][data['results'].length - 1]['rid']);
    }

    if (data['status'] === 'done') {
      clearInterval(pollInterval);
      $('#task-results-spinner').hide();
      $('#task-results-waiting').hide();
      if ($('#task-results').children().length === 0) {
          $('#task-results').append(`
            <div class="alert alert-info">Failed to find any queries.</div>
          `)
      }
    } else if (data['status'] === 'error') {
      errorHandler();
    } else if (data['status'] === 'waiting') {
      $('#task-results-spinner').hide();
      $('#task-results-waiting').show();
    } else if (data['status'] === 'running') {
      $('#task-results-spinner').show();
      $('#task-results-waiting').hide();
    }
  }).fail(function() {
    errorHandler();
  });
}

$(document).on('click', '.run-result-query', function () {
  if (!$(this).attr('data-loaded')) {
    var rid = $(this).attr('data-rid');
    var target_selector = $(this).attr('data-target');
    self = $(this)

    $.get(`/results/${rid}/preview`, function (data) {
      data = JSON.parse(data);

      var table = $('<table class="table table-sm table-bordered"></table>');
      var header = $('<tr></tr>');
      data['header'].forEach(function(head) {
          $(header).append(`<th>${head}</th>`);
      });
      $(table).append(header);

      data['results'].forEach(function (row) {
        var tr = $('<tr></tr>')
        row.forEach(function (cell) {
          $(tr).append(`<td>${cell}</td>`);
        });
        $(table).append(tr);
      });
      $(target_selector).append(table);
      self.attr('data-loaded', true);
    });
    $(`#result-${rid}-spinner`).hide();
  }
});
