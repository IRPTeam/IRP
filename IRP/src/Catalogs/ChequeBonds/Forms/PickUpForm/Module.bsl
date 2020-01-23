#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque");
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	
	NewFilter = List.Filter.Items.Add(Type("DataCompositionFilterItem"));
	
	NewFilter.LeftValue = New DataCompositionField("Status");
	NewFilter.ComparisonType = DataCompositionComparisonType.InList;
	NewFilter.RightValue = StatusSelection;
	NewFilter.Use = False;
	
	FilterByStatusIndex = List.Filter.Items.IndexOf(NewFilter);
	
	NewFilter = List.Filter.Items.Add(Type("DataCompositionFilterItem"));
	
	NewFilter.LeftValue = New DataCompositionField("Type");
	NewFilter.ComparisonType = DataCompositionComparisonType.Equal;
	NewFilter.RightValue = ChequeBondType;
	NewFilter.Use = True;
	
	FilterByChequeBondType = List.Filter.Items.IndexOf(NewFilter);
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
	StatusCheck = False;
	StatusSelection = PredefinedValue("Catalog.ObjectStatuses.EmptyRef");
	SetFilterByStatus();
EndProcedure

&AtClient
Procedure StstusCheakOnChange(Item)
	SetFilterByStatus();
EndProcedure


&AtClient
Procedure StatusSelectionOnChange(Item)
	StatusCheck = ValueIsFilled(StatusSelection);
	SetFilterByStatus();
EndProcedure

&AtClient
Procedure SetFilterByStatus()
	If List.Filter.Items.Count() = 0 Then
		Return;
	EndIf;
	
	Filter = List.Filter.Items[FilterByStatusIndex];
	Filter.RightValue 	= StatusSelection;
	Filter.Use 			= StatusCheck;
	
	Filter = List.Filter.Items[FilterByChequeBondType];
	Filter.RightValue 	= ChequeBondType;
	
EndProcedure


#EndRegion

#Region ComandsEvents
&AtClient
Procedure CommandSaveAndClose(Command)
	Close(ThisObject.PickedCheckBonds);
EndProcedure

&AtClient
Procedure StatusSelectionStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.StatusStartChoice(Sourse, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure StatusSelectionEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.StatusEditTextChange(Sourse, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion




