	
package com.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Scanner;

import message.Sender;

public class ConnectionManager extends DatabaseUtility {

	public static void main(String[] args) {
	getDBConnection();
	}


	
	
	public static void closeConnection(Connection conn) {
		try {
			if (conn != null)
				conn.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}
	
	

	public static int index = 0;

	
	
	public static OBDModel getOBDList() {
		String query = "SELECT * FROM obd  order by `time` LIMIT " + index
				+ ",1";
		index++;
		System.out.println(query);
		List beans = getBeanList(OBDModel.class, query);
		System.out.println("Beans Size " + beans.size());
		OBDModel o = null;
		if (beans.size() > 0) {
			o = (OBDModel) beans.get(0);
		}
		return o;

	}

	
	public static List getAllOwners() {
		String query = "SELECT * FROM useraccounts u,vehicles v where v.ownerId=u.userid and u.role="+ServerConstants.ROLE_USER;
		System.out.println(query);
		List lst = getBeanList(OwnerInfoModel.class, query);
		System.out.println("Size "+lst.size());
		return lst;
	}
	public static List getAllOwners(String userId) {
		String query = "SELECT * FROM useraccounts u,vehicles v where v.ownerId=u.userid and u.role="+ServerConstants.ROLE_USER+" and u.userid="+userId;
		System.out.println(query);
		List lst = getBeanList(OwnerInfoModel.class, query);
		System.out.println("Size "+lst.size());
		return lst;
	}
	public static List getAllUsers() {
		String query = "SELECT * from useraccounts where role="+ServerConstants.ROLE_USER;
		System.out.println(query);
		List lst = getBeanList(UserAccountModel.class, query);
		System.out.println("Size "+lst.size());
		return lst;
	}
	
	
	
	public static AlertModel getAlertInfo(String ownerid, String type) {
		String query = "";
		AlertModel am= null;
		query = "SELECT * FROM alerts a where ownerid='"+ownerid+"' and alerttype like '"+type+"'";
		System.out.println(query);
		List lst = getBeanList(AlertModel.class, query);
		if (lst.size() > 0) {
			am = (AlertModel) lst.get(0);
		}
		return am;
	}
	
	public static OwnerInfoModel getOwnerInfo(String ownerid) {
		String query = "";
		OwnerInfoModel oi= null;
		query = "SELECT * FROM useraccounts o where userId='"+ownerid+"'";
		System.out.println(query);
		List lst = getBeanList(OwnerInfoModel.class, query);
		if (lst.size() > 0) {
			oi = (OwnerInfoModel) lst.get(0);
		}
		return oi;
	}
	
	public static boolean checkSpeedAlert(String ownerid, String vss){
		boolean b = false;
		String type= "S";
		String sql = "Select * from alerts o where o.ownerid like '"+ownerid+"' and o.alerttype = '"+type+"' and o.val < '"+vss+"'";
		List lst = getMapList(sql);
		if(lst.size()>0){
			b= true;
		}
		return b;
	}

	
	
	public static boolean checkPositionAlert(String ownerid, String lat, String lng){
		boolean b = false;
		String type= "P";
		String[] arr=Geocoder.getLocation(""+lat+","+lng);
		String currentLoacation = arr[0]+" "+arr[1];
		System.out.println("currentLoacation "+currentLoacation);
		AlertModel am = ConnectionManager.getAlertInfo(ownerid, type);
		String defaultplace = am.getVal();
		HashMap map = Geocoder.getDIstanceTimeDetails(defaultplace, currentLoacation);
		String i =(String) map.get("DISTANCE");
		System.out.println("Distance " +i);
		double range = 50f;	
		Scanner st = new Scanner(i);
        while (!st.hasNextDouble())
        {
            st.next();
        }
        double distanceBetween = st.nextDouble();
        System.out.println(distanceBetween);
        if(range < distanceBetween){
        	b= true;
        }else{
        	b= false;
        }
		return b;
	}

	
	public static boolean delVehicle(String ownerid,String vehicleno){
	boolean b = false;
	String query = "DELETE FROM ownertable WHERE ownerid=? and vehicleno = ?";
	System.out.println(query);
	int i = executeUpdate(query, new Object[] {ownerid, vehicleno});
	if (i > 0) {
		b = true;
	}
	return b;
	}
	
	

	public static boolean delOwner(String userid){
		boolean b = false;
		String query = "DELETE FROM useraccounts WHERE userid=?";
		System.out.println(query);
		int i = executeUpdate(query, new Object[] {userid});
		if (i > 0) {
			b = true;
		}
		
		query = "DELETE FROM vehicles WHERE ownerId=?";
		 i = executeUpdate(query, new Object[] {userid});
			if (i > 0) {
				b = true;
			}
		return b;
		}
	
	
	//(load_pct, iat, maf, throttlepos, vss, rpm, temp,  latsend, lngsend,oi);
	public static boolean setOBDList(String load_pct, String iat, String maf, String throttlepos, String vss, String rpm, String temp,String latsend, String lngsend, OwnerInfoModel oi) {
		boolean b = false;
		String ownername = oi.getUserid();
		String vehicleno = oi.getVehicleno();
		boolean alertCheck = ConnectionManager.checkSpeedAlert(oi.getOwnerId(), vss);
		boolean alertPosition = ConnectionManager.checkPositionAlert(oi.getOwnerId(), latsend, lngsend);
		String[] arr = Geocoder.getLocation(""+latsend+","+lngsend);
		String location = arr[0]+ " "+arr[1];
		String msg = "Hello " +ownername+ " , Your Vehicle " +vehicleno+" Has Crossed The Speed Limit of "+vss+" Km/Hr. Current Position of Your Vehicle: "+location;
		System.out.println("SMS To Send "+msg);
		if(alertCheck){
			  String sms[] = {oi.getPhoneno()};
		        for (int i = 0; i < sms.length; i++) {
		            message.Sender sender = new Sender(sms[i], msg);
		            try {
		                sender.send();
		                Thread.sleep(4000);
		            } catch (Exception e) {
		                // TODO Auto-generated catch block
		                e.printStackTrace();
		            }
		        }
		}
		
		String msg2 = "Hello " +ownername+ " , Your Vehicle " +vehicleno+" Has Crossed The Area Limit of Your Set Location & Current Position Of Your Vehicle is: "+location;
		if(alertPosition){
			  String sms[] = {oi.getPhoneno()};
		        for (int i = 0; i < sms.length; i++) {
		            message.Sender sender = new Sender(sms[i], msg2);
		            try {
		                sender.send();
		                Thread.sleep(4000);
		            } catch (Exception e) {
		                // TODO Auto-generated catch block
		                e.printStackTrace();
		            }
		        }
		}
		
		
		String query = "INSERT INTO obdserver (load_pct, temp, rpm, vss, iat, maf, throttlepos, vehicleId, latsend, lngsend)  values(?,?,?,?,?,?,?,?,?,?)";
		System.out.println(query);
		int i = executeUpdate(query, new Object[] { load_pct,temp, rpm, vss, iat, maf, throttlepos, oi.getVehicleId(), latsend, lngsend});
		if (i >= 0) {
			b = true;
		}
		return b;
	}

	
	
	
	public static boolean setAlert(String ownerid, String type, String val) {
		boolean b = false;
		String query = "INSERT INTO alerts (alerttype, val, ownerid)  values(?,?,?)";
		System.out.println(query);
		int i = executeUpdate(query, new Object[] {type, val, ownerid});
		if (i >= 0) {
			b = true;
		}
		return b;
	}
	
	
	
	public static boolean addOwner(String ownerid, String drivername,String vno, String imei) {
		boolean b = false;
		 
		String query = "INSERT INTO obdserver.vehicles (drivername, vehicleno, imei, ownerId)  values(?,?,?,?)";
		System.out.println(query);
		int i = executeUpdate(query, new Object[] {drivername,vno, imei, ownerid});
		if (i >= 0) {
			b = true;
		}
		return b;
	}
	
	
	public static boolean duplicateCheck(String ownerid,String val){
		boolean b = false;
		String sql = "Select * from alerts where ownerid='"+ownerid+"' and ";
		List lst = getMapList(sql);
		if(lst.size()>0){
			b= true;
		}
		return b;
	}
	
	
	
	
	public static List getOBDAllList(String vehicleNo) {
		String query = "";
		if (vehicleNo.length() > 0)
			query = "SELECT * FROM obd o,adminvehicles a where o.vehicleNo=a.vehicleNo and a.vehicleno like '%"
					+ vehicleNo + "%' order by `time` Limit 1,1000";
		else
			query = "SELECT * FROM obd o,adminvehicles a where o.vehicleNo =a.vehicleNo order by `time` Limit 1,1000";
		System.out.println(query);
		List beans = getBeanList(OBDModel.class, query);
		return beans;
	}
	
	
	
	
	public static OwnerInfoModel getOwnerId(String imei) {
		String query = "";
		OwnerInfoModel oi= null;
		query = "SELECT * FROM vehicles v,useraccounts u where v.ownerId=u.userId and v.imei='"+imei+"'";
		System.out.println(query);
		List lst = getBeanList(OwnerInfoModel.class, query);
		if (lst.size() > 0) {
			oi = (OwnerInfoModel) lst.get(0);
		}
		return oi;
	}

	
	public static List validateUser(String username, String pwd) {
		String query = "Select * from useraccounts a where a.login like '"+ username +"' and a.pass like '"+ pwd +"' ";
		return getBeanList(UserAccountModel.class, query);
	}
	

	public static boolean dataExists(String query) {

		boolean success = false;
		Connection conn = null;
		ResultSet rs = null;
		try {
			conn = ConnectionManager.getDBConnection();
			rs = conn.createStatement().executeQuery(query);
			System.out.println("Executing " + query);
			if (rs.next()) {
				success = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return success;
	}

	public static String getDomain() {
		String qu = "SELECT * FROM ownertable";
		return getDropDownList(qu);
	}
	
	public static String getDropDownList(String query) {
		String ret = "";
//		
//		System.out.println(query);
//		List domainList = DBUtils.getBeanList(OwnerInfoModel.class, query);
//		for (int i = 0; domainList.size() > 0 && i < domainList.size(); i++) {
//			OwnerInfoModel dm = (OwnerInfoModel) domainList.get(i);
//			ret += "<OPTION value='" + dm.getOwnerid()+ "'>" + dm.getOwnername()
//					+ "</OPTION>";
//		}
		System.out.println("ret  "+ret );
		return ret;
	}
	public static String getMaxValue(String query) {

		String success = "";
		Connection conn = null;
		ResultSet rs = null;
		try {
			conn = ConnectionManager.getDBConnection();
			rs = conn.createStatement().executeQuery(query);
			System.out.println("Executing " + query);
			if (rs.next()) {
				success = rs.getString(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return success;
	}
	
	
}
