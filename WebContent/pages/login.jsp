<%@page import="com.util.UserAccountModel"%>
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
<h2>OBD Admin Login Portal </h2>   
<BR><BR><BR>
<%
if(request.getParameter("submit")!=null){
	String username=StringHelper.n2s(request.getParameter("username"));
	String pwd=StringHelper.n2s(request.getParameter("pwd"));
	List list=ConnectionManager.validateUser(username, pwd);
	if(list.size()>0){
		session.setAttribute("USER_MODEL", (UserAccountModel)list.get(0));
		%>
		<script>
			window.location.href='<%=request.getContextPath()%>/pages/vehicle.jsp';
		</script>
		<%  
	}else{		
		out.println("<h1>Invalid Credentials</h1>");
	}
	
}

%>
<form action="" method="post">
		<input name="methodId" value="loginUser" type="hidden">
<table align="center" class="SIMPLE" style="width:30%;" border="0" cellspacing="0" cellpadding="0">


<tr  class="even">
  <td colspan="2" style="text-align: center;"><img src="<%=request.getContextPath()%>/theme/images/dashboard-128.png"/></td>
</tr>
  <tr  class="even">
 
    <td  colspan="2" style="text-align: center;"><B>Login</B> </td>
 </tr>
  <tr class="even">
    <td>UserName </td>
    <td><input type="text" name="username" /></td>
  </tr>
  <tr class="even"> 
    <td>Password</td>
    <td><input type="Password" name="pwd" /></td>
  </tr>
  <tr  class="even">
    <td>&nbsp;</td>
    <td>    <input type="submit" name="submit" value="Login">&nbsp;</td>
  </tr>
  <tr class="even">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>

</table>
</form>
</div>


</body>
</html>
