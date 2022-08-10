<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
    .axis path,
    .axis line {
        fill: none;
        stroke: #000;
        shape-rendering: crispEdges;
    }

    .x.axis path {
        display: none;
    }
    
    .xaxis text{
    	fill: #000;
    }

    .line {
        fill: none;
        stroke-width: 1.5px;
    }

    .overlay {
        fill: none;
        pointer-events: bounding-box;
    }
	
	.tooltip-duas,
	text.duas{
        fill: #2d5985;
    }
    
    .dua_dta_focus{
    	fill: black;
    	pointer-events:none;
    }
    
    .tool_line{
    	pointer-events:none;
    }
    .dua_dta_focus .tooltip{
    	opacity: 0.7;
    	stroke:none;
    	width:130px;
    }
    
    path.duas,
    rect.duas{
    	stroke: #2d5985;
    	stroke-width:1.5px;
    }
    path.dtas,rect.dtas{
    	stroke:#6b496b;
    	stroke-width:1.5px;
    }
    
    .tooltip-dtas, text.dtas{
    		fill:#6b496b;
    }
    
    .dua_dta_focus text{
        font-size: 12px;
    }

    .tooltip {
        fill: white;
        stroke: #000;
    }

    .tooltip-date_dta_dua, 
    .tooltip-duas, 
    .tooltip-dtas{
        font-weight: bold;
    }

.axis1 text{
  fill: #2d5985;
}

.axis2 text{
  fill: #6b496b;
}

</style>

	

<script>



