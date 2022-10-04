
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	MF_DocProductionServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetFormRules(Object, Object, ThisObject);
	EndIf;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	Return;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	Return;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	MF_FormsServer.DocumentAfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetFormRules(Object, Object, ThisObject);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	ThisObject.ProductionPlanningClosing = MF_FormsServer.GetProductionPlanningColosing(CurrentObject.ProductionPlanning);
	MF_FormsServer.DocumentOnReadAtServer(Object, ThisObject, CurrentObject);
	SetFormRules(Object, Object, ThisObject);
	ThisObject.ReadOnly = GetReadOnly();
EndProcedure

&AtServer
Function GetReadOnly()
	Return ValueIsFilled(ThisObject.ProductionPlanningClosing);
EndFunction

&AtClientAtServerNoContext
Procedure SetFormRules(Object, CurrentObject, Form)
	MF_FormsClientServer.DocumentSetFormRules(Object, CurrentObject, Form);
	Form.Items.GroupHead.Visible = ValueIsFilled(Form.ProductionPlanningClosing);
	For Each Row In Object.Materials Do
		If Row.MaterialType = PredefinedValue("Enum.MF_MaterialTypes.Semiproduct") Then
			Row.Picture = 2;
		ElsIf Row.MaterialType = PredefinedValue("Enum.MF_MaterialTypes.Material") Then
			Row.Picture = 3;
		ElsIf Row.MaterialType = PredefinedValue("Enum.MF_MaterialTypes.Service") Then
			Row.Picture = 1;
		Else
			Row.Picture = -1;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure MaterialsMaterialTypeOnChange(Item)
	SetFormRules(Object, Object, ThisObject);
EndProcedure

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocumentsClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region Production

&AtClient
Procedure ItemStartChoice(Item, ChoiceData, StandardProcessing)
	MF_FormsClient.ItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemEditTextChange(Item, Text, StandardProcessing)
	MF_FormsClient.ItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemOnChange(Item)
	MF_FormsClientServer.ItemOnChange_Object(Object);
	Object.BillOfMaterials = MF_FormsServer.GetBillOfMaterialsByItemKey(Object.ItemKey);
	BillOfMaterialsOnChangeAtServer();
EndProcedure

&AtClient
Procedure ItemKeyOnChange(Item)
	MF_FormsClientServer.ItemKeyOnChange_Object(Object);
	Object.BillOfMaterials = MF_FormsServer.GetBillOfMaterialsByItemKey(Object.ItemKey);
	BillOfMaterialsOnChangeAtServer();
EndProcedure

&AtClient
Procedure BillOfMaterialsStartChoice(Item, ChoiceData, StandardProcessing)
	Filters = New Array();
	Filters.Add(DocumentsClientServer.CreateFilterItem("Item"    , Object.Item, DataCompositionComparisonType.Equal));
	Filters.Add(DocumentsClientServer.CreateFilterItem("ItemKey" , Object.ItemKey, DataCompositionComparisonType.Equal));
	
	MF_FormsClient.BillOfMaterialsStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Filters);
EndProcedure

&AtClient
Procedure BillOfMaterialsEditTextChange(Item, Text, StandardProcessing)
	Filters = New Array();
	Filters.Add(DocumentsClientServer.CreateFilterItem("Item"    , Object.Item, DataCompositionComparisonType.Equal));
	Filters.Add(DocumentsClientServer.CreateFilterItem("ItemKey" , Object.ItemKey, DataCompositionComparisonType.Equal));
	
	MF_FormsClient.BillOfMaterialsEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, Filters);
EndProcedure

&AtClient
Procedure BillOfMaterialsOnChange(Item)
	BillOfMaterialsOnChangeAtServer();
EndProcedure

&AtClient
Procedure MaterialsBeforeDeleteRow(Item, Cancel)
	CurrentData = Items.Materials.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Cancel = Not CanDeleteMaterialRow(CurrentData.UniqueID);
