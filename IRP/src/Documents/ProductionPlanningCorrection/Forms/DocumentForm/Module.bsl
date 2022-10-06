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


&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocumentsClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region Productions

&AtClient
Procedure ProductionsOnChange(Item)
	MF_FormsClient.FillRowIDInTable(Object, ThisObject, "Productions");
EndProcedure

&AtClient
Procedure ProductionsAfterDeleteRow(Item)
	MF_FormsClient.ClearDependedTables(Object, ThisObject, "Productions", "BillOfMaterials");
EndProcedure

&AtClient
Procedure ProductionsItemStartChoice(Item, ChoiceData, StandardProcessing)
	MF_FormsClient.ItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ProductionsItemEditTextChange(Item, Text, StandardProcessing)
	MF_FormsClient.ItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ProductionsItemOnChange(Item)
	MF_FormsClient.ItemOnChange(Object, ThisObject, Item, "Productions");
	UpdateCurrentQuantityByRow();
EndProcedure

&AtClient
Procedure ProductionsUnitOnChange(Item)
	UpdateCurrentQuantityByRow();
EndProcedure

&AtClient
Procedure ProductionsQuantityOnChange(Item)
	UpdateCurrentQuantityByRow();
EndProcedure

&AtClient
Procedure ProductionsItemKeyOnChange(Item)
	MF_FormsClient.ItemKeyOnChange(Object, ThisObject, Item, "Productions");
	UpdateCurrentQuantityByRow();
EndProcedure

&AtClient
Procedure ProductionsBillOfMaterialsOnChange(Item)
	UpdateCurrentQuantityByRow();
EndProcedure

&AtClient
Procedure ProductionsBillOfMaterialsStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	CurrentData = Items.Productions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Filters = New Array();
	Filters.Add(DocumentsClientServer.CreateFilterItem("Item"    , CurrentData.Item, DataCompositionComparisonType.Equal));
	Filters.Add(DocumentsClientServer.CreateFilterItem("ItemKey" , CurrentData.ItemKey, DataCompositionComparisonType.Equal));
	
	MF_FormsClient.BillOfMaterialsStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Filters);
EndProcedure

&AtClient
Procedure ProductionsBillOfMaterialsEditTextChange(Item, Text, StandardProcessing)
	StandardProcessing = False;
	CurrentData = Items.Productions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Filters = New Array();
	Filters.Add(DocumentsClientServer.CreateFilterItem("Item"    , CurrentData.Item, DataCompositionComparisonType.Equal));
	Filters.Add(DocumentsClientServer.CreateFilterItem("ItemKey" , CurrentData.ItemKey, DataCompositionComparisonType.Equal));
	
	MF_FormsClient.BillOfMaterialsEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, Filters);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure GroupTitleCollapsedClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure GroupTitleUncollapsedClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

&AtClient
Procedure CompanyOnChange(Item)
	MF_FormsClient.SetDocumentProductionPlanning(Object);
	UpdateCurrentQuantityByTable();
EndProcedure

&AtClient
Procedure BusinessUnitOnChange(Item)
	MF_FormsClient.ChangePlanningPeriodWithQuestion(Object);
	UpdateCurrentQuantityByTable();
EndProcedure

&AtClient
Procedure PlanningPeriodOnChange(Item)
	MF_FormsClient.SetDocumentProductionPlanning(Object);
	UpdateCurrentQuantityByTable();
EndProcedure

&AtClient
Procedure DateOnChange(Item)
	MF_FormsClient.ChangePlanningPeriodWithQuestion(Object);
	UpdateCurrentQuantityByTable();
EndProcedure

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
	MF_FormsClient.FillBillOfMaterialTableCorrection(Object, ThisObject, CurrentData);
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
		MF_FormsClientServer.FillBillOfMaterialTableCorrection(Object, Row);
	EndDo;
	SetCurrentQuantityError(False);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	MF_FormsClient.ShowRowKey(ThisObject);
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
	Return Documents.MF_ProductionPlanningCorrection.GetCurrentQuantity(Company,
																		ProductionPlanning,
																		PlanningPeriod,  
	                                                                    BillOfMaterials,
	                                                                    ItemKey);
EndFunction

&AtClient
Procedure StatusHistoryClick(Item)
	MF_ObjectStatusesClient.OpenHistoryByStatus(Object.Ref, ThisObject);
EndProcedure

&AtClient
Procedure UpdateCurrentQuantity(Command)
	UpdateCurrentQuantityByTable();
EndProcedure

&AtClient
Procedure ProductionsSelection(Item, RowSelected, Field, StandardProcessing)
	If Not ThisObject.ReadOnly Then
		Return;
	EndIf;
	CurrentData = Items.Productions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	MF_FormsClient.OpenObjectForm(Field, "ProductionsItem", CurrentData.Item, StandardProcessing);
	MF_FormsClient.OpenObjectForm(Field, "ProductionsItemKey", CurrentData.ItemKey, StandardProcessing);
	MF_FormsClient.OpenObjectForm(Field, "ProductionsUnit", CurrentData.Unit, StandardProcessing);
	MF_FormsClient.OpenObjectForm(Field, "ProductionsBillOfMaterials", CurrentData.BillOfMaterials, StandardProcessing);
EndProcedure

&AtClient
Procedure EditStores(Command)
		CurrentData = Items.Productions.CurrentData;
	If CurrentData = Undefined Then 
		Return;
	EndIf;
	FormParameters = MF_FormsClient.GetEditStoresParameters(CurrentData, Object);
	FormParameters.Insert("ReadOnlyStores", ValueIsFilled(CurrentData.CurrentQuantity) Or ThisObject.ReadOnly);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditStoresContinue", MF_FormsClient, NotifyParameters);
	OpenForm("CommonForm.MF_EditStores", FormParameters, ThisObject, , , , Notify , FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

