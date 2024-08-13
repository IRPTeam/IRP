Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	Parameters = CurrenciesClientServer.GetParameters_V3(ThisObject);
	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies);
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	
	AmountsInfo = CurrenciesClientServer.GetLocalTotalAountsInfo();	
	AmountsInfo.TotalAmount.Value = ThisObject.ItemList.Total("TotalAmount");
	AmountsInfo.NetAmount.Value   = ThisObject.ItemList.Total("NetAmount");
	AmountsInfo.TaxAmount.Value   = ThisObject.ItemList.Total("TaxAmount");
	TotalAmounts = CurrenciesServer.GetLocalTotalAmounts(ThisObject, Parameters, AmountsInfo);
	CurrenciesServer.UpdateLocalTotalAmounts(ThisObject, TotalAmounts, AmountsInfo);
	
	ThisObject.DocumentAmount = ThisObject.ItemList.Total("TotalAmount");
	ThisObject.AdditionalProperties.Insert("OriginalDocumentDate", PostingServer.GetOriginalDocumentDate(ThisObject));
	ThisObject.AdditionalProperties.Insert("IsPostingNewDocument" , WriteMode = DocumentWriteMode.Posting And Not Ref.Posted);
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

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("BasedOn") Then
			If FillingData.BasedOn = "SalesReportToConsignor" Then 
				ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData, "SerialLotNumbers, SourceOfOrigins");
				Filling_BasedOn(FillingData);
			EndIf;
		EndIf;
	EndIf;
EndProcedure

Procedure Filling_BasedOn(FillingData)
	FillPropertyValues(ThisObject, FillingData);
	
	For Each Row In FillingData.ItemList Do
		NewRow = ThisObject.ItemList.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;
	
	For Each Row In FillingData.SerialLotNumbers Do
		NewRow = ThisObject.SerialLotNumbers.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;
	
	For Each Row In FillingData.SourceOfOrigins Do
		NewRow = ThisObject.SourceOfOrigins.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;	
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If Not SerialLotNumbersServer.CheckFilling(ThisObject) Then
		Cancel = True;
	EndIf;
EndProcedure
