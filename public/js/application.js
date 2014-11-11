$(function(){
    function check_job_status(job_id){
    var request = $.ajax({
      type: "GET",
      url: '/status/' + job_id
    });
    request.done(function(response){
      if (response === 'true'){
        $('#status').text('done');
      } else {
        setTimeout(function(){ check_job_status(job_id) }, 1000);
      }
    });
  };


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
      $('#status').html('Tweeting');
      setTimeout(function(){ check_job_status(value) }, 1000);
      },
      error: function(value){
      	$("#status").html("Tweet Failed!");
      } 
     });
	});	


  $('#send-tweet-later').one("submit", function(event){
    event.preventDefault();
    $('#button').attr('disabled', 'disabled');
    $("#status").append("<img src='/images/ajax-loader.gif'>Posting</img>")
    $.ajax({
      type: "POST",
      url: "/tweets_later",
      data: $("#send-tweet-later").serialize(),
      cache: false,
      success: function(value){       
      $('#status').html('Tweeting');
      setTimeout(function(){ check_job_status(value) }, 1000);
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