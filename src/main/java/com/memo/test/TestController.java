package com.memo.test;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class TestController {
	@ResponseBody
	@RequestMapping("/test")
	public String test() {
		return "Hello world!";
	}
	
	@RequestMapping("/jsp_test")
	public String jspTest() {
		return "test/test";
	}
}
