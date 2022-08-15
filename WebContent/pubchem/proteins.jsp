<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<script type="text/javascript">
	function protein_render(mode) {
		var summary = document.getElementById("protein-summary-heading");
		summary.innerHTML = mode + " Summary";
		var graph = document.getElementById("pubchem_protein-graph-heading");
		graph.innerHTML = mode + " Preprint Counts by Month";
		var mention = document.getElementById("protein-mention-heading");
		mention.innerHTML = mode + " Mentions";
		var footer = document.getElementById("protein-panel-footer");
		footer.innerHTML = "<a href=\"feeds/pubchem_protein.jsp?protein=" + mode
				+ "\">Export this list as JSON</a>";
		d3.html("pubchem/protein_count_by_source.jsp?protein=" + mode,
				function(fragment) {
					var divContainer = document.getElementById("protein-summary-panel");
					divContainer.innerHTML = "";
					divContainer.append(fragment);
				});

		pubchem_protein_table_load(mode);
		pubchem_protein_table_reload(mode);
		
		d3.html("tables/pubchem_protein.jsp?protein=" + mode,
				function(fragment) {
					var divContainer = document.getElementById("protein_target_table");
					divContainer.innerHTML = "";
					divContainer.append(fragment);
				});
		d3.select("#protein_mode").property("value", mode);
		$('.nav-tabs a[href="#proteins"]').tab('show');
	}
	function removeAllChildNodes(parent) {
	    while (parent.firstChild) {
	        parent.removeChild(parent.firstChild);
	    }
	}

	async function pubchem_protein_table_reload(protein) {
		const response = await fetch('feeds/pubchem_protein_by_source_count_monthly.jsp?protein=' + protein);
		var newDataArray = await response.json();
		console.log("new data", newDataArray)
		var datatable = $("#pubchem-protein-div-table").DataTable();
		datatable.clear();
		datatable.rows.add(newDataArray.rows);
		datatable.draw();
	}
</script>

<form action="index.jsp">
	<sql:query var="proteins" dataSource="jdbc/N3CCohort">
		select name as protein,count(*) from covid_pubchem.proteins_drugs_by_week group by 1 order by 2 desc;
	</sql:query>
	<label for="table">Choose a Compound:</label>
	<select name="mode" id="protein_mode" onchange="protein_render(mode.value)">
		<c:forEach items="${proteins.rows}" var="row" varStatus="rowCounter">
			<option value="${row.protein}" <c:if test="${rowCounter.first}">selected<c:set var="target" value="${row.protein}"/></c:if>>${row.protein}</option>
		</c:forEach>
	</select>
</form>

<div class="row">
	<div class="col-sm-3">
		<div class="panel panel-primary">
			<div class="panel-heading" id="protein-summary-heading">Summary</div>
			<div class="panel-body">
				<div id="protein-summary-panel">
					<jsp:include page="protein_count_by_source.jsp">
						<jsp:param value="hydroxychloroquine" name="protein"/>
					</jsp:include>
				</div>
			</div>
		</div>
	</div>
	<div class="col-sm-9">
		<div class="panel panel-primary">
			<div class="panel-heading" id="pubchem_protein-graph-heading">Publication Counts by Month</div>
			<jsp:include page="../filters/source.jsp">
				<jsp:param value="pubchem_protein_table" name="block"/>
			</jsp:include>
			<div id="pubchem_protein_timeline">
			<script type="text/javascript">
				var categorical8 = ["#09405A", "#AD1181", "#8406D1", "#ffa600", "#ff7155", "#4833B2", "#007BFF", "#a6a6a6"];

				async function pubchem_protein_table_load(protein) {
					const response = await fetch('feeds/pubchem_protein_by_source_count_monthly2.jsp?protein='+protein);
					const data = await response.json();
					for (let i = 0; i < data.length; i++) {
						data[i].date = new Date(data[i].date+"-02")
					}
					pubchem_protein_table_timeline_refresh(data);
				}
				pubchem_protein_table_load("${target}");
				
				function pubchem_protein_table_timeline_refresh(data) {
					//console.log(data); 

					var properties = {
							block: "pubchem_protein_table",
							domName: "pubchem_protein_timeline",
							legend_labels: ['biorxiv', "medrxiv", "litcovid", "pmc"],
							aspectRatio: 2,
							xaxis_label: "Month",
							yaxis_label: "Publication Count",
							constraintPropagator: pubchem_protein_table_constraint
						}

				   	d3.select("#pubchem_protein_timeline").select("svg").remove();
					TimeLineNColumnChart(data, properties);						
				}
			</script>
			</div>
			<div id="pubchem_protein_wrapper">
				<div id="pubchem_protein-div"></div>
				<jsp:include page="../tables/timeline_table.jsp">
					<jsp:param name="feed" value="feeds/pubchem_protein_by_source_count_monthly.jsp?protein=${target}" />
					<jsp:param name="block" value="pubchem_protein_table" />
					<jsp:param name="target_div" value="pubchem_protein-div" />
					<jsp:param name="text_table" value="protein_table_inner" />
				</jsp:include>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading" id="protein-mention-heading">Compound
				Mentions</div>
			<div class="panel-body">
				<div id="protein_target_table">
					<jsp:include page="../tables/pubchem_protein.jsp" flush="true">
						<jsp:param value="${target}" name="protein" />
					</jsp:include>
				</div>

				<div id="protein_table" style="overflow: scroll;">&nbsp;</div>
				<div id="op_table" style="overflow: scroll;">&nbsp;</div>
			</div>
			<div class="panel-footer" id="protein-panel-footer">
				<a href="feeds/pubchem_protein.jsp?protein=${target}">Export this list as JSON</a>
			</div>
		</div>
	</div>
</div>


