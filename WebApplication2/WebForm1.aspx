<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="WebApplication2.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    

    <script type="text/javascript" src="scripts/jquery-1.8.2.js"></script>


	
	<style type="text/css">
		body{
			background-color:white;
			color: black;
		}
		.constraintsTab {
			position:fixed; 
			top: 35%; 
			left: 0px; 
			height: 150px; 
			width:30px; 
			background-color:#DECED4; 
			z-index: 2;
            border-top: 1px solid black; 
			border-top-right-radius: 12px; 
			border-bottom-right-radius:12px;
		}


	    .constraints {
	        position: fixed; 
            top:0px; 
            left: -400px; 
            width: 400px; 
            height: 100%; 
            background-color:#DECED4;
            z-index: 3;
	    }
	    .titleDiv {
            background-color:white;
            text-align:center;
            font-size: 16pt;
            font-weight: bold;
            margin-left:auto;
            margin-right: auto;
	    }
	    .tweet {
            margin-top: 10px; 
            margin-left: 10px; 
            margin-right:10px; 
            border: 1px solid black; 
            border-radius: 4px; 
            color:black; 
            background-color: #5AE87C;
	    }
	</style>

	
	<script language="javascript">
	    function toggleConstraints() {
	        if ($('div[id="constraints"]').position().left >= 0) {
	            $('div[id*="constraints"]').animate({ left: '-=400px' }, 400)

	        }
	        else {
	            $('div[id*="constraints"]').animate({ left: '+=400px' }, 400)
	        }
	    }
        
	    function requestTweets() {
	        $('.tweet').remove();
	        $.ajax({
	            type: "POST",
	            url: "WebForm1.aspx/requestTweets",
                data: '{ "qTemp": "'+$('#tagList').val()+'"}',
	            contentType: "application/json; charset=utf-8",
	            dataType: "json",
	            success: function (data) {
	                var tempData = eval("(" + data.d + ")");
	                $(tempData.statuses).each(function () {
	                    showTweet(this);
	                });
	            }
	        });
	        $('.titleDiv').html('Searching twitter for: ' + $('#tagList').val());
	        toggleConstraints();
	    }
	    
	    function showTweet(tweet) {
	        var hashtagString = '';
	        var comma = '';
	        $(tweet.entities.hashtags).each(function () {
	            hashtagString += comma + '#' + this.text;
	            comma = ',';
	        });

	        var tweetDiv = '<div class="tweet">User: ' + tweet.user.name + '<br>Tweeted: ' + tweet.text + '<br>Retweets: '+tweet.retweet_count+'<br>Tweet Time: '+parseTwitterDate(tweet.created_at)+'<br>Hashtags: '+hashtagString+'</div>';
	        $('#contentDiv').append(tweetDiv);
	    }

        /* Stolen from the internet */
	    function parseTwitterDate(text) {
	        return new Date(Date.parse(text.replace(/( +)/, ' UTC$1')));
	    }
	</script>
    
    <title>Tweet!</title>
</head>
<body>
    <form id="form1" runat="server">
    
    <div name="contentDiv" id="contentDiv" style="margin-left: 200px; margin-right:200px; background-color:white;">
        <div class="titleDiv">Twitter Search</div>
		<div name="constraintsTab" id="constraintsTab" class="constraintsTab" onClick="toggleConstraints();">
			
		</div>
		<div name="constraints" id="constraints" class="constraints">
			<table style="position:relative; width: 300px; margin-left: auto; margin-right: auto; border:1px solid black;">
				<tr>
					<td valign="top" style="font-weight:bold;">Tags to search: </td>
					<td><textarea cols="12" rows="5" name="tagList" id="tagList"></textarea>
				</tr>
				<tr>
					<td><input type="button" value="Show" onClick="requestTweets();"></td>
				</tr>
			</table>
		</div>
	</div>
    </form>
</body>
</html>
