// Call the dataTables jQuery plugin
$(document).on('ready', function() {
  $('#dataTable').DataTable({
    'aoColumnDefs': [{
        'bSortable': false,
        'aTargets': ['nosort']
    }]
  });
});
