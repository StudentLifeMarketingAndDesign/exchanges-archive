<div id="header">
      <!-- Custom logo code -->
      <a href="$BaseURL"><div id="logo"></div></a>
           
 		<% include TopNav %>

		<div class="clear"></div>
      </div>
       <div id="page_top"></div>
  	   <div id="container" class="typography">
  	   	<div class="clear"></div>
       		<% if Level(3) %>
			<div id="breadcrumbs">
     			$BreadCrumbs
            </div>
            <% end_if %>

  	    <div id="content" class="typography">
	<div id="toc"> $Content </div>
	<div id="toc_extra">
		<% if ContentsImage %>
		$ContentsImage
		<% end_if %>
	</div>

</div>
	<div class="clear"></div>
		
		<div class="clear"></div>
           
       </div>
       
       

