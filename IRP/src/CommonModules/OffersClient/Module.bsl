Procedure OpenFormPickupSpecialOffers_ForDocument(Object, Form, NotifyEditFinish, AddInfo = Undefined) Export
	OpenFormArgs = OffersClientServer.GetOpenFormArgsPickupSpecialOffers_ForDocument(Object);
	CallbackDescription = New CallbackDescription(NotifyEditFinish, Form, AddInfo);
	OpenForm("CommonForm.PickupSpecialOffers", New Structure("Info", OpenFormArgs), , , , , CallbackDescription,
			 FormWindowOpeningMode.LockWholeInterface);
EndProcedure

Procedure SpecialOffersEditFinish_ForDocument(Object, Form, AddInfo = Undefined) Export
	If Form.TaxAndOffersCalculated Then
		Form.TaxAndOffersCalculated = False;
	EndIf;
	
	ViewClient_V2.OffersOnChange(Object, Form);
	
	Form.Modified = True;
	Form.TaxAndOffersCalculated = True;
EndProcedure

Procedure OpenFormPickupSpecialOffers_ForRow(Object, CurrentRow, Form, NotifyEditFinish, AddInfo = Undefined) Export
	OpenFormArgs = GetOpenFormArgsPickupSpecialOffers_ForRow(Object, CurrentRow);
	OpenForm("CommonForm.PickupSpecialOffers", New Structure("Info", OpenFormArgs), Form, , , ,
		New CallbackDescription(NotifyEditFinish, Form, AddInfo), FormWindowOpeningMode.LockWholeInterface);
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
	ViewClient_V2.OffersOnChange(Object, Form);
	Form.Modified = True;
EndProcedure

Procedure OpenFormPickupSpecialOffers_ForSelectedRows(Object, ArrayOfRowKeys, Form, NotifyEditFinish, AddInfo = Undefined) Export
	OpenFormArgs = GetOpenFormArgsPickupSpecialOffers_ForSelectedRows(Object, ArrayOfRowKeys);
	OpenForm("CommonForm.PickupSpecialOffers", New Structure("Info", OpenFormArgs), Form, , , ,
		New CallbackDescription(NotifyEditFinish, Form, AddInfo), FormWindowOpeningMode.LockWholeInterface);
EndProcedure        

Function GetOpenFormArgsPickupSpecialOffers_ForSelectedRows(Object, ArrayOfRowKeys) Export
	OpenArgs = New Structure();
	OpenArgs.Insert("ArrayOfOffers", OffersServer.GetAllActiveOffers_ForSelectedRows(Object));
	OpenArgs.Insert("Type", "Offers_ForSelectedRows");
	OpenArgs.Insert("ArrayOfRowKeys", ArrayOfRowKeys);
	OpenArgs.Insert("Object", Object);
	Return OpenArgs;
EndFunction

Procedure SpecialOffersEditFinish_ForSelectedRows(OffersInfo, Object, Form, AddInfo = Undefined) Export
	If OffersInfo = Undefined Then
		Return;
	EndIf;
	ViewClient_V2.OffersOnChange(Object, Form);
	Form.Modified = True;
EndProcedure


