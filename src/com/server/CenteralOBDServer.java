package com.server;

import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.Executors;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;
import com.util.ConnectionManager;
import com.util.OBDModel;
import com.util.OwnerInfoModel;
import com.util.StringHelper;

public class CenteralOBDServer {

	
	public static void main(String[] args) throws IOException {
		System.out.println(new Date(12628896499787l).toGMTString());
		launchOBDServer();
	}

	
	public static void launchOBDServer() throws IOException {
		InetSocketAddress addr = new InetSocketAddress(9988);
		HttpServer server = HttpServer.create(addr, 0);
		server.createContext("/", new MyHandler());
		server.setExecutor(Executors.newCachedThreadPool());
		server.start();
		System.out.println("OBDServer is Listening on Port 9988");
	}

	
	
	
}


class MyHandler implements HttpHandler {
	public void handle(HttpExchange exchange) {
		OutputStream responseBody = exchange.getResponseBody();
		try {
			String uri = exchange.getRequestURI().getQuery();
			uri = URLDecoder.decode(uri);
			System.out.println("URI " + uri);
			final HashMap parameters = new HashMap();
			try {
				String tokens[] = uri.split("&");
				System.out.println("tokens " + tokens.length);
				for (String keyvalue : tokens) {
					String key = keyvalue.split("=")[0];
					String value = keyvalue.split("=")[1];
					System.out.println(key + "=" + value);
					parameters.put(key, value);
				}
			} catch (Exception e) {

			}
			System.out.println("Start -> "+new Date());
			String methodParameter = StringHelper.n2s(parameters.get("method"));

			boolean skipWriting = false;
			Headers responseHeaders = exchange.getResponseHeaders();

			// responseHeaders.set("Content-Type", "text/plain");

			exchange.sendResponseHeaders(200, 0);
			StringBuffer sb = new StringBuffer();
			if (methodParameter.equalsIgnoreCase("receive")) {
				OBDModel o = ConnectionManager.getOBDList();
				if (o != null) {
					ObjectOutputStream os = new ObjectOutputStream(responseBody);
					os.writeObject(o);
					os.flush();
					os.close();
					skipWriting = true;
				}
				skipWriting = true;
			}
			//Writing data to the server which is retrieved from 
			if (methodParameter.equalsIgnoreCase("send")) {
				new Thread(){
					public void run() {
						String iat = StringHelper.nullObjectToStringEmpty(parameters
								.get("iat"));
						String maf = StringHelper.nullObjectToStringEmpty(parameters
								.get("maf"));
						String throttlepos = StringHelper
								.nullObjectToStringEmpty(parameters.get("throttlepos"));
						
						String load_pct = StringHelper.nullObjectToStringEmpty(parameters.get("load_pct"));
						String vss = StringHelper.nullObjectToStringEmpty(parameters.get("vss"));
						String rpm = StringHelper.nullObjectToStringEmpty(parameters.get("rpm"));
						String temp = StringHelper.nullObjectToStringEmpty(parameters.get("temp"));
						String imei = StringHelper.nullObjectToStringEmpty(parameters.get("imei"));
						String latsend = StringHelper.nullObjectToStringEmpty(parameters.get("latsend"));
						String lngsend = StringHelper.nullObjectToStringEmpty(parameters.get("lngsend"));
						OwnerInfoModel oi  = ConnectionManager.getOwnerId(imei);
						String ownerid;
						String ownerno;
						if(oi!=null){
					
						boolean b = ConnectionManager.setOBDList(load_pct, iat, maf, throttlepos, vss, rpm, temp,  latsend, lngsend,oi);
						if(b){
							System.out.println("Writing Data To Server From Client " +b);
						}else{
							System.out.println("Server Writing Error / Connection Error! \n Please Restart The Server!" +b);
						}
						}
						
					}
				}.start();
			
				
				

			}

			else if (methodParameter.equalsIgnoreCase("reset")) {

				ConnectionManager.index = 0;
				sb.append("true");
			}
			if (!skipWriting) {
				System.out.println(sb.toString());
				responseBody.write(sb.toString().getBytes());
				responseBody.flush();
				responseBody.close();
			}
			System.out.print("Response Sent..............");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

		}
	}
}