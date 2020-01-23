#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, Not ValueIsFilled(Object.Ref));
	If Form.Parameters.Key.IsEmpty() Then
		Form.CurrentPartner = Object.Partner;
		Form.CurrentAgreement = Object.Agreement;
		Form.CurrentDate = Object.Date;
		Form.StoreBeforeChange 		= Form.Store;
		
		DocumentsClientServer.FillDefinedData(Object, Form);
		
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		DocumentsClientServer.FillStores(ObjectData, Form);
		
		DocumentsServer.FillItemList(Object);
		
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	Form.CurrentPartner = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate = CurrentObject.Date;
	
	DocumentsServer.FillItemList(Object);
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsServer.FillItemList(Object);
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	Form.CurrentPartner = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate = CurrentObject.Date;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#EndRegion

Function GetAgreementByPartner(Partner, Agreement) Export
	If Not Partner.IsEmpty() Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", Enums.AgreementTypes.Vendor, ComparisonType.Equal));
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

Function GetLegalNameByPartner(Partner, LegalName) Export
	If Not Partner.IsEmpty() Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		If ValueIsFilled(LegalName) Then
			ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref", LegalName, ComparisonType.Equal));
		EndIf;
		AdditionalParameters = New Structure();
		If ValueIsFilled(Partner) Then
			AdditionalParameters.Insert("Partner", Partner);
			AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
		EndIf;
		Parameters = New Structure("CustomSearchFilter, AdditionalParameters",
				DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters),
				DocumentsServer.SerializeArrayOfFilters(AdditionalParameters));
		Return Catalogs.Companies.GetDefaultChoiseRef(Parameters);
	EndIf;
	Return Undefined;
EndFunction

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array;
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");
	AttributesArray.Add("Status");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title),
				Form.Items[Atr].Title,
				Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion