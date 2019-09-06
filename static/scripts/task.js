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

  $.get(`/tasks/${tid}/results`, {offset: offset}, function (data) {
    data = JSON.parse(data);

    $('#task-results').attr('data-status', data['status']);

    if (data['results'].length > 0) {
      data['results'].forEach(function (result) {
        $('#task-results').append(`<li class="list-group-item">${result['query']}</li>`)
      });
      $('#task-results').attr('data-offset', data['results'][data['results'].length - 1]['rid']);
    }

    if (data['status'] === 'done') {
      clearInterval(pollInterval);
      $('#task-results-spinner').hide();
      $('#task-results-waiting').hide();
    } else if (data['status'] === 'error') {
      errorHandler();
    } else if (data['status'] === 'waiting') {
      $('#task-results-spinner').hide();
      $('#task-results-waiting').show();
    } else if (data['status'] === 'running') {
      $('#task-results-spinner').show();
      $('#task-results-waiting').show();
    }
  }).fail(function() {
    errorHandler();
  });
}
