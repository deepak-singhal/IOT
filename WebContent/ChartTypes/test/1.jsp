<!DOCTYPE HTML>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>IOT Combo Chart</title>

<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>

<%@page import="java.util.HashMap" %>

<!--  Script to fetch all Departments -->
<script>
	var xmlhttp;
	var jsonDepartment;
	<% 	
		ArrayList depttName = new ArrayList();
		ArrayList depttId = new ArrayList(); 
	%>
	var depttId = new Array();

	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp = new XMLHttpRequest();
	} else {// code for IE6, IE5
		xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
			jsonDepartment = xmlhttp.responseText;
			var jsonData = JSON.parse(jsonDepartment);
			for ( var i = 0; i < jsonData.beacon.length; i++) {
				var counter = jsonData.beacon[i];
				depttName[i] = counter.department;
				depttId[i] = counter.id;
			}
		}
	}
	xmlhttp.open("GET", "/IOT/rest/api/departments", false);
	xmlhttp.send();
</script>

<!--  Script to fetch all Departments with counts -->
<script>
			<%HashMap deptCountMap=new HashMap();%>
			for(var i=0;i<depttId.length;i++)
			{
				var xmlhttp;
				var count = new Array();
				if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
					xmlhttp = new XMLHttpRequest();
				} else {// code for IE6, IE5
					xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
				}
				xmlhttp.onreadystatechange = function() {
					if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
						count[i] = xmlhttp.responseText;
					}
				}
				xmlhttp.open("GET", "http://localhost:8080/IOT/rest/api/department/count/"+depttId[i], false);
				xmlhttp.send();
			}
</script>


<!--  ------------------------------- -->
<!--  Start of Page Rendering Script  -->
<!--  ------------------------------- -->

<style type="text/css">
${demo.css}
</style>
<script type="text/javascript">
	$(function() {
		$('#container1')
				.highcharts(
						{
							title : {
								text : 'Combo Chart'
							},
							xAxis : {
								categories : [ 'Jan', 'Feb', 'Mar', 'Apr',
										'May', 'Jun', 'Jul', 'Aug', 'Sep',
										'Oct', 'Nov', 'Dec' ]
							},
							labels : {
								items : [ {
									html : 'Library Trend',
									style : {
										left : '50px',
										top : '18px',
										color : (Highcharts.theme && Highcharts.theme.textColor)
												|| 'black'
									}
								} ]
							},
							series : [
							          
							          
							   <% 
							   for(int i=0; i<depttName.size();i++)
							    {%>
									{
										type : 'column',
										name : <%=depttName.get(i)%>,
										data : [ 3, 2, 1, 3, 4 ]
									},
							   <%}%>
									
									
									
									
									
							          
									{
										type : 'column',
										name : 'Jane',
										data : [ 3, 2, 1, 3, 4 ]
									},
									{
										type : 'column',
										name : 'John',
										data : [ 2, 3, 5, 7, 6 ]
									},
									{
										type : 'column',
										name : 'Joe',
										data : [ 4, 3, 3, 9, 0 ]
									},
									{
										type : 'spline',
										name : 'Average',
										data : [ 3, 2.67, 3, 6.33, 3.33 ],
										marker : {
											lineWidth : 2,
											lineColor : Highcharts.getOptions().colors[3],
											fillColor : 'white'
										}
									},
									{
										type : 'pie',
										name : 'Total consumption',
										data : [
												{
													name : 'Jane',
													y : 13,
													color : Highcharts
															.getOptions().colors[0]
												// Jane's color
												},
												{
													name : 'John',
													y : 23,
													color : Highcharts
															.getOptions().colors[1]
												// John's color
												},
												{
													name : 'Joe',
													y : 19,
													color : Highcharts
															.getOptions().colors[2]
												// Joe's color
												} ],
										center : [ 100, 80 ],
										size : 100,
										showInLegend : false,
										dataLabels : {
											enabled : false
										}
									} ]
						});
	});
</script>
<!--  ------------------------------ -->
<!--   End of Page Rendering Script  -->
<!--  ------------------------------ -->

</head>
<body>
	<script src="js/highcharts.js"></script>
	<script src="js/modules/exporting.js"></script>

	<div id="container1"
		style="min-width: 310px; height: 400px; margin: 0 auto"></div>

</body>
</html>