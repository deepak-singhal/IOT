<%@page import="com.iot.dao.ChartData"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	
<link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/css/bootstrap-combined.min.css" rel="stylesheet">
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">



<link rel="stylesheet" href="/IOT/css/calender.css">
<link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/css/bootstrap-combined.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" media="screen" href="http://tarruda.github.com/bootstrap-datetimepicker/assets/css/bootstrap-datetimepicker.min.css">
<script type="text/javascript" src="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/js/bootstrap.min.js"></script>
<script type="text/javascript" src="http://tarruda.github.com/bootstrap-datetimepicker/assets/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="http://tarruda.github.com/bootstrap-datetimepicker/assets/js/bootstrap-datetimepicker.pt-BR.js"></script>
<!-- <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script> -->
	

	<script type="text/javascript">
    $(function() {
    	$('#startDate').datetimepicker({
	        format: 'yyyy-MM-dd hh:mm:ss',
	        endDate: new Date(),
	      });
	  });
    
    $(function() {
    	$('#endDate').datetimepicker({
	        format: 'yyyy-MM-dd hh:mm:ss',
	        endDate: new Date(),
	      });
	  });
    </script>

	
	<title>IOT Statistics</title>

	<!-- Script to load the Departments from the Database -->
	<script>
		var xmlhttp;
		var jsonDepartment;
		var depttName=new Array();
		var depttId=new Array();
		
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
			  jsonDepartment=xmlhttp.responseText;
			  var jsonData = JSON.parse(jsonDepartment);
			  for (var i = 0; i < jsonData.beacon.length; i++) {
			      var counter = jsonData.beacon[i];
			      //console.log(counter.counter_name);
			      depttName[i]=counter.department;
			      depttId[i]=counter.id;
			  }
		    }
		  }
		xmlhttp.open("GET","rest/api/departments",false);
		xmlhttp.send();
	</script>
</head>


<body>


<!--  -----------------------------------------------------------------------   -->
<!--  --------------------Patron Vs Department Chart-------------------------   -->
<!--  -----------------------------------------------------------------------   -->	

<script>
	<% 
	if((request.getParameter("department")==null)&&
	(request.getParameter("sDate")==null)&&
	(request.getParameter("eDate")==null))
	{		
	%>  // If Page loads for First time -> provides default chart criteria
		var sDate="2015-01-01 00:00:00";
		var eDate=getTimeStamp();
		window.location.replace("statistics.jsp?department="+depttId[0]+"&sDate="+sDate+"&eDate="+eDate);
	<% 
	}		
	%>
	
	function getTimeStamp() {
	    var now = new Date();
	    return (now.getFullYear() + '-'  + (now.getMonth() + 1) + '-' +
	            (now.getDate())
	             + " " +
	             now.getHours() + ':' +
	             ((now.getMinutes() < 10)
	                 ? ("0" + now.getMinutes())
	                 : (now.getMinutes())) + ':' +
	             ((now.getSeconds() < 10)
	                 ? ("0" + now.getSeconds())
	                 : (now.getSeconds())));
		}
	
</script>
		<%
		HashMap depttVsPatronMap = null;
		String bId = request.getParameter("department");
			try {
				depttVsPatronMap = ChartData.getDepttVsPatron(bId);
			} catch (Exception e) {
				System.out.println("Error In Chart Data Preparation");
				e.printStackTrace();
			}
	
			request.setAttribute("chartData1", depttVsPatronMap);
	
			ServletContext context = getServletContext();
			RequestDispatcher dispatcher = context.getRequestDispatcher("/ChartTypes/column-basic/patronVSdeptt.jsp");
			dispatcher.include(request, response);
		%>
		

	<!-- 	<div id="departments" style="display:block; margin-left: 5%;">
			<label for="department" style="width: 100px"><b>Department </b></label>
		</div> -->
		<script type="text/javascript">
				var sd="2015-01-01 00:00:00";
				var ed=getTimeStamp();
			    var newDiv=document.createElement('div');
			    var selectHTML = "";
			    selectHTML="<form name=\"departmentForm\" style=\"width: 80%\"><select id=\"department\" name=\"department\" style=\"width:180px\"onchange=\"this.form.submit()\">";
			    
			    var bId = '<%=bId %>'; 
			    for(i=0; i<depttName.length; i++){
			        	if(bId == 'null' && i == 0){
			        	selectHTML+= "<option value='"+depttId[i]+"' selected>"+depttName[i]+"</option>";
			        	}else if(bId == depttId[i]){
			        	selectHTML+= "<option value='"+depttId[i]+"' selected>"+depttName[i]+"</option>";
			        	}else{
			        	selectHTML+= "<option value='"+depttId[i]+"'>"+depttName[i]+"</option>";
			        	}
			    }
			        selectHTML += "</select>";
			        selectHTML += "<input type=\"hidden\" name=\"sDate\" id=\"hsDate\" value='"+sd+"' \"/>";
			        selectHTML += "<input type=\"hidden\" name=\"eDate\" id=\"heDate\" value='"+ed+"' \"/>";
				    selectHTML += "</form>";
			    newDiv.innerHTML= selectHTML;
			    document.getElementById("depDiv").appendChild(newDiv);
			    
		</script>
		
		
<!--  -----------------------------------------------------------------------   -->
<!--  -------------------------Patron FootFall Chart-------------------------   -->
<!--  -----------------------------------------------------------------------   -->	
		
		<%
		HashMap patronFootfallMap = null;
		String startDate=(String) request.getParameter("sDate");
		String endDate=(String) request.getParameter("eDate");
		/* startDate= "2015-01-01 10:45:12";
		endDate= "2015-03-16 10:45:12"; */
		try {
			patronFootfallMap=ChartData.getPatronFootFall(startDate, endDate);
		} catch (Exception e) {
			System.out.println("Error In Chart Data Preparation");
			e.printStackTrace();
		}
		
		request.setAttribute("chartData", patronFootfallMap);
		//dispatcher = context.getRequestDispatcher("/ChartTypes/3D-pie/patronFootFall.jsp");
		dispatcher = context.getRequestDispatcher("/ChartTypes/3D-Column/patronFootFall.jsp");
		dispatcher.include(request,response);
		%>
		
 				<script>
				var e = document.getElementById("department");
				var strdepartment = e.options[e.selectedIndex].value;
				document.getElementById('hdepartment').value = strdepartment;
				document.getElementById("sDate").value='<%=startDate%>';	
				document.getElementById("eDate").value='<%=endDate%>';	
				</script>
 
	
</body>
</html>