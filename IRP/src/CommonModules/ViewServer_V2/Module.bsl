
Procedure OnCreateAtServer(Object, Form) Export
	If Not CommonFunctionsServer.FormHaveAttribute(Form, "CacheBeforeChange") Then
		ArrayOfNewAttribute = New Array();
		ArrayOfNewAttribute.Add(New FormAttribute("CacheBeforeChange", New TypeDescription("String")));
		Form.ChangeAttributes(ArrayOfNewAttribute);
	EndIf;
EndProcedure