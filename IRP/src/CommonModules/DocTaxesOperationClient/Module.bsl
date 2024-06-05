#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, Form.MainTables);
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, Form.MainTables);
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, Form.MainTables);
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True,
		DataCompositionComparisonType.Equal));
	OpenSettings.FillingData = New Structure("OurCompany", True);

	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True, ComparisonType.Equal));
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region CURRENCY

Procedure CurrencyOnChange(Object, Form, Item) Export
	ViewClient_V2.CurrencyOnChange(Object, Form, Form.MainTables);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

Procedure TransactionTypeOnChange(Object, Form, Item) Export
	ViewClient_V2.TransactionTypeOnChange(Object, Form, Form.MainTables);
EndProcedure

#EndRegion

#Region PARTNER

Procedure PartnerOnChange(Object, Form, Item) Export
	ViewClient_V2.PartnerOnChange(Object, Form, Form.MainTables);
EndProcedure

Procedure PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.PartnerStartChoice_TransactionTypeFilter(Object, Form, Item, ChoiceData, StandardProcessing, Object.TransactionType);
EndProcedure

Procedure PartnerTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.PartnerTextChange_TransactionTypeFilter(Object, Form, Item, Text, StandardProcessing, Object.TransactionType);
EndProcedure

#EndRegion

#Region LEGAL_NAME

Procedure LegalNameOnChange(Object, Form, Item) Export
	ViewClient_V2.LegalNameOnChange(Object, Form, Form.MainTables);
EndProcedure

Procedure LegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.LegalNameStartChoice_PartnerFilter(Object, Form, Item, ChoiceData, StandardProcessing, Object.Partner);
EndProcedure

Procedure LegalNameTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.LegalNameTextChange_PartnerFilter(Object, Form, Item, Text, StandardProcessing, Object.Partner);
EndProcedure

#EndRegion

#Region AGREEMENT

Procedure AgreementOnChange(Object, Form, Item) Export
	ViewClient_V2.AgreementOnChange(Object, Form, Form.MainTables);
EndProcedure

Procedure AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.AgreementStartChoice_TransactionTypeFilter(Object, Form, Item, ChoiceData, StandardProcessing, Object.TransactionType);
EndProcedure

Procedure AgreementTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.AgreementTextChange_TransactionTypeFilter(Object, Form, Item, Text, StandardProcessing, Object.TransactionType);
EndProcedure

#EndRegion

#Region LEGAL_NAME_CONTRACT

Procedure LegalNameContractOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#EndRegion

#Region TAXES_INCOMING

Procedure TaxesIncomingBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.TaxesIncomingOutgoingBeforeAddRow(Object, Form, "TaxesIncoming", Cancel, Clone);
EndProcedure

Procedure TaxesIncomingAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.TaxesIncomingOutgoingAfterDeleteRow(Object, Form, "TaxesIncoming");
EndProcedure

Procedure TaxesIncomingVatRateOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.TaxesIncomingOutgoingVatRateOnChange(Object, Form, "TaxesIncoming", CurrentData);
EndProcedure

Procedure TaxesIncomingNetAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.TaxesIncomingOutgoingNetAmountOnChange(Object, Form, "TaxesIncoming", CurrentData);
EndProcedure

Procedure TaxesIncomingTaxAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.TaxesIncomingOutgoingTaxAmountOnChange(Object, Form, "TaxesIncoming", CurrentData);
EndProcedure

Procedure TaxesIncomingTotalAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.TaxesIncomingOutgoingTotalAmountOnChange(Object, Form, "TaxesIncoming", CurrentData);
EndProcedure

#EndRegion

#Region TAXES_OUTGOING

Procedure TaxesOutgoingBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.TaxesIncomingOutgoingBeforeAddRow(Object, Form, "TaxesOutgoing", Cancel, Clone);
EndProcedure

Procedure TaxesOutgoingAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.TaxesIncomingOutgoingAfterDeleteRow(Object, Form, "TaxesOutgoing");
EndProcedure

Procedure TaxesOutgoingVatRateOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.TaxesIncomingOutgoingVatRateOnChange(Object, Form, "TaxesOutgoing", CurrentData);
EndProcedure

Procedure TaxesOutgoingNetAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.TaxesIncomingOutgoingNetAmountOnChange(Object, Form, "TaxesOutgoing", CurrentData);
EndProcedure

Procedure TaxesOutgoingTaxAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.TaxesIncomingOutgoingTaxAmountOnChange(Object, Form, "TaxesOutgoing", CurrentData);
EndProcedure

Procedure TaxesOutgoingTotalAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.TaxesIncomingOutgoingTotalAmountOnChange(Object, Form, "TaxesOutgoing", CurrentData);
EndProcedure

#EndRegion

Procedure FillTaxesIncomingOutgoing(Object, Form, DocRef, DocDate, Company, Branch, Currency, RegName, TableName) Export
	TableInfo = DocTaxesOperationServer.FillTaxesIncomingOutgoing(Form.UUID, DocRef, DocDate, Company, Branch, Currency, RegName);
	ViewClient_V2.TaxesIncomingOutgoingLoad(Object, Form, TableName, TableInfo.Address, TableInfo.GroupColumn, TableInfo.SumColumn);
EndProcedure
