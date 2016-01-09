<!DOCTYPE HTML>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>Highcharts Example</title>

		<!-- <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script> -->
		<style type="text/css">
${demo.css}
		</style>

<!-- -----------------------------------------	 -->
<%
	HashMap<String, String> chartXY = (HashMap<String, String>) request.getAttribute("chartData");

	Iterator itr = chartXY.entrySet().iterator();

	ArrayList chartX = new ArrayList();
	ArrayList chartY = new ArrayList();

	while (itr.hasNext()) {
		Entry entry = (Entry) itr.next();

		chartX.add(entry.getKey());
		chartY.add(entry.getValue());
	}
%>
<!-- -----------------------------------------	 -->


<script type="text/javascript">
$(function () {
    $('#container2').highcharts({
        chart: {
            type: 'pie',
            options3d: {
                enabled: true,
                alpha: 45,
                beta: 0
            }
        },
        title: {
            text: 'Patron footfall over a given time period'
        },
        subtitle : {
			text : 'A distribution of patrons visiting a particular library section spread over a given time duration.'
		},
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                depth: 35,
                dataLabels: {
                    enabled: true,
                    format: '{point.name}'
                }
            }
        },
        series: [{
            type: 'pie',
            name: 'Footfall share',
            data: [
					<% for(int i=0;i<chartX.size();i++){%>
					['<%=chartX.get(i)%>',   <%=chartY.get(i)%>],
					<%}%>
            ]
        }]
    });
});
		</script>
	</head>
	<body>

<script src="../../js/highcharts.js"></script>
<script src="../../js/highcharts-3d.js"></script>
<script src="../../js/modules/exporting.js"></script>

	<table style="margin-left: 5%">
		<tr>
			<td style="min-width: 28%;max-width:300px;">
				<div>
				<form action="statistics.jsp" id="pt" name="patronFootFall" style="width: 85%">
					<input type="hidden" name="department" id="hdepartment" value="" />
					<div id="dateRange">
						<!-- <label for="dateRange"><b>Date Range:</b></label><br> --> 
						<label for="startDate">Start Date *:</label>
						<div id="startDate" class="input-append date">
							<input type="text" id="sDate" name="sDate" value=""></input> <span
								class="add-on"> <i data-time-icon="icon-time"
								data-date-icon="icon-calendar"></i></span>
						</div>
						<br> <label for="endDate">End Date *:</label>
						<div id="endDate" class="input-append date">
							<input type="text" id="eDate" name="eDate" value=""></input> <span
								class="add-on"> <i data-time-icon="icon-time"
								data-date-icon="icon-calendar"></i></span>
						</div>
					</div>

					<input type="submit" name="submit" value="Prepare Chart" />

				</form>
				</div>
			</td>

			<td><div id="container2" style="height: 400px"></div></td>
		</tr>
	</table>

	</body>
</html>
