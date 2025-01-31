package com.example.fabrikam.HotelCoupon.IntegrationTest;

import static org.junit.Assert.assertEquals;

import java.util.List;
import java.util.concurrent.TimeUnit;

import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.ie.InternetExplorerDriver;
import org.openqa.selenium.ie.InternetExplorerOptions;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@TestPropertySource(locations="classpath:application.properties")
public class LoginUIIT {
	
	/*
	 * Extract application URL from application.properties
	 */
	
	@Value("${app.url}")
	private String appUrl;
	
	/*
	 * Set property for location of drivers.
	 */
	
	@BeforeClass
	public static void setupClass() {
		System.setProperty("webdriver.chrome.driver", "src/test/resources/binaries/chromedriver.exe");
		System.setProperty("webdriver.gecko.driver", "src/test/resources/binaries/geckodriver.exe");
		System.setProperty("webdriver.ie.driver", "src/test/resources/binaries/IEDriverServer.exe");
	}
	
	/*
	 * UI test with Chrome browser
	 */
	
	@Test
	public void testInQAChrome() throws InterruptedException {
		System.out.println(String.format("Testing chrome against: %s", appUrl));
		UiTesting(new ChromeDriver());
	}
	
	/*
	 * UI test with Firefox browser
	 */
	
	@Test
	public void testInQAFirefox() throws InterruptedException {
		System.out.println(String.format("Testing firefox against: %s", appUrl));
		UiTesting(new FirefoxDriver());
	}
	
	/*
	 * UI test with Internet Explorer
	 */

	@Test
	public void testInterExplorer() throws InterruptedException {
		System.out.println(String.format("Testing IE against: %s", appUrl));
		DesiredCapabilities capabilities = DesiredCapabilities.internetExplorer();
		capabilities.setCapability(InternetExplorerDriver.NATIVE_EVENTS, false);
		capabilities.setCapability(InternetExplorerDriver.IGNORE_ZOOM_SETTING, true);
		capabilities.setCapability(InternetExplorerDriver.INTRODUCE_FLAKINESS_BY_IGNORING_SECURITY_DOMAINS, true);
		UiTesting(new InternetExplorerDriver(new InternetExplorerOptions(capabilities)));
	}

	public void UiTesting(WebDriver browserDriver) throws InterruptedException {
		try {
			browserDriver.findElement(By.tagName("html")).sendKeys(Keys.CONTROL, "0");
			browserDriver.get(appUrl);
			browserDriver.manage().window().maximize();
			browserDriver.findElement(By.id("inputUsername")).sendKeys("me@smarthotel360.com");
			browserDriver.findElement(By.id("inputPassword")).sendKeys("1234");

			browserDriver.findElement(By.id("formId")).submit();
			TimeUnit.SECONDS.sleep(5);
			List<WebElement> listCount = browserDriver.findElements(By.className("guest-row"));
			assertEquals(7, listCount.size());
			assertEquals("2", listCount.get(1).findElement(By.id("guestList1.id")).getAttribute("value"));
			assertEquals("Lane", listCount.get(1).findElement(By.xpath("ul/li[2]")).getText());

			browserDriver.findElement(By.id("searchGuest")).sendKeys("sop");
			browserDriver.findElement(By.id("clickSearch")).click();
			TimeUnit.SECONDS.sleep(5);

			listCount = browserDriver.findElements(By.cssSelector(".guest-row:not(.hidden)"));
			for (WebElement webElement : listCount) {
				String name = webElement.findElement(By.tagName("li")).getText();
				assertEquals(true, name.contains("Sop"));
			}

			browserDriver.findElement(By.className("coupon-btn")).click();
		} finally {
			if (browserDriver != null) {
				browserDriver.quit();
			}
		}
	}
}
