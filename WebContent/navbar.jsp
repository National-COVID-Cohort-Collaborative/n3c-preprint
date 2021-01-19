<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<nav class="navbar navbar-expand navbar-light bg-light">
	<img src="images/n3c_logo.png" class="n3c_logo_navbar" alt="N3C Logo">
	<div class="collapse navbar-collapse" id="navbarNav">
		<ul class="navbar-nav" style="display: flex; width: 100%;">
			<li class="nav-item">
				<a class="nav-link" href="Https://covid.cd2h.org">N3C</a>
			</li>
			<c:if test="${not empty admin}">
				<li class="nav-item">
					<a class="nav-link" href="dashboard.jsp">Dashboard</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="admin.jsp">Admin</a>
				</li>
			</c:if>
			<li class="nav-item">
				<a class="nav-link" href="https://cd2h.org">CD2H</a>
			</li>
		</ul>
	</div>
</nav>