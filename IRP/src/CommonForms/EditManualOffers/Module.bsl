
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If ValueIsFilled(Parameters.ManualOfferType) Then
		ThisObject.ManualOfferType = Parameters.ManualOfferType;
	Else
		ThisObject.ManualOfferType = PredefinedValue("Enum.ManualOfferTypes.Amount");
	EndIf;
	
	ThisObject.ManualOfferAmount  = Parameters.ManualOfferAmount;
	ThisObject.ManualOfferPercent = Parameters.ManualOfferPercent;
	
	For Each Row In Parameters.ItemList Do
		FillPropertyValues(ThisObject.ItemList.Add(), Row);
	EndDo;
	
	SetVisibilityAvailability(ThisObject);
EndProcedure

&AtClient
Procedure ManualOfferTypeOnChange(Item)
	SetVisibilityAvailability(ThisObject);
EndProcedure

&AtClient
Procedure Ok(Command)
	ArrayOfResuts = New Array();
	IsPercent = (ThisObject.ManualOfferType = PredefinedValue("Enum.ManualOfferTypes.Percent"));
	TotalAmount = 0;
	If Not IsPercent Then
		For Each Row In ThisObject.ItemList Do
			TotalAmount = TotalAmount + (Row.Price * Row.Quantity);
		EndDo;
	EndIf;
	
	TotalManualOfferAmount = 0;
	MaxRow = Undefined;
	For Each Row In ThisObject.ItemList Do
		NewRow = New Structure("Key, ManualOfferType, ManualOfferPercent, ManualOfferAmount", 
			Row.Key, ThisObject.ManualOfferType, 0, 0);
		ArrayOfResuts.Add(NewRow);
		If IsPercent Then
			NewRow.ManualOfferPercent = ThisObject.ManualOfferPercent;
		Else
			If TotalAmount = 0 Then
				Continue;
			EndIf;
			PercentOnRow = (Row.Price * Row.Quantity) / (TotalAmount/100);//TotalAmount / 100 * (Row.Price * Row.Quantity);
			NewRow.ManualOfferAmount = Round(ThisObject.ManualOfferAmount / 100 * PercentOnRow, 2);
			TotalManualOfferAmount = TotalManualOfferAmount + NewRow.ManualOfferAmount;
			If MaxRow = Undefined Then
				MaxRow = NewRow;
			Else
				If MaxRow.ManualOfferAmount < NewRow.ManualOfferAmount Then
					MaxRow = NewRow;
				EndIf;
			EndIf;
		EndIf;
	EndDo;
	If Not IsPercent Then
		If TotalManualOfferAmount <> ThisObject.ManualOfferAmount And MaxRow <> Undefined Then
			MaxRow.ManualOfferAmount = MaxRow.ManualOfferAmount + (TotalManualOfferAmount - ThisObject.ManualOfferAmount);
		EndIf;
	EndIf;
	Close(New Structure("ItemList", ArrayOfResuts));
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Form)
	IsPercent = (Form.ManualOfferType = PredefinedValue("Enum.ManualOfferTypes.Percent"));
	Form.Items.ManualOfferPercent.Visible = IsPercent;
	Form.Items.ManualOfferAmount.Visible  = Not IsPercent;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure
