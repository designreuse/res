package com.xzd.substation.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.plugin.activerecord.Record;

public class Status {

	public boolean success ; 
	public String message ; 
	public List<Map<String , Object>> result ; 
	
	public Status() {
		super();
	}
	
	public Status(boolean success, String message){
		this.success = success ; 
		this.message = message ; 
	}
	
	public Status(boolean success, String message,String key , Object value){
		Map<String , Object> map = new HashMap<String , Object>();
		map.put(key, value);
		List<Map<String , Object>> list = new ArrayList<Map<String , Object>>();
		list.add(map);
		this.success = success ; 
		this.message = message ; 
		this.result = list;
	}
	
	public Status(boolean success, String message,Map<String , Object> map){
		List<Map<String , Object>> list = new ArrayList<Map<String , Object>>();
		list.add(map);
		this.success = success ; 
		this.message = message ; 
		this.result = list;
	}

	public Status(boolean success, String message , Record record){
		List<Map<String , Object>> list = new ArrayList<Map<String , Object>>();
		list.add(record.getColumns());
		this.success = success ; 
		this.message = message ; 
		this.result = list;
	}
	
	public Status(boolean success, String message , List<Record> records){
		List<Map<String , Object>> list = new ArrayList<Map<String , Object>>();
		for (Record record : records) {
			list.add(record.getColumns());
		}
		this.success = success ; 
		this.message = message ; 
		this.result = list;
	}


	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public List<Map<String, Object>> getResult() {
		return result;
	}

	public void setResult(List<Map<String, Object>> result) {
		this.result = result;
	}

	@Override
	public String toString() {
		return "Status [success=" + success + ", message=" + message + ", result=" + result + "]";
	}
}
