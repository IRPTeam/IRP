&AtClient
Procedure RoutesBeforeAddRow(Item, Cancel, Clone, Parent, Folder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure RoutesBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure TasksBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure AddTask(Command)
	OpenArgs = CreateOpenArgsAddTask();
	Notify = New NotifyDescription("AddTaskEnd", ThisObject);
	OpenForm("Document.TrackList.Form.FormAddTaskMobile", OpenArgs, ThisObject, , , , Notify);
EndProcedure

&AtServer
Function CreateOpenArgsAddTask()
	Result = New Structure();
	Result.Insert("DeliveryList", New Array());
	For Each Row In Object.Tasks Do
		If TypeOf(Row.Task) = Type("DocumentRef.DeliveryList") Then
			Result.DeliveryList.Add(Row.Task);
		EndIf;
	EndDo;
	Return Result;
EndFunction

&AtClient
Procedure AddTaskEnd(Result, Parameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	UpdateTask_DeliveryList(Result.DeliveryList);
	
	// Esle task processing here
	
	ThisObject.Modified = True;
EndProcedure

&AtServer
Procedure UpdateTask_DeliveryList(DeliveryLists)
	// Delete all task And routes
	ArrayOfRouteRows = New Array();
	ArrayOfTaskRows = New Array();
	For Each Row In Object.Tasks Do
		If TypeOf(Row.Task) = Type("DocumentRef.DeliveryList") Then
			For Each RouteRow In Object.Routes.FindRows(New Structure("Key", Row.Key)) Do
				ArrayOfRouteRows.Add(RouteRow);
			EndDo;
			ArrayOfTaskRows.Add(Row);
		EndIf;
	EndDo;
	
	For Each Row In Object.Routes Do
		If Not Object.Tasks.FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayOfRouteRows.Add(Row);
		EndIf;
	EndDo;
	
	For Each Row In ArrayOfTaskRows Do
		Object.Tasks.Delete(Row);
	EndDo;
	
	For Each Row In ArrayOfRouteRows Do
		Object.Routes.Delete(Row);
	EndDo;
	
	OriginGPS = "";
	If DeliveryLists.Count() Then
		OriginGPS = GetGPS(DeliveryLists[0].Store);
		OriginAddress = GetAddress(DeliveryLists[0].Store);
	EndIf;
	
	If ValueIsFilled(OriginGPS) Then
		NewKey = New UUID();
		NewRow_Routes = Object.Routes.Add();
		NewRow_Routes.Key = NewKey;
		NewRow_Routes.Address = OriginAddress;
		NewRow_Routes.GPS = OriginGPS;
		NewRow_Routes.Info = "";
		NewRow_Routes.Presentation = String(DeliveryLists[0].Store) + " - " + OriginAddress;
	EndIf;
	
	// add task And routes
	For Each DeliveryListRef In DeliveryLists Do
		NewKey = New UUID();
		NewRow_Task = Object.Tasks.Add();
		NewRow_Task.Key = NewKey;
		NewRow_Task.Task = DeliveryListRef;
		NewRow_Task.Presentation = Documents.DeliveryList.PresentationAsTask(DeliveryListRef);
		
		
		For Each Route In DeliveryListRef.Routes Do
			If Not ValueIsFilled(Route.GPS) Then
				Continue;
			EndIf;
			
			ArrayOfBasises = DeliveryListRef.Basises.FindRows(
					New Structure("Key", Route.Key));
			
			Partner = "";
			If ArrayOfBasises.Count()
				And ValueIsFilled(ArrayOfBasises[0].Basis)
				And TypeOf(ArrayOfBasises[0].Basis) = Type("DocumentRef.SalesOrder") Then
				
				Partner = String(ArrayOfBasises[0].Basis.Partner);
			EndIf;
			
			NewRow_Routes = Object.Routes.Add();
			NewRow_Routes.Key = NewKey;
			NewRow_Routes.Address = Route.Address;
			NewRow_Routes.GPS = Route.GPS;
			NewRow_Routes.Info = Route.Key;
			NewRow_Routes.Presentation = Partner + " - " + Route.Address;
		EndDo;
	EndDo;
	
	If ValueIsFilled(OriginGPS) Then
		NewKey = New UUID();
		NewRow_Routes = Object.Routes.Add();
		NewRow_Routes.Key = NewKey;
		NewRow_Routes.Address = OriginAddress;
		NewRow_Routes.GPS = OriginGPS;
		NewRow_Routes.Info = "";
		NewRow_Routes.Presentation = String(DeliveryLists[0].Store) + " - " + OriginAddress;
	EndIf;
	
EndProcedure

&AtServer
Function GetGPS(Ref)
	ArrayOfIDInfoTypes = New Array();
	ArrayOfIDInfoTypes.Add(Constants.DefaultDeliveryGPS.Get());
	store_gps = IDInfoServer.GetIDInfoTypeValue(Ref, ArrayOfIDInfoTypes);
	Return store_gps;
EndFunction

&AtServer
Function GetAddress(Ref)
	ArrayOfIDInfoTypes = New Array();
	ArrayOfIDInfoTypes.Add(Constants.DefaulDeliveryAddress.Get());
	store_gps = IDInfoServer.GetIDInfoTypeValue(Ref, ArrayOfIDInfoTypes);
	Return store_gps;
EndFunction

&AtClient
Procedure RoutesSelection(Item, SelectedRow, Field, StandardProcessing)
	StandardProcessing = False;
	If Field.Name = "RoutesChekIn" Then
		Return;
	EndIf;
	SelectedRow = Object.Routes.FindByID(SelectedRow);
	TypesOfTask = GetTypeOfTask(SelectedRow.Key);
	If TypesOfTask.Find(Type("DocumentRef.DeliveryList")) <> Undefined Then
		OpenTask_DeliveryList(SelectedRow.Info);
	EndIf;
EndProcedure

&AtClient
Procedure OpenTask_DeliveryList(Key)
	OrderByKey = GetOrderByKey(Key);
	If ValueIsFilled(OrderByKey) Then
		OpenForm("Document.SalesOrder.ObjectForm", New Structure("Key", OrderByKey), ThisObject, , , , , FormWindowOpeningMode.LockOwnerWindow);
	EndIf;
EndProcedure

&AtServer
Function GetOrderByKey(Key)
	Query = New Query();
	Query.Text =
		"SELECT TOP 1
		|	DeliveryListBasises.Basis AS Ref
		|FROM
		|	Document.DeliveryList.Basises AS DeliveryListBasises
		|WHERE
		|	DeliveryListBasises.Key = &Key";
	Query.SetParameter("Key", Key);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtServer
Function GetTypeOfTask(Key)
	ArrayOfTypes = New Array();
	For Each Row In Object.Tasks.FindRows(New Structure("Key", Key)) Do
		ArrayOfTypes.Add(TypeOf(Row.Task));
	EndDo;
	Return ArrayOfTypes;
EndFunction

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Key = "AIzaSyA2WCO2tJglRWL0u1uqlD5xJAf8BIjS9sw";
EndProcedure

#Region Map

&AtClient
Procedure CreateRoute(Command)
	
	#If WebClient Then
	
	CommonFunctionsClientServer.ShowUsersMessage(R()["Error_015"]);
	Return;
	
	#Else
	
	ThisObject.WayPoints.Clear();
	
	For Each Row In Object.Routes Do
		NewRow = ThisObject.WayPoints.Add();
		NewRow.LatLng = Row.GPS;
	EndDo;
	
	count_points = ThisObject.WayPoints.Count();
	If Not count_points Then
		Return;
	EndIf;
	
	_origIn = StrSplit(ThisObject.WayPoints[0].LatLng, ",");	
	origIn = New Structure("lat, lng", Number(_origin[0]), Number(_origin[1]));
	
	_destination = StrSplit(ThisObject.WayPoints[count_points - 1].LatLng, ",");
	destination = New Structure("lat,lng", Number(_destination[0]), Number(_destination[1]));
	
	array_of_waypoints = New Array();
	array_of_locations = New Array();
	For i = 1 To count_points - 2 Do
		_waypoint = StrSplit(ThisObject.WayPoints[i].LatLng, ",");
		array_of_waypoints.Add(_waypoint[0] + "," + _waypoint[1]);
		array_of_locations.Add(New Structure("location, stopover",
				New Structure("lat,lng", Number(_waypoint[0]), Number(_waypoint[1])), True));
	EndDo;
	
	InitMap(JSON_Write(origin), JSON_Write(destination), JSON_Write(array_of_locations));
	
	URL = StrTemplate("/maps/api/directions/json?"
			+ "origin=%1"
			+ "&destination=%2"
			+ "&waypoints=optimize:True|%3"
			+ "&key=%4",
			Format(origin.lat, "NDS=.") + "," + Format(origin.lng, "NDS=."),
			Format(destination.lat, "NDS=.") + "," + Format(destination.lng, "NDS=."),
			StrConcat(array_of_waypoints, "|"),
			ThisObject.Key);
	
	Request = New HTTPRequest(URL);
	
	HTTP = HTTPConnection();
	Answer = HTTP.GET(Request);
	JSONStr = Answer.GetBodyAsString();
	Data = JSON_Read(JSONStr);
	
	If Data.status <> "OK" Then
		Return;
	EndIf;
	
	Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
	Object.Routes[0].WayPointMarker = Mid(Alphabet, 1, 1);
	index = 1;
	For Each Row In Data.routes[0].waypoint_order Do
		
		Object.Routes[index].WayPointOrder = Row + 1;
		Object.Routes[index].WayPointMarker = Mid(Alphabet, Row + 2, 1);
		
		Object.Routes[index].TrackInfo =
			Data.routes[0].legs[index - 1].distance.text
			+ " ~ " +
			Data.routes[0].legs[index - 1].duration.text;
		
		index = index + 1;
	EndDo;
	Object.Routes[index].WayPointOrder = Row + 2;
	Object.Routes[index].WayPointMarker = Mid(Alphabet, Row + 3, 1);
	
	Object.Routes[index].TrackInfo =
		Data.routes[0].legs[index - 1].distance.text
		+ " ~ " +
		Data.routes[0].legs[index - 1].duration.text;
	
	Object.Routes.Sort("WayPointOrder");
	ThisObject.Modified = True;
	
	#EndIf
	
EndProcedure

&AtClient
Function HTTPConnection()
	
	ReturnValue = Undefined;
	
	#If Not WebClient Then
	
	ReturnValue = New HTTPConnection("maps.googleapis.com", 443, , , , 10, New OpenSSLSecureConnection);
	
	#EndIf
	
	Return ReturnValue;
	
EndFunction

&AtClient
Function JSON_Read(JSON)
	
	ReturnValue = Undefined;
	
	#If Not WebClient Then
	
	JSON_Reader = New JSONReader;
	JSON_Reader.SetString(JSON);
	ReturnValue = ReadJSON(JSON_Reader, False);
	
	#EndIf
	
	Return ReturnValue;
	
EndFunction

&AtClient
Function JSON_Write(Obj)
	
	ReturnValue = Undefined;
	
	#If Not WebClient Then
	
	JSONWriter = New JSONWriter();
	JSONWriter.SetString();
	WriteJSON(JSONWriter, Obj);
	ReturnValue = JSONWriter.Close();
	
	#EndIf
	
	Return ReturnValue;
	
EndFunction

&AtServer
Procedure InitMap(start_latlng, end_latlng, waypoints)
	
	Map = Documents.TrackList.GetTemplate("Map").GetText();
	Map = StrReplace(Map, "YOUR_API_KEY", ThisObject.Key);
	Map = StrReplace(Map, "START_LATLNG", start_latlng);
	Map = StrReplace(Map, "END_LATLNG", end_latlng);
	Map = StrReplace(Map, "WAYPOINTS", waypoints);
	
EndProcedure

#EndRegion

