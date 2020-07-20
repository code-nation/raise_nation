// Call the dataTables jQuery plugin
$(document).on('turbolinks:load', function() {
  $('#dataTable').DataTable({
    'aoColumnDefs': [{
        'bSortable': false,
        'aTargets': ['nosort']
    }]
  });
});
