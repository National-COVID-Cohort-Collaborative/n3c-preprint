<script>

d3.json("${param.data_page}", function(data) {
	// SET UP DIMENSIONS
	var w = 500,
		h = 300;
	
	// margin.middle is distance from center line to each y-axis
	var margin = {
		top: 10,
		right: 10,
		bottom: 40,
		left: 10,
		middle: 28
	};
	

	var myObserver = new ResizeObserver(entries => {
		entries.forEach(entry => {
			var newWidth = Math.floor(entry.contentRect.width);
			// console.log('body width '+newWidth);
			if (newWidth > 0) {
				d3.select("${param.dom_element}").select("svg").remove();
				w = newWidth;
				draw();
			}
		});
	});
	myObserver.observe(d3.select("${param.dom_element}").node());

	draw();

	function draw() {
		// the width of each side of the chart
		var regionWidth = w / 2 - margin.middle;
		
		// these are the x-coordinates of the y-axes
		var pointA = regionWidth,
			pointB = w - regionWidth;
		
		// GET THE TOTAL POPULATION SIZE AND CREATE A FUNCTION FOR RETURNING THE PERCENTAGE
		var totalPopulation = d3.sum(data, function(d) { return d.left + d.right; }),
			percentage = function(d) { return d / totalPopulation; };
		
		
		// CREATE SVG
		var svg = d3.select('#pyramid-wrapper').append('svg')
			.attr('width', margin.left + w - margin.right)
			.attr('height', margin.top + h + margin.bottom)
			// ADD A GROUP FOR THE SPACE WITHIN THE MARGINS
			.append('g')
			.attr('transform', translation(margin.left, margin.top));
		
		// find the maximum data value on either side
		//  since this will be shared by both of the x-axes
		var maxValue = Math.max(
			d3.max(data, function(d) { return d.left; }),
			d3.max(data, function(d) { return d.right; })
		);
		
		// SET UP SCALES
		
		// the xScale goes from 0 to the width of a region
		//  it will be reversed for the left x-axis
		var xScale = d3.scaleLinear()
			.domain([0, maxValue])
			.range([0, regionWidth])
			.nice();
		
		var xScaleLeft = d3.scaleLinear()
			.domain([0, maxValue])
			.range([regionWidth, 0]);
		
		var xScaleRight = d3.scaleLinear()
			.domain([0, maxValue])
			.range([0, regionWidth]);
		
		var yScale = d3.scaleBand()
			.domain(data.map(function(d) { return d.group; }))
			.range([h, 0], 0.1);
		
		
		// SET UP AXES
		var yAxisLeft = d3.axisRight()
			.scale(yScale)
			.tickSize(4, 0)
			.tickPadding(margin.middle - 4);
		
		var yAxisRight = d3.axisLeft()
			.scale(yScale)
			.tickSize(4, 0)
			.tickFormat('');
		
		var xAxisRight = d3.axisBottom()
			.scale(xScale)
			.ticks(4);
		
		var xAxisLeft = d3.axisBottom()
			// REVERSE THE X-AXIS SCALE ON THE LEFT SIDE BY REVERSING THE RANGE
			.scale(xScale.copy().range([pointA, 0]))
			.ticks(4);
		
		svg.append("text")
        .attr("transform", "translate(" + (w * .25) + " ," + 0 + ")")
        .style("text-anchor", "middle")
        .text("${param.left_header}");

		svg.append("text")
        .attr("transform", "translate(" + (w * .75) + " ," + 0 + ")")
        .style("text-anchor", "middle")
        .text("${param.right_header}");

		svg.append("text")
        .attr("transform", "translate(" + (w * .25) + " ," + (h + 30) + ")")
        .style("text-anchor", "middle")
        .text("${param.left_label}");

		svg.append("text")
        .attr("transform", "translate(" + (w / 2) + " ," + (h + 30) + ")")
        .style("text-anchor", "middle")
        .text("${param.middle_label}");

		svg.append("text")
        .attr("transform", "translate(" + (w * .75) + " ," + (h + 30) + ")")
        .style("text-anchor", "middle")
        .text("${param.right_label}");

		
		// MAKE GROUPS FOR EACH SIDE OF CHART
		// scale(-1,1) is used to reverse the left side so the bars grow left instead of right
		var leftBarGroup = svg.append('g')
			.attr('transform', translation(pointA, 0) + 'scale(-1,1)');
		var rightBarGroup = svg.append('g')
			.attr('transform', translation(pointB, 0));
		
		// DRAW AXES
		svg.append('g')
			.attr('class', 'axis y left')
			.attr('transform', translation(pointA, 0))
			.call(yAxisLeft)
			.selectAll('text')
			.style('text-anchor', 'middle');
		
		svg.append('g')
			.attr('class', 'axis y right')
			.attr('transform', translation(pointB, 0))
			.call(yAxisRight);
		
		svg.append('g')
			.attr('class', 'axis x left')
			.attr('transform', translation(0, h))
			.call(xAxisLeft);
		
		svg.append('g')
			.attr('class', 'axis x right')
			.attr('transform', translation(pointB, h))
			.call(xAxisRight);
		
		// DRAW BARS
		leftBarGroup.selectAll('.bar.left')
			.data(data)
			.enter().append('rect')
			.attr('class', 'bar left')
			.attr('x', 0)
			.attr('y', function(d) { return yScale(d.group); })
			.style("stroke", "#ffffff")
			.style("stroke-width", 1)
			.attr('width', function(d) { return xScale(d.left); })
			.attr('height', yScale.bandwidth());
		
		rightBarGroup.selectAll('.bar.right')
			.data(data)
			.enter().append('rect')
			.attr('class', 'bar right')
			.attr('x', 0)
			.attr('y', function(d) { return yScale(d.group); })
			.style("stroke", "#ffffff")
			.style("stroke-width", 1)
			.attr('width', function(d) { return xScale(d.right); })
			.attr('height', yScale.bandwidth());
		
	}
});

//so sick of string concatenation for translations
function translation(x, y) {
	return 'translate(' + x + ',' + y + ')';
}

</script>
