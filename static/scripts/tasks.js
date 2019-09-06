$('.rerun:enabled').on('click', function() {
  var tid = $(this).attr('data-tid');
  $.get(`/tasks/${tid}/rerun`, function () {
      location.reload();
  });
});
