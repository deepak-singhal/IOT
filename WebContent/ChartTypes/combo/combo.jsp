<!DOCTYPE HTML>
<%@page import="com.iot.dto.Beacon_Data"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.iot.dao.ChartData"%>
<%@page import="java.util.HashMap"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>IOT Charts</title>

		<!-- -----------------------------------------	 -->
			<%
				HashMap<String, List<Beacon_Data>> chartXY=ChartData.comboMap();;
				
				ArrayList<String> chartXd=new ArrayList<String>();
				ArrayList<List<Beacon_Data>> chartYd=new ArrayList<List<Beacon_Data>>();
				
				Iterator itr=chartXY.entrySet().iterator();
				while(itr.hasNext()){
					Entry<String, List<Beacon_Data>> entry=(Entry<String, List<Beacon_Data>>)itr.next();
					
					chartXd.add(entry.getKey());
					chartYd.add(entry.getValue());
				}
			%>
		<!-- -----------------------------------------	 -->
		
		
		<!-- ---------------------Average Calculator----------------------- -->
		<%
			ArrayList<Double> monthAvg=new ArrayList<Double>();
			Double sum=0.0;
			Double avg=0.0;
			for (int i=0; i < chartXd.size(); i++) { 
				sum=0.0;
				for(int j=0;j<chartXd.size(); j++) {  
					try{
					sum+=Integer.parseInt(chartYd.get(j).get(i)+"");
					}catch(Exception e){}
				}
				avg=sum/chartYd.size();
				if(avg!=0)
					monthAvg.add(i, avg);
			}
		%>
		<!-- -------------------------------------------------------------- -->
		
		<!-- ---------------------Total Calculator----------------------- -->
		<%
			ArrayList<Integer> sectionTotal=new ArrayList<Integer>();
			Integer sectionSum=0;
			for (int i=0; i < chartYd.size(); i++) { 
				sectionSum=0;
				for(int j=0;j<chartYd.get(i).size(); j++) {  
					try{
						sectionSum+=Integer.parseInt(chartYd.get(i).get(j)+"");
					}catch(Exception e){}
				}
				sectionTotal.add(i, sectionSum);
			}
		%>
		<!-- -------------------------------------------------------------- -->
		
		<script type="text/javascript">
		var jsChartX;
		var jsChartY;
		<%  
		for (int i=0; i < chartYd.size(); i++) {  
		%>  
		jsChartX = '<%=chartXd.get(i) %>';
		jsChartY = <%=chartYd.get(i) %>;
		<%}%> 
		</script>
		
		
		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
		<style type="text/css">
${demo.css}
		</style>
		<script type="text/javascript">
$(function () {
    $('#container3').highcharts({
        title: {
            text: 'Library Trend'
        },
        xAxis: {
            categories: ['Jan',
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
                         'Dec']
        },
        labels: {
            items: [{
                html: 'Patron Trend',
                style: {
                    left: '50px',
                    top: '18px',
                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'black'
                }
            }]
        },
        series: [
				<% for(int i=0;i<chartXd.size();i++){%>
					{
			            type: 'column',
			            name: depttName[<%= i%>],
			            data: <%= chartYd.get(i)%>
			        },
				<%}%>
				
           {
            type: 'spline',
            name: 'Average',
            data: <%= monthAvg%>,
            marker: {
                lineWidth: 2,
                lineColor: Highcharts.getOptions().colors[3],
                fillColor: 'white'
            }
        }, {
            type: 'pie',
            name: 'Section Trend',
            data: [
				<% for(int i=0;i<chartXd.size();i++){ %>
					{
	                name: depttName[<%= i%>],
	                y: <%= sectionTotal.get(i)%>,
	                color: Highcharts.getOptions().colors[<%=i%>] // Pie Chart Color
	            	},
				<%}%>
				
            ],
            center: [100, 80],
            size: 100,
            showInLegend: false,
            dataLabels: {
                enabled: false
            }
        }]
    });
});

		</script>
	</head>
	<body>

<script src="../../js/highcharts.js"></script>
<script src="../../js/modules/exporting.js"></script>

<div id="container3" style="min-width: 310px; height: 400px; margin: 0 auto"></div>

	</body>
</html>
