package com.example.fabrikam.HotelCoupon.UnitTest;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

import java.util.ArrayList;

import org.apache.logging.log4j.Logger;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Bean;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.validation.support.BindingAwareModelMap;

import com.example.fabrikam.HotelCoupon.controller.CouponController;
import com.example.fabrikam.HotelCoupon.dao.CouponRepository;
import com.example.fabrikam.HotelCoupon.dao.GuestRepository;
import com.example.fabrikam.HotelCoupon.data.Coupon;
import com.example.fabrikam.HotelCoupon.model.CouponListViewModel;

@RunWith(SpringRunner.class)
public class CouponControllerTest {

	@TestConfiguration
	static class CouponControllerConfiguration {

		@Bean
		public CouponController controller() {
			return new CouponController();
		}
	}

	@Autowired
	CouponController couponimpl;

	@MockBean
	CouponRepository couponRepository;

	@MockBean
	private GuestRepository guestRepository;

	@MockBean
	private Logger logger;

	@Test
	public void testIndex() {

		BindingAwareModelMap model = new BindingAwareModelMap();

		ArrayList<Coupon> couponArrayList = new ArrayList<Coupon>();

		Coupon couponOne = new Coupon();
		couponOne.setId(2345);
		couponOne.setTitle("testing");
		couponArrayList.add(couponOne);

		Coupon couponTwo = new Coupon();
		couponTwo.setId(9987);
		couponTwo.setAddressLine1("hyderabad");
		couponTwo.setTitle("test2");
		couponArrayList.add(couponTwo);

		when(couponRepository.findAll()).thenReturn(couponArrayList);

		String guestId = "9";
		String coupon = couponimpl.index(model, guestId);

		CouponListViewModel couponListViewModel = (CouponListViewModel) model.get("couponsModel");

		assertEquals(couponArrayList.size(), couponListViewModel.getCouponList().size());
		assertEquals((long) 9987, (long) (couponListViewModel.getCouponList().get(1).getId()));
		assertEquals("testing", couponListViewModel.getCouponList().get(0).getTitle());
		assertEquals("coupon", coupon);
	}
}
