Procedure OnCreateAtServer(Cancel, StandardProcessing, Form, Parameters) Export
	CustomFilter = Undefined;
	If Parameters.Property("CustomFilter", CustomFilter) Then
		Form.List.CustomQuery = True;
		Form.List.QueryText = CustomFilter.QueryText;
		For Each QueryParameter In CustomFilter.QueryParameters Do
			Form.List.Parameters.SetParameterValue(QueryParameter.Key, QueryParameter.Value);
		EndDo;
	EndIf;
EndProcedure
