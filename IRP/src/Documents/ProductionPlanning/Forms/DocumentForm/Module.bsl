#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocProductionPlanningServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	ThisObject.ProductionPlanningClosing = DocProductionPlanningClosingServer.GetProductionPlanningColosing(CurrentObject.Ref);
	ThisObject.DependentDocument = DocProductionPlanningServer.GetDependentDocument(CurrentObject.Ref);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocProductionPlanningServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocProductionPlanningServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocProductionPlanningClient.OnOpen(Object, ThisObject, Cancel);	
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
	
	If Not Source = ThisObject Then
		Return;
	EndIf;
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);	
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	DocProductionPlanningClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsFilled_ProductionPlanningClosing = ValueIsFilled(Form.ProductionPlanningClosing);
	IsFilled_DependentDocument = ValueIsFilled(Form.DependentDocument);
	
	Form.ReadOnly = IsFilled_ProductionPlanningClosing Or IsFilled_DependentDocument;
	Form.Items.DependentDocument.Visible = IsFilled_DependentDocument;
	Form.Items.GroupHead.Visible = IsFilled_ProductionPlanningClosing;
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocProductionPlanningClient.DateOnChange(Object, ThisObject, Item);
	//MF_FormsClient.ChangePlanningPeriodWithQuestion(Object);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocProductionPlanningClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocProductionPlanningClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocProductionPlanningClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region BUSINESS_UNIT

&AtClient
Procedure BusinessUnitOnChange(Item)
	DocProductionPlanningClient.BusinessUnitOnChange(Object, ThisObject, Item);
	
//	MF_FormsClient.ChangePlanningPeriodWithQuestion(Object);
//	MF_FormsClient.FillBillOfMaterialTable(Object, ThisObject);
EndProcedure

#EndRegion

#Region PLANNING_PERIOD

&AtClient
Procedure PlanningPeriodOnChange(Item)
	DocProductionPlanningClient.PlanningPeriodOnChange(Object, ThisObject, Item);
	
	//MF_FormsClient.FillBillOfMaterialTable(Object, ThisObject);
EndProcedure

#EndRegion

#Region PRODUCTIONS

&AtClient
Procedure ProductionsSelection(Item, RowSelected, Field, StandardProcessing)
//	ProductionPlanningClient.ProductionsSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
	
//	If Not ThisObject.ReadOnly Then
//		Return;
//	EndIf;
//	CurrentData = Items.Productions.CurrentData;
//	If CurrentData = Undefined Then
//		Return;
//	EndIf;
//	MF_FormsClient.OpenObjectForm(Field, "ProductionsItem", CurrentData.Item, StandardProcessing);
//	MF_FormsClient.OpenObjectForm(Field, "ProductionsItemKey", CurrentData.ItemKey, StandardProcessing);
//	MF_FormsClient.OpenObjectForm(Field, "ProductionsUnit", CurrentData.Unit, StandardProcessing);
//	MF_FormsClient.OpenObjectForm(Field, "ProductionsBillOfMaterials", CurrentData.BillOfMaterials, StandardProcessing);	
EndProcedure


&AtClient
Procedure ProductionsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
//	ProductionPlanningClient.ProductionsBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure


&AtClient
Procedure ProductionsBeforeDeleteRow(Item, Cancel)
//	ProductionPlanningClient.ProductionsBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ProductionsAfterDeleteRow(Item)
//	ProductionPlanningClient.ProductionsAfterDeleteRow(Object, ThisObject, Item);

//	MF_FormsClient.ClearDependedTables(Object, ThisObject, "Productions", "BillOfMaterials");
EndProcedure

#Region PRODUCTIONS_COLUMNS

#Region _ITEM

&AtClient
Procedure ProductionsItemOnChange(Item)
//	ProductionPlanningClient.ProductionsItemOnChange(Object, ThisObject, Item);

//	MF_FormsClient.ItemOnChange(Object, ThisObject, Item, "Productions");
//	MF_FormsClient.FillBillOfMaterialTable(Object, ThisObject);
EndProcedure

&AtClient
Procedure ProductionsItemStartChoice(Item, ChoiceData, StandardProcessing)
//	ProductionPlanningClient.ProductionsItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);

//	MF_FormsClient.ItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ProductionsItemEditTextChange(Item, Text, StandardProcessing)
//	ProductionPlanningClient.ProductionsItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);

//	MF_FormsClient.ItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ProductionsItemKeyOnChange(Item)
//	ProductionPlanningClient.ProductionsItemKeyOnChange(Object, ThisObject, Item);

//	MF_FormsClient.ItemKeyOnChange(Object, ThisObject, Item, "Productions");
//	MF_FormsClient.FillBillOfMaterialTable(Object, ThisObject);
EndProcedure

#EndRegion

#Region BILL_OF_MATERIALS

&AtClient
Procedure ProductionsBillOfMaterialsOnChange(Item)
//	ProductionPlanningClient.ProductionsBillOfMaterialsOnChange(Object, ThisObject, Item);

//	MF_FormsClient.FillBillOfMaterialTable(Object, ThisObject);
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ProductionsUnitOnChange(Item)
//	ProductionPlanningClient.ProductionsUnitOnChange(Object, ThisObject, Item);

//	MF_FormsClient.FillBillOfMaterialTable(Object, ThisObject);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ProductionsQuantityOnChange(Item)
//	ProductionPlanningClient.ProductionsQuantityOnChange(Object, ThisObject, Item);

//	MF_FormsClient.FillBillOfMaterialTable(Object, ThisObject);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocWorkOrderClient);
	Str.Insert("Server", DocWorkOrderServer);
	Return Str;
EndFunction

#Region DESCRIPTION

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

&AtClient
Procedure GroupTitleCollapsedClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure GroupTitleUncollapsedClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

#Region ADD_ATTRIBUTES

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion

#Region EXTERNAL_COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure EditStores(Command)
	CurrentData = Items.Productions.CurrentData;
	If CurrentData = Undefined Then 
		Return;
	EndIf;
	FormParameters = ManufacturingClient.GetEditStoresParameters(CurrentData, Object);
	FormParameters.Insert("ReadOnlyStores", ThisObject.ReadOnly);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditStoresContinue", ManufacturingClient, NotifyParameters);
	OpenForm("CommonForm.EditStores", FormParameters, ThisObject, , , , Notify , FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

#EndRegion

#EndRegion






