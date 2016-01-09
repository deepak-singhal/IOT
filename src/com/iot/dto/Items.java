package com.iot.dto;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class Items {
	int id;
	String item_id;
	String beacon_id;
	String item_title;
	String item_author;

	public Items() {
		super();
	}

	public Items(int id, String item_id, String beacon_id, String item_title,
			String item_author) {
		super();
		this.id = id;
		this.item_id = item_id;
		this.beacon_id = beacon_id;
		this.item_title = item_title;
		this.item_author = item_author;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getItem_id() {
		return item_id;
	}

	public void setItem_id(String item_id) {
		this.item_id = item_id;
	}

	public String getBeacon_id() {
		return beacon_id;
	}

	public void setBeacon_id(String beacon_id) {
		this.beacon_id = beacon_id;
	}

	public String getItem_title() {
		return item_title;
	}

	public void setItem_title(String item_title) {
		this.item_title = item_title;
	}

	public String getItem_author() {
		return item_author;
	}

	public void setItem_author(String item_author) {
		this.item_author = item_author;
	}
}
