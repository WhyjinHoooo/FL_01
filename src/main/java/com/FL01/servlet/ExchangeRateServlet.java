package com.FL01.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.FL01.service.ExchangeRateService;

@WebServlet("/getExchangeRate")
public class ExchangeRateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("Servlet reached");

		String currencyCode = request.getParameter("currencyCode");
		String dealPrice = request.getParameter("dealPrice");

		if (currencyCode != null && dealPrice != null) {
			System.out.println("currencyCode: " + currencyCode);
			System.out.println("dealPrice: " + dealPrice);
		} else {
			System.out.println("개새");
			return;
		}

		BigDecimal exchangeRate = ExchangeRateService.getExchangeRate(currencyCode);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write("{\"exchangeRate\": " + exchangeRate + "}");
	}
}
