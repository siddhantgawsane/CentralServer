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

<html>
<head>
<title>OBD Add Alert</title>
<link href="<%=request.getContextPath()%>/theme/style.css" rel="stylesheet" type="text/css" media="screen" />
<script src="<%=request.getContextPath()%>/jquery.autocomplete-1.1.3/jquery-1.7.2.js"></script>

<style type="text/css">
@import "gallery.css";
</style>

</head>
<body>
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
<BR><BR>Add Alerts<BR> 

<form id="commentForm" method="post" name="myform">
<fieldset>
	<table style="width: 100%;text-align: left;">
		   		<tr>
		   		<td colspan="2" style="text-align: center;"><img src="<%=request.getContextPath()%>/theme/images/alert.png" height="128" width="128">
		   		</tr>
	</table>
	</fieldset> 
	
	<fieldset>
			<%
			
			List list=null;
			if(isAdmin)
				list=ConnectionManager.getAllOwners();
			else
				list=ConnectionManager.getAllOwners(um.getUserid());
			
			session.setAttribute("RESULT", list);
			%>

	<%@page import="com.util.*"%>
<%@ taglib uri="/WEB-INF/displaytag-12.tld" prefix="display" %>
<display:table  class="simple" name="sessionScope.RESULT" requestURI="/pages/addalert.jsp"  id="searchTableId"  pagesize="20"  style=" width:100%;"  defaultsort="1"  defaultorder="ascending"  export= "false"  sort="list" >
    <display:setProperty name="export.csv" value="false" /> 
    <display:setProperty name="export.xml" value="false" />
    <display:setProperty name="export.xls" value="false" />
    <display:setProperty name="paging.banner.placement" value="bottom"  />
    
   	<display:column  title="Owner ID"  sortable="true"  property="ownerId">
    </display:column>
   	<display:column  title="Owner Name"  sortable="true" property="fullname">   
   	</display:column>
   	<display:column  title="Vehicle No."  sortable="true"  property="vehicleno">	
	</display:column>
	<display:column  title="Phone No"  sortable="true"  property="phoneno">	
	</display:column>
		<display:column  title="IMEI"  sortable="true"  property="imei">	
	</display:column>
	<display:column sortable="true" 	title="Add Alert" media="html" >
   	<a href="#" onclick="fnAddAlertDetails('<%=((OwnerInfoModel)(pageContext.getAttribute("searchTableId"))).getUserid()%>','<%=StringHelper.nullObjectToStringEmpty(((OwnerInfoModel)(pageContext.getAttribute("searchTableId"))).getImei())%>','<%=StringHelper.nullObjectToStringEmpty(((OwnerInfoModel)(pageContext.getAttribute("searchTableId"))).getVehicleno())%>')">Add Alert</a>
    </display:column>
	<display:column sortable="true" 	title="Delete " media="html" >
   	<a href="#" onclick="fnDeleteDetails('<%=((OwnerInfoModel)(pageContext.getAttribute("searchTableId"))).getUserid()%>','<%=((OwnerInfoModel)(pageContext.getAttribute("searchTableId"))).getVehicleno()%>')">Delete Owner Vehicle Details</a>
    </display:column>
	</display:table>
	
	
	
	
	
	<br><br><br><br><br>
	<div id="divId" style="display: none;">
	<p>Add Alert Details:</p>
				<p>Owner ID&nbsp;&nbsp;:&nbsp;&nbsp;<input type="text" name = "ownerid"  readonly="readonly" id="ownerid"></input></p>
				<p>Vehicle Name&nbsp;&nbsp;:&nbsp;&nbsp;<input type="text" name ="vehicleno"  readonly="readonly" id="vehicleno"></input></p>
				<p>IMEI&nbsp;&nbsp;:&nbsp;&nbsp;<input type="text" name = "imei"  readonly="readonly" id="imei"></input></p>
				<p>Alert Type&nbsp;&nbsp;:&nbsp;&nbsp;<select id="type" name="type"><option value="S">Speed Alert</option><option value="P">Position Alert</option></select></p>
				<p>Alert Value&nbsp;&nbsp;:&nbsp;&nbsp;<input type="text" id="val" name = "val" minlength="2" id="val"></input></p>
				<p><input type="button" value="Add Alert" onclick="fnAdd();" /></p>
	</div>
	</div>
	</div>   
	<!-- end #page --> 
	<!-- end #footer -->

</div>
	</fieldset>
	</form>



	
	
	

	

</div>


<script>
function fnAddAlertDetails(id,imei,vehicleno){
	$("#divId").show();
	$("#ownerid").val(id);
	$("#val").val('');   
	$("#vehicleno").val(vehicleno);
	$("#imei").val(imei);
}



function fnDeleteDetails(ownerid, vehicleno){
	dataString='ownerid='+ownerid+"&vehicleno="+vehicleno;
	if(confirm("Are you sure ?")){
		$.ajax({
			  type: "POST",
			  url: "<%=request.getContextPath()%>/pages/tiles/save.jsp?method=deleteUser",
			  dataType: "text",
			  data:dataString
		}).done(function(msg) {  
			alert(msg.trim());
			window.location.reload();
		});	
		}
}



function fnAdd(){
	ownerid=$("#ownerid").val();
	type=$("#type").val();
	val =$("#val").val();
	
	if(val.length<=0){
		alert("Alert Type Value Empty!");
	}
	dataString='ownerid='+ownerid+"&type="+type+"&val="+val;
	//alert(dataString);
	$.ajax({
		  type: "POST",
		  url: "<%=request.getContextPath()%>/pages/tiles/save.jsp?method=addAlert",
		  dataType: "text",
		  data:dataString
		}).done(function( msg ) {
			alert(msg.trim());
			window.location.reload();
	});
}


</script>

</body>



</html>
