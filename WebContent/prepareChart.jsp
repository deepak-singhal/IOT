<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<link
	href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/css/bootstrap-combined.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css" media="screen"
	href="http://tarruda.github.com/bootstrap-datetimepicker/assets/css/bootstrap-datetimepicker.min.css">
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">



<script type="text/javascript"
	src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript"
	src="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/js/bootstrap.min.js"></script>
<script type="text/javascript"
	src="http://tarruda.github.com/bootstrap-datetimepicker/assets/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript"
	src="http://tarruda.github.com/bootstrap-datetimepicker/assets/js/bootstrap-datetimepicker.pt-BR.js"></script>
	

	<!--  Script to show/hide the specific criterias according to Chart Type Slected -->	
	 <script>
		function show_hide_date() {
			var e = document.getElementById("chartType");
			var chartSelected = e.options[e.selectedIndex].text;
			
			if(chartSelected == "Patron Footfall in different Sections") {
			   document.getElementById('dateRange').style.display = 'block';
			   document.getElementById('departments').style.display = 'none';
			}
			if(chartSelected == "Patron vs Department") {
				document.getElementById('dateRange').style.display = 'none';
				document.getElementById('departments').style.display = 'block';
				}
		}
	 </script>
	
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


<style>
body {
    background: rgba(0, 0, 0, 0);
    color: #333;
    font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
    font-size: 14px;
    line-height: 20px;
    margin: 0;
}

form { /* Just to center the form on the page */
	margin: 0 auto;
	width: 18%;
	/* To see the outline of the form */
	padding: 1em;
	border: 1px solid #CCC;
	border-radius: 1em;
}

form div+div {
	margin-top: 1em;
}

label {
	/* To make sure that all label have the same size and are properly align */
	display: inline-block;
	width: 90px;
	text-align: right;
}

input,textarea {
	/* To make sure that all text fields have the same font settings
       By default, textareas have a monospace font */
	font: 1em sans-serif;
	/* To give the same size to all text field */
	width: 230px;
	-moz-box-sizing: border-box;
	box-sizing: border-box;
	/* To harmonize the look & feel of text field border */
	border: 1px solid #999;
}

input:focus,textarea:focus {
	/* To give a little highlight on active elements */
	border-color: #000;
}

textarea {
	/* To properly align multiline text fields with their labels */
	vertical-align: top;
	/* To give enough room to type some text */
	height: 5em;
	/* To allow users to resize any textarea vertically
       It does not work on every browsers */
	resize: vertical;
}

.button {
	/* To position the buttons to the same position of the text fields */
	padding-left: 90px; /* same size as the label elements */
}

button {
	/* This extra margin represent roughly the same space as the space
       between the labels and their text fields */
	margin-left: .5em;
    background: repeat-x scroll left center #0085CC;
    border: 0 none;
    box-shadow: 0 1px 1px #ddd;
    color: #fff;
    cursor: pointer;
    height: 34px;
    margin: 10px 0 0;
    padding: 6px 15px 9px;
    text-transform: uppercase;
}
</style>

<title>IOT Home</title>
</head>

<body onload="show_hide_date();">
	<%-- 
<%
	ServletContext context = getServletContext();
	RequestDispatcher dispatcher = context.getRequestDispatcher("/PrepareChart");
	dispatcher.forward(request,response);
%>
 --%>

	<br>
	<br>
	<br>
	<br>
	<form action="/IOT/PrepareChart" method="post" style="background-color:#ffffff">
		<div>
			<center>
				<h2>IOT Chart Demo</h2>
			</center>
		</div>

		<div>
			<label for="chartType"><b>Chart Type *:</b></label>
			<div class="input-append date">
				<select name="chartType" id="chartType" style="width: 260px" onchange="show_hide_date();">
					<option value="Select Chart Type">
						Select Chart Type
					</option>
					<option value="Patron Footfall in different Sections">
						Patron Footfall in different Sections
					</option>
					<option value="Patron vs Department">
						Patron vs Department
					</option>
				</select>
			</div>
		</div>

		<div id="dateRange" style="display:none">
			<label for="dateRange"><b>Date Range:</b></label><br> 
			<label for="startDate">Start Date *:</label>
				<div id="startDate" class="input-append date">
					<input type="text" id="startDate" name="startDate"></input> 
					<span class="add-on"> <i data-time-icon="icon-time" data-date-icon="icon-calendar"></i></span>
				</div>
			<br> 
			<label for="endDate">End Date *:</label>
				<div id="endDate" class="input-append date">
					<input type="text" id="endDate" name="endDate"></input> 
					<span class="add-on"> <i data-time-icon="icon-time" data-date-icon="icon-calendar"></i></span>
				</div>
		</div>
		
		<div id="departments" style="display:none">
			<label for="department" style="width: 100px"><b>Department *:</b></label>
		</div>
		<script type="text/javascript">
			    var newDiv=document.createElement('div');
			    var selectHTML = "";
			    selectHTML="<select id=\"department\" name=\"department\" style=\"width:260px\"><option>Select Department</option>";
			    for(i=0; i<depttName.length; i++){
			        selectHTML+= "<option value='"+depttId[i]+"'>"+depttName[i]+"</option>";
			    }
			        selectHTML += "</select>";
			    newDiv.innerHTML= selectHTML;
			    document.getElementById("departments").appendChild(newDiv);
		</script>
		

		<div class="button">
			<button type="submit">Prepare Chart</button>
		</div>
		
	</form>

</body>
</html>