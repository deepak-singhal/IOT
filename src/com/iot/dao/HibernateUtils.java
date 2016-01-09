package com.iot.dao;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtils {
	private static SessionFactory sessionfactory = new Configuration()
			.configure().buildSessionFactory();

	public static SessionFactory getSessionFactory() {
		return sessionfactory;
	}
}
