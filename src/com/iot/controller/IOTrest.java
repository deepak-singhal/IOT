package com.iot.controller;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import com.iot.dao.HibernateUtils;
import com.iot.dao.UserActivity;
import com.iot.dto.Beacon;
import com.iot.dto.Beacon_Data;
import com.iot.dto.Items;

@Path("/api")
public class IOTrest {

	SessionFactory sessionfactory;
	Session session = null;
	Transaction transaction = null;

	/*
	 * To fetch Random Item Information from nearby Beacon for specific Device
	 */
	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	@Path("{id}")
	public Response getAnswer(@PathParam("id") String id) throws SQLException {
		String urlParams[] = id.split(","); // BeaconID, DeviceID
		String bId = urlParams[0]; // Beacon ID
		String dId = urlParams[1]; // Device ID (UserName)
		List<Items> list = new ArrayList<Items>();
		List<String> listDeptt = new ArrayList<String>();
		String returnString = "";

		System.out.println("BeaconID : " + bId);
		System.out.println("Device / User ID : " + dId);
		try {
			sessionfactory = HibernateUtils.getSessionFactory();
			session = sessionfactory.openSession();
			transaction = session.beginTransaction();
			Query entryQuery = session
					.createQuery("SELECT department FROM Beacon WHERE id=:bId");
			entryQuery.setParameter("bId", bId);
			listDeptt = entryQuery.list();
			if (listDeptt.size() == 0) {
				transaction.commit();
				return Response.status(Response.Status.BAD_REQUEST).build();
			}
			if (listDeptt.get(0).equalsIgnoreCase("ENTRY")) {
				returnString = "Welcome to Innovative Smart Library."
						+ " Tap if you need my help in discovering something that interests you";
			} else {
				Query query = session
						.createQuery("From Items where beacon_id=:beacon_id ORDER BY RAND()");
				query.setParameter("beacon_id", bId);
				list = query.list();
				returnString = "Interested in " + listDeptt.get(0) + "? \""
						+ list.get(0).getItem_title()
						+ "\" is now available for checkout";
			}
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			System.out.println("Exception in GetDepartments");
			return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
					.build();
		} finally {
			session.flush();
			session.close();
		}
		return Response.status(Response.Status.OK).entity(returnString).build();
	}

	/*
	 * To fetch all the Departments in a library
	 */
	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	@Path("departments")
	public List<Beacon> getDepartments(
			@PathParam("departments") String departments) throws SQLException {
		List<Beacon> list = null;
		try {
			sessionfactory = HibernateUtils.getSessionFactory();
			session = sessionfactory.openSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery("From Beacon");
			list = query.list();

			transaction.commit();
			session.flush();
			session.close();
		} catch (Exception e) {
			transaction.rollback();
			session.close();
			System.out.println("Exception in GetDepartments");
		}

		return list;
	}

	/*
	 * To fetch the Name of the Department
	 */
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	@Path("/department/{beaconId}")
	public String getDepartmentName(@PathParam("beaconId") String beaconId)
			throws SQLException {
		Beacon beacon = new Beacon();
		try {
			sessionfactory = HibernateUtils.getSessionFactory();
			session = sessionfactory.openSession();
			transaction = session.beginTransaction();
			beacon = (Beacon) session.get(Beacon.class, beaconId);

			transaction.commit();
			session.flush();
			session.close();
		} catch (Exception e) {
			transaction.rollback();
			session.close();
			System.out.println("Exception in getDepartmentName");
		}
		return beacon.getDepartment();
	}

	/*
	 * To fetch the Footfall in the specific Department
	 */
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	@Path("/department/count/{beaconId}")
	public String getDepartmentcount(@PathParam("beaconId") String beaconId)
			throws SQLException {
		Integer count = 0;
		try {
			sessionfactory = HibernateUtils.getSessionFactory();
			session = sessionfactory.openSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery("SELECT COUNT(*) from Beacon_Data where beaconId=:beaconId");
			query.setParameter("beaconId", beaconId);
			count = ((Number)query.uniqueResult()).intValue();
			transaction.commit();
			session.flush();
			session.close();
		} catch (Exception e) {
			transaction.rollback();
			session.close();
			System.out.println("Exception in getDepartmentName");
		}
		return count+"";
	}

	/*
	 * To capture the Time Spent in a section by a patron
	 */
	@GET
	@Path("/user/{beaconId}/{deviceId}/{timeIn}/{timeOut}")
	@Produces(MediaType.APPLICATION_XML)
	public String captureTime(@PathParam("beaconId") String beaconId,
			@PathParam("deviceId") String deviceId,
			@PathParam("timeIn") String timeInMillis,
			@PathParam("timeOut") String timeOutMillis)
			throws NumberFormatException, ParseException {
		String result = "SUCCESS";
		Timestamp timeIn = Timestamp.valueOf(UserActivity.millistoDate(Long
				.parseLong(timeInMillis)));
		Timestamp timeOut = Timestamp.valueOf(UserActivity.millistoDate(Long
				.parseLong(timeOutMillis)));

		Beacon_Data data = new Beacon_Data();
		data.setBeaconId(beaconId);
		data.setDeviceId(deviceId);
		data.setTimeIn(timeIn);
		data.setTimeOut(timeOut);

		try {
			sessionfactory = HibernateUtils.getSessionFactory();
			session = sessionfactory.openSession();
			transaction = session.beginTransaction();

			session.save(data);

			transaction.commit();
			session.flush();
			session.close();
		} catch (Exception e) {
			transaction.rollback();
			session.close();
			System.out.println("Exception in getDepartmentName");
			result = "FAILURE";
		}
		return "<?xml version=\"1.0\"?>" + "<result>" + result + "</result>";
	}
}
