	
    <% control previousPager %>
  		<a href="$URLSegment">back</a> |
 	<% end_control %>
   

	<% control Level(2) %>
		<a href="$Link">table of contents</a>
	<% end_control %>
    
    <% if nextPager %>
    	|
    <% end_if %>
        
        
 	<% control nextPager %>
  	 	<a href="$URLSegment">continue</a>
 	<% end_control %> 

