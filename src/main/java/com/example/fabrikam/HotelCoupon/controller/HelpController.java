package com.example.fabrikam.HotelCoupon.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HelpController {

	 @RequestMapping("/help")
	    public void help()
	    {
	    	throw new UnsupportedOperationException("Not implemented yet");
	    }
}
