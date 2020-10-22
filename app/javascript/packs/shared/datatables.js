// Call the dataTables jQuery plugin
$(document).on('turbolinks:load', function() {
  $('.raise-nation-datatable').DataTable({
    'aoColumnDefs': [{
        'bSortable': false,
        'aTargets': ['nosort']
    }]
  });
});
