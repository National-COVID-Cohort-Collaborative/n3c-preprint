<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<script>

d3.json("${param.data_page}", function(data) {
	var maxWidth = 280; // width of the bar with the max value

	// parse the date / time
	var parseTime = d3.timeParse("%Y-%W");

	// format the data
	data.forEach(function(d) {
		d.week = parseTime(d.week);
		d.count = +d.count;
	});
	var myObserver = new ResizeObserver(entries => {
		entries.forEach(entry => {
			var newWidth = Math.floor(entry.contentRect.width);
			// console.log('body width '+newWidth);
			if (newWidth > 0) {
				d3.select("${param.dom_element}").select("svg").remove();
				maxWidth = newWidth;
				draw();
			}
		});
	});
	myObserver.observe(d3.select("${param.dom_element}").node());

	draw();

	function draw() {
		// set the dimensions and margins of the graph
		var margin = { top: 20, right: 20, bottom: 70, left: 50 };
		var width = maxWidth - margin.left - margin.right,
			height = 200 - margin.top - margin.bottom;

		// set the ranges
		var x = d3.scaleTime().range([0, width]);
		var y = d3.scaleLinear().range([height, 0]);

		// define the line
		var valueline = d3.line()
			.x(function(d) { return x(d.week); })
			.y(function(d) { return y(d.count); });

		// append the svg object to the body of the page
		// appends a 'group' element to 'svg'
		// moves the 'group' element to the top left margin
		var svg = d3.select("${param.dom_element}").append("svg")
			.attr("width", width + margin.left + margin.right)
			.attr("height", height + margin.top + margin.bottom)
			.append("g")
			.attr("transform",
				"translate(" + margin.left + "," + margin.top + ")");

		// Scale the range of the data
		x.domain(d3.extent(data, function(d) { return d.week; }));
		y.domain([0, d3.max(data, function(d) { return d.count; })]);

		// Add the valueline path.
		svg.append("path")
			.data([data])
			.attr("class", "line")
			.attr("d", valueline);

		// Add the X Axis
		svg.append("g")
			.attr("class", "axis")
			.attr("transform", "translate(0," + height + ")")
			.call(d3.axisBottom(x)
				.tickFormat(d3.timeFormat("%Y-%W")))
			.selectAll("text")
			.style("text-anchor", "end")
			.attr("dx", "-.8em")
			.attr("dy", ".15em")
			.attr("transform", "rotate(-65)");

		// Add the Y Axis
		svg.append("g")
			.attr("class", "axis")
			.call(d3.axisLeft(y).ticks(5));
	}
});
</script>

