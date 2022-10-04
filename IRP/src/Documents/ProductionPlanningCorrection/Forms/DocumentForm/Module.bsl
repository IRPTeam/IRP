
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	MF_FormsServer.DocumentOnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetFormRules(Object, Object, ThisObject);
		SetCurrentQuantityError(False);
		Items.ProductionPlanningCorrectionExists.Visible = False;		
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If Not ValueIsFilled(Object.Ref) 
		And Not ValueIsFilled(Object.PlanningPeriod) Then
		NewPlanningPeriod = MF_FormsServer.GetPlanningPeriod(Object.Date, Object.BusinessUnit);
		If NewPlanningPeriod <> Object.PlanningPeriod Then
			Object.PlanningPeriod = NewPlanningPeriod;
			MF_FormsClient.SetDocumentProductionPlanning(Object);
		EndIf;
	EndIf;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	MF_FormsServer.DocumentAfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetFormRules(Object, Object, ThisObject);
	SetCurrentQuantityError(Not IsCurrentQuantityActual());
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	ThisObject.ProductionPlanningClosing = MF_FormsServer.GetProductionPlanningColosing(CurrentObject.ProductionPlanning);
	MF_FormsServer.DocumentOnReadAtServer(Object, ThisObject, CurrentObject);
	SetFormRules(Object, Object, ThisObject);
	SetCurrentQuantityError(Not IsCurrentQuantityActual());
	ThisObject.ReadOnly = GetReadOnly();
EndProcedure

&AtServer
Function GetReadOnly()
	If Not Object.Status.Posting Then
		Return False;
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	MF_ProductionPlanningCorrection.Ref
	|FROM
	|	Document.MF_ProductionPlanningCorrection AS MF_ProductionPlanningCorrection
	|WHERE
	|	NOT MF_ProductionPlanningCorrection.DeletionMark
	|	AND MF_ProductionPlanningCorrection.Posted
	|	AND MF_ProductionPlanningCorrection.ProductionPlanning = &ProductionPlanning
	|	AND MF_ProductionPlanningCorrection.Ref <> &Ref
	|	AND MF_ProductionPlanningCorrection.ApprovedDate > &ApprovedDate
	|ORDER BY
	|	MF_ProductionPlanningCorrection.ApprovedDate";
	Query.SetParameter("Ref", Object.Ref);
	Query.SetParameter("ApprovedDate", Object.ApprovedDate);
	Query.SetParameter("ProductionPlanning", Object.ProductionPlanning);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	IsReadOnly = False;
	If QuerySelection.Next() Then
		ThisObject.ProductionPlanningCorrectionExists = QuerySelection.Ref;
		Items.ProductionPlanningCorrectionExists.Visible =  True;
		IsReadOnly = True;
	Else
		Items.ProductionPlanningCorrectionExists.Visible = False;
	EndIf;
	Return IsReadOnly Or ValueIsFilled(ThisObject.ProductionPlanningClosing);
EndFunction

&AtClientAtServerNoContext
Procedure SetFormRules(Object, CurrentObject, Form)
	MF_FormsClientServer.DocumentSetFormRules(Object, CurrentObject, Form);
	Form.Items.GroupHead.Visible = ValueIsFilled(Form.ProductionPlanningClosing);
EndProcedure

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

