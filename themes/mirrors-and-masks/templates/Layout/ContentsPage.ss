 <div id="content" class="typography">
<div class="issueLeftColumn">

$ContentsImage

$Content2

</div>

<div class="issueRightColumn">

<h1>$MenuTitle</h1>

<p style="margin-top: -8px;">$IssueDate</p>

<h1>Table of Contents</h1>


<ul style="margin-top: -10px;">
<% control contributors %>
	<li>
		<h4><a href="$Link" id="$URLSegment">$FirstName</a></h4>
        
        <ul>
			<% control Pieces %>
    			<li><a href="$Link">$Title</a></li>
            <% end_control %>
        </ul>
    	
	</li>
   

<% end_control %>
	

</ul>
$Content

</div>
</div>


