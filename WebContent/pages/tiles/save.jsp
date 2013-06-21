<%@page import="com.util.ConnectionManager"%>
<%@page import="com.util.StringHelper"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Enumeration"%>
<%@page import="org.apache.commons.collections.functors.ForClosure"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URL"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.util.DBUtils"%>
<%@page import="org.json.JSONTokener"%>
<%@page import="org.json.JSONObject"%>

<%
	String method = StringHelper.n2s(request.getParameter("method"));
	String id = StringHelper.n2s(request.getParameter("id"));
	System.out.println(method + " " + id);
	
	java.util.HashMap parameters = StringHelper.displayRequest(request);
	String str = "";

	if (method.equalsIgnoreCase("getDomain")) {
		System.out.println("Into getDomain");
		str = ConnectionManager.getDomain();
		response.getWriter().write(str);
		response.getWriter().close();
	}
	else if (method.equalsIgnoreCase("logout")) {
session.removeAttribute("USER_MODEL");
	%>
	<script>
	window.location.href='<%=request.getContextPath()%>/pages/index.jsp';
	</script>
	<%
	}
	
	else if(method.equalsIgnoreCase("addAlert")){
	String ownerid = StringHelper.n2s(request.getParameter("ownerid"));
	String type= StringHelper.n2s(request.getParameter("type"));
	String val= StringHelper.n2s(request.getParameter("val"));
	boolean b = ConnectionManager.setAlert(ownerid, type, val);
	if(b){
		out.println("Alert Added In Database!");
	}
	else{
		out.println("Error in Adding Alert In Database!");
	}
	}
	
	
	else if(method.equalsIgnoreCase("addOwner")){
		String ownerid = StringHelper.n2s(request.getParameter("ownerid"));
		String drivername= StringHelper.n2s(request.getParameter("drivername"));
		String vno= StringHelper.n2s(request.getParameter("vno"));
		String imei= StringHelper.n2s(request.getParameter("imei"));
		
		boolean b = ConnectionManager.addOwner(ownerid, drivername, vno, imei);
		if(b){
			out.println("Vehicle Details Added In Database!");
		}
		else{
			out.println("Error in Adding Vehicle Details In Database!");
		}
	
	
	}else if(method.equalsIgnoreCase("deleteUser")){
		String ownerid = StringHelper.n2s(request.getParameter("ownerid"));
		String vehicleno = StringHelper.n2s(request.getParameter("vehicleno"));
		/*
		boolean b = ConnectionManager.delOwner(ownerid, vehicleno);
		if(b){
			out.println("User Details Deleted From Database!");
		}
		else{
			out.println("Error in Deleting Database!");
		}
		
	*/
	
	
	}else if(method.equalsIgnoreCase("delUser")){
		String ownerid = StringHelper.n2s(request.getParameter("ownerid"));
		boolean b = ConnectionManager.delOwner(ownerid);
		if(b){
			out.println("User Details Deleted From Database!");
		}
		else{
			out.println("Error in Deleting Database!");
		}
		}
	
	
	
	
%>