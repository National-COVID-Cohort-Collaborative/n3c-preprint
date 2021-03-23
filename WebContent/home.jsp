<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<div class="row">
	<div class="col-sm-3">
		<div class="panel panel-primary">
			<div class="panel-heading">Summary</div>
			<div class="panel-body">
				<div id="home_summary">
				<sql:query var="elements" dataSource="jdbc/N3CCohort">
					select * from
					(select site as description,to_char(count(*),'FM999,999') as count from covid_biorxiv.biorxiv_current group by 1
					union
					select 'LitCovid' as description,to_char(count(*),'FM999,999') as count from covid_litcovid.article
					union
					select 'PubMed Central' as description, to_char(count(*),'FM999,999') as count from covid_pmc.xml
					) as foo
					order by description
				</sql:query>
				
				<c:forEach items="${elements.rows}" var="row" varStatus="rowCounter">
					<c:if test="${rowCounter.first}">
						<table  class="table">
						<tr><th>Source</th><th># COVID-19 Publications</th></tr>
					</c:if>
					<tr><td>${row.description}</td><td>${row.count}</td></tr>
					<c:if test="${rowCounter.last}">
						</table>
						<p>Last Updated: ${row.last_update}</p>
					</c:if>
				</c:forEach>
				</div>
			</div>
		</div>
	</div>
	<div class="col-sm-9">
		<div class="panel panel-primary">
			<div class="panel-heading">Publication Counts by Week</div>
			<div class="panel-body">
				<div id="home-line-wrapper"></div>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-sm-6">
		<div class="panel panel-primary">
			<div class="panel-heading">NCATS Drugs of Interest by # Mentioning Publications</div>
			<div class="panel-body" style="height:613px; overflow-y:auto; ">
				<p>Click on a drug or its bar to display mentions. Scroll to see the full histogram.</p>
				<div id="ncats_drugs_distinct"></div>
			</div>
		</div>
	</div>
	<div class="col-sm-4">
		<div class="panel panel-primary">
			<div class="panel-heading">N3C Drugs by # Mentioning Preprints</div>
			<div class="panel-body">
				<p>Click on a drug or its bar to display mentions.</p>
				<div id="drugs_distinct"></div>
			</div>
		</div>
	</div>
	<div class="col-sm-6">
		<div class="panel panel-primary">
			<div class="panel-heading">PubChem Compounds by # Mentioning Preprints</div>
			<div class="panel-body" style="height:613px; overflow-y:auto; ">
				<p>Click on a compound or its bar to display mentions. Scroll to see the full histogram.</p>
				<div id="compounds_distinct"></div>
			</div>
		</div>
	</div>
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading">PubChem Genes by # Mentioning Preprints</div>
			<div class="panel-body"  style="height:613px; overflow-y:auto; ">
				<p>Click on a gene or its bar to display mentions. Scroll to see the full histogram.</p>
				<div id="genes_distinct"></div>
			</div>
		</div>
	</div>
	<div class="col-sm-9">
		<div class="panel panel-primary">
			<div class="panel-heading">PubChem Proteins by # Mentioning Preprints</div>
			<div class="panel-body">
				<p>Click on a protein or its bar to display mentions.</p>
				<div id="proteins_distinct"></div>
			</div>
		</div>
	</div>
	<div class="col-sm-3">
		<div class="panel panel-primary">
			<div class="panel-heading">PubChem Substances by # Mentioning Preprints</div>
			<div class="panel-body">
				<p>Click on a substance or its bar to display mentions.</p>
				<div id="substances_distinct"></div>
			</div>
		</div>
	</div>
</div>

<jsp:include page="graph_support/multiline.jsp">
	<jsp:param name="data_page" value="feeds/total_by_source_count_weekly.jsp" />
	<jsp:param name="dom_element" value="#home-line-wrapper" />
</jsp:include>

<jsp:include page="graph_support/verticalBarChart.jsp">
	<jsp:param name="data_page" value="feeds/ncats_drugs_distinct_count.jsp" />
	<jsp:param name="dom_element" value="#ncats_drugs_distinct" />
	<jsp:param name="entity" value="ncats_drug" />
</jsp:include>

<jsp:include page="graph_support/verticalBarChart.jsp">
	<jsp:param name="data_page" value="feeds/n3c_drugs_distinct_count.jsp" />
	<jsp:param name="dom_element" value="#drugs_distinct" />
	<jsp:param name="entity" value="drug" />
</jsp:include>

<jsp:include page="graph_support/verticalBarChart.jsp">
	<jsp:param name="data_page" value="feeds/pubchem_compounds_distinct_count.jsp" />
	<jsp:param name="dom_element" value="#compounds_distinct" />
	<jsp:param name="entity" value="compound" />
</jsp:include>

<jsp:include page="graph_support/verticalBarChart.jsp">
	<jsp:param name="data_page" value="feeds/pubchem_genes_distinct_count.jsp" />
	<jsp:param name="dom_element" value="#genes_distinct" />
	<jsp:param name="entity" value="gene" />
</jsp:include>

<jsp:include page="graph_support/verticalBarChart.jsp">
	<jsp:param name="data_page" value="feeds/pubchem_proteins_distinct_count.jsp" />
	<jsp:param name="dom_element" value="#proteins_distinct" />
	<jsp:param name="entity" value="protein" />
</jsp:include>

<jsp:include page="graph_support/verticalBarChart.jsp">
	<jsp:param name="data_page" value="feeds/pubchem_substances_distinct_count.jsp" />
	<jsp:param name="dom_element" value="#substances_distinct" />
	<jsp:param name="entity" value="substance" />
</jsp:include>
