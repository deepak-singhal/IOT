package com.iot;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.iot.dao.ChartData;

/**
 * Servlet implementation class PrepareChart
 */
public class PrepareChart extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * Default constructor.
	 */
	public PrepareChart() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	protected void doProcess(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String chartType = (String) request.getParameter("chartType");

		if (chartType.equalsIgnoreCase("Patron Footfall in different Sections"))
			patronFootfall(request, response);

		if (chartType.equalsIgnoreCase("Patron vs Department"))
			patronVSdeptt(request, response);

	}

	public void patronFootfall(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		HashMap patronFootfallMap = null;
		String startDate = (String) request.getParameter("startDate");
		String endDate = (String) request.getParameter("endDate");

		try {
			patronFootfallMap = ChartData.getPatronFootFall(startDate, endDate);
		} catch (Exception e) {
			System.out.println("Error In Chart Data Preparation");
			e.printStackTrace();
		}

		request.setAttribute("chartData", patronFootfallMap);

		ServletContext context = getServletContext();
		RequestDispatcher dispatcher = context
				.getRequestDispatcher("/ChartTypes/3D-Column/patronFootFall.jsp");
		dispatcher.forward(request, response);
	}

	public void patronVSdeptt(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		HashMap depttVsPatronMap = null;
		String bId = request.getParameter("department");

		try {
			depttVsPatronMap = ChartData.getDepttVsPatron(bId);
		} catch (Exception e) {
			System.out.println("Error In Chart Data Preparation");
			e.printStackTrace();
		}

		request.setAttribute("chartData", depttVsPatronMap);

		ServletContext context = getServletContext();
		RequestDispatcher dispatcher = context
				.getRequestDispatcher("/ChartTypes/column-basic/patronVSdeptt.jsp");
		dispatcher.forward(request, response);
	}
}
