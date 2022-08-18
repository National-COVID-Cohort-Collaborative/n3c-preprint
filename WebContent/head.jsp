<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<head>
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-136610069-2"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-136610069-2');
</script>
	 <meta charset="utf-8">
	 <meta http-equiv="X-UA-Compatible" content="IE=edge">
     <meta name="viewport" content="width=device-width, initial-scale=1">
	 <title>N3C COVID-19 Preprint Explorer</title>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

	<!-- bootstrap CSS -->
	<link href="<util:applicationRoot/>/resources/bootstrap/css/bootstrap.css" rel="stylesheet" >
	<script src="<util:applicationRoot/>/resources/anime.min.js"></script>

	<!-- jQuery library -->
	<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script>$.ajaxPrefilter(function( options, originalOptions, jqXHR ) {    options.async = true; });</script>	
	
	<!-- bootstrap Latest compiled JavaScript -->
	<script type='text/javascript' src='<util:applicationRoot/>/resources/bootstrap/js/bootstrap.bundle.min.js '></script>
	
	<!-- bootstrap multiselect support -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/1.1.1/js/bootstrap-multiselect.min.js" integrity="sha512-fp+kGodOXYBIPyIXInWgdH2vTMiOfbLC9YqwEHslkUxc8JLI7eBL2UQ8/HbB5YehvynU3gA3klc84rAQcTQvXA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/1.1.1/css/bootstrap-multiselect.min.css" integrity="sha512-jpey1PaBfFBeEAsKxmkM1Yh7fkH09t/XDVjAgYGrq1s2L9qPD/kKdXC/2I6t2Va8xdd9SanwPYHIAnyBRdPmig==" crossorigin="anonymous" referrerpolicy="no-referrer" />
	
	<!-- datatables -->
<%-- 	<link rel="stylesheet" type="text/css" href="<util:applicationRoot/>/resources/DataTables/css/jquery.dataTables.min.css"/> --%>
<%-- 	<script type="text/javascript" charset="utf8" src="<util:applicationRoot/>/resources/DataTables/js/jquery.dataTables.min.js"></script> --%>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.12.1/css/jquery.dataTables.min.css"/>
	<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.12.1/js/jquery.dataTables.min.js"></script>
	
	<script type="text/javascript" charset="utf8" src="<util:applicationRoot/>/resources/jquery-colorize.js"></script>
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/moment.min.js"></script>
    <script src="https://cdn.datatables.net/plug-ins/1.10.19/dataRender/datetime.js"></script>
    <script src="https://cdn.datatables.net/plug-ins/1.11.5/sorting/datetime-moment.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/buttons/2.2.2/css/buttons.dataTables.min.css"/>
    <script src="https://cdn.datatables.net/buttons/2.2.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.2.2/js/buttons.html5.min.js"></script>
    
    <!-- select library -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
	<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<!-- select2 library latest development version -->	
<%-- 	<link href="<util:applicationRoot/>/resources/select2/select2.min.css" rel="stylesheet" /> --%>
<%-- 	<script src="<util:applicationRoot/>/resources/select2/select2.js"></script> --%>
	<script src="<util:applicationRoot/>/resources/select2/select2_search.js"></script>

	<!-- fontawesome -->
	<link rel="stylesheet" id='font-awesome' href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">
	<script src="https://kit.fontawesome.com/c831130235.js" crossorigin="anonymous"></script>
	
	<!-- Viz -->
	<script src="<util:applicationRoot/>/resources/d3.v4.min.js"></script>
	<script src="<util:applicationRoot/>/resources/d3-tip.js"></script>
	<script src='https://cdn.plot.ly/plotly-latest.min.js'></script>
	<script src="<util:applicationRoot/>/resources/slider.min.js"></script>
	
	<script src="https://d3js.org/d3-selection-multi.v1.min.js"></script>
	<script src="resources/he.js"></script>
	<script src="resources/d3RangeSlider.js"></script>

    <link href="resources/d3RangeSlider.css" rel="stylesheet">

	 <script src="https://cdn.rawgit.com/eligrey/canvas-toBlob.js/f1a01896135ab378aa5c0118eadd81da55e698d8/canvas-toBlob.js"></script>
	 <script src="https://cdn.rawgit.com/eligrey/FileSaver.js/e9d941381475b5df8b7d7691013401e171014e89/FileSaver.min.js"></script>
	
	
	<!-- local stylesheets -->
	<link rel="stylesheet" href="<util:applicationRoot/>/resources/n3c_login_style.css">

<style type="text/css">
table.dataTable thead .sorting_asc {
	background-image: none !important;
}
</style>

</head>
