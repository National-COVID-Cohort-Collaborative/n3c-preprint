<script>
$.getJSON("feeds/pubchem_protein.jsp?protein=${param.protein}", function(data){
		
	var json = $.parseJSON(JSON.stringify(data));

	var col = [];

	for (i in json['headers']){
		col.push(json['headers'][i]['label']);
	}


	var table = document.createElement("table");
	table.className = 'table table-hover';
	table.style.width = '100%';
	table.id="protein_table_inner";

	var header= table.createTHead();
	var header_row = header.insertRow(0); 

	for (i in col) {
		var th = document.createElement("th");
		th.innerHTML = '<span style="color:#333; font-weight:600; font-size:16px;">' + col[i].toString() + '</span>';
		header_row.appendChild(th);
	}

	var divContainer = document.getElementById("protein_table");
	divContainer.innerHTML = "<h3>${param.protein}</h3>";
	divContainer.appendChild(table);

	var data = json['rows'];

	$('#protein_table_inner').DataTable( {
    	data: data,
       	paging: true,
    	pageLength: 10,
    	lengthMenu: [ 10, 25, 50, 75, 100 ],
    	order: [[0, 'asc'],[1, 'asc']],
     	columns: [
        	{ data: 'title',
          	  orderable: true,
          	  width: "40%",
          	  render: function ( data, type, row ) {
          		return '<a href="'+row.url+'"><span style="color:#376076">'+row.title+'</span></a>';
               	}
               },
       		{ data: 'section', visible: true, orderable: true },
        	{ data: 'sentence',
        	  orderable: true,
       		  allowHTML: true
             },
       		{ data: 'source', visible: true, orderable: true },
       		{ data: 'week', visible: true, orderable: true }
    	],
    	rowsGroup:  [0,1],	
    initComplete: function () {
        this.api().columns().every( function () {
            var column = this;
            if  (column.index() != 1 && column.index() != 3)
            	return;
            var select = $('<br/><select><option value=""></option></select>')
                .appendTo( $(column.header()) )
                .on( 'change', function () {
                    var val = $.fn.dataTable.util.escapeRegex(
                        $(this).val()
                    );

                    column
                        .search( val ? '^'+val+'$' : '', true, false )
                        .draw();
                } );

            column.data().unique().sort().each( function ( d, j ) {
                select.append( '<option value="'+d+'">'+d+'</option>' )
            } );
        } );
    }
	} );
});
</script>
