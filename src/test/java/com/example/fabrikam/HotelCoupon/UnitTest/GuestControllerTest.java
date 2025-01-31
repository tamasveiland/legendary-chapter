package com.example.fabrikam.HotelCoupon.UnitTest;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.Logger;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Bean;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.validation.support.BindingAwareModelMap;

import com.example.fabrikam.HotelCoupon.controller.GuestController;
import com.example.fabrikam.HotelCoupon.dao.GuestRepository;
import com.example.fabrikam.HotelCoupon.data.Guest;
import com.example.fabrikam.HotelCoupon.model.GuestListViewModel;

@RunWith(SpringRunner.class)
public class GuestControllerTest {

	@TestConfiguration
	static class GuestControllerConfiguration {
		@Bean
		public GuestController controller() {
			return new GuestController();
		}
	}

	@Autowired
	GuestController guestController;

	@MockBean
	private GuestRepository guestRepository;

	@MockBean
	private Logger logger;

	@MockBean
	private HttpServletRequest httpRequest;

	@Test
	public void test() throws Exception {

		BindingAwareModelMap model = new BindingAwareModelMap();
		ArrayList<Guest> guestArrayList = new ArrayList<Guest>();

		Guest guestOne = new Guest();
		guestOne.setFirstName("Guest1");
		guestOne.setId((long) 1234);
		guestArrayList.add(guestOne);

		when(guestRepository.findAll()).thenReturn(guestArrayList);

		String guest = guestController.index(model, httpRequest);

		assertEquals("guest", guest);

		GuestListViewModel guestview = (GuestListViewModel)model.get("guestsModel");

		assertEquals(guestArrayList.size(), guestview.getGuestList().size());

		assertEquals((long) 1234, (long) (guestview.getGuestList().get(0).getId()));

	}
}
