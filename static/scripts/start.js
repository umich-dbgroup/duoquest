$('#start').on('submit', function(e) {
  $("<input />").attr("type", "hidden")
          .attr("name", "num_cols")
          .attr("value", parseInt($('#tsq').attr('data-num-cols')))
          .appendTo("#start");

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
          .appendTo("#start");
  $("<input />").attr("type", "hidden")
          .attr("name", "values")
          .attr("value", JSON.stringify(values))
          .appendTo("#start");
  return true;
});
