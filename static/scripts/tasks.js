$('.rerun-task:not([disabled])').on('click', function() {
  var tid = $(this).attr('data-tid');
  $.get(`/tasks/${tid}/rerun`, function () {
      location.reload();
  });
});

$('.del-task:not([disabled])').on('click', function() {
  var tid = $(this).attr('data-tid');
  $.get(`/tasks/${tid}/delete`, function () {
      location.reload();
  });
});
