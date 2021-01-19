<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>


<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-primary">
			<div class="panel-heading">Drug Mentions</div>
			<div class="panel-body">
				<div id="drug_target_table">
					<jsp:include page="../tables/drug.jsp" flush="true">
						<jsp:param value="Lopinavir" name="drug" />
					</jsp:include>
				</div>

				<div id="drug_table" style="overflow: scroll;">&nbsp;</div>
				<div id="op_table" style="overflow: scroll;">&nbsp;</div>
			</div>
		</div>
	</div>
</div>

