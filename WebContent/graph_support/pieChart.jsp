<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<style>
chart {
	font: 10px sans-serif;
}

.arc path {
	stroke-width: 1px;
	stroke: #fff;
}
</style>

<script>

d3.json("${param.data_page}", function(error, data) {

	var width = 325, //var width = parseInt(d3.select("${param.dom_element}").style("width"))-10,
		height = width,
		border = 10;

	var myObserver = new ResizeObserver(entries => {
		entries.forEach(entry => {
			var newWidth = Math.floor(entry.contentRect.width);
			if (newWidth > 0) {
				d3.select("${param.dom_element}").select("svg").remove();
				//console.log('${param.dom_element} width '+newWidth);
				width = newWidth;
				height = newWidth;
				draw();
			}
		});
	});
	myObserver.observe(d3.select("${param.dom_element}").node());

	draw();

	function draw() {
		var radius = Math.min(width - border, height - border) / 2;
		var color = d3.scale.ordinal()
			.range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);

		var arc = d3.svg.arc()
			.outerRadius(radius - 10)
			.innerRadius(0);

		var pie = d3.layout.pie()
			.sort(null)
			.value(function(d) { return d.count; });

		var svg = d3.select("${param.dom_element}").append("svg")
			.attr("width", width)
			.attr("height", height)
			.append("g")
			.attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

		data.forEach(function(d) {
			d.count = +d.count;
		});

		var g = svg.selectAll(".arc")
			.data(pie(data))
			.enter().append("g")
			.attr("class", "arc");

		g.append("path")
			.attr("d", arc)
			.style("fill", function(d) { return color(d.data.element); });

		g.append("text")
			.attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
			.attr("dy", ".35em")
			.style("text-anchor", "middle")
			.text(function(d) { return d.data.element; });
	}
});

</script>