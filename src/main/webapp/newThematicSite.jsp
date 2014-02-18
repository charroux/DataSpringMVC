<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>  
<!-- <script type="text/javascript" src="/script/jquery-1.10.2.min.js"></script> -->

<div>Create...
<div id="createFolder">folder</div>
<div id="createThematicSite">thematic site</div>
</div>

<div class="entryPoint"></div>

<div class="navigation"></div>

<div class="thematicSite"><h1>Thematic site</h1></div>
    
	<script type="text/javascript">
	
	
		$(document).ready(function() {
			
			var restEntryPoint = "http://localhost:8081/Data/sites/entryPoint";
			
			$( "#createThematicSite" ).click(function() {
				
				$('.entryPoint').unbind( "click" );
				$('.entryPoint').empty();
				
				$('.navigation').unbind( "click" );
				$('.navigation').empty();
				
				$('.entryPoint').append("<h1>Search publications by</h1>");
				getRestEntryPoints(restEntryPoint);
			});
						
			function getRestEntryPoints(restEntryPoint){

				var cptRef = 0;
				var relAndHref = {};
				
				$.getJSON( restEntryPoint, function( data ) {
					$.each( data, function( key, val ) {
						if(key == "links"){
							$.each( val, function( key1, val1 ) {
								if(val1.rel != "self"){
									$(relAndHref).data(val1.rel, val1.href);
									$(relAndHref).data(val1.href, val1.rel);
									$('.entryPoint').append("<div id='" + val1.rel + "' class='entryPointRel" + (cptRef) + "'><a href>" + val1.rel + "</a></div> ");
									cptRef++;									
								}
							});							
						}

					});
					
					$('.entryPoint').unbind( "click" );
					
					$('.entryPoint').on('click', '[class^=entryPointRel]', function(e){	// bind un événement
						e.preventDefault();
						var rel = $(this).attr('id');
						var href = $(relAndHref).data(rel);
						navigateIntoDataStructure(href, relAndHref);
					});
				});
				
			}
			
			function getJSonData(val, relAndHref, cptTypeOfResource){
				
				var rel;
				var cptRef = 0;
				var hrefTypeOfResource;
				
				$.each( val, function( key1, val1 ) {

					if(key1 != "links"){
						$('.navigation').append("<div>" + key1 + " : " + val1 + "</div> ");
					}
				});
				
				$.each( val, function( key1, val1 ) {							
					if(key1 == "links"){
						$.each( val1, function( key2, val2 ) {
							$.each( val2, function( key3, val3 ) {
								if(key3 == "rel"){										
									rel = val3;
								} else if(key3=="href" && rel!="self"){
									
									//if(val3.match("\\w*/author/\\d+/publications\\b")){
									if(rel == "publications"){
										
										$('.navigation').append(" has written ");
										
										$('.navigation').append("<a href id='" + val3 + "' class='newRef" + (cptRef) + "'>" + rel + "</a> ");
										$(relAndHref).data(val3, rel);
										cptRef++;
									//} else if(val3.match("\\w*/publication/\\d+/authors\\b")){
									} else if(rel == "authors"){
										
										$('.navigation').append(" written by ");
										
										var firstName;
										var lastName;
										
										$.ajax({
											url: val3,
											dataType: 'json',
											async: false,
											success: function(data2){
												$.each( data2, function( key4, val4 ) {
													$.each( val4, function( key5, val5 ) {
														if(key5 == "firstName"){
															firstName = val5;
														} else if(key5 == "lastName"){
															lastName = val5;
														} else if(key5 == "links"){
															uri = val5[0].href;	
														}
													});
													
													$('.navigation').append("<a href id='" + uri + "' class='newRef" + (cptRef) + "'>" + firstName + " " + lastName + "</a> ");
													$(relAndHref).data(uri, firstName + " " + lastName);
													cptRef++;
														
												});
											}  
										});
										

									//} else if(val3.match("\\w*/companionSite/\\d+\\b")){
									} else if(rel == "companionSite"){
										
										$('.navigation').append(" related companion site ");
										
										$('.navigation').append("<a href id='" + val3 + "' class='newRef" + (cptRef) + "'>" + rel + "</a> ");
										$(relAndHref).data(val3, rel);
										cptRef++;
										
									} else if(rel == "companionSites"){
										
										$('.navigation').append(" contains (mostly) many ");
										
										$('.navigation').append("<a href id='" + val3 + "' class='newRef" + (cptRef) + "'>" + rel + "</a> ");
										$(relAndHref).data(val3, rel);
										cptRef++;
										
									} else if(rel == "thematicSites"){
										
										$('.navigation').append(" included into one or many ");
										
										$('.navigation').append("<a href id='" + val3 + "' class='newRef" + (cptRef) + "'>" + rel + "</a> ");
										$(relAndHref).data(val3, rel);
										cptRef++;
										
									} else if(rel == "publication"){
										
										$('.navigation').append(" related publication ");
										
										var name;
										var uri;
										
										$.ajax({
											url: val3,
											dataType: 'json',
											async: false,
											success: function(data2){										
													$('.navigation').append("<a href id='" + data2.links[0].href + "' class='newRef" + (cptRef) + "'>" + data2.title + "</a> ");
													$(relAndHref).data(data2.links[0].href, data2.title);
													//$(relAndHref).data(data2.links[0].href, rel);
													cptRef++;
											}  
										});
										
									//} else if(val3.match("\\w*/code/\\d+\\b")){
									} else if(rel == "code"){
										
										$('.navigation').append(" related program ");
										
										$('.navigation').append("<a href id='" + val3 + "' class='newRef" + (cptRef) + "'>" + rel + "</a> ");
										$(relAndHref).data(val3, rel);
										cptRef++;
										
									} else if(rel == "referenceImplementation"){
										
										$('.navigation').append(" related program ");
										
										$('.navigation').append("<a href id='" + val3 + "' class='newRef" + (cptRef) + "'>" + rel + "</a> ");
										$(relAndHref).data(val3, rel);
										cptRef++;
										
									} else {
										
										$('.navigation').append("<a href id='" + val3 + "' class='newRef" + (cptRef) + "'>" + rel + "</a> ");
										$(relAndHref).data(val3, rel);
										cptRef++;
									}
									
								} else if(key3=="href" && rel=="self"){
	 								hrefTypeOfResource = val3;
 								}
								
							});
						});
					} else if(key1 == "typeOfResource"){
						if(val1=="Publication"){
							$(relAndHref).data(hrefTypeOfResource, val1);
							$('.navigation').append("<div><input id=" + hrefTypeOfResource + " class='AddThematicSite" + (cptTypeOfResource) + "' type=\"button\" value=\"Add to a thematic site\"></div>");
						}
					}
				});	
				
				return relAndHref;
			}
			
			function navigateIntoDataStructure(restURI, relAndHref){
				
				$('.navigation').empty();

				var parentRel = $(relAndHref).data(restURI);
				
				if(parentRel == "companionSites"){
					parentRel = parentRel + " included into a thematic site";
				}
			
				$('.navigation').append("<div><h1>" + parentRel + "</h1></div> ");

				$.getJSON( restURI, function( data ) {
					
					var cptTypeOfResource = 0;
					
					if(data instanceof Array){
						$.each( data, function( key, val ) {
							relAndHref = getJSonData(val, relAndHref, cptTypeOfResource);
							cptTypeOfResource++;
						});
					} else {
						relAndHref = getJSonData(data, relAndHref, cptTypeOfResource);
					}
					
					$('.navigation').on('click', '[class^=AddThematicSite]', function(e){
						var hrefToAdd = $(this).attr('id');
						var typeOfResource = $(relAndHref).data(hrefToAdd);
						if(typeOfResource == "Publication"){
							
							$.get( hrefToAdd, function( publication, status, xhr ) {	// get json for the publication
								
								jQuery.ajax({
							         type: "PUT",
							         url: "http://localhost:8585/DataSpringMVC/thematicSite",
							         contentType: "application/json; charset=utf-8",
							         data: xhr.responseText,	// send raw data (pure json)
							         dataType: "json",
							         success: function (data, status, jqXHR) {
							             alert("data");
							         },
							    
							         error: function (jqXHR, status) {
							        	 alert( "Request failed: " + status );
							         }    
							     });
							});
							
							
						
/* 							$.getJSON( hrefToAdd, function( data ) {
								
								$('.thematicSite').append(data.title);
								
								var val = data.links;
								
								$.each( val, function( key2, val2 ) {
									$.each( val2, function( key3, val3 ) {
										if(key3 == "rel"){										
											rel = val3;
										} else if(key3=="href" && rel!="self"){
											
											if(rel == "authors"){
												
												$('.thematicSite').append(", ");
												
												$.ajax({
													url: val3,
													dataType: 'json',
													async: false,
													success: function(data2){
														$.each( data2, function( key4, val4 ) {
															$.each( val4, function( key5, val5 ) {
																if(key5 == "firstName"){
																	firstName = val5;
																} else if(key5 == "lastName"){
																	lastName = val5;
																} else if(key5 == "links"){
																	uri = val5[0].href;	
																}
															});
															
															$('.thematicSite').append(firstName + " " + lastName + " ");

														});
													}  
												});
												
											}
											
										}
										
									});
								});
							}); */
							
							
						}
						//alert(hrefToAdd + "   " + $(relAndHref).data(hrefToAdd));
					});	
					
				});
				
				$('.navigation').unbind( "click" );

				$('.navigation').on('click', '[class^=newRef]', function(e){	// bind un événement
					
					e.preventDefault();
				
					restURI = $(this).attr('id');
					
					navigateIntoDataStructure(restURI, relAndHref);

				}); 
			} 			
		});
				
	</script>
	
	
</body>
</html>