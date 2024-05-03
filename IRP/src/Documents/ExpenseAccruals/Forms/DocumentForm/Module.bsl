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

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocExpenseRevenueAccrualsServer.OnReadAtServer(Object, ThisObject, CurrentObject);
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

&AtClient
Procedure BasisStartChoice(Item, ChoiceData, StandardProcessing)
	
	StandardProcessing = False;
	
	OpenPickupForm();
	
EndProcedure

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
Procedure CostListSelection(Item, RowSelected, Field, StandardProcessing)
	DocExpenseRevenueAccrualsClient.CostListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure CostListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocExpenseRevenueAccrualsClient.CostListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure CostListBeforeDeleteRow(Item, Cancel)
	DocExpenseRevenueAccrualsClient.CostListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure CostListAfterDeleteRow(Item)
	DocExpenseRevenueAccrualsClient.CostListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

//&AtClient
//Procedure CostListOnChange(Item)
//	CurrentData = Item.CurrentData;
//	If CurrentData = Undefined Then
//		Return;
//	EndIf;
//	If Not ValueIsFilled(CurrentData.Key) Then
//		CurrentData.Key = String(New UUID());
//	EndIf;
//	FillDocumentAmount();
//EndProcedure
//
//&AtClient
//Procedure CostListAfterDeleteRow(Item)
//	DeleteUnnecessaryRowsInCurrencies();
//EndProcedure
//
//&AtClient
//Procedure CostListOnEditEnd(Item, NewRow, CancelEdit)
//	If NewRow Then
//		CurrentData = Item.CurrentData;
//		If CurrentData = Undefined Then
//			Return;
//		EndIf;
//		AfterRowAdd(CurrentData);
//	EndIf;
//EndProcedure

&AtClient
Procedure EditCurrencies(Command)
	CurrentData = ThisObject.Items.CostList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;	
	FormParameters = CurrenciesClientServer.GetParameters_V5(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

#EndRegion

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion

#Region Public
// все методы, которые являются экспортными, и не относятся к оповещениям внутри формы
#EndRegion

#Region Private

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	//
EndProcedure

&AtClient
Procedure DeleteUnnecessaryRowsInCurrencies()
	ArrayRowsToDelete = New Array; // Array of FormDataCollectionItem
	For Each Row In Object.Currencies Do
		If Object.CostList.FindRows(New Structure("Key", Row.Key)).Count() = 0 Then
			ArrayRowsToDelete.Add(Row);
		EndIf;
	EndDo;
	For Each Row In ArrayRowsToDelete Do
		Object.Currencies.Delete(Row);
	EndDo;
EndProcedure

// After expense SelectСosts.
// 
// Parameters:
//  Result - Array of See DocExpenseRevenueAccrualsClient.RowPickupEmptyStructure
//  Structure, Undefined
//  AdditionalParemeters - Arbitrary


&AtServer
Function FillCostist(Result)
	Table = New ValueTable();
	Table.Columns.Add("Amount");
	Table.Columns.Add("AmountTax");
	
	For Each Structure In Result Do
		Row = Table.Add();
		FillPropertyValues(Row, Structure);
	EndDo;
	
	Address = PutToTempStorage(Table, ThisObject.UUID);
	Return New Structure("Address, GroupColumn, SumColumn", Address, "", "Amount, AmountTax");
EndFunction

&AtClient
Procedure AfterExpensePickup(Result, AdditionalParemeters) Export
	If Result = Undefined Then
		Return;
	EndIf;	
	
	Result = FillCostist(Result);
	Object.CostList.Clear();		
	ViewClient_V2.CostListLoad(Object, ThisObject, Result.Address, "CostList", Result.GroupColumn, Result.SumColumn);
	ThisObject.Modified = True;
		
		
	
	
	
//	ArrayOfStructure = Result;
//	
//	If ArrayOfStructure.Count() = 0 Then
//		Return;
//	EndIf;
//
//	Object.CostList.Clear();
//	Object.Basis = ArrayOfStructure[0].Document;
//	Object.Currencies.Clear();
//	
//	For Each Structure In ArrayOfStructure Do
//		
//		CostListRow = Object.CostList.Add();
//	
//		FillPropertyValues(CostListRow, Structure);
//		
//		AmountTax = Structure.TaxAmount; // Number
//		
//		CostListRow.AmountTax = AmountTax;
//		
//		AfterRowAdd(CostListRow);
//	EndDo;
//	
//	FillDocumentAmount();
//		
EndProcedure

&AtClient
Procedure AfterRowAdd(Row)
	
	CurrentBasis = Object.Basis;
	Row.Key = String(New UUID());
	If ValueIsFilled(CurrentBasis) Then
		If Object.CostList.Count() = 1 Then
			If TypeOf(CurrentBasis) = Type("DocumentRef.PurchaseInvoice") Then
				ObjectCurrencies = GetObjectCurrencies(CurrentBasis);
				For Each CurrencyRow In ObjectCurrencies Do
					NewRow = Object.Currencies.Add();
					FillPropertyValues(NewRow, CurrencyRow);
					NewRow.Key = Row.Key;
				EndDo;
			ElsIf TypeOf(CurrentBasis) = Type("DocumentRef.ExpenseAccruals") Then
				ObjectCurrencies = GetObjectCurrencies(CurrentBasis);
				If ObjectCurrencies.Count() > 0 Then
					FirstRowID = ObjectCurrencies[0].Key; // String
					
					For Each RowInArray In ObjectCurrencies Do
						If RowInArray.Key = FirstRowID Then
							NewCurrencyRow = Object.Currencies.Add();
							FillPropertyValues(NewCurrencyRow, RowInArray);
							NewCurrencyRow.Key = Row.Key;
						EndIf;
					EndDo;
					
				EndIf;
			EndIf;
		Else
			FirstRowID = Object.CostList[0].Key;
				
			RowArray = Object.Currencies.FindRows(New Structure("Key", FirstRowID));
			For Each RowInArray In RowArray Do
				NewCurrencyRow = Object.Currencies.Add();
				FillPropertyValues(NewCurrencyRow, RowInArray);
				NewCurrencyRow.Key = Row.Key;
			EndDo;
		EndIf;
	EndIf;
	
EndProcedure

&AtClient
Procedure FillDocumentAmount()
	TotalAmount = Object.CostList.Total("Amount"); // Number
	//@skip-check property-return-type
	Object.DocumentAmount = TotalAmount;
EndProcedure

// Get object currencies.
// 
// Parameters:
//  DocRef - DocumentRef.PurchaseInvoice, DocumentRef.ExpenseAccruals - Doc ref
// 
// Returns:
//  Array - Array of Structure:
// * Key - String
// * CurrencyFrom - CatalogRef.Currencies
// * Rate - String
// * ReverseRate - DefinedType.typeCurrencyRate
// * ShowReverseRate - Boolean
// * Multiplicity - Number
// * MovementType - ChartOfCharacteristicTypesRef.CurrencyMovementType
// * Amount - DefinedType.typeAmount
// * IsFixed - Boolean
&AtServer
Function GetObjectCurrencies(DocRef)
	Return CommonFunctionsServer.GetTableForClient(DocRef.Currencies.Unload());
EndFunction

&AtClient
Async Procedure OpenPickupForm()
	
	TableIsFilled = Object.CostList.Count() > 0;
	
	If TableIsFilled Then
		Answer = Await DoQueryBoxAsync(R().QuestionToUser_015, QuestionDialogMode.OKCancel);
	EndIf;
	
	If TableIsFilled And Answer = DialogReturnCode.Cancel Then
		Return;
	EndIf;
		
	If Not ValueIsFilled(Object.Currency) Then
		//@skip-check property-return-type
		TextMessage = R().Error_EmptyCurrency; // String
		CommonFunctionsClientServer.ShowUsersMessage(TextMessage, "Object.Currency");
		Return;
	EndIf;
	If Not ValueIsFilled(Object.TransactionType) Then
		//@skip-check property-return-type
		TextMessage = R().Error_EmptyTransactionType; // String
		CommonFunctionsClientServer.ShowUsersMessage(TextMessage, "Object.TransactionType");
		Return;
	EndIf;
	
	Object.CostList.Clear();
	
	Notify = New NotifyDescription("AfterExpensePickup", ThisObject);
	FormParameters = New Structure();
	FormParameters.Insert("Company", Object.Company);
	FormParameters.Insert("Ref", Object.Ref);
	FormParameters.Insert("Date", Object.Date);
	FormParameters.Insert("Currency", Object.Currency);
	FormParameters.Insert("TransactionType", Object.TransactionType);
	FormParameters.Insert("Branch", Object.Branch);
	
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