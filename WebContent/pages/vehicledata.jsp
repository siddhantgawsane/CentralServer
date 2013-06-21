<%@page import="com.util.StringHelper"%>
<%@page import="com.util.ConnectionManager"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib prefix="display" uri="/WEB-INF/displaytag-12.tld"%>
<html>
<head>
<title>OBD Home Page</title>
<link href="<%=request.getContextPath()%>/theme/style.css" rel="stylesheet" type="text/css" media="screen" />

<style type="text/css">
@import "gallery.css";
</style>
</head>
<body>
<div id="wrapper" style="text-align: center;">
<BR><BR><BR>
<h2>Vehicle Data As Received </h2>   
<BR><BR><BR>
<%   


	
	List list=ConnectionManager.getOBDAllList(StringHelper.n2s(request.getParameter("v")));
	request.setAttribute("LIST", list);   
	%>
	<span style="float: right;"><a
		href="<%=request.getContextPath()%>/pages/login.jsp">Logout</a></span>
	<display:table name="LIST" id="LIST" class="displayTable" 
			defaultsort="1" defaultorder="ascending" export="true" pagesize="10"> 

			<display:setProperty name="export.pdf.filename" value="report.pdf" />

			<display:setProperty name="export.csv.filename" value="report.csv" />

			<display:setProperty name="export.excel.filename" value="report.xls" />
			<display:setProperty name="export.csv" value="false" />
			<display:setProperty name="export.xml" value="false" />
			<display:column property="load_pct" title="Load PCT" sortable="true"
				headerClass="sortable" />

			<display:column property="temp" title="Temprature" sortable="true" />
			<display:column property="rpm" title="RPM"
				sortable="true" />
			<display:column property="vss" title="Vehicle Speed Sensor"
				sortable="true" />
			<display:column property="iat" title="Intake Air Flow" sortable="true" />
			<display:column property="maf" title="Mass Air Flow" sortable="true" />
			<display:column property="throttlepos" title="Throttle Position"
				sortable="true" />
			<display:column property="time" title="Time" sortable="true" />
			<display:column property="vehicleno" title="Vehicle No" sortable="true" />
			
		</display:table>

</div>


</body>
</html>
