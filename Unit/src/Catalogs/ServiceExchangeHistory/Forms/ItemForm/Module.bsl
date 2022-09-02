// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ReadOnly = True;
	
	RealObject = FormDataToValue(Object, Type("CatalogObject.ServiceExchangeHistory")); //CatalogObject.ServiceExchangeHistory 
	HeadersValue = RealObject.Headers.Get();
	If TypeOf(HeadersValue) = Type("Map") Then
		For Each KeyValue In HeadersValue Do
			HeaderRow = HeadersTable.Add();
			HeaderRow.Key = String(KeyValue.Key);
			HeaderRow.Value = String(KeyValue.Value);
		EndDo;
	EndIf;
	
	If Object.Parent.IsEmpty() Then			// Query
		Items.GroupAnswer.Visible = False;
	Else									// Answer
		Items.GroupQuery.Visible = False;
		Items.HeadersGroup.Visible = False;
		Items.TryLoadBody.Visible = False;
		BodyString = String(RealObject.Body.Get());
	EndIf;
	
EndProcedure


&AtClient
Procedure TryLoadBody(Command)
	TryLoadBodyAtServer();
EndProcedure

&AtServer
Procedure TryLoadBodyAtServer()
	RealObject = FormDataToValue(Object, Type("CatalogObject.ServiceExchangeHistory")); //CatalogObject.ServiceExchangeHistory 
	BodyString = String(RealObject.Body.Get());
EndProcedure
