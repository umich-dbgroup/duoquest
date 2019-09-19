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
      data['results'].forEach(function (result) {
        var index = $('#task-results .card').length + 1;
        var card = $(
          `<div class="card">
             <div class="card-header">
                <strong>Q${index}:</strong> ${result['query']}
                <div class="float-right">
                <button class="btn btn-primary btn-sm run-result-query" data-load-type="preview"
                 data-target="#result-${result['rid']}" data-rid=${result['rid']}>Query Preview</button>
                <button class="btn btn-success btn-sm run-result-query" data-load-type="full"
                  data-target="#result-${result['rid']}" data-rid=${result['rid']}>Full Query View</button>
                </div>
            </div>
            <div id="result-${result['rid']}" class="result-info collapse" data-parent="#task-results">
              <div id="result-${result['rid']}-spinner" class="text-center"><div class="spinner-border"></div></div>
            </div>
          `);
        $('#task-results').append(card);
        $(card).find('.collapse').collapse({
          toggle: false
        });
      });
      $('#task-results').attr('data-offset', data['results'][data['results'].length - 1]['rid']);
    }

    if (data['status'] === 'done') {
      $('#rerun-task').removeAttr('disabled');
      $('#stop-task').attr('disabled', true);
      $('#task-results-waiting').hide();

      if (data['results'].length == 0) {
        clearInterval(pollInterval);
        $('#task-results-spinner').hide();
        
        if ($('#task-results').children().length === 0) {
            $('#task-results').append(`
              <div class="alert alert-warning">Failed to find any queries.</div>
            `)
        }
      }
    } else if (data['status'] === 'error') {
      errorHandler();
      $('#rerun-task').removeAttr('disabled');
      $('#stop-task').attr('disabled', true);
    } else if (data['status'] === 'waiting') {
      $('#task-results-spinner').hide();
      $('#task-results-waiting').show();

      $('#rerun-task').attr('disabled', true);
      $('#stop-task').attr('disabled', true);
    } else if (data['status'] === 'running') {
      $('#task-results-spinner').show();
      $('#task-results-waiting').hide();
      $('#rerun-task').attr('disabled', true);
      $('#stop-task').removeAttr('disabled');
    }
  }).fail(function() {
    errorHandler();
  });
}

$(document).on('click', '.run-result-query', function (e) {
  let rid = $(this).attr('data-rid');
  let target_selector = $(this).attr('data-target');
  self = $(this)

  if (!$(this).attr('data-loaded')) {
    let url = "";
    if ($(this).attr('data-load-type') === 'preview') {
      url = `/results/${rid}/preview`;
    } else if ($(this).attr('data-load-type') === 'full') {
      url = `/results/${rid}/view`;
    }

    if (url) {
      $('.run-result-query[data-loaded]').removeAttr('data-loaded');
      $(target_selector).find('table').remove();
      $(`#result-${rid}-spinner`).show();
      $(target_selector).collapse('show');

      $.get(url, function (data) {
        data = JSON.parse(data);

        var table = $('<table class="table table-sm table-bordered"></table>');
        var header = $('<tr></tr>');
        data['header'].forEach(function(head) {
            $(header).append(`<th>${head}</th>`);
        });
        $(header).append('<th></th>');
        $(table).append(header);

        data['results'].forEach(function (row) {
          var tr = $('<tr></tr>')
          row.forEach(function (cell) {
            $(tr).append(`<td class="result-cell">${cell}</td>`);
          });
          $(tr).append('<td><button class="btn btn-success btn-sm add-result">Add to Query</button></td>')
          $(table).append(tr);
        });
        $(target_selector).append(table);
        self.attr('data-loaded', true);
        $(`#result-${rid}-spinner`).hide();
      });
    }
  } else {
    $(target_selector).collapse('toggle');
  }
});

$(document).on('click', '.add-result', function () {
  var values = [];
  $(this).parents('tr').children('.result-cell').each(function (i) {
    values.push($(this).text());
  });
  add_value_row(values);
});

$('#rerun-task').on('click', function (e) {
  e.preventDefault();
  var tid = $(this).attr('data-tid');
  $.get(`/tasks/${tid}/rerun`, function (data) {
    location.reload();
  });
});

$('#stop-task').on('click', function (e) {
  e.preventDefault();
  var tid = $(this).attr('data-tid');
  $.get(`/tasks/${tid}/stop`, function (data) {
    location.reload();
  });
});
