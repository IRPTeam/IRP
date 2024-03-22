
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	SetCodeMask();
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure LedgerTypeVariantOnChange(Item)
	SetCodeMask();
EndProcedure

&AtServer
Procedure SetCodeMask()
	If ValueIsFilled(Object.LedgerTypeVariant) And ValueIsFilled(Object.LedgerTypeVariant.AccountChartsCodeMask) Then
		Items.Code.Mask = Object.LedgerTypeVariant.AccountChartsCodeMask;
	EndIf;
EndProcedure

&AtClient
Async Procedure QuantityOnChange(Item)
	//@skip-check unknown-method-property
	TableIsFilled = Object.ExtDimensionTypes.Count() > 0;
	
	If TableIsFilled Then
		Answer = Await DoQueryBoxAsync(R().AccountingQuestion_01, QuestionDialogMode.OKCancel);
	EndIf;
	
	If TableIsFilled And Answer = DialogReturnCode.OK Then
		For Each Row In Object.ExtDimensionTypes Do
			//@skip-check unknown-method-property
			Row.Quantity = Object.Quantity;
		EndDo;
	EndIf;
EndProcedure

&AtClient
Async Procedure CurrencyOnChange(Item)
	//@skip-check unknown-method-property
	TableIsFilled = Object.ExtDimensionTypes.Count() > 0;
	
	If TableIsFilled Then
		Answer = Await DoQueryBoxAsync(R().AccountingQuestion_02, QuestionDialogMode.OKCancel);
	EndIf;
	
	If TableIsFilled And Answer = DialogReturnCode.OK Then
		For Each Row In Object.ExtDimensionTypes Do
			//@skip-check unknown-method-property
			Row.Currency = Object.Currency;
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure ExtDimensionTypesOnStartEdit(Item, NewRow, Clone)
	If Not Clone And  NewRow Then
		Item.CurrentData.Amount = True;
		Item.CurrentData.Currency = Object.Currency;
		Item.CurrentData.Quantity = Object.Quantity;
	EndIf;
EndProcedure