EndProcedure

&AtServer
Function CanDeleteMaterialRow(RowUniqueIDForDelete)
	BillOfMaterials_UUID = String(Object.BillOfMaterials.UUID());
	For Each Row In Object.BillOfMaterials.Content Do
		RowUniqueID = String(Row.ItemKey.UUID()) + "-" + BillOfMaterials_UUID;
		If Upper(RowUniqueID) = Upper(RowUniqueIDForDelete) Then
			Return False;
		EndIf;
	EndDo;
	Return True;
EndFunction	

&AtClient
Procedure UnitOnChange(Item)
	QuantityOnChangeAtServer();
EndProcedure

&AtClient
Procedure QuantityOnChange(Item)
	QuantityOnChangeAtServer();
EndProcedure

#EndRegion

#Region Materials

&AtClient
Procedure MaterialsItemStartChoice(Item, ChoiceData, StandardProcessing)
	MF_FormsClient.ItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure MaterialsItemEditTextChange(Item, Text, StandardProcessing)
	MF_FormsClient.ItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure MaterialsItemOnChange(Item)
	MF_FormsClient.ItemOnChange(Object, ThisObject, Item, "Materials");
EndProcedure

&AtClient
Procedure MaterialsItemKeyOnChange(Item)
	MF_FormsClient.ItemKeyOnChange(Object, ThisObject, Item, "Materials");
EndProcedure

&AtClient
Procedure MaterialsUnitOnChange(Item)
	MF_DocProductionServer.CalculateMaterialsQuantity(Object);
EndProcedure

&AtClient
Procedure MaterialsQuantityOnChange(Item)
	CurrentData = Items.Materials.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.IsManualChanged = CurrentData.Quantity <> CurrentData.QuantityBOM;
EndProcedure


#EndRegion

&AtClient
Procedure StagesDoneOnChange(Item)
	CurrentData = Items.Stages.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If CurrentData.Done Then
		For Index = 0 To Object.Stages.Count() - 1 Do
			Row = Object.Stages[Index];
			If Row.LineNumber >= CurrentData.LineNumber Then
				Break;
			Else
				Row.Done = True;
			EndIf;
		EndDo;
	Else
		For Index = 0 To Object.Stages.Count() - 1 Do
			Row = Object.Stages[Object.Stages.Count() - 1 - Index];
			If Row.LineNumber <= CurrentData.LineNumber Then
				Break;
			Else
				Row.Done = False;
			EndIf;
		EndDo;
	EndIf;
EndProcedure

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
Procedure UpdateByBillOfMaterials(Command)
	BillOfMaterialsOnChangeAtServer();
EndProcedure

&AtServer
Procedure QuantityOnChangeAtServer()
	MF_DocProductionServer.CalculateMaterialsQuantity(Object);
EndProcedure


&AtServer
Procedure BillOfMaterialsOnChangeAtServer()
	MF_DocProductionServer.BillOfMaterialsOnChangeAtServer(Object);
EndProcedure

&AtClient
Procedure CompanyOnChange(Item)
	MF_FormsClient.SetDocumentProductionPlanning(Object);
EndProcedure

&AtClient
Procedure BusinessUnitOnChange(Item)
	MF_FormsClient.ChangePlanningPeriodWithQuestion(Object);
EndProcedure

&AtClient
Procedure StoreProductionOnChange(Item)
	MF_FormsClient.SetDocumentProductionPlanning(Object);
EndProcedure

&AtClient
Procedure StoreMaterialOnChange(Item)
	MF_FormsClient.SetDocumentProductionPlanning(Object);
EndProcedure

&AtClient
Procedure PlanningPeriodOnChange(Item)
	MF_FormsClient.SetDocumentProductionPlanning(Object);
EndProcedure

&AtClient
Procedure DateOnChange(Item)
	MF_FormsClient.ChangePlanningPeriodWithQuestion(Object);
EndProcedure

