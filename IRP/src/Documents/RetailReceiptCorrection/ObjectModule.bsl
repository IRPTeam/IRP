Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	If ThisObject.StatusType = Enums.RetailReceiptStatusTypes.Completed Then
		Payments_Amount = ThisObject.Payments.Total("Amount");
		ItemList_Amount = ThisObject.ItemList.Total("TotalAmount");
		If ItemList_Amount <> Payments_Amount Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_095, Payments_Amount, ItemList_Amount));
		EndIf;
	EndIf;
	
	If Cancel Then
		Return;
	EndIf;
	
	For Each Row In ThisObject.Payments Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = String(New UUID());
		EndIf;
	EndDo;
	
	Parameters = CurrenciesClientServer.GetParameters_V3(ThisObject);
	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies);
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	
	ThisObject.DocumentAmount = ThisObject.ItemList.Total("TotalAmount");
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	
	If TypeOf(FillingData) = Type("Structure") And FillingData.Property("Basis") Then
		FillingStructure = New Structure();
		Basis = FillingData.Basis;
		
		BasisMetadata = Basis.Metadata();
		ThisMetadata = ThisObject.Metadata();
		For Each Attr In BasisMetadata.Attributes Do
			If ThisMetadata.Attributes.Find(Attr.Name) = Undefined Then
				Continue;
			EndIf;	
			
			FillingStructure.Insert(Attr.Name, Basis[Attr.Name]);
			ThisObject[Attr.Name] = Basis[Attr.Name];
		EndDo;
		
		For Each Tab In BasisMetadata.TabularSections Do
			If ThisMetadata.TabularSections.Find(Tab.Name) = Undefined Then
				Continue;
			EndIf;
			
			FillingStructure.Insert(Tab.Name, New Array());
			For Each Row In Basis[Tab.Name] Do
				NewRow = New Structure();
				For Each Column In Tab.Attributes Do
					If ThisMetadata.TabularSections[Tab.Name].Attributes.Find(Column.Name) = Undefined Then
						Continue;
					EndIf;
					
					NewRow.Insert(Column.Name, Row[Column.Name]);
				EndDo;
				FillPropertyValues(ThisObject[Tab.Name].Add(), NewRow);
				FillingStructure[Tab.Name].Add(NewRow);
			EndDo;
		EndDo;
		ThisObject.BasisDocument = Basis;
		If TypeOf(Basis) = Type("DocumentRef.RetailReceiptCorrection") Then
			ThisObject.BasisDocumentFiscalNumber = Basis.BasisDocumentFiscalNumber;
		Else
			FiscalBasisData = InformationRegisters.DocumentFiscalStatus.GetStatusData(Basis);
			ThisObject.BasisDocumentFiscalNumber = FiscalBasisData.CheckNumber;
		EndIf;
		
		ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingStructure);
	EndIf;
EndProcedure

Procedure OnCopy(CopiedObject)
	LinkedTables = New Array();
	LinkedTables.Add(SpecialOffers);
	LinkedTables.Add(Currencies);
	LinkedTables.Add(SerialLotNumbers);
	DocumentsServer.SetNewTableUUID(ItemList, LinkedTables);
	
	For Each Row In Payments Do
		Row.RRNCode = "";
		Row.PaymentInfo = "";
	EndDo;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;
	EndIf;

	If Not SerialLotNumbersServer.CheckFilling(ThisObject) Then
		Cancel = True;
	EndIf;		
EndProcedure
