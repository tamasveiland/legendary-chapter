package com.example.fabrikam.HotelCoupon.config;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.example.fabrikam.HotelCoupon.HotelCouponApplication;

@Configuration
public class LoggerConfiguration {

	@Bean
	public Logger getLogger() {
		return LogManager.getLogger(HotelCouponApplication.class);
	}
}