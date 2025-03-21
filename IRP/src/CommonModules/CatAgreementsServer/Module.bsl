Procedure OnCreateAtServer(Cancel, StandardProcessing, Form, Parameters) Export
	FillingData = Undefined;
	If Parameters.Property("FillingData", FillingData) Then
		Form.FillingData = CommonFunctionsServer.SerializeXMLUseXDTO(FillingData);
	EndIf;

	If Parameters.Property("FormTitle") Then
		Form.Title = Parameters.FormTitle;
		Form.AutoTitle = False;
	EndIf;

	If Form.FormName = "Catalog.Agreements.Form.ChoiceForm" Or Form.FormName = "Catalog.Agreements.Form.ListForm" Then
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

Function GetAgreementPaymentTerms(Agreement) Export
	Return Catalogs.Agreements.GetAgreementPaymentTerms(Agreement);
EndFunction

// Create mirorr agreement.
// 
// Parameters:
//  Object - CatalogObject.Agreements - Object
// 
// Returns:
//  CatalogRef.Agreements
Function CreateMirorrAgreement(Object) Export
	NewObject = Catalogs.Agreements.CreateItem();
	CopyAgreement(NewObject, Object);
	NewObject.Write();
	Return NewObject.Ref;
EndFunction

// Copy agreement.
// 
// Parameters:
//  NewObject - CatalogObject.Agreements - New object
//  Object - CatalogObject.Agreements - Object
Procedure CopyAgreement(NewObject, Object)
	IgnoreList = New Array;
	IgnoreList.Add("Parent");
	IgnoreList.Add("Owner");
	IgnoreList.Add("Ref");
	IgnoreList.Add("Code");
	For Each Table In Metadata.Catalogs.Agreements.TabularSections Do
		NewObject[Table.Name].Load(Object[Table.Name].Unload());
		IgnoreList.Add(Table.Name);
	EndDo;
	FillPropertyValues(NewObject, Object, , StrConcat(IgnoreList, ","));
	
	NewObject.IntercompanyBaseAgreement = Object.Ref;
	NewObject.Account = Catalogs.CashAccounts.EmptyRef();
	
	NewObject.Partner = Catalogs.Partners.EmptyRef();
	NewObject.PartnerSegment = Catalogs.PartnerSegments.EmptyRef();
	NewObject.Company = Catalogs.Companies.EmptyRef();
	NewObject.LegalName = Catalogs.Companies.EmptyRef();
	
	If Object.Type = Enums.AgreementTypes.Customer Then
		NewObject.Type = Enums.AgreementTypes.Vendor;
		NewObject.ItemSegment = Catalogs.ItemSegments.EmptyRef();
		NewObject.UseCreditLimit = False;
		NewObject.CreditLimitAmount = 0;
	Else
		NewObject.Type = Enums.AgreementTypes.Customer;
		NewObject.RecordPurchasePrices = False;
	EndIf;
	
EndProcedure

// Update mirorr agreement.
// 
// Parameters:
//  Object - CatalogObject.Agreements - Object
// 
// Returns:
//  CatalogRef.Agreements
Function UpdateMirorrAgreement(Object) Export
	
	Query = New Query;
	Query.Text =
		"SELECT TOP 1
		|	Agreements.Ref
		|FROM
		|	Catalog.Agreements AS Agreements
		|WHERE
		|	Agreements.IntercompanyBaseAgreement = &IntercompanyBaseAgreement";
	
	Query.SetParameter("IntercompanyBaseAgreement", Object.Ref);
	
	QueryResult = Query.Execute().Select();

	If QueryResult.Next() Then
		NewObject = QueryResult.Ref.GetObject();
		UpdateAgreement(NewObject, Object);
		NewObject.Write();
		Return NewObject.Ref;
	Else
		Return CreateMirorrAgreement(Object)
	EndIf;
EndFunction

// Update agreement.
// 
// Parameters:
//  NewObject - CatalogObject.Agreements - New object
//  Object - CatalogObject.Agreements - Object
Procedure UpdateAgreement(NewObject, Object)
	IgnoreList = New Array;
	Ignore = "Code, Owner, Ref, Parent, PartnerSegment, Partner, Company, ItemSegment, Type, LegalName, UseCreditLimit, CreditLimitAmount, RecordPurchasePrices,
	|Account, Intercompany, IntercompanyBaseAgreement";
	IgnoreList.Add(Ignore);
	For Each Table In Metadata.Catalogs.Agreements.TabularSections Do
		NewObject[Table.Name].Load(Object[Table.Name].Unload());
		IgnoreList.Add(Table.Name);
	EndDo;
	FillPropertyValues(NewObject, Object, , StrConcat(IgnoreList, ","));
EndProcedure