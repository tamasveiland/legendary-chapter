package com.example.fabrikam.HotelCoupon.IntegrationTest;

import static org.junit.Assert.assertEquals;

import org.junit.Ignore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.support.BindingAwareModelMap;

import com.example.fabrikam.HotelCoupon.controller.CouponController;
import com.example.fabrikam.HotelCoupon.dao.CouponRepository;
import com.example.fabrikam.HotelCoupon.model.CouponListViewModel;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

@Ignore
public class CouponControllerStepDefinitions extends CouponControllerIT {

	String response;
	CouponListViewModel couponListViewModel;

	@Autowired
	CouponController couponController;

	@Autowired
	CouponRepository couponRepository;

	@Given("Guest has the provision to get coupons")
	public void guest_has_the_provision_to_get_coupons() {

		System.out.println("excluding given!!");
	}

	@When("the guest with id {string} requests on coupons")
	public void the_guest_with_id_requests_on_coupons(String guestId) {
		BindingAwareModelMap couponModel = new BindingAwareModelMap();
		response = couponController.index(couponModel, guestId);
		couponListViewModel = (CouponListViewModel)couponModel.get("couponsModel");
	}

	@Then("list of coupons alloted for guest with id {string} is displayed.")
	public void list_of_coupons_alloted_for_guest_with_id_is_displayed(String guestId) {
		assertEquals(8, couponListViewModel.getCouponList().size());
		assertEquals((long) 2, (long) (couponListViewModel.getCouponList().get(1).getId()));
		assertEquals("coupon", response);

	}

}
