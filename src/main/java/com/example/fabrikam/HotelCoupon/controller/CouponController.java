package com.example.fabrikam.HotelCoupon.controller;

import com.example.fabrikam.HotelCoupon.Logger.CustomEvents;
import com.example.fabrikam.HotelCoupon.dao.CouponRepository;
import com.example.fabrikam.HotelCoupon.dao.GuestRepository;
import com.example.fabrikam.HotelCoupon.data.Coupon;
import com.example.fabrikam.HotelCoupon.data.Guest;
import com.example.fabrikam.HotelCoupon.model.CouponListViewModel;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StopWatch;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.CloseableThreadContext;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.Marker;
import org.apache.logging.log4j.MarkerManager;

@Controller
public class CouponController {

    @Autowired
    private CouponRepository couponRepository;

    @Autowired
    private GuestRepository guestRepository;
    
     
	@Autowired
	private Logger logger;
    
    
    StopWatch timeTaken = new StopWatch();
    
    @RequestMapping("/coupon")
    public String index(Model model,String guestId){
    	
    	
       timeTaken.start();
       
       
        ArrayList<Coupon> couponList = couponRepository.findAll();
       
       
        timeTaken.stop();
		try (final CloseableThreadContext.Instance ctc = CloseableThreadContext
				.put("EventId", CustomEvents.getCouponTimeID())
				.put("DurationMs", String.valueOf(timeTaken.getTotalTimeMillis()))) {
			logger.info("Total time taken to get Coupons");
			
		}
        

        int guestIdInt = 0;
        
            guestIdInt = Integer.parseInt(guestId);
            try (final CloseableThreadContext.Instance ctc = CloseableThreadContext.put("EventId", CustomEvents.getCouponParseGuestID())) {
    			logger.info("parsing for guest");
    		}    
        
        Guest guest = guestRepository.findById((long)guestIdInt);
        model.addAttribute("couponsModel", new CouponListViewModel(couponList,guest));       
        return "coupon";

    }

}
