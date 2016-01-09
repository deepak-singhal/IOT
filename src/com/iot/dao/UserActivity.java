package com.iot.dao;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class UserActivity {
	
	/*****************************************************************/
	/******************* Supporting Methods ****************************/
	/*****************************************************************/
	public static String changeDateFormat(String date) throws ParseException {
		final String OLD_FORMAT = "MM/dd/yyyy";
		final String NEW_FORMAT = "yyyy-MM-dd hh:mm:ss";

		// e.g, Date : August 12, 2010
		String oldDateString = date;
		String newDateString;

		SimpleDateFormat simpleDate = new SimpleDateFormat(OLD_FORMAT);
		Date formatDate = simpleDate.parse(oldDateString);
		simpleDate.applyPattern(NEW_FORMAT);
		newDateString = simpleDate.format(formatDate);

		return newDateString;
	}

	public static int getCurrentYear() {
		Calendar now = Calendar.getInstance();
		int year = now.get(Calendar.YEAR);
		return year;
	}
	
	public static String millistoDate(long time) throws ParseException {
	       Date date = new Date(time);
	       DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	       return dateFormat.format(date);
	}
}
