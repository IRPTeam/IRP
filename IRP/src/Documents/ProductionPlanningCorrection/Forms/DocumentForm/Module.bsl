
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocProductionPlanningCorrectionServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	ThisObject.ProductionPlanningClosing = DocProductionPlanningClosingServer.GetProductionPlanningColosing(CurrentObject.ProductionPlanning);
	ThisObject.ProductionPlanningCorrectionExists = DocProductionPlanningCorrectionServer.GetProductionPlanningCorrectionExists(CurrentObject.Ref);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocProductionPlanningCorrectionServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
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
	DocProductionPlanningCorrectionServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocProductionPlanningCorrectionClient.OnOpen(Object, ThisObject, Cancel);
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
	DocProductionPlanningCorrectionClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsFilled_ProductionPlanningClosing = ValueIsFilled(Form.ProductionPlanningClosing);
	IsFilled_ProductionPlanningCorrectionExists = ValueIsFilled(Form.ProductionPlanningCorrectionExists);
	IsNewObject = Not ValueIsFilled(Object.Ref);
	
	Form.ReadOnly = IsFilled_ProductionPlanningClosing Or IsFilled_ProductionPlanningCorrectionExists;
	Form.Items.ProductionPlanningCorrectionExists.Visible = IsFilled_ProductionPlanningCorrectionExists;
	Form.Items.GroupHead.Visible = IsFilled_ProductionPlanningClosing;
	
	If ValueIsFilled(Object.ApprovedDate) Or IsNewObject Then
		UpdateCurrentQuantityVisible = False;
	Else
		Rows = New Array();
		For Each Row In Object.Productions Do
			NewRow = New Structure("ItemKey, BillOfMaterials, CurrentQuantity");
			FillPropertyValues(NewRow, Row);
			Rows.Add(NewRow);
		EndDo;
		UpdateCurrentQuantityVisible = Not IsCurrentQuantityActual(Object.Company, Object.ProductionPlanning, Object.PlanningPeriod, Rows);
	EndIf;	
	
	Form.Items.PictureCurrentQuantittyError.Visible = UpdateCurrentQuantityVisible;
	Form.Items.LabelCurrentQuantityError.Visible    = UpdateCurrentQuantityVisible;
	Form.Items.UpdateCurrentQuantity.Visible        = UpdateCurrentQuantityVisible;
EndProcedure

&AtClient
Procedure _IdeHandler()
	ViewClient_V2.ViewIdleHandler(ThisObject, Object);
EndProcedure

&AtClient
Procedure _AttachIdleHandler() Export
	AttachIdleHandler("_IdeHandler", 1);
EndProcedure

&AtClient 
Procedure _DetachIdleHandler() Export
	DetachIdleHandler("_IdeHandler");
EndProcedure

&AtServerNoContext
Function IsCurrentQuantityActual(Company, ProductionPlanning, PlanningPeriod, Rows)
	For Each Row In Rows Do
		CurrentQuantityInfo = GetCurrentQuantity(Company, ProductionPlanning, PlanningPeriod, Row.BillOfMaterials, Row.ItemKey);

		CurrentQunatity = ?(ValueIsFilled(Row.CurrentQuantity), Row.CurrentQuantity, 0);
		ActualQuantity  = ?(ValueIsFilled(CurrentQuantityInfo.BasisQuantity), CurrentQuantityInfo.BasisQuantity, 0);
				
		If CurrentQunatity <> ActualQuantity Then
			Return False;
		EndIf;	
	EndDo;
	Return True;
EndFunction

&AtServerNoContext
Function GetCurrentQuantity(Company, ProductionPlanning, PlanningPeriod, BillOfMaterials, ItemKey)
	Return Documents.ProductionPlanningCorrection.GetCurrentQuantity(Company, ProductionPlanning, PlanningPeriod, BillOfMaterials, ItemKey);
EndFunction

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocProductionPlanningCorrectionClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocProductionPlanningCorrectionClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocProductionPlanningCorrectionClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocProductionPlanningCorrectionClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region BUSINESS_UNIT

&AtClient
Procedure BusinessUnitOnChange(Item)
	DocProductionPlanningCorrectionClient.BusinessUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PLANNING_PERIOD

&AtClient
Procedure PlanningPeriodOnChange(Item)
	DocProductionPlanningCorrectionClient.PlanningPeriodOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRODUCTIONS

&AtClient
Procedure ProductionsSelection(Item, RowSelected, Field, StandardProcessing)
	DocProductionPlanningCorrectionClient.ProductionsSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ProductionsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocProductionPlanningCorrectionClient.ProductionsBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ProductionsBeforeDeleteRow(Item, Cancel)
	DocProductionPlanningCorrectionClient.ProductionsBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ProductionsAfterDeleteRow(Item)
	DocProductionPlanningCorrectionClient.ProductionsAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region PRODUCTIONS_COLUMNS

#Region _ITEM

&AtClient
Procedure ProductionsItemOnChange(Item)
	DocProductionPlanningCorrectionClient.ProductionsItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ProductionsItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocProductionPlanningCorrectionClient.ProductionsItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ProductionsItemEditTextChange(Item, Text, StandardProcessing)
	DocProductionPlanningCorrectionClient.ProductionsItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ProductionsItemKeyOnChange(Item)
	DocProductionPlanningCorrectionClient.ProductionsItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region BILL_OF_MATERIALS

&AtClient
Procedure ProductionsBillOfMaterialsOnChange(Item)
	DocProductionPlanningCorrectionClient.ProductionsBillOfMaterialsOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ProductionsUnitOnChange(Item)
	DocProductionPlanningCorrectionClient.ProductionsUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ProductionsQuantityOnChange(Item)
	DocProductionPlanningCorrectionClient.ProductionsQuantityOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocProductionPlanningCorrectionClient);
	Str.Insert("Server", DocProductionPlanningCorrectionServer);
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

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
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
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

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
	FormParameters.Insert("ReadOnlyStores", ValueIsFilled(CurrentData.CurrentQuantity) Or ThisObject.ReadOnly);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditStoresContinue", ManufacturingClient, NotifyParameters);
	OpenForm("CommonForm.EditStores", FormParameters, ThisObject, , , , Notify , FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure StatusHistoryClick(Item)
	ObjectStatusesClient.OpenHistoryByStatus(Object.Ref, ThisObject);
EndProcedure

&AtClient
Procedure UpdateCurrentQuantity(Command)
	DocProductionPlanningCorrectionClient.UpdateCurrentQuantity(Object, ThisObject);
EndProcedure

#EndRegion

#EndRegion

