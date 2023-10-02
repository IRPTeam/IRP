
&AtClient
Procedure OnOpen(Cancel)
	
	If Not Record.Segment.IsEmpty() Then
		ThisObject.CurrentItem = Items.Item;
		If Not Record.Item.IsEmpty() Then
			ThisObject.CurrentItem = Items.ItemKey;
		EndIf;
	EndIf;

	If Not Record.Item.IsEmpty() Then
		ParametersArray = New Array; // Array of ChoiceParameter
		ParametersArray.Add(New ChoiceParameter("Filter.DeletionMark", False));
		ParametersArray.Add(New ChoiceParameter("Filter.Item", Record.Item));
		Items.ItemKey.ChoiceParameters = New FixedArray(ParametersArray);
	EndIf;

EndProcedure

&AtClient
Procedure ItemKeyOnChange(Item)
	If Not Record.ItemKey.IsEmpty() And Record.Item.IsEmpty() Then
		Record.Item = CommonFunctionsServer.GetRefAttribute(Record.ItemKey, "Item");
	EndIf;
EndProcedure

&AtClient
Procedure ItemOnChange(Item)
	
	If Record.Item.IsEmpty() Then
		Items.ItemKey.ChoiceParameters = New FixedArray(New Array);
	Else
		ParametersArray = New Array; // Array of ChoiceParameter
		ParametersArray.Add(New ChoiceParameter("Filter.DeletionMark", False));
		ParametersArray.Add(New ChoiceParameter("Filter.Item", Record.Item));
		Items.ItemKey.ChoiceParameters = New FixedArray(ParametersArray);
		If Not Record.ItemKey.IsEmpty() Then
			FactItem = CommonFunctionsServer.GetRefAttribute(Record.ItemKey, "Item");
			If FactItem <> Record.Item Then
				Record.ItemKey = Undefined;
			EndIf;
		EndIf;
	EndIf;

EndProcedure
