<HTML>
<HEAD>
    <link rel="stylesheet" href="/t/jquery.autocomplete-1.1.3/jquery.ui.all.css">
	<script src="/t/jquery.autocomplete-1.1.3/jquery-1.7.2.js"></script>
	<script src="/t/jquery.autocomplete-1.1.3/jquery.ui.core.js"></script>
	<script src="/t/jquery.autocomplete-1.1.3/jquery.ui.widget.js"></script>

	<script src="/t/jquery.autocomplete-1.1.3/jquery.ui.position.js"></script>
	<script src="/t/jquery.autocomplete-1.1.3/jquery.ui.autocomplete.js"></script>
	<link rel="stylesheet" href="/t/jquery.autocomplete-1.1.3/demos.css">



</HEAD>
<BODY>
     <input type="text" name="q" id="query" />
    <div style="width: 50%;">
  
    <input type="text" name="q2" size="50" id="query2" />
</div>
    <script>

  $(function() {
		var at=['Need Project ideas','Need Documentation & UML Diagrams','Project Report','First Module','Complete Project'];

		$( "#query2" ).autocomplete({
			source: at,
                        maxHeight:400,
                        maxWidth:200,

    zIndex: 9999
		});
	});



var a = $('#query').autocomplete({
    serviceUrl:'service/autocomplete.ashx',
    minChars:0,
    delimiter: /(,|;)\s*/, // regex or character
    maxHeight:400,
    width:300,
    zIndex: 9999,
    deferRequestBy: 0, //miliseconds
    params: { country:'Yes' }, //aditional parameters
    noCache: false, //default is false, set to true to disable caching
    // callback function:
    onSelect: function(value, data){ alert('You selected: ' + value + ', ' + data); },
    // local autosugest options:
    lookup: ['09 AM','10 AM','11 AM','12 AM','1 PM','2 PM','3 PM','4 PM','5 PM','6 PM','7 PM','8 PM','9 PM','10 PM','11 PM'] //local lookup values
  });
        </script>

    
            <script>







        </script>
</BODY>
</HTML>