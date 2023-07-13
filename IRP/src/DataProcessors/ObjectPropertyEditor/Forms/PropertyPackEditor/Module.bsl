
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	RowData = Parameters.RowData; // See PropertyValuesDescription
	If Not RowData = Undefined Then
		For Each PropertyRow In RowData Do
			NewRecord = ThisObject.PropertiesTable.Add();
			FillPropertyValues(NewRecord, PropertyRow);
			If NewRecord.isCollection Then
				NewRecord.isMarked = TypeOf(NewRecord.Value) = Type("ValueList") And NewRecord.Value.Count() > 0;
			ElsIf PropertyRow.FieldName = "Field_Key" Then
				NewRecord.isMarked = False;
			Else
				NewRecord.isMarked = ValueIsFilled(NewRecord.Value);
			EndIf;
		EndDo;
		ThisObject.PropertiesTable.Sort("isMarked Desc, Property Asc");
	EndIf; 

EndProcedure

&AtClient
Procedure SetValues(Command)
	
	Result = PropertyValuesDescription();
	
	For Each TableRow In ThisObject.PropertiesTable Do
		If TableRow.isMarked Then
			RowDescription = PropertyValueDescription();
			FillPropertyValues(RowDescription, TableRow);
			Result.Add(RowDescription);
		EndIf;
	EndDo;
	
	Close(Result);

EndProcedure

&AtClient
Procedure Uncheck(Command)
	
	For Each Row In ThisObject.PropertiesTable Do
		Row.isMarked = False;
	EndDo;

EndProcedure

&AtClient
Procedure PropertiesTableValueStartChoice(Item, ChoiceData, StandardProcessing)
	
	CurrentData = Items.PropertiesTable.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ParametersArray = New Array; // Array of ChoiceParameter
	ParametersArray.Add(New ChoiceParameter("Filter.Owner", CurrentData.Property));
	Item.ChoiceParameters = New FixedArray(ParametersArray);
	
	FieldDescription = Undefined; // See GetFieldDescription
	CurrentFieldValue = CurrentData.Value; // Arbitrary, String, ValueList
	If GetColumnsData().Property(CurrentData.FieldName, FieldDescription) Then
		If TypeOf(CurrentFieldValue) = Type("ValueList") Then
			CurrentFieldValue.ValueType = FieldDescription.ValueType;
		ElsIf CurrentFieldValue = Undefined Then
			Item.TypeRestriction = FieldDescription.ValueType;
		EndIf;
	EndIf;
	
	If TypeOf(CurrentFieldValue) = Type("String") Then
		StandardProcessing = False;
		SelectedRows = New Array; // Array of Number
		SelectedRows.Add(Items.PropertiesTable.CurrentData.GetID());
		OpenForm("DataProcessor.ObjectPropertyEditor.Form.EditMultilineText", 
				New Structure("ExternalText", CurrentFieldValue), 
				ThisObject, , , ,
				New NotifyDescription("OnEditedMultilineTextEnd", 
					ThisObject, 
					New Structure("SelectedRows", SelectedRows)),
				FormWindowOpeningMode.LockOwnerWindow);
	EndIf;

EndProcedure

&AtClient
Procedure PropertiesTableOnActivateRow(Item)
	
	CurrentData = Items.PropertiesTable.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If TypeOf(CurrentData.Value) = Type("String") Then
		Items.PropertiesTableValue.ChoiceButton = True;
	EndIf;

EndProcedure

&AtClient
Function GetColumnsData()
	Return ThisObject.FormOwner.FormDataCash.ColumnsData;
EndFunction

&AtClient
Procedure OnEditedMultilineTextEnd(ChangedText, AddInfo) Export
	If ValueIsFilled(ChangedText) Then
		For Each RowKey In AddInfo.SelectedRows Do
			CurrentRow = ThisObject.PropertiesTable.FindByID(RowKey);
			CurrentRow.Value = ChangedText;
		EndDo;
	EndIf;
EndProcedure

// Property values description.
// 
// Returns:
//  Array of See PropertyValueDescription
&AtClientAtServerNoContext
Function PropertyValuesDescription()
	
	Result = New Array; // Array of See PropertyValueDescription
	
	Return Result;
	
EndFunction

// Property value description.
// 
// Returns:
//  Structure - Property value description:
// * Property - Undefined -
// * Value - Undefined -
// * isCollection - Boolean -
// * FieldName - String -
&AtClientAtServerNoContext
Function PropertyValueDescription()
	
	Result = New Structure;
	
	Result.Insert("Property", Undefined);
	Result.Insert("Value", Undefined);
	Result.Insert("isCollection", False);
	Result.Insert("FieldName", "");
	
	Return Result;
	
EndFunction
