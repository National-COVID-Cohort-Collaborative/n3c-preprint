<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<script type="text/javascript">
	function substance_render(mode) {
		var summary = document.getElementById("substance-summary-heading");
		summary.innerHTML = mode + " Summary";
		var graph = document.getElementById("pubchem_substance-graph-heading");
		graph.innerHTML = mode + " Preprint Counts by Month";
		var mention = document.getElementById("substance-mention-heading");
		mention.innerHTML = mode + " Mentions";
		var footer = document.getElementById("substance-panel-footer");
		footer.innerHTML = "<a href=\"feeds/pubchem_substance.jsp?substance=" + mode
				+ "\">Export this list as JSON</a>";
		d3.html("pubchem/substance_count_by_source.jsp?substance=" + mode,
				function(fragment) {
					var divContainer = document.getElementById("substance-summary-panel");
					divContainer.innerHTML = "";
					divContainer.append(fragment);
				});

		pubchem_substance_table_load(mode);
		pubchem_substance_table_reload(mode);
		
		d3.html("tables/pubchem_substance.jsp?substance=" + mode,
				function(fragment) {
					var divContainer = document.getElementById("substance_target_table");
					divContainer.innerHTML = "";
					divContainer.append(fragment);
				});
		d3.select("#substance_mode").property("value", mode);
		$('.nav-tabs a[href="#substances"]').tab('show');
	}
	function removeAllChildNodes(parent) {
	    while (parent.firstChild) {
	        parent.removeChild(parent.firstChild);
	    }
	}

	async function pubchem_substance_table_reload(substance) {
		const response = await fetch('feeds/pubchem_substance_by_source_count_monthly.jsp?substance=' + substance);
		var newDataArray = await response.json();
		console.log("new data", newDataArray)
		var datatable = $("#pubchem-substance-div-table").DataTable();
		datatable.clear();
		datatable.rows.add(newDataArray.rows);
		datatable.draw();
	}
</script>

<form action="index.jsp">
	<sql:query var="substances" dataSource="jdbc/N3CCohort">
		select name as substance,count(*) from covid_pubchem.substances_drugs_by_week group by 1 order by 2 desc;
	</sql:query>
	<label for="table">Choose a Compound:</label>
	<select name="mode" id="substance_mode" onchange="substance_render(mode.value)">
		<c:forEach items="${substances.rows}" var="row" varStatus="rowCounter">
			<option value="${row.substance}" <c:if test="${rowCounter.first}">selected<c:set var="target" value="${row.substance}"/></c:if>>${row.substance}</option>
		</c:forEach>
	</select>
</form>

<div class="row">
	<div class="col-sm-3">
		<div class="panel panel-primary">
			<div class="panel-heading" id="substance-summary-heading">Summary</div>
			<div class="panel-body">
				<div id="substance-summary-panel">
					<jsp:include page="substance_count_by_source.jsp">
						<jsp:param value="hydroxychloroquine" name="substance"/>
					</jsp:include>
				</div>
			</div>
		</div>
	</div>
	<div class="col-sm-9">
		<div class="panel panel-primary">
			<div class="panel-heading" id="pubchem_substance-graph-heading">Publication Counts by Month</div>
			<jsp:include page="../filters/source.jsp">
				<jsp:param value="pubchem_substance_table" name="block"/>
			</jsp:include>
			<div id="pubchem_substance_timeline">
			<script type="text/javascript">
				var categorical8 = ["#09405A", "#AD1181", "#8406D1", "#ffa600", "#ff7155", "#4833B2", "#007BFF", "#a6a6a6"];

				async function pubchem_substance_table_load(substance) {
					const response = await fetch('feeds/pubchem_substance_by_source_count_monthly2.jsp?substance='+substance);
					const data = await response.json();
					for (let i = 0; i < data.length; i++) {
						data[i].date = new Date(data[i].date+"-02")
					}
					pubchem_substance_table_timeline_refresh(data);
				}
				pubchem_substance_table_load("${target}");
				
				function pubchem_substance_table_timeline_refresh(data) {
					//console.log(data); 

					var properties = {
							block: "pubchem_substance_table",
							domName: "pubchem_substance_timeline",
							legend_labels: ['biorxiv', "medrxiv", "litcovid", "pmc"],
							aspectRatio: 2,
							xaxis_label: "Month",
							yaxis_label: "Publication Count",
							constraintPropagator: pubchem_substance_table_constraint
						}

				   	d3.select("#pubchem_substance_timeline").select("svg").remove();
					TimeLineNColumnChart(data, properties);						
				}
			</script>
			</div>
			<div id="pubchem_substance_wrapper">
				<div id="pubchem_substance-div"></div>
				<jsp:include page="../tables/timeline_table.jsp">
					<jsp:param name="feed" value="feeds/pubchem_substance_by_source_count_monthly.jsp?substance=${target}" />
					<jsp:param name="block" value="pubchem_substance_table" />
					<jsp:param name="target_div" value="pubchem_substance-div" />
					<jsp:param name="text_table" value="substance_table_inner" />
				</jsp:include>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading" id="substance-mention-heading">Compound
				Mentions</div>
			<div class="panel-body">
				<div id="substance_target_table">
					<jsp:include page="../tables/pubchem_substance.jsp" flush="true">
						<jsp:param value="${target}" name="substance" />
					</jsp:include>
				</div>

				<div id="substance_table" style="overflow: scroll;">&nbsp;</div>
				<div id="op_table" style="overflow: scroll;">&nbsp;</div>
			</div>
			<div class="panel-footer" id="substance-panel-footer">
				<a href="feeds/pubchem_substance.jsp?substance=${target}">Export this list as JSON</a>
			</div>
		</div>
	</div>
</div>


