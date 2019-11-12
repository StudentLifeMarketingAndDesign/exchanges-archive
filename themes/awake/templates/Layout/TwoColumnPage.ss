<div id="header">
      <!-- Custom logo code -->
      <a href="$BaseURL"><div id="logo"></div></a>
           
<% include TopNav %>
      </div>
       <div id="page_top_plain"></div>
  	   <div id="container_plain" class="typography">
  	   	<div class="clear"></div>
       		<% if Level(3) %>
			<div id="breadcrumbs">
     			$BreadCrumbs
            </div>
            <% end_if %>
			<div id="light">
  	   		<div id="content" class="typography">

			<div class="leftColumn">

 		       $Content
			</div>

			<div class="rightColumn">

 			  $Content2
        	   
			</div>
  	   	<div class="clear"></div>

			
			<% include ChildLink %>
			$Form
			</div>
			</div>
           
       </div>
       <div id="page_butt"></div>
       