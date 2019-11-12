	<div id="breadcrumbs">
 <a href="$contributorIssue.Link">$contributorIssue.Title</a>
 <% control GetContributorInfo %>
 &raquo; Contributors &raquo; $FirstName $LastName
             
                <% end_control %>
            </div>
<div id="content" class="typography">
<% control GetContributorInfo %>
<h1>$FirstName $LastName</h1>
$Bio
<% end_control %>
</div>