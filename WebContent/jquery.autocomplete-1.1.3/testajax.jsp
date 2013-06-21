<html>
    <head>
<link rel="stylesheet" href="<%=request.getContextPath()%>\jquery.autocomplete-1.1.3\jquery.ui.all.css">
<script src="<%=request.getContextPath()%>\jquery.autocomplete-1.1.3\jquery-1.7.2.js"></script>

<link rel="stylesheet" href="demos.css">

<script>
    function callURL(){
        $.ajax({
            url: "demos.css"

        }).done(function(result) {
            alert(result);
        });
    }

    function sendParam(){
        var request=$.ajax({
            type: "POST","WebContent/jquery.autocomplete-1.1.3/some.php"
            url: "some.php",
            data: { name: "John", location: "Boston" },
            cache: false
        });
        request.done(function(result) {
            $("#results").append(result);

            //   alert(result);
        });
        request.fail(function(jqXHR, textStatus) {
            alert( "Request failed: " + textStatus );
        });
    }
    function perform(){
        $.ajax({
            url: 'some.php',
            success: function(data) {
                $('#results').html(data);
                alert('Load was performed.');

            }
        });
    }
    function sendPost(){
    	
    	$.post("dummy.jsp",
    			createQueryObject(),
    			  function(data){
    			    alert("Data Loaded: " + data);
    			  }
    			);
    }


    function createQueryObject() {
        var txtData = [];
        
        $("input").each(function() {
            txtData.push("\""+$(this).attr('name')+"\":\""+$(this).val()+"\"");  
        });
        $("select").each(function() {
            txtData.push("\""+$(this).attr('name')+"\":\""+$(this).val()+"\"");
        });  
        objs="{"+txtData.join(",")+"}";
        obj=jQuery.parseJSON(objs);
        return obj;
        
    }
</script>
</head>
<body>
<span id="results">
</span>
<input id="menuId" name="menuId"  value="Test"/>
<input type="button" onclick="sendParam();" value="Click"/>
</body>
</html>