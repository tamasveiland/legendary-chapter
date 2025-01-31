package com.example.fabrikam.HotelCoupon.Logger;

public enum CustomEventIds {
	
	GUESTINDEX("1010"),
	COUPONINDEX("1020"),
	PARSEGUEST("1021"),
	EXECUTIONTIME("1022");
	
	 public final String eventId; 
	  
//	    public String getEventId() 
//	    { 
//	        return this.eventId; 
//	    } 
//	  
	    private CustomEventIds(String eventId) 
	    { 
	        this.eventId = eventId; 
	    } 
}
