package com.example.fabrikam.HotelCoupon;



import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

@ControllerAdvice
public class GlobalExceptionHandler {

	@Autowired
	private Logger logger;

	
	@ExceptionHandler(Exception.class)
	public String handleIOException(Throwable exception){
		logger.error("Error occuerd in the app",exception);
		return "Error Occured" ;
	}
}