// set the dimensions and margins of the graph
	var margin = {top: 100, right: 150, bottom: 80, left: 80},
	    width = 960 - margin.left - margin.right,
	    height = 600 - margin.top - margin.bottom;
	
	
	
	d3.json("${param.data_page}", function(error, data) {	
		if (error) throw error;
		
		// parse the date / time
		var parseDate = d3.timeParse("%Y-%m");

		// format the data
		data.forEach(function(d) {
			d.month = parseDate(d.month);
			d.count = +d.count;
		});

		var column1_opacity = 1;
		var column2_opacity = 1;
		var column3_opacity = 1;
		var column4_opacity = 1;
		
		<c:if test="${not empty param.column1_opacity}">
			column1_opacity = ${param.column1_opacity};
		</c:if>
		<c:if test="${not empty param.column2_opacity}">
			column2_opacity = ${param.column2_opacity};
		</c:if>
		<c:if test="${not empty param.column3_opacity}">
			column3_opacity = ${param.column3_opacity};
		</c:if>
		<c:if test="${not empty param.column4_opacity}">
			column4_opacity = ${param.column4_opacity};
		</c:if>
		
		var myObserver = new ResizeObserver(entries => {
			entries.forEach(entry => {
				var newWidth = Math.floor(entry.contentRect.width);
				if (newWidth > 0) {
					d3.select("${param.dom_element}").select("svg").remove();
					width = newWidth - margin.left - margin.right;
					if ((width/2 - margin.top - margin.bottom) > 200){
						height = width/2 - margin.top - margin.bottom;
					} else { 
						height = 200;
					}
					draw();
				}
			});
		});
		
		myObserver.observe(d3.select("${param.dom_element}").node());
		
		draw();
		
		function draw() {
		    
			// set the ranges
			var ${param.namespace}x = d3.scaleTime().domain(d3.extent(data, function(d) { return d.date; })).range([0, width]);
			var y1 = d3.scaleLinear().range([height, 0]);
			var y2 = d3.scaleLinear().range([height, 0]);
			var line = d3.line().x(d => x(d.${param.date_column})).y(d => y(d.${param.column1}));
			
			
		
			// append the svg obgect to the body of the page
			// appends a 'group' element to 'svg'
			// moves the 'group' element to the top left margin
			var svg = d3.select("${param.dom_element}_graph").append("svg")
				.attr("class", "clear_target")
				.attr("width", width + margin.left + margin.right)
				.attr("height", height + margin.top + margin.bottom)
				.append("g")
				.attr("transform", "translate(" + margin.left + "," + margin.top + ")");
			
			// Add a clipPath: everything out of this area won't be drawn.
			 var clip = svg.append("defs").append("svg:clipPath")
			     .attr("id", "clip")
			     .append("svg:rect")
			     .attr("width",width)
			     .attr("height", height)
			     .attr("x", 0)
			     .attr("y", 0);
			
			
			    // Create the scatter variable: where both the circles and the brush take place
			  var graph = svg.append('g')
    			  .attr("clip-path", "url(#clip)")
    			  .attr("class", "overlay");
			 
			  
			// Add brushing
			  var brush = d3.brushX()                   // Add the brush feature using the d3.brush function
			      .extent( [ [0,0], [width,height] ] )  // initialise the brush area: start at 0,0 and finishes at width,height: it means I select the whole graph area
			      .on("brush", dua_dta_mousemove)
			      .on("end", ${param.namespace}updateChart);              // Each time the brush selection changes, trigger the 'updateChart' function
			  
			  
			  
				// Scales
				${param.namespace}x.domain(d3.extent(data, function(d) { return d.${param.date_column}; }));
				<c:choose>
					<c:when test="${not empty param.useColumn1Scaling}">
						y1.domain([0, d3.max(data, function(d) { return d.${param.column1}; })]);
						y2.domain([0, d3.max(data, function(d) { return d.${param.column1}; })]);
					</c:when>
					<c:when test="${not empty param.useColumn2Scaling}">
						y1.domain([0, d3.max(data, function(d) { return d.${param.column2}; })]);
						y2.domain([0, d3.max(data, function(d) { return d.${param.column2}; })]);
					</c:when>
					<c:otherwise>
						y1.domain([0, d3.max(data, function(d) { return d.${param.column1}; })]);
						y2.domain([0, d3.max(data, function(d) { return d.${param.column2}; })]);
					</c:otherwise>
				</c:choose>
			  
				// X & Y 
				var valueline = d3.line()
					.x(function(d) { return ${param.namespace}x(d.${param.date_column}); })
					.y(function(d) { return y1(d.${param.column1}); });
				var valueline2 = d3.line()
					.x(function(d) { return ${param.namespace}x(d.${param.date_column}); })
					.y(function(d) { return y2(d.${param.column2}); });
				var valueline3 = d3.line()
					.x(function(d) { return ${param.namespace}x(d.${param.date_column}); })
					.y(function(d) { return y2(d.${param.column3}); });
				var valueline4 = d3.line()
					.x(function(d) { return ${param.namespace}x(d.${param.date_column}); })
					.y(function(d) { return y2(d.${param.column4}); });
			
				// Lines
				graph.append("path")
					.data([data])
					.attr("opacity", column1_opacity)
					.attr("class", "line duas")
					.attr("d", valueline);
				graph.append("path")
					.data([data])
					.attr("opacity", column2_opacity)
					.attr("class", "line dtas")
					.attr("d", valueline2);
				graph.append("path")
					.data([data])
					.attr("opacity", column2_opacity)
					.attr("class", "line dtas")
					.attr("d", valueline3);
				graph.append("path")
					.data([data])
					.attr("opacity", column2_opacity)
					.attr("class", "line dtas")
					.attr("d", valueline4);
				
				// Add the brushing
				var test_tip = graph
				    .append("g")
				    .attr("class", "brush")
				    .call(brush)
				    .on("mouseover", function() { dua_dta_focus.style("display", null);  tooltipLine.style("display", null);})
		    	  	.on("mouseout", function() { dua_dta_focus.style("display", "none");  tooltipLine.style("display", "none");})
		    	  	.on("mousemove", dua_dta_mousemove);
			
				// Labels & Current Totals
				<c:if test="not empty param.lineLabels">
					graph.append("text")
				    	.attr("transform", "translate("+(width+3)+","+y1(data[data.length-1].${param.column1})+")")
				    	.attr("dy", ".35em")
				    	.attr("text-anchor", "start")
				    	.attr("class", "duas")
				    	.text("${param.column1_tip}");
					graph.append("text")
				    	.attr("transform", "translate("+(width+3)+","+y2(data[data.length-1].${param.column2})+")")
				    	.attr("dy", ".35em")
				    	.attr("text-anchor", "start")
				    	.attr("class", "dtas")
				    	.text("${param.column2_tip}");
				</c:if>
				

			    
			  	// Axis
				var ${param.namespace}xaxis = svg.append("g")
					.attr("transform", "translate(0," + height + ")")
					.attr("class", "xaxis")
					.call(d3.axisBottom(${param.namespace}x).tickFormat(function(date){
						if (d3.timeYear(date) < date) {
					           return d3.timeFormat('%b')(date);
					         } else {
					           return d3.timeFormat('%Y')(date);
					         }
					      }))
					.selectAll("text")  
    					.style("text-anchor", "end")
    					.attr("dx", "-.8em")
    					.attr("dy", ".15em")
    					.attr("transform", "rotate(-65)");

				// text label for the x axis
				  svg.append("text")             
				      .attr("transform",
				            "translate(" + (width/2) + " ," + 
				                           (height + margin.top + 20) + ")")
				      .style("text-anchor", "middle")
				      .text("Date");

				  svg.append("g")
			      .attr("class", "axis1")
			      .call(d3.axisLeft(y1));

				  // text label for the y axis
				  svg.append("text")
				      .attr("transform", "rotate(-90)")
				      .attr("y", 0 - margin.left)
				      .attr("x",0 - (height / 2))
				      .attr("dy", "1em")
				      .style("text-anchor", "middle")
				      .text("${param.column1_label}");      
				  
		        // Add the Legend
			    var legend_keys = {"nodes":[{"text": "${param.column1_tip}", "tag": "duas", "opacity":"${param.column1_opacity}"},
			    							{"text": "${param.column2_tip}", "tag": "dtas", "opacity":"${param.column2_opacity}"},
											{"text": "${param.column3_tip}", "tag": "dtas", "opacity":"${param.column3_opacity}"},
											{"text": "${param.column4_tip}", "tag": "dtas", "opacity":"${param.column4_opacity}"}
			    					]};

			    var lineLegend = svg.selectAll(".lineLegend").data(legend_keys.nodes)
			    	.enter().append("g")
			    	.attr("class","lineLegend")
			    	.attr("transform", function (d, i) {
			            return "translate(" + (20) + "," + ((i*20)-50)+")";
			        });

				lineLegend.append("text").text(function (d) {return d.text;})
				    .attr("transform", "translate(25, 6)"); //align texts with boxes
	
				lineLegend.append("rect")
				    .attr("width", 22)
				    .attr("class", function(d){return d.tag;})
				    .attr("opacity", function(d){return d.opacity;})
				    .attr('height', 2);
				    
				//tooltip line
				var tooltipLine = graph.append('line')
					.attr("class", "tool_line");
				
				// tooltips
				var dua_dta_focus = test_tip.append("g")
			    	.attr("class", "dua_dta_focus")
			    	.style("display", "none");
			
				dua_dta_focus.append("rect")
			    	.attr("class", "tooltip")
			    	.attr("height", 80)
			    	.attr("x", 10)
			    	.attr("y", -22)
			    	.attr("rx", 4)
			    	.attr("ry", 4);
			
				dua_dta_focus.append("text")
			    	.attr("class", "tooltip-date_dta_dua")
			    	.attr("x", 18)
			    	.attr("y", 0);
			
				dua_dta_focus.append("text")
			    	.attr("x", 18)
			    	.attr("y", 18)
			    	.text("${param.column1_tip}:");
				
				dua_dta_focus.append("text")
		    		.attr("x", 18)
		    		.attr("y", 30)
		    		.text("${param.column2_tip}:");
			
				dua_dta_focus.append("text")
	    			.attr("x", 18)
	    			.attr("y", 42)
	    			.text("${param.column3_tip}:");
		
				dua_dta_focus.append("text")
	    			.attr("x", 18)
	    			.attr("y", 54)
	    			.text("${param.column4_tip}:");
		
				dua_dta_focus.append("text")
			    	.attr("class", "tooltip1")
			    	.attr("x", ${param.column1_tip_offset})
			    	.attr("y", 18);
				
				dua_dta_focus.append("text")
					.attr("class", "tooltip2")
					.attr("x", ${param.column2_tip_offset})
					.attr("y", 30);
				
				dua_dta_focus.append("text")
					.attr("class", "tooltip3")
					.attr("x", ${param.column3_tip_offset})
					.attr("y", 42);
			
				dua_dta_focus.append("text")
					.attr("class", "tooltip4")
					.attr("x", ${param.column4_tip_offset})
					.attr("y", 54);
			
			    
				var parseDate = d3.timeFormat("%m/%e/%Y").parse,
					bisectDate_dua_dta = d3.bisector(function(d) { return d.${param.date_column}; }).left,
					formatValue = d3.format(","),
					dateFormatter = d3.timeFormat("%m/%y");
				
			
				function dua_dta_mousemove() {
				    var x0 = ${param.namespace}x.invert(d3.mouse(this)[0]),
				        i = bisectDate_dua_dta(data, x0, 1),
				        d0 = data[i - 1],
				        d1 = data[i],
				        d = x0 - d0.first_diagnosis_date > d1.first_diagnosis_date - x0 ? d1 : d0;
				    
				    
				    if (width/2 > d3.mouse(this)[0]){
				    	dua_dta_focus.attr("transform", "translate(" + ${param.namespace}x(d.${param.date_column}) + "," + d3.mouse(this)[1] + ")");
				    }else{
				    	dua_dta_focus.attr("transform", "translate(" + ((${param.namespace}x(d.${param.date_column}))-150) + "," + d3.mouse(this)[1] + ")");
				    };
				   
				    dua_dta_focus.select(".tooltip-date_dta_dua").text(dateFormatter(d.${param.date_column}));
				    dua_dta_focus.select(".tooltip1").text(formatValue(d.${param.column1}));
				    dua_dta_focus.select(".tooltip2").text(formatValue(d.${param.column2}));
				    dua_dta_focus.select(".tooltip3").text(formatValue(d.${param.column3}));
				    dua_dta_focus.select(".tooltip4").text(formatValue(d.${param.column4}));
				    
				    tooltipLine.attr('stroke', 'black')
				    	.attr("transform", "translate(" + ${param.namespace}x(d.${param.date_column}) + "," + 0 + ")")
				    	.attr('y1', 0)
				    	.attr('y2', height);
				};


				
				// A function that set idleTimeOut to null
				  var idleTimeout;
				  function idled() { idleTimeout = null; };
				
				// A function that update the chart for given boundaries
				   function ${param.namespace}updateChart() {

						// What are the selected boundaries?
						var extent = d3.event.selection;

				      	// If no selection, back to initial coordinate. Otherwise, update X axis domain
				     	if(!extent){
				        	if (!idleTimeout) return idleTimeout = setTimeout(idled, 350); // This allows to wait a little bit
				        	${param.namespace}x.domain(d3.extent(data, function(d) { return d.${param.date_column}; }));
				      	}else{
				      		${param.namespace}x.domain([ ${param.namespace}x.invert(extent[0]), ${param.namespace}x.invert(extent[1]) ]);
				        	graph.select(".brush").call(brush.move, null); // This remove the grey brush area as soon as the selection has been done
				      	}
				      		
					      
				      	// redraw axis
				      	d3.selectAll('${param.dom_element} .xaxis').remove();
				      	svg.append("g")
						.attr("transform", "translate(0," + height + ")")
						.attr("class", "xaxis")
						.call(d3.axisBottom(${param.namespace}x))
						 .selectAll("text")  
		    				.style("text-anchor", "end")
		    				.attr("dx", "-.8em")
		    				.attr("dy", ".15em")
		    				.attr("transform", "rotate(-65)");

				      	// Update line position
				      	graph
				          .select('path.duas')
				          .transition()
				          .duration(1000)
				          .attr("d", d3.line()
				            .x(function(d) { return ${param.namespace}x(d.${param.date_column}); })
				            .y(function(d) { return y1(d.${param.column1}); }));
				      	graph
				          .select('path.dtas')
				          .transition()
				          .duration(1000)
				          .attr("d", d3.line()
				            .x(function(d) { return ${param.namespace}x(d.${param.date_column}); })
				            .y(function(d) { return y2(d.${param.column2}); }));
				      	graph
				          .select('path.dtas')
				          .transition()
				          .duration(1000)
				          .attr("d", d3.line()
				            .x(function(d) { return ${param.namespace}x(d.${param.date_column}); })
				            .y(function(d) { return y2(d.${param.column3}); }));
				      	graph
				          .select('path.dtas')
				          .transition()
				          .duration(1000)
				          .attr("d", d3.line()
				            .x(function(d) { return ${param.namespace}x(d.${param.date_column}); })
				            .y(function(d) { return y2(d.${param.column4}); }));
	
				};
				
				function ${param.namespace}time_line_clear(){
					
					${param.namespace}x.domain(d3.extent(data, function(d) {return d.${param.date_column}; }));
					
					
					d3.select("${param.dom_element} ${param.dom_element}_graph .xaxis")
			        	.transition()
			        	.call(d3.axisBottom(${param.namespace}x)
			        	.tickFormat(function(date){
							if (d3.timeYear(date) < date) {
					           return d3.timeFormat('%b')(date);
					         } else {
					           return d3.timeFormat('%Y')(date);
					         }
					      	}))
						.selectAll("text")  
    						.style("text-anchor", "end")
    						.attr("dx", "-.8em")
    						.attr("dy", ".15em")
    						.attr("transform", "rotate(-65)");
			        
			        graph
			          .select('path.duas')
			          .transition()
			          .attr("d", d3.line()
			          	.x(function(d) { return ${param.namespace}x(d.${param.date_column}); })
					    .y(function(d) { return y1(d.${param.column1}); }));
			        
			        graph
			          .select('path.dtas')
			          .transition()
			          .attr("d", d3.line()
			          	.x(function(d) { return ${param.namespace}x(d.${param.date_column}); })
					    .y(function(d) { return y2(d.${param.column2}); }));
					
				};
				
				d3.select("${param.dom_element} ${param.dom_element}_graph .clear_target")
					.on("dblclick", ${param.namespace}time_line_clear);
				
				$("${param.dom_element}_btn").off().on("click", function(){
					d3.select("${param.dom_element} ${param.dom_element}_graph .clear_target").dispatch("dblclick");
				});
				
			};
		});

	
	
	

</script>
