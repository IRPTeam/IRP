Procedure OpenFormPickupSpecialOffers_ForDocument(Object, Form, NotifyEditFinish, AddInfo = Undefined,
	isAutoProcess = False) Export
	OpenFormArgs = GetOpenFormArgsPickupSpecialOffers_ForDocument(Object, isAutoProcess);

	If isAutoProcess Then
		// BSLLS:GetFormMethod-off
		OffersForm = GetForm("CommonForm.PickupSpecialOffers", New Structure("Info", OpenFormArgs), Form);
		// BSLLS:GetFormMethod-on
		ResultAutoProcess = OffersForm.PutOffersTreeToTempStorageOnClient();
		SpecialOffersEditFinish_ForDocument(ResultAutoProcess, Object, Form, AddInfo);
	Else
		OpenForm("CommonForm.PickupSpecialOffers", New Structure("Info", OpenFormArgs), Form, , , ,
			New NotifyDescription(NotifyEditFinish, Form, AddInfo), FormWindowOpeningMode.LockWholeInterface);
	EndIf;
EndProcedure

Function GetOpenFormArgsPickupSpecialOffers_ForDocument(Object, isAutoProcess) Export
	OpenArgs = New Structure();
	OpenArgs.Insert("ArrayOfOffers", OffersServer.GetAllActiveOffers_ForDocument(Object));
	OpenArgs.Insert("Type", "Offers_ForDocument");
	OpenArgs.Insert("Object", Object);
	Return OpenArgs;
EndFunction

Procedure SpecialOffersEditFinish_ForDocument(OffersInfo, Object, Form, AddInfo = Undefined) Export
	If OffersInfo = Undefined Then
		Return;
	EndIf;
	OffersClient.RecalculateTaxAndOffers(Object, Form);
	CalculationStringsClientServer.CalculateAndLoadOffers_ForDocument(Object, OffersInfo.OffersAddress);

	CalculationStringsClientServer.RecalculateAppliedOffers_ForRow(Object);
	
	If TypeOf(Object.Ref) = Type("DocumentRef.SalesInvoice")
		Or TypeOf(Object.Ref) = Type("DocumentRef.PurchaseInvoice") Then
		ViewClient_V2.OffersOnChange(Object, Form);
	Else
		CalculationStringsClientServer.CalculateItemsRows(Object, Form, Object.ItemList,
			CalculationStringsClientServer.GetCalculationSettings(), TaxesClient.GetArrayOfTaxInfo(Form));
	EndIf;
	
	Form.Modified = True;
	Form.TaxAndOffersCalculated = True;
	
	ExecuteCallback(AddInfo);
EndProcedure

Procedure OpenFormPickupSpecialOffers_ForRow(Object, CurrentRow, Form, NotifyEditFinish, AddInfo = Undefined) Export
	OpenFormArgs = GetOpenFormArgsPickupSpecialOffers_ForRow(Object, CurrentRow);
	OpenForm("CommonForm.PickupSpecialOffers", New Structure("Info", OpenFormArgs), Form, , , ,
		New NotifyDescription(NotifyEditFinish, Form, AddInfo), FormWindowOpeningMode.LockWholeInterface);
EndProcedure

Function GetOpenFormArgsPickupSpecialOffers_ForRow(Object, CurrentRow) Export
	OpenArgs = New Structure();
	OpenArgs.Insert("ArrayOfOffers", OffersServer.GetAllActiveOffers_ForRow(Object));
	OpenArgs.Insert("Type", "Offers_ForRow");
	OpenArgs.Insert("ItemListRowKey", CurrentRow.Key);
	OpenArgs.Insert("Object", Object);
	Return OpenArgs;
EndFunction

Procedure SpecialOffersEditFinish_ForRow(OffersInfo, Object, Form, AddInfo = Undefined) Export
	If OffersInfo = Undefined Then
		Return;
	EndIf;
	CalculationStringsClientServer.CalculateAndLoadOffers_ForRow(Object, OffersInfo.OffersAddress, OffersInfo.ItemListRowKey);
	
	If TypeOf(Object.Ref) = Type("DocumentRef.SalesInvoice") 
		Or TypeOf(Object.Ref) = Type("DocumentRef.PurchaseInvoice") Then
		ViewClient_V2.OffersOnChange(Object, Form);
	Else
		CalculationStringsClientServer.CalculateItemsRows(Object, Form, Object.ItemList,
			CalculationStringsClientServer.GetCalculationSettings(), TaxesClient.GetArrayOfTaxInfo(Form));
	EndIf;
	
	Form.Modified = True;
	ExecuteCallback(AddInfo);
EndProcedure

Procedure ExecuteCallback(Args)
	If Args <> Undefined And TypeOf(Args) = Type("Structure") And Args.Property("Callback") Then

		Execute StrTemplate("Args.Callback.Module.%1();", Args.Callback.Method);

	EndIf;
EndProcedure

Procedure RecalculateTaxAndOffers(Object, Form) Export
	If Form.TaxAndOffersCalculated Then
		Form.TaxAndOffersCalculated = False;
	EndIf;
	CalculationStringsClientServer.ClearDependentData(Object);
EndProcedure