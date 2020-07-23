Procedure OnCreateAtServer(Cancel, StandardProcessing, Form, Parameters) Export
	FillingData = Undefined;
	If Parameters.Property("FillingData", FillingData) Then
		Form.FillingData = CommonFunctionsServer.SerializeXMLUseXDTO(FillingData);
	EndIf;
	
	If Parameters.Property("FormTitle") Then
		Form.Title = Parameters.FormTitle;	
		Form.AutoTitle = False;
	EndIf;
	
	If Form.FormName = "Catalog.Agreements.Form.ChoiceForm"
		Or Form.FormName = "Catalog.Agreements.Form.ListForm" Then
		Form.List.Parameters.SetParameterValue("IncludeFilterByEndOfUseDate", Parameters.IncludeFilterByEndOfUseDate);
		Form.List.Parameters.SetParameterValue("IncludeFilterByPartner", Parameters.IncludeFilterByPartner);
		Form.List.Parameters.SetParameterValue("IncludePartnerSegments", Parameters.IncludePartnerSegments);
		Form.List.Parameters.SetParameterValue("EndOfUseDate", Parameters.EndOfUseDate);
		Form.List.Parameters.SetParameterValue("Partner", Parameters.Partner);
	EndIf;
EndProcedure

Function GetAgreementInfo(Agreement) Export
	Return Catalogs.Agreements.GetAgreementInfo(Agreement);
EndFunction