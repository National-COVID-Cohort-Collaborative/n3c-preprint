<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<script>

function ${param.block}_constrain_table(filter) {
	var table = $('#${param.target_div}-table').DataTable();
	console.log("filter",filter)
	switch (filter) {
	case 'medrxiv':
        var column = table.column(1);
        column.visible(!column.visible());
		break;
	case 'biorxiv':
        var column = table.column(2);
        column.visible(!column.visible());
		break;
	case 'litcovid':
        var column = table.column(3);
        column.visible(!column.visible());
		break;
	case 'pmc':
        var column = table.column(4);
        column.visible(!column.visible());
		break;
	}
	
 }

var ${param.block}_datatable = null;

$.getJSON("<util:applicationRoot/>/${param.feed}", function(data){
	var json = $.parseJSON(JSON.stringify(data));
	console.log("json",json)

	var col = [];

	for (i in json['headers']){
		col.push(json['headers'][i]['label']);
	}


	var table = document.createElement("table");
	table.className = 'table table-hover compact site-wrapper';
	table.style.width = '100%';
	table.id="${param.target_div}-table";

	var header= table.createTHead();
	var header_row = header.insertRow(0); 

	for (i in col) {
		var th = document.createElement("th");
		th.innerHTML = '<span style="color:#333; font-weight:600; font-size:14px;">' + col[i].toString() + '</span>';
		header_row.appendChild(th);
	}

	var divContainer = document.getElementById("${param.target_div}");
	divContainer.appendChild(table);

	var data = json['rows'];

	${param.block}_datatable = $('#${param.target_div}-table').DataTable( {
    	data: data,
    	dom: 'lfr<"datatable_overflow"t>Bip',
        	paging: true,
       	snapshot: null,
       	initComplete: function( settings, json ) {
       	 	settings.oInit.snapshot = $('#${param.target_div}-table').DataTable().rows({order: 'index'}).data().toArray().toString();
       	  },
    	pageLength: 10,
    	lengthMenu: [ 10, 25, 50, 75, 100 ],
    	order: [[0, 'desc']],
     	columns: [
        	{ data: 'month', visible: true, orderable: true },
        	{ data: 'medrxiv', visible: true, orderable: true },
        	{ data: 'biorxiv', visible: true, orderable: true },
        	{ data: 'litcovid', visible: true, orderable: true },
        	{ data: 'pmc', visible: true, orderable: true }
    	]
	} );

	// this is necessary to populate the histograms for the panel's initial D3 rendering
	//${param.block}_refreshHistograms();
	//${param.block}_medication_ts_refresh();

	
});

</script>
