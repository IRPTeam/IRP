Procedure OnCreateAtServer(Cancel, StandartProcessing, Form, Parameters) Export
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
		If Parameters.IncludePartnerSegments Then
			PartnersSegmentsArray = InformationRegisters.PartnerSegments.GetSegmentsRefArrayByPartner(Parameters.Partner);
			Form.List.Parameters.SetParameterValue("PartnerSegments", PartnersSegmentsArray);
		Else
			Form.List.Parameters.SetParameterValue("PartnerSegments", New Array());
		EndIf;
		Form.List.Parameters.SetParameterValue("EndOfUseDate", Parameters.EndOfUseDate);
		Form.List.Parameters.SetParameterValue("Partner", Parameters.Partner);
	EndIf;
EndProcedure

Function GetAgreementByPartner(Partner, Agreement) Export
	If Not Partner.IsEmpty() Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", Enums.AgreementTypes.Customer, ComparisonType.Equal));
		If ValueIsFilled(Agreement) Then
			ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref", Agreement, ComparisonType.Equal));
		EndIf;
		AdditionalParameters = New Structure();
		AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
		AdditionalParameters.Insert("IncludeFilterByPartner", True);
		AdditionalParameters.Insert("IncludePartnerSegments", True);
		AdditionalParameters.Insert("EndOfUseDate", CurrentDate());
		AdditionalParameters.Insert("Partner", Partner);
		Parameters = New Structure("CustomSearchFilter, AdditionalParameters",
				DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters),
				DocumentsServer.SerializeArrayOfFilters(AdditionalParameters));
		Return Catalogs.Agreements.GetDefaultChoiseRef(Parameters);
	EndIf;
	Return Undefined;
EndFunction

Function GetAgreementByLegalName(LegalName, Agreement) Export
	If Not LegalName.IsEmpty() Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", Enums.AgreementTypes.Customer, ComparisonType.Equal));
		
		If ValueIsFilled(Agreement) Then
			ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref", Agreement, ComparisonType.Equal));
		EndIf;
		
		AdditionalParameters = New Structure();
		AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
		AdditionalParameters.Insert("IncludeFilterByPartner", True);
		AdditionalParameters.Insert("IncludePartnerSegments", True);
		AdditionalParameters.Insert("EndOfUseDate", CurrentDate());
		AdditionalParameters.Insert("LegalName", LegalName);
		Parameters = New Structure("CustomSearchFilter, AdditionalParameters",
				DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters),
				DocumentsServer.SerializeArrayOfFilters(AdditionalParameters));
		Return Catalogs.Agreements.GetDefaultChoiseRef(Parameters);
	EndIf;
	Return Undefined;
EndFunction

Function GetAgreementInfo(Agreement) Export
	Return Catalogs.Agreements.GetAgreementInfo(Agreement);
EndFunction