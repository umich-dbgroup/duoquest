$(document).on('click', '.del-fkpk', function (e) {
  e.preventDefault();
  $(this).parents('tr').remove();
});

$('.add-fkpk-input').on('keypress', function (e) {
    if (e.which == 13) { // ENTER
      e.preventDefault();
      $('.add-fkpk').trigger('click');
      $('#add-fkpk-fk').focus();
    }
});

$('.add-fkpk').on('click', function (e) {
  e.preventDefault();
  var fk = $('#add-fkpk-fk').val();
  var pk = $('#add-fkpk-pk').val();

  if (fk && pk) {
    $(this).parents('tr').before(`<tr class='fkpk-row'>
      <td class='fkpk-row-fk'>${fk}</td>
      <td class='fkpk-row-pk'>${pk}</td>
      <td><button class='del-fkpk btn btn-sm btn-danger'>Delete</button></td>
      </tr>`);
    $('#add-fkpk-fk').val('');
    $('#add-fkpk-pk').val('');
  }
});

$('#fkpk-form').on('submit', function (e) {
  var fkpks = [];
  $('.fkpk-row').each(function () {
    var fk = parseInt($(this).children('.fkpk-row-fk').text());
    var pk = parseInt($(this).children('.fkpk-row-pk').text());
    fkpks.push([fk, pk]);
  });

  fkpks = JSON.stringify(fkpks);
  $("<input />").attr("type", "hidden")
          .attr("name", "fkpks")
          .attr("value", fkpks)
          .appendTo("#fkpk-form");
  return true;
});
