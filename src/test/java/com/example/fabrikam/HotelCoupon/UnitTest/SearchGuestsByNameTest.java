package com.example.fabrikam.HotelCoupon.UnitTest;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.mockito.Mockito.when;

import java.util.ArrayList;

import org.apache.logging.log4j.Logger;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Bean;
import org.springframework.test.context.junit4.SpringRunner;

import com.example.fabrikam.HotelCoupon.controller.GuestController;
import com.example.fabrikam.HotelCoupon.dao.GuestRepository;
import com.example.fabrikam.HotelCoupon.data.Guest;

@RunWith(SpringRunner.class)
public class SearchGuestsByNameTest {


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
					
	@Before
	public void setUp()
	{
		ArrayList<Guest> guestArrayList = new ArrayList<Guest>();

		Guest guestOne = new Guest();
		guestOne.setFirstName("GuestOne");
		guestOne.setLastName("FullName");
		guestOne.setId((long)9);
		guestArrayList.add(guestOne);
		
		Guest guestTwo = new Guest();
		guestTwo.setFirstName("GuestTwo");
		guestTwo.setLastName("FullName");
		guestTwo.setId((long)10);
		guestArrayList.add(guestTwo);

		when(guestRepository.findAll()).thenReturn(guestArrayList);			
	}
	
	/**
	 * Tests the Search by name in guests page using valid name that exists.
	 */
	
	@Test
	public void testSearchByNameValid() {	
		
		ArrayList<String> response = guestController.searchGuestsByName("full");			
		assertEquals(2,response.size());	
	}
	
	/**
	 * Tests the Search by name in guests page using invalid name that does not exists.
	 */
	
	@Test
	public void testSearchByNameInvalid()
	{
		ArrayList<String> response = guestController.searchGuestsByName("abc");			
		assertFalse("No search found",response.size()>0);
	}
	
	/**
	 * Tests the Search by name in guests page using string with length lesser than 3.
	 */
	
	@Test(expected = IllegalArgumentException.class)
	public void testIfStringLengthIsLesserThanThree()
	{
		guestController.searchGuestsByName("fu");
	}
	
	/**
	 * Tests the Search by name in guests page using valid string length.
	 */
	
	@Test(expected = IllegalArgumentException.class)
	public void testIfStringLengthIsGreaterThanThreeValid()
	{
		guestController.searchGuestsByName("fu");
	}
	
	
	/**
	 * Tests the Search by name in guests page using valid string with integers
	 */
	
	@Test(expected = IllegalArgumentException.class)
	public void testIfSearchStringContainsNumberInvalid()
	{
		guestController.searchGuestsByName("ab23");		
	}
}
