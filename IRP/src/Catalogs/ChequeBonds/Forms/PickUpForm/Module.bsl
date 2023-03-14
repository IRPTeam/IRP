#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque");
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	// filter by status
	NewFilter = List.Filter.Items.Add(Type("DataCompositionFilterItem"));
	NewFilter.LeftValue = New DataCompositionField("Status");
	NewFilter.ComparisonType = DataCompositionComparisonType.InList;
	NewFilter.RightValue = StatusSelection;
	NewFilter.Use = False;
	ThisObject.FilterByStatusIndex = List.Filter.Items.IndexOf(NewFilter);

	// filter by type
	NewFilter = List.Filter.Items.Add(Type("DataCompositionFilterItem"));
	NewFilter.LeftValue = New DataCompositionField("Type");
	NewFilter.ComparisonType = DataCompositionComparisonType.Equal;
	NewFilter.RightValue = ChequeBondType;
	NewFilter.Use = True;
	ThisObject.FilterByChequeBondType = List.Filter.Items.IndexOf(NewFilter);
EndProcedure

#EndRegion

#Region FormItemsEvents

&AtClient
Procedure ListSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	CurrentRow = Items.List.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	NewRow = PickedCheckBonds.Add();
	FillPropertyValues(NewRow, CurrentRow);
EndProcedure

&AtClient
Procedure ChequeBondTypeOnChange(Item)
	ThisObject.StatusCheck = False;
	ThisObject.StatusSelection = PredefinedValue("Catalog.ObjectStatuses.EmptyRef");
	SetFilterByStatus();
EndProcedure

&AtClient
Procedure StatusCheckOnChange(Item)
	SetFilterByStatus();
EndProcedure

&AtClient
Procedure StatusSelectionOnChange(Item)
	ThisObject.StatusCheck = ValueIsFilled(ThisObject.StatusSelection);
	SetFilterByStatus();
EndProcedure

&AtClient
Procedure SetFilterByStatus()
	If ThisObject.List.Filter.Items.Count() = 0 Then
		Return;
	EndIf;

	Filter = ThisObject.List.Filter.Items[ThisObject.FilterByStatusIndex];
	Filter.RightValue 	= ThisObject.StatusSelection;
	Filter.Use 			= ThisObject.StatusCheck;

	Filter = ThisObject.List.Filter.Items[ThisObject.FilterByChequeBondType];
	Filter.RightValue 	= ThisObject.ChequeBondType;
EndProcedure

#EndRegion

#Region CommandsEvents

&AtClient
Procedure CommandSaveAndClose(Command)
	Close(ThisObject.PickedCheckBonds);
EndProcedure

&AtClient
Procedure StatusSelectionStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.StatusStartChoice(ThisObject.Source, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure StatusSelectionEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.StatusEditTextChange(ThisObject.Source, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion
