$(function(){

	$('#send-tweet').one("submit", function(event){
		event.preventDefault();
		$('#button').attr('disabled', 'disabled');
		$("#status").append("<img src='/images/ajax-loader.gif'>Posting</img>")
		$.ajax({
			type: "POST",
      url: "/tweets",
      data: $("#send-tweet").serialize(),
      cache: false,
      success: function(value){

      	
        $("#status").html("<h1>Tweet Posted!</h1>");
      },
      error: function(value){
      	$("#status").html("Tweet Failed!");
      } 
     });
	});	

  $.ajax({
      type: "POST",
      url: "/<%= params[:username] %>/stale",
      cache: false,
      success: function(value){
        $("#tweets").html(value);
        $("#wait-msg").html("");     
      },
      error: function(value){
        $("#wait-msg").html("");
      } 
   });	
});