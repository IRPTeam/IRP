Procedure OnCreateAtServer(Cancel, StandardProcessing, Form, Parameters) Export
	FillingData = Undefined;
	If Parameters.Property("FillingData", FillingData) Then
		Form.FillingData = CommonFunctionsServer.SerializeXMLUseXDTO(FillingData);
	EndIf;
	
	If Parameters.Property("FormTitle") Then
		Form.Title = Parameters.FormTitle;	
		Form.AutoTitle = False;
	EndIf;	
EndProcedure
