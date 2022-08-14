<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<div class="panel-body">
	<h6>Source</h6>
	<select id="${param.block}-source-select" multiple="multiple">
		<option value="medrxiv">MedRxiv</option>
		<option value="biorxiv">BioRxiv</option>
		<option value="litcovid">LitCovid</option>
		<option value="pmc">PMC</option>
	</select>
	<button onclick="$('#${param.block}-source-select').multiselect('deselectAll', false); ${param.block}_constrain_table([]);">Clear</button>
</div>
<script type="text/javascript">
$(document).ready(function() {
	$('#${param.block}-source-select').multiselect({	
		onChange: function(option, checked, select) {
			var options = $('#${param.block}-source-select');
	        var selected = [];
	        $(options).each(function(){
	            selected.push($(this).val());
	        });
	        //console.log("selected", selected)
			${param.block}_constrain_table(selected[0]);
	    }
	});
});

function ${param.block}_viz_constrain(element) {
	var options = $("#${param.block}-source-select");
    var selected = [];
    
    $(options).each(function(){
        selected.push($(this).val());
    });
        
    //console.log("call selected", selected);
	if (selected[0].includes( element)){
		$("#${param.block}-source-select").multiselect('deselect', $("#${param.block}-source-select option[value='" + element + "']").val(), true);
	} else {
		$("#${param.block}-source-select").multiselect('select', $("#${param.block}-source-select option[value='" + element + "']").val(), true);
	}
}

</script>
