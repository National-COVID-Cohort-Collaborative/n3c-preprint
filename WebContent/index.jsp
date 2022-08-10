<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<!DOCTYPE html>
<html>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

<!-- jQuery library -->
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<!-- Latest compiled JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<jsp:include page="head.jsp" flush="true" />
<link href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.js"></script>
<script src="resources/dataTables.rowsGroup.js"></script>
<script src="https://d3js.org/d3.v4.min.js"></script>
<script src="https://d3js.org/d3-selection-multi.v1.min.js"></script>
<script src="resources/he.js"></script>
<script src="resources/d3RangeSlider.js"></script>

    <link href="resources/d3RangeSlider.css" rel="stylesheet">

<style type="text/css">
table.dataTable thead .sorting_asc {
	background-image: none !important;
}
</style>

<body>
<jsp:include page="graph_support/time_line_n_column_local.jsp"/>

	<jsp:include page="navbar.jsp" flush="true" />

	<div class="container-fluid center-box">
		<h2 class="header-text">
			<img src="images/n3c_logo.png" class="n3c_logo_header" alt="N3C Logo">N3C COVID-19 Literature Exploration
		</h2>
		<div style="text-align: center;">
			This is an initial configuration of an exploration tool for mentions of entities of interest (drugs,
			genes, etc.) <br>appearing in the literature involving COVID-19. All data are drawn from
			the sources in the tile on the top left.
			<br> You are encouraged to submit suggestions for
			enhancements/additions.
		</div>
		<p>&nbsp;</p>
		<ul class="nav nav-tabs" style="font-size: 16px;">
			<li class="active"><a data-toggle="tab" href="#home">Home</a></li>
			<li><a data-toggle="tab" href="#ncats_drugs">NCATS Drugs of Interest</a></li>
			<li><a data-toggle="tab" href="#drugs">N3C Drugs</a></li>
			<li><a data-toggle="tab" href="#compounds">PubChem Compounds</a></li>
			<li><a data-toggle="tab" href="#genes">PubChem Genes</a></li>
			<li><a data-toggle="tab" href="#proteins">PubChem Proteins</a></li>
			<li><a data-toggle="tab" href="#substances">PubChem Substances</a></li>
		</ul>

		<div class="tab-content">
			<div class="tab-pane fade in active" id="home">
				<jsp:include page="home.jsp" flush="true" />
			</div>
			
			<div class="tab-pane fade" id="ncats_drugs">
				<jsp:include page="ncats/index.jsp" flush="true" />
			</div>

			<div class="tab-pane fade" id="drugs">
				<jsp:include page="n3c/index.jsp" flush="true" />
			</div>

			<div class="tab-pane fade" id="compounds">
				<jsp:include page="pubchem/compounds.jsp" flush="true" />
			</div>

			<div class="tab-pane fade" id="genes">
				<jsp:include page="pubchem/genes.jsp" flush="true" />
			</div>

			<div class="tab-pane fade" id="proteins">
				<jsp:include page="pubchem/proteins.jsp" flush="true" />
			</div>

			<div class="tab-pane fade" id="substances">
				<jsp:include page="pubchem/substances.jsp" flush="true" />
			</div>
		</div>

		<jsp:include page="footer.jsp" flush="true" />
	</div>
</body>
</html>
