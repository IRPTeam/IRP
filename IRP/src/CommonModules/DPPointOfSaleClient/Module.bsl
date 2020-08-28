
&AtClient
Procedure ExternalEvent(Object, Form, Source, Event, Data) Export
	If Data <> Undefined Then
		NotifyParameters = New Structure;
		NotifyParameters.Insert("Form", Form);
		NotifyParameters.Insert("Object", Object);
		NotifyParameters.Insert("ClientModule", ThisObject);
		BarcodeClient.InputBarcodeEnd(Data, NotifyParameters);
	EndIf;
EndProcedure

&AtClient
Procedure BeforePayment(Object, Cancel, AddInfo = Undefined) Export
	Return;
EndProcedure