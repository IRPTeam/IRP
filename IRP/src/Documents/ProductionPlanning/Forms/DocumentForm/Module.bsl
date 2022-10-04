
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	MF_FormsServer.DocumentOnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetFormRules(Object, Object, ThisObject);
		Items.DependentDocument.Visible = False;
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If Not ValueIsFilled(Object.Ref) 
		And Not ValueIsFilled(Object.PlanningPeriod) Then
		NewPlanningPeriod = MF_FormsServer.GetPlanningPeriod(Object.Date, Object.BusinessUnit);
		If NewPlanningPeriod <> Object.PlanningPeriod Then
			Object.PlanningPeriod = NewPlanningPeriod;
		EndIf;
	EndIf;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	MF_FormsServer.DocumentAfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetFormRules(Object, Object, ThisObject);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	ThisObject.ProductionPlanningClosing = MF_FormsServer.GetProductionPlanningColosing(CurrentObject.Ref);
	MF_FormsServer.DocumentOnReadAtServer(Object, ThisObject, CurrentObject);
	SetFormRules(Object, Object, ThisObject);
	ThisObject.ReadOnly = GetReadOnly();
EndProcedure

&AtServer
Function GetReadOnly()
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	InternalSupplyRequest.Ref,
	|	InternalSupplyRequest.Date
	|INTO tmpInternalSupplyRequest
	|FROM
	|	Document.InternalSupplyRequest AS InternalSupplyRequest
	|WHERE
	|	InternalSupplyRequest.MF_ProductionPlanning = &ProductionPlanning
	|	AND NOT InternalSupplyRequest.DeletionMark
	|	AND InternalSupplyRequest.Posted
	|ORDER BY
	|	InternalSupplyRequest.Date
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	MF_Production.Ref,
	|	MF_Production.Date
	|INTO tmpProduction
	|FROM
	|	Document.MF_Production AS MF_Production
	|WHERE
	|	NOT MF_Production.DeletionMark
	|	AND MF_Production.Posted
	|	AND MF_Production.ProductionPlanning = &ProductionPlanning
	|ORDER BY
	|	MF_Production.Date
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	MF_ProductionPlanningCorrection.Ref,
	|	MF_ProductionPlanningCorrection.Date
	|INTO tmpProductionPlanningCorrection
	|FROM
	|	Document.MF_ProductionPlanningCorrection AS MF_ProductionPlanningCorrection
	|WHERE
	|	NOT MF_ProductionPlanningCorrection.DeletionMark
	|	AND MF_ProductionPlanningCorrection.Posted
	|	AND MF_ProductionPlanningCorrection.ProductionPlanning = &ProductionPlanning
	|ORDER BY 
	|	MF_ProductionPlanningCorrection.Date
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpInternalSupplyRequest.Ref,
	|	tmpInternalSupplyRequest.Date
	|INTO tmpAllDocuments
	|FROM
	|	tmpInternalSupplyRequest AS tmpInternalSupplyRequest
	|
	|UNION ALL
	|
	|SELECT
	|	tmpProduction.Ref,
	|	tmpProduction.Date
	|FROM
	|	tmpProduction AS tmpProduction
	|
	|UNION ALL
	|
	|SELECT
	|	tmpProductionPlanningCorrection.Ref,
	|	tmpProductionPlanningCorrection.Date
	|FROM
	|	tmpProductionPlanningCorrection AS tmpProductionPlanningCorrection
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	tmpAllDocuments.Ref
	|FROM
	|	tmpAllDocuments AS tmpAllDocuments
	|ORDER BY
	|	tmpAllDocuments.Date";
	Query.SetParameter("ProductionPlanning", Object.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	IsReadOnly = False;
	If QuerySelection.Next() Then
		ThisObject.DependentDocument = QuerySelection.Ref;
		Items.DependentDocument.Visible =  True;
		IsReadOnly = True;
	Else
		Items.DependentDocument.Visible = False;
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

&AtClient
Procedure DateOnChange(Item)
	MF_FormsClient.ChangePlanningPeriodWithQuestion(Object);
EndProcedure

&AtClient
Procedure BusinessUnitOnChange(Item)
	MF_FormsClient.ChangePlanningPeriodWithQuestion(Object);
	MF_FormsClient.FillBillOfMaterialTable(Object, ThisObject);
EndProcedure

&AtClient
Procedure PlanningPeriodOnChange(Item)
	MF_FormsClient.FillBillOfMaterialTable(Object, ThisObject);
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
	MF_FormsClient.FillBillOfMaterialTable(Object, ThisObject);
EndProcedure

&AtClient
Procedure ProductionsItemKeyOnChange(Item)
	MF_FormsClient.ItemKeyOnChange(Object, ThisObject, Item, "Productions");
	MF_FormsClient.FillBillOfMaterialTable(Object, ThisObject);
EndProcedure

&AtClient
Procedure ProductionsUnitOnChange(Item)
	MF_FormsClient.FillBillOfMaterialTable(Object, ThisObject);
EndProcedure

&AtClient
Procedure ProductionsQuantityOnChange(Item)
	MF_FormsClient.FillBillOfMaterialTable(Object, ThisObject);
EndProcedure

&AtClient
Procedure ProductionsBillOfMaterialsOnChange(Item)
	MF_FormsClient.FillBillOfMaterialTable(Object, ThisObject);
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

#EndRegion

&AtClient
Procedure EditStores(Command)
	CurrentData = Items.Productions.CurrentData;
	If CurrentData = Undefined Then 
		Return;
	EndIf;
	FormParameters = MF_FormsClient.GetEditStoresParameters(CurrentData, Object);
	FormParameters.Insert("ReadOnlyStores", ThisObject.ReadOnly);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditStoresContinue", MF_FormsClient, NotifyParameters);
	OpenForm("CommonForm.MF_EditStores", FormParameters, ThisObject, , , , Notify , FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	MF_FormsClient.ShowRowKey(ThisObject);
EndProcedure
