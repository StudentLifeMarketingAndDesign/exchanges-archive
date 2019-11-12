<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <% base_tag %>
            <title>
            
          $Title - 
     eXchanges Journal of Literary Translation - The University of Iowa</title>
            $MetaTags(false)
            <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="themes/exchanges/css/layout.css" />
    <link rel="stylesheet" type="text/css" href="themes/exchanges/css/typography.css" />
	<% control Level(2) %>
	
	<% end_control %>
	
    
    <% control Level(2) %>
	    <link rel="stylesheet" type="text/css" href="themes/exchanges/css/{$URLSegment}.css" />
    <% end_control %>

</head>
<% control getIssue %>
	<style type="text/css"> 
   body { 
      background: url('$BackgroundImage.Link') repeat left top; 
   } 
 </style>
<% end_control %>
<body>
	<% include ArchiveNav %>

	<div id="wrapper">
	  <div id="header">
      <!-- Custom logo code -->
      <a href="$BaseURL">
      	<% if inSection(issues) %>
      		<% control Level(2) %>
            	<% if CustomExchangesLogo %>
                	$CustomExchangesLogo
                <% else %>
                	 <img src="$ThemeDir/images/logo.png" />
                <% end_if %>
            <% end_control %>
        <% else %>
            	<img src="$ThemeDir/images/logo.png" />
        <% end_if %>
       </a>
           
      <div id="navHolder">
        <ul>
        
		<% control Masthead %>
	 		<li><a href="$Link">Masthead</a></li>
		<% end_control %>
		
		<% control getIssue %>
			<li><a href="$Link">Contents</a></li>
		<% end_control %>
        
         <% control Menu(1) %>
		 <li><a href="$Link">$MenuTitle</a></li>
		 <% end_control %>
        </ul>
        </div>
		<div class="clear"></div>
      </div>
  	   <div id="container" class="typography">
       		<% if Level(3) %>
			<div id="breadcrumbs">
     			$BreadCrumbs
            </div>
            <% end_if %>

  	    $Layout
		
		<div class="clear"></div>
           
       </div>
       
      <div id="footer">
        <ul>
         <% control Menu(1) %>
		 <li><a href="$Link">$MenuTitle</a></li>
		 <% end_control %>
         <% if CurrentMember %>
         <li><a href="/admin/show/$ID" style="font-weight: bold;">Edit Page</a>
         <% end_if %>
        </ul>
      </div>

      
   </div>

<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-426753-15");
pageTracker._trackPageview();
} catch(err) {}</script>
</body>
</html>
