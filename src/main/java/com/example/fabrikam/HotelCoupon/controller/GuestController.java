package com.example.fabrikam.HotelCoupon.controller;

import com.example.fabrikam.HotelCoupon.dao.GuestRepository;
import com.example.fabrikam.HotelCoupon.data.Guest;
import com.example.fabrikam.HotelCoupon.model.GuestListViewModel;

 
import org.apache.logging.log4j.CloseableThreadContext;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import com.example.fabrikam.HotelCoupon.Logger.CustomEvents;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Controller
public class GuestController {

	@Autowired
	private GuestRepository guestRepository;

	 
	@Autowired
	private Logger logger;
	
	
	@RequestMapping("/guest")
	public String index(Model model, HttpServletRequest httpRequest) {
		ArrayList<Guest> guestList = guestRepository.findAll();
		model.addAttribute("guestsModel", new GuestListViewModel(guestList));
		
		 
		try (final CloseableThreadContext.Instance ctc = CloseableThreadContext.put("EventId", CustomEvents.getGuestEID())) {
			logger.info("In guest controller index");
		}
		
		return "guest";
	}

	public ArrayList<String> searchGuestsByName(String guestName) {

		if (guestName.length() < 3) {
			throw new IllegalArgumentException("String length cannot be less than three");
		}

		Pattern pattern = Pattern.compile("([0-9])");
		Matcher matcher = pattern.matcher(guestName);

		if (matcher.find()) {
			throw new IllegalArgumentException("String can not contain numbers!");
		}

		ArrayList<Guest> guestArrayList = guestRepository.findAll();
		ArrayList<String> nameArrayList = new ArrayList<String>();
		guestArrayList.forEach(g -> {
			if (g.getFullName().toLowerCase().contains(guestName)) {
				nameArrayList.add(g.getFullName());
			}
		});

		return nameArrayList;

	}

}
