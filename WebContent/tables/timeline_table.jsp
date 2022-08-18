<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<script>

function ${param.block}_constrain_table(filter) {
	var table = $('#${param.target_div}-table').DataTable();
	console.log("filter",filter)
	if (filter.length > 0) {
		table.column(1).visible(filter.includes('medrxiv'));
		table.column(2).visible(filter.includes('biorxiv'));
		table.column(3).visible(filter.includes('litcovid'));
		table.column(4).visible(filter.includes('pmc'));
	} else {
		table.column(1).visible(true);
		table.column(2).visible(true);
		table.column(3).visible(true);
		table.column(4).visible(true);		
	}

	<c:if test="${not empty param.text_table}">
		var join = (filter.length == 0 ? "" : ("^" + filter.join("|") + "$"));
		console.log("join", join)
		var textTable = $('#${param.text_table}').DataTable();
		textTable.column(3).search(join, true, false, true).draw();	
	</c:if>

	var data = table.data().toArray();
	//console.log("current data", data, table.column(1).visible())
	var constrainedData = new Array();
	for (let i = 0; i < data.length; i++) { 
		var obj = new Object();
	    Object.defineProperty(obj, 'date', {
  			value: new Date(data[i].month + "-02") // the -02 is to fake out the timezone calculations in D3
	    });
	    var elements = new Object();
	    if (table.column(1).visible()) {
		    Object.defineProperty(elements, 'medrxiv', {
		    	value: data[i].medrxiv
		    });	    	
	    }
	    if (table.column(2).visible()) {
		    Object.defineProperty(elements, 'biorxiv', {
		    	value: data[i].biorxiv
		    });	    	
	    }
	    if (table.column(3).visible()) {
		    Object.defineProperty(elements, 'litcovid', {
		    	value: data[i].litcovid
		    });	    	
	    }
	    if (table.column(4).visible()) {
		    Object.defineProperty(elements, 'pmc', {
		    	value: data[i].pmc
		    });	    	
	    }
	    Object.defineProperty(obj, 'elements', {
	    	value: elements
	    });
	    constrainedData.push(obj);
	}

	constrainedData.sort((a,b) => (a.month > b.month) ? 1 : ((b.month > a.month) ? -1 : 0));
	//console.log("refreshed array", constrainedData);
	${param.block}_timeline_refresh(constrainedData);
}

var ${param.block}_constraint_begin = null,
	${param.block}_constraint_end = null;

function ${param.block}_constraint(begin, end) {
	//console.log("constraint", begin, end)
	${param.block}_constraint_begin = begin;
	${param.block}_constraint_end = end;
	var table = $('#${param.target_div}-table').DataTable();
	table.draw();
	<c:if test="${not empty param.text_table}">
		var textTable = $('#${param.text_table}').DataTable();
		textTable.draw();
	</c:if>
}

$(document).ready( function () {
	$.fn.dataTable.ext.search.push(
		    function( settings, searchData, index, rowData, counter ) {
		    	if (${param.block}_constraint_begin == null)
		    		return true;
		    	 if ('${param.target_div}-table' === settings.sTableId) {
		    		 if (${param.block}_constraint_begin <= searchData[0] && searchData[0] <= ${param.block}_constraint_end)
			    		return true;
		    	 } else {
		    		 if (${param.block}_constraint_begin <= searchData[4] && searchData[4] <= ${param.block}_constraint_end)
				    	return true;		    		 
		    	 }
		    	
		    	return false;
		    }
		);
});

var ${param.block}_datatable = null;

$.getJSON("<util:applicationRoot/>/${param.feed}", function(data){
	var json = $.parseJSON(JSON.stringify(data));
	//console.log("json",json)

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
    	buttons: {
    	    dom: {
    	      button: {
    	        tag: 'button',
    	        className: ''
    	      }
    	    },
    	    buttons: [{
    	      extend: 'csv',
    	      className: 'btn btn-sm btn-light',
    	      titleAttr: 'CSV export.',
    	      exportOptions: {
                  columns: ':visible'
              },
    	      text: 'CSV',
    	      filename: 'timeline',
    	      extension: '.csv'
    	    }, {
    	      extend: 'copy',
    	      className: 'btn btn-sm btn-light',
    	      titleAttr: 'Copy table data.',
    	      exportOptions: {
                  columns: ':visible'
              },
    	      text: 'Copy'
    	    }]
    	},
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
