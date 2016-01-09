<!DOCTYPE HTML>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>IOT Charts</title>
		
		<style type="text/css">
		#container2 {
			height: 400px;
			min-width: 700px;
			max-width: 1100px;
			margin: 0 auto;
		}
		</style>

		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
		<style type="text/css">
${demo.css}
		</style>
		
		
<!-- -----------------------------------------	 -->
	<%
		HashMap<String,String> chartXY=(HashMap<String,String>)request.getAttribute("chartData1");
		Iterator itr=chartXY.entrySet().iterator();
		ArrayList chartXd=new ArrayList();
		ArrayList chartYd=new ArrayList();
		while(itr.hasNext()){
			Entry entry=(Entry)itr.next();
			
			chartXd.add(entry.getKey());
			chartYd.add(entry.getValue());
		}
	%>
<!-- -----------------------------------------	 -->

		<script type="text/javascript">
		var jsChartX;
		var jsChartY;
		<%  
		for (int i=0; i < chartYd.size(); i++) {  
		%>  
		jsChartX = '<%=chartXd.get(i) %>';
		jsChartY = <%=chartYd.get(i) %>;
		<%}%> 
		
		
		<% if(request.getParameter("department")!=null){%>
		var xmlhttp;
		var department_name;
		if (window.XMLHttpRequest)
		  {// code for IE7+, Firefox, Chrome, Opera, Safari
		  xmlhttp=new XMLHttpRequest();
		  }
		else
		  {// code for IE6, IE5
		  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		  }
		xmlhttp.onreadystatechange=function()
		  {
		  if (xmlhttp.readyState==4 && xmlhttp.status==200)
		    {
			  department_name=xmlhttp.responseText;
		    }
		  }
		xmlhttp.open("GET","rest/api/department/"+jsChartX,false);
		xmlhttp.send();
		<%}%>
		
$(function () {
    $('#container').highcharts({
        chart: {
            type: 'column'
        },
        title: {
            text: 'Patron footfall across sections'
        },
        subtitle: {
            text: 'A comparison between number of patrons visiting each section of the library in a given time duration.'
        },
        xAxis: {
            categories: [
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec'
            ]
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Patron FootFall'
            }
        },
        tooltip: {
            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                '<td style="padding:0"><b>{point.y:.1f}</b></td></tr>',
            footerFormat: '</table>',
            shared: true,
            useHTML: true
        },
        plotOptions: {
            column: {
                pointPadding: 0.2,
                borderWidth: 0
            }
        },
        series: [{
            name: department_name,
            data: jsChartY

        }]
    });
});
		</script>
		
	</head>
	<body>
<script src="/IOT/js/highcharts.js"></script>
<script src="/IOT/js/modules/exporting.js"></script>
		<table style="margin-left: 5%">
			<tr>
				<h1 style="text-align: center; color: #3399FF;margin-top: 1.5%;margin-bottom: 1.5%">IOT Charts at a Glance</h1>
			</tr>
			
			<tr>
				<%
				ServletContext context = getServletContext();
				RequestDispatcher dispatcher = context.getRequestDispatcher("/ChartTypes/combo/combo.jsp");
				dispatcher.include(request, response);
				%>
			</tr>
		
			<tr> 
			  <td id="depDiv" style="min-width: 28%;max-width:300px;" > </td>
			 <td><div id="container" style="min-width: 700px;max-width:900px; height: 400px; "></div></td>
			</tr>
		</table>
<br>
	</body>
</html>
