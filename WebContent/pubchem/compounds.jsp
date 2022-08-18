<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<script type="text/javascript">
	function compound_render(mode) {
		var summary = document.getElementById("compound-summary-heading");
		summary.innerHTML = mode + " Summary";
		var graph = document.getElementById("pubchem_compound-graph-heading");
		graph.innerHTML = mode + " Preprint Counts by Month";
		var mention = document.getElementById("compound-mention-heading");
		mention.innerHTML = mode + " Mentions";
		var footer = document.getElementById("compound-panel-footer");
		footer.innerHTML = "<a href=\"feeds/pubchem_compound.jsp?compound=" + mode
				+ "\">Export this list as JSON</a>";
		d3.html("pubchem/compound_count_by_source.jsp?compound=" + mode,
				function(fragment) {
					var divContainer = document.getElementById("compound-summary-panel");
					divContainer.innerHTML = "";
					divContainer.append(fragment);
				});

		pubchem_compound_table_load(mode);
		pubchem_compound_table_reload(mode);
		
		d3.html("tables/pubchem_compound.jsp?compound=" + mode,
				function(fragment) {
					var divContainer = document.getElementById("compound_target_table");
					divContainer.innerHTML = "";
					divContainer.append(fragment);
				});
		d3.select("#compound_mode").property("value", mode);
		$('.nav-tabs a[href="#compounds"]').tab('show');
	}
	function removeAllChildNodes(parent) {
	    while (parent.firstChild) {
	        parent.removeChild(parent.firstChild);
	    }
	}

	async function pubchem_compound_table_reload(compound) {
		const response = await fetch('feeds/pubchem_compound_by_source_count_monthly.jsp?compound=' + compound);
		var newDataArray = await response.json();
		console.log("new data", newDataArray)
		var datatable = $("#pubchem-compound-div-table").DataTable();
		datatable.clear();
		datatable.rows.add(newDataArray.rows);
		datatable.draw();
	}
</script>

<form action="index.jsp">
	<sql:query var="compounds" dataSource="jdbc/N3CCohort">
		select name as compound,count(*) from covid_pubchem.compounds_drugs_by_week group by 1 order by 2 desc;
	</sql:query>
	<label for="table">Choose a Compound:</label>
	<select name="mode" id="compound_mode" onchange="compound_render(mode.value)">
		<c:forEach items="${compounds.rows}" var="row" varStatus="rowCounter">
			<option value="${row.compound}" <c:if test="${rowCounter.first}">selected<c:set var="target" value="${row.compound}"/></c:if>>${row.compound}</option>
		</c:forEach>
	</select>
</form>

<div class="row">
	<div class="col-sm-3">
		<div class="panel panel-primary">
			<div class="panel-heading" id="compound-summary-heading">Summary</div>
			<div class="panel-body">
				<div id="compound-summary-panel">
					<jsp:include page="compound_count_by_source.jsp">
						<jsp:param value="hydroxychloroquine" name="compound"/>
					</jsp:include>
				</div>
			</div>
		</div>
	</div>
	<div class="col-sm-9">
		<div class="panel panel-primary">
			<div class="panel-heading" id="pubchem_compound-graph-heading">Publication Counts by Month</div>
			<jsp:include page="../filters/source.jsp">
				<jsp:param value="pubchem_compound_table" name="block"/>
			</jsp:include>
			<div id="pubchem_compound_timeline">
			<script type="text/javascript">
				var categorical8 = ["#09405A", "#AD1181", "#8406D1", "#ffa600", "#ff7155", "#4833B2", "#007BFF", "#a6a6a6"];

				async function pubchem_compound_table_load(compound) {
					const response = await fetch('feeds/pubchem_compound_by_source_count_monthly2.jsp?compound='+compound);
					const data = await response.json();
					for (let i = 0; i < data.length; i++) {
						data[i].date = new Date(data[i].date+"-02")
					}
					pubchem_compound_table_timeline_refresh(data);
				}
				pubchem_compound_table_load("${target}");
				
				function pubchem_compound_table_timeline_refresh(data) {
					//console.log(data); 

					var properties = {
							block: "pubchem_compound_table",
							domName: "pubchem_compound_timeline",
							legend_labels: ['biorxiv', "medrxiv", "litcovid", "pmc"],
							aspectRatio: 2,
							xaxis_label: "Month",
							yaxis_label: "Publication Count",
							constraintPropagator: pubchem_compound_table_constraint
						}

				   	d3.select("#pubchem_compound_timeline").select("svg").remove();
					TimeLineNColumnChart(data, properties);						
				}
			</script>
				<div id="pubchem_compound_timeline_save_viz"> 
					<button id='svgButton' class="btn btn-light btn-sm" onclick="saveVisualization('pubchem_compound_timeline', 'pubchem_compound_timeline.svg');">Save as SVG</button>
					<button id='pngButton' class="btn btn-light btn-sm" onclick="saveVisualization('pubchem_compound_timeline', 'pubchem_compound_timeline.pmg');">Save as PNG</button>
					<button id='jpegButton' class="btn btn-light btn-sm" onclick="saveVisualization('pubchem_compound_timeline', 'pubchem_compound_timeline.jpg');">Save as JPEG</button>
				</div>
			</div>
			<div id="pubchem_compound_wrapper">
				<div id="pubchem_compound-div"></div>
				<jsp:include page="../tables/timeline_table.jsp">
					<jsp:param name="feed" value="feeds/pubchem_compound_by_source_count_monthly.jsp?compound=${target}" />
					<jsp:param name="block" value="pubchem_compound_table" />
					<jsp:param name="target_div" value="pubchem_compound-div" />
					<jsp:param name="text_table" value="compound_table_inner" />
				</jsp:include>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading" id="compound-mention-heading">Compound
				Mentions</div>
			<div class="panel-body">
				<div id="compound_target_table">
					<jsp:include page="../tables/pubchem_compound.jsp" flush="true">
						<jsp:param value="${target}" name="compound" />
					</jsp:include>
				</div>

				<div id="compound_table" style="overflow: scroll;">&nbsp;</div>
				<div id="op_table" style="overflow: scroll;">&nbsp;</div>
			</div>
			<div class="panel-footer" id="compound-panel-footer">
				<a href="feeds/pubchem_compound.jsp?compound=${target}">Export this list as JSON</a>
			</div>
		</div>
	</div>
</div>


