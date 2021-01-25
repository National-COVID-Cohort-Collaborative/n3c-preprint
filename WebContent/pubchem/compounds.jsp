<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
    <style type="text/css">
        #slider-container{
            height: 30px;
			position:relative;
        }

        #range-label {
            text-align: center;
        }
        .section{
            margin-bottom:5em;
            font-size: 1.5em;
        }
	    </style>

<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading">PubChem Compounds</div>
			<div class="panel-body">
    <div class="section">

        <h2>Drag the bar to select a range</h2>
        <div id="slider-container"></div>
        <div id="range-label"></div>

        <script type="text/javascript">
            var slider = createD3RangeSlider(202001, 202012, "#slider-container", false);

            slider.onChange(function(newRange){
                d3.select("#range-label").html(newRange.begin + " &mdash; " + newRange.end);
            });

            slider.range(202002,202010);
        </script>
    </div>
			</div>
		</div>
	</div>
</div>
