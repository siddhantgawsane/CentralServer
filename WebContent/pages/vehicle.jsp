

<%@page import="com.util.ServerConstants"%>
<%@page import="com.util.UserAccountModel"%>
<%@page import="com.util.OBDServerModel"%>
<%@page import="com.util.DBUtils"%>
<%@page import="com.util.OwnerInfoModel"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
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
<script>
function fnload(){
	$("#domain").load("<%=request.getContextPath()%>/pages/tiles/save.jsp?method=getDomain");
};

</script>
</head>
<body onload="fnload();">
<div id="wrapper" style="text-align: center;">
<BR><BR><BR>

<%
Object o=session.getAttribute("USER_MODEL");
UserAccountModel um=null;
if(o==null){
	%>
	<script>
	window.location.href="<%=request.getContextPath()%>/pages/login.jsp";
	</script>
	<%
}else{
	um=(UserAccountModel)o;
}
boolean isAdmin=false;
if(um.getRole()==ServerConstants.ROLE_ADMIN){
	isAdmin=true;
}

%>
<h2>Welcome</h2>   
<BR>
<a href="<%=request.getContextPath()%>/pages/vehicle.jsp">Vehicle Report</a>&nbsp;&nbsp;&nbsp;
<%if(isAdmin){ %>
<a href="<%=request.getContextPath()%>/pages/addownervehicle.jsp">Add/Delete Owner</a>&nbsp;&nbsp;&nbsp;
<%} %>
<a href="<%=request.getContextPath()%>/pages/addalert.jsp">Add/Delete Alerts</a>&nbsp;&nbsp;&nbsp;
<a href="<%=request.getContextPath()%>/pages/login.jsp">Logout</a>
<BR><BR>
OBD Data As Per Owner<BR> 



<form 
		id="commentForm" method="post" name="myform" >
		<fieldset>		
		<table style="width: 100%;text-align: left;">
		   		<tr>
		   		<td style="text-align: center;"><img src="<%=request.getContextPath()%>/theme/images/car.png" height="128" width="128">
		   		</tr>
			<tr>
				<td style="text-align: center; color:red;"><input type="submit"  name="Fetch"  value="Generate" ></td>
			</tr>
			
			
		</table>
		
 		</fieldset> 
 		
 		<fieldset>
 	<%
  if(request.getParameter("Fetch")!=null){
  List list = null;
  String domain=StringHelper.nullObjectToStringEmpty(request.getParameter("domain"));
  String sql = "";
  
 	if(isAdmin){
 		sql = "Select * from obdserver o";
 	}else{
 		sql = "Select * from  obdserver o,vehicles v where v.vehicleId=o.vehicleId and v.ownerId = "+um.getUserid();
 	}
  
  list = DBUtils.getBeanList(OBDServerModel.class,sql);
  System.out.println("The Control is in the delete adds and list size is " + list.size());
  session.setAttribute("LIST2", list);

  %>
<div style="width: 100%;">
<display:table  class="simple" name="sessionScope.LIST2" requestURI="/pages/vehicle.jsp"  id="searchTableId"  pagesize="20"  style=" width:100%;"  defaultsort="1"  defaultorder="ascending"  export= "false"  sort="list" >
    <display:setProperty name="export.csv" value="false" /> 
    <display:setProperty name="export.xml" value="false" />
    <display:setProperty name="export.xls" value="false" />
    <display:setProperty name="paging.banner.placement" value="bottom"  />
   
   	
    <display:column  title="Owner ID"  sortable="true"  property="ownerid">
    </display:column>
    <display:column  title="Time"  sortable="true"  property="time">
    </display:column>
   
	
	<display:column sortable="true" 	title="OBD Data Received" media="html" >
  <br>
   	<b>Speed</b>: <%=((OBDServerModel)(pageContext.getAttribute("searchTableId"))).getVss()%><br>
   	<b>RPM:</b> <%=((OBDServerModel)(pageContext.getAttribute("searchTableId"))).getRpm()%><br>
   	<b>LOAD PCT:</b> <%=((OBDServerModel)(pageContext.getAttribute("searchTableId"))).getLoad_pct()%><br>
   	<b>IAT:</b> <%=((OBDServerModel)(pageContext.getAttribute("searchTableId"))).getIat()%><br>
   	<b>TEMP:</b> <%=((OBDServerModel)(pageContext.getAttribute("searchTableId"))).getTemp()%><br>
   	<b>MAF:</b> <%=((OBDServerModel)(pageContext.getAttribute("searchTableId"))).getMaf()%><br>
   	<b>Throttle Position:</b> <%=((OBDServerModel)(pageContext.getAttribute("searchTableId"))).getThrottlepos()%>
   	<br><br>
    </display:column>
    
    <display:column sortable="true" 	title="Location " media="html" >
   	Latitude: <%=((OBDServerModel)(pageContext.getAttribute("searchTableId"))).getLatsend()%></br>
   	Longitude: <%=((OBDServerModel)(pageContext.getAttribute("searchTableId"))).getLngsend()%></br>
    </display:column>
	
	
	</display:table>  
</div>

<%} %>

 		</fieldset>
	</form>



	
	
	

	

</div>

</body>



</html>
