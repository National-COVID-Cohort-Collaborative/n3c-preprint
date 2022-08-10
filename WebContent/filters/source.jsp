<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<div class="panel-body">
	<h6>Source</h6>
	<select id="block-source-select" multiple="multiple">
		<option value="medrxiv">MedRxiv</option>
		<option value="biorxiv">BioRxiv</option>
		<option value="litcovid">LitCovid</option>
		<option value="pmc">PMC</option>
	</select>
</div>
<script type="text/javascript">
$(document).ready(function() {
    $('#block-source-select').multiselect();
    console.log("intialized")
});
</script>
