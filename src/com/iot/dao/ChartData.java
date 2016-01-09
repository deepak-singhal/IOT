package com.iot.dao;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map.Entry;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.classic.Session;

import com.iot.dto.Beacon;
import com.iot.dto.Beacon_Data;

public class ChartData {
	
	/*****************************************************************/
	/*************** Specific Chart Methods (Secondary) **************/
	/*****************************************************************/
	@SuppressWarnings("unchecked")
	public static HashMap<String, String> getBeaconInfo() throws SQLException {
		SessionFactory sessionFactory = HibernateUtils.getSessionFactory();
		Session session = sessionFactory.openSession();
		Transaction transaction = session.beginTransaction();
		List<Beacon> list = session.createQuery("From Beacon").list();

		HashMap<String, String> beaconData = new HashMap<String, String>();

		for (Beacon beacon : list)
			beaconData.put(beacon.getId() + "", beacon.getDepartment());

		transaction.commit();
		session.close();

		return beaconData;
	}

	/*****************************************************************/
	/*************** Specific Chart Methods (Primary) ****************/
	/*****************************************************************/

	@SuppressWarnings("unchecked")
	public static HashMap<String, String> getPatronFootFall(String startDate,
			String endDate) throws SQLException, ParseException {
		SessionFactory sessionFactory = HibernateUtils.getSessionFactory();
		Session session = sessionFactory.openSession();
		Transaction transaction = session.beginTransaction();

		HashMap<String, String> beaconInfo = getBeaconInfo();

		Iterator<Entry<String, String>> it = beaconInfo.entrySet().iterator();

		String bId;
		String bDepartment;
		HashMap<String, String> chartMap = new HashMap<String, String>();

		while (it.hasNext()) {
			Entry<String, String> entry = (Entry<String, String>) it.next();
			bId = (String) entry.getKey();
			bDepartment = (String) entry.getValue();

			Query query = session
					.createQuery("From Beacon_Data where beacon_id=:bId AND time_in>=:startDate AND time_in<=:endDate");
			query.setParameter("bId", bId);
			query.setParameter("startDate", startDate);
			query.setParameter("endDate", endDate);
			List<Beacon_Data> list = query.list();

			chartMap.put(bDepartment, list.size() + "");
		}

		transaction.commit();
		session.close();
		return chartMap;
	}

	public static HashMap<String, List<Beacon_Data>> getDepttVsPatron(String bId)
			throws SQLException, ParseException {
		SessionFactory sessionFactory = HibernateUtils.getSessionFactory();
		Session session = sessionFactory.openSession();

		Query query = session
				.createQuery("Select count(*) FROM Beacon_Data WHERE beaconId=:bId GROUP BY month(timeIn)");
		query.setParameter("bId", bId);
		List<Beacon_Data> list = query.list();

		HashMap<String, List<Beacon_Data>> chartMap = new HashMap<String, List<Beacon_Data>>();
		chartMap.put(bId, list);

		return chartMap;
	}

	@SuppressWarnings("unchecked")
	public static HashMap<String, List<Beacon_Data>> comboMap()
			throws SQLException, ParseException {
		SessionFactory sessionFactory = HibernateUtils.getSessionFactory();
		Session session = sessionFactory.openSession();

		HashMap<String, String> beaconInfo = getBeaconInfo();

		String bId;
		HashMap<String, List<Beacon_Data>> chartMap = new HashMap<String, List<Beacon_Data>>();
		Iterator<Entry<String, String>> it = beaconInfo.entrySet().iterator();
		while (it.hasNext()) {
			Entry<String, String> entry = (Entry<String, String>) it.next();
			bId = (String) entry.getKey();
			Query query = session
					.createQuery("Select count(*) FROM Beacon_Data WHERE beaconId=:bId GROUP BY month(timeIn)");
			query.setParameter("bId", bId);
			List<Beacon_Data> list = new ArrayList<Beacon_Data>();
			list = query.list();

			chartMap.put(bId, list);
		}
		return chartMap;
	}
}