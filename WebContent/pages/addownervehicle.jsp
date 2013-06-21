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
<title>OBD Add Owner Vehicle</title>
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
<BR><BR>Add Owner Vehicle<BR> 

<form id="commentForm" method="post" name="myform">
<fieldset>
	<table style="width: 100%;text-align: left;">
		   		<tr>
		   		<td colspan="2" style="text-align: center;"><img src="<%=request.getContextPath()%>/theme/images/Owner-128.png" height="128" width="128">
		   		</tr>
	</table>
	</fieldset> 
	
	<fieldset>
			<%
			List list=ConnectionManager.getAllUsers();
			session.setAttribute("RESULT_USER", list);
			%>

	<%@page import="com.util.*"%>
<%@ taglib uri="/WEB-INF/displaytag-12.tld" prefix="display" %>
<display:table  class="simple" name="sessionScope.RESULT_USER" requestURI="/pages/addownervehicle.jsp"  id="searchTableId"  pagesize="20"  style=" width:100%;"  defaultsort="1"  defaultorder="ascending"  export= "false"  sort="list" >
    <display:setProperty name="export.csv" value="false" /> 
    <display:setProperty name="export.xml" value="false" />
    <display:setProperty name="export.xls" value="false" />
    <display:setProperty name="paging.banner.placement" value="bottom"  />
    
   	<display:column  title="User ID"  sortable="true"  property="userid">
    </display:column>
   	<display:column  title="User Name"  sortable="true" property="login">   
   	</display:column>
   	
	
	<display:column sortable="true" 	title="Add Alert" media="html" >
   	<a href="#" onclick="fnAddDetails('<%=((UserAccountModel)(pageContext.getAttribute("searchTableId"))).getUserid()%>','<%=((UserAccountModel)(pageContext.getAttribute("searchTableId"))).getUserid()%>')">Add Owner Vehicle Details</a>
    </display:column>
	
	<display:column sortable="true" 	title="Delete " media="html" >
   	<a href="#" onclick="fnDeleteDetails('<%=((UserAccountModel)(pageContext.getAttribute("searchTableId"))).getUserid()%>')">Delete User</a>
    </display:column>
    
	</display:table>
	
	
	<br><br><br><br><br>
	
	<div id="divId" style="display: none;">
	<p style="color:red; text-decoration: underline;">Add Owner Details:</p>
				<p>Owner ID&nbsp;&nbsp;:&nbsp;&nbsp;<input type="text" name = "ownerid"  readonly="readonly" id="ownerid"></input></p>
				<p>Driver Name&nbsp;&nbsp;:&nbsp;&nbsp;<input type="text" id="drivername" name = "drivername" minlength="2" ></input></p>
				<p>Vehicle No.&nbsp;&nbsp;:&nbsp;&nbsp;<input type="text" name = "vno" minlength="2" id="vno"></input></p>
				<p>IMEI No.(Phone)&nbsp;&nbsp;:&nbsp;&nbsp;<input type="text" name = "imei" minlength="2" id="imei"></input></p>
				<p><input type="button" value="Add Owner" onclick="fnAdd();"/></p>
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


function fnAddDetails(uid,name){
	$("#divId").show();
	$("#ownerid").val(uid);
	$("#drivername").val('');
	$("#vno").val('');
	$("#imei").val('');
	
}



function fnDeleteDetails(ownerid){
	dataString='ownerid='+ownerid;
	if(confirm("Are you sure ?")){
		$.ajax({
			  type: "POST",
			  url: "<%=request.getContextPath()%>/pages/tiles/save.jsp?method=delUser",
			  dataType: "text",
			  data:dataString
		}).done(function(msg) {  
			alert(msg);
			window.location.reload();
		});	
		}
}



function fnAdd(){
	ownerid=$("#ownerid").val();
	drivername=$("#drivername").val();
	vno=$("#vno").val();
	imei=$("#imei").val();
	
	
	if(ownerid.length<=0){
		alert("Owner ID Value Empty!");
	}else if(drivername.length<=0){
		alert("Driver Name Value Empty!");
	}else if(vno.length<=0){
		alert("Vehicle Number Value Empty!");
	}else if(imei.length<=0){
		alert("IMEI Empty!");
	}else{
		dataString='ownerid='+ownerid+'&drivername='+drivername+'&vno='+vno+'&imei='+imei;
		alert(dataString);
		$.ajax({
			  type: "POST",
			  url: "<%=request.getContextPath()%>/pages/tiles/save.jsp?method=addOwner",
			  dataType: "text",
			  data:dataString
			}).done(function( msg ) {
				alert(msg.trim());
				window.location.reload();
		});
	}
	
	
}


</script>

</body>



</html>
