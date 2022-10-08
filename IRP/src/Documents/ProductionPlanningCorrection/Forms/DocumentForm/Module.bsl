#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocProductionPlanningCorrectionServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	ThisObject.ProductionPlanningClosing = DocProductionPlanningClosingServer.GetProductionPlanningColosing(CurrentObject.ProductionPlanning);
	ThisObject.ProductionPlanningCorrectionExists = DocProductionPlanningCorrectionServer.GetProductionPlanningCorrectionExists(CurrentObject.Ref);
	SetVisibilityAvailability(CurrentObject, ThisObject);
	SetCurrentQuantityError(Not IsCurrentQuantityActual());
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocProductionPlanningCorrectionServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
		SetCurrentQuantityError(False);		
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
	SetCurrentQuantityError(Not IsCurrentQuantityActual());
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocProductionPlanningCorrectionClient.OnOpen(Object, ThisObject, Cancel);
	
//	If Not ValueIsFilled(Object.Ref) 
//		And Not ValueIsFilled(Object.PlanningPeriod) Then
//		NewPlanningPeriod = MF_FormsServer.GetPlanningPeriod(Object.Date, Object.BusinessUnit);
//		If NewPlanningPeriod <> Object.PlanningPeriod Then
//			Object.PlanningPeriod = NewPlanningPeriod;
//			MF_FormsClient.SetDocumentProductionPlanning(Object);
//		EndIf;
//	EndIf;
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
	
	Form.ReadOnly = IsFilled_ProductionPlanningClosing Or IsFilled_ProductionPlanningCorrectionExists;
	Form.Items.ProductionPlanningCorrectionExists.Visible = IsFilled_ProductionPlanningCorrectionExists;
	Form.Items.GroupHead.Visible = IsFilled_ProductionPlanningClosing;
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocProductionPlanningCorrectionClient.DateOnChange(Object, ThisObject, Item);
	//UpdateCurrentQuantityByTable();
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocProductionPlanningCorrectionClient.CompanyOnChange(Object, ThisObject, Item);
	//UpdateCurrentQuantityByTable();
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
	//UpdateCurrentQuantityByTable();
EndProcedure

#EndRegion

#Region PLANNING_PERIOD

&AtClient
Procedure PlanningPeriodOnChange(Item)
	DocProductionPlanningCorrectionClient.PlanningPeriodOnChange(Object, ThisObject, Item);
	//UpdateCurrentQuantityByTable();
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
//	UpdateCurrentQuantityByRow();
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
//	UpdateCurrentQuantityByRow();
EndProcedure

#EndRegion

#Region BILL_OF_MATERIALS

&AtClient
Procedure ProductionsBillOfMaterialsOnChange(Item)
	DocProductionPlanningCorrectionClient.ProductionsBillOfMaterialsOnChange(Object, ThisObject, Item);
//	UpdateCurrentQuantityByRow();
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ProductionsUnitOnChange(Item)
	DocProductionPlanningCorrectionClient.ProductionsUnitOnChange(Object, ThisObject, Item);
//	UpdateCurrentQuantityByRow();
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ProductionsQuantityOnChange(Item)
	DocProductionPlanningCorrectionClient.ProductionsQuantityOnChange(Object, ThisObject, Item);
//	UpdateCurrentQuantityByRow();
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
	UpdateCurrentQuantityByTable();
EndProcedure

#EndRegion

#EndRegion

&AtServer
Procedure SetCurrentQuantityError(IsError)
	If ValueIsFilled(Object.ApprovedDate) Then
		Items.PictureCurrentQuantittyError.Visible = False;
		Items.LabelCurrentQuantityError.Visible = False;
		Items.UpdateCurrentQuantity.Visible = False;
	Else		
		Items.PictureCurrentQuantittyError.Visible = IsError;
		Items.LabelCurrentQuantityError.Visible = IsError;
		Items.UpdateCurrentQuantity.Visible = IsError;
	EndIf;
EndProcedure

&AtClient
Procedure UpdateCurrentQuantityByRow()
	CurrentData = Items.Productions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	CurrentQuantityInfo = GetCurrentQuantity(Object.Company,
											 Object.ProductionPlanning, 
											 Object.PlanningPeriod, 
											 CurrentData.BillOfMaterials,
											 CurrentData.ItemKey);
	If ValueIsFilled(CurrentQuantityInfo.BasisQuantity) Then
		CurrentData.Unit = CurrentQuantityInfo.BasisUnit;
	EndIf;
	CurrentData.CurrentQuantity = CurrentQuantityInfo.BasisQuantity;
//	MF_FormsClient.FillBillOfMaterialTableCorrection(Object, ThisObject, CurrentData);
EndProcedure

&AtServer
Procedure UpdateCurrentQuantityByTable()
	For Each Row In Object.Productions Do
		CurrentQuantityInfo = GetCurrentQuantity(Object.Company,
												 Object.ProductionPlanning, 
												 Object.PlanningPeriod,
												 Row.BillOfMaterials,
												 Row.ItemKey);
		If ValueIsFilled(CurrentQuantityInfo.BasisQuantity) Then
			Row.Unit = CurrentQuantityInfo.BasisUnit;
		EndIf;
		Row.CurrentQuantity = CurrentQuantityInfo.BasisQuantity;
//		MF_FormsClientServer.FillBillOfMaterialTableCorrection(Object, Row);
	EndDo;
	SetCurrentQuantityError(False);
EndProcedure

&AtServer
Function IsCurrentQuantityActual()
	For Each Row In Object.Productions Do
		CurrentQuantityInfo = GetCurrentQuantity(Object.Company,
												 Object.ProductionPlanning,
												 Object.PlanningPeriod, 
												 Row.BillOfMaterials,
												 Row.ItemKey);

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
	Return Documents.ProductionPlanningCorrection.GetCurrentQuantity(Company,
																	 ProductionPlanning,
																	 PlanningPeriod,  
	                                                                 BillOfMaterials,
	                                                                 ItemKey);
EndFunction









