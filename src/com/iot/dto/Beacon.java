package com.iot.dto;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class Beacon {
	String id;
	String department;

	public Beacon() {
		super();
	}

	public Beacon(String id, String department) {
		super();
		this.id = id;
		this.department = department;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

}
