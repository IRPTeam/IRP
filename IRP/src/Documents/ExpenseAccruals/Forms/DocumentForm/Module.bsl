// @strict-types

#Region Variables

#EndRegion

#Region FormEventHandlers

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocExpenseRevenueAccrualsServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocExpenseRevenueAccrualsClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocExpenseRevenueAccrualsClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocExpenseRevenueAccrualsClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocExpenseRevenueAccrualsClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocExpenseRevenueAccrualsClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

#EndRegion

#Region FormTableItemsEventHandlers
#Region CostList

&AtClient
Procedure Pickup(Command)

	Notify = New NotifyDescription("AfterExpensePickup", ThisObject);
	FormParameters = New Structure();
	FormParameters.Insert("Company", Object.Company);
	FormParameters.Insert("Ref", Object.Ref);
	FormParameters.Insert("Date", Object.Date);
	FormParameters.Insert("Currency", Object.Currency);
	
	ArrayOfSelectedRows = New Array(); // Array of structure
	For Each Row In Object.CostList Do
		SelectedRow = New Structure();
		SelectedRow.Insert("Basis", Row.Basis);
		SelectedRow.Insert("Amount", Row.Amount);
		ArrayOfSelectedRows.Add(SelectedRow);
	EndDo;
	FormParameters.Insert("SelectedRows", ArrayOfSelectedRows);
	
	OpenForm("Document.ExpenseAccruals.Form.PickupExpenseForm",
		FormParameters,
		ThisObject,
		ThisObject.UUID,
		,
		ThisObject.URL,
		Notify,
		FormWindowOpeningMode.LockOwnerWindow);	
	
EndProcedure

#EndRegion
#EndRegion

#Region FormCommandsEventHandlers
// события по нажатию кнопок формы (не табличных частей
#EndRegion

#Region Public
// все методы, которые являются экспортными, и не относятся к оповещениям внутри формы
#EndRegion

#Region Private

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	//
EndProcedure

// After expense pickup.
// 
// Parameters:
//  Result - Array of See Document.ExpenseAccruals.Form.PickupExpenseForm.RowEmptyStructure
//  Structure, Undefined
//  AdditionalParemeters - Arbitrary
&AtClient
Procedure AfterExpensePickup(Result, AdditionalParemeters) Export
	If Result = Undefined Then
		Return;
	EndIf;	
	ArrayOfStructure = Result;
	
	For Each Structure In ArrayOfStructure Do
		
		SearchArray = Object.CostList.FindRows(New Structure("Basis", Structure.Document));
		If SearchArray.Count() = 0 Then
		
			CostListRow = Object.CostList.Add();
		Else
			CostListRow = SearchArray[0];
		EndIf;		
		FillPropertyValues(CostListRow, Structure);
		
		AmountTax = Structure.TaxAmount; // Number
		
		CostListRow.Basis = DocumentRef;
		CostListRow.AmountTax = AmountTax;
			
	EndDo;	
		
EndProcedure	

#EndRegion

#Region DescriptionEvents

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region AddAttributes

// Add attribute start choice.
// 
// Parameters:
//  Item - FormAllItems
//  ChoiceData - Arbitrary
//  StandardProcessing - Boolean
&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

// Add attribute button click.
// 
// Parameters:
//  Item - FormItems
&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region ExternalCommands

// Generated form command action by name.
// 
// Parameters:
//  Command - FormCommand
&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

// Generated form command action by name.
// 
// Parameters:
//  CommandName - String
&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion