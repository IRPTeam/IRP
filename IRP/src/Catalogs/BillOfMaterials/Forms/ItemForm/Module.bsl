
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	T7010S_BillOfMaterials.Recorder AS Ref
	|FROM
	|	InformationRegister.T7010S_BillOfMaterials AS T7010S_BillOfMaterials
	|WHERE
	|	T7010S_BillOfMaterials.BillOfMaterials = &BillOfMaterials
	|
	|ORDER BY
	|	T7010S_BillOfMaterials.Period";
	Query.SetParameter("BillOfMaterials" , Object.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		ThisObject.ProductionPlanningExists = QuerySelection.Ref;
	EndIf;
	
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("ExpandAllTrees", 1, True);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsProduct = Object.Type = PredefinedValue("Enum.BillOfMaterialsTypes.Product");
	IsWork    = Object.Type = PredefinedValue("Enum.BillOfMaterialsTypes.Work");
	Form.Items.BusinessUnitReleaseStore.Visible = IsProduct;
	Form.Items.BusinessUnitSemiproductStore.Visible = IsProduct;
	Form.Items.ContentBillOfMaterials.Visible = IsProduct;
	Form.Items.ContentExpenseType.Visible = IsWork;
	
	IsFilled_ProductionPlanningExists = ValueIsFilled(Form.ProductionPlanningExists);	
	Form.ReadOnly = IsFilled_ProductionPlanningExists;	
	Form.Items.ProductionPlanningExists.Visible =  IsFilled_ProductionPlanningExists;
	
	If Object.Active Then
		Form.Items.ChangeActive.Picture = PictureLib.CheckAll;
	Else
		Form.Items.ChangeActive.Picture = PictureLib.UncheckAll;
	EndIf;
	
	// Button set as default
	If IsDefaultBillOfMaterials(Object.Ref, Object.ItemKey) Then
		Form.Items.FormSetAsDefault.Title = R().Form_037;
	Else
		Form.Items.FormSetAsDefault.Title = R().Form_036;
	EndIf;
	
	// Productions tree
	Form.ProductionTree.GetItems().Clear();
	ArrayOfProductTreeRows = New Array();
	CreateProductionTreeAtServer(ArrayOfProductTreeRows, Object.Ref, True);
	CreateProductionTree(Object, Form, Form.ProductionTree, ArrayOfProductTreeRows);
EndProcedure

&AtClient
Procedure ChangeActive(Command)
	Object.Active = Not Object.Active;
	If ValueIsFilled(ThisObject.ProductionPlanningExists) Then
		Write();
	Else
		SetVisibilityAvailability(Object, ThisObject);
		ThisObject.Modified = True;
	EndIf;
EndProcedure

&AtClient
Procedure ExpandAllTrees() Export
	RowIDInfoClient.ExpandTree(Items.ProductionTree, ThisObject.ProductionTree.GetItems());
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure TypeOnChange(Item)
	If Object.Type = PredefinedValue("Enum.BillOfMaterialsTypes.Work") Then
		For Each Row In Object.Content Do
			Row.BillOfMaterials = Undefined;
		EndDo;
	EndIf;
	
	SetVisibilityAvailability(Object, ThisObject);	
EndProcedure

&AtClient
Procedure ItemOnChange(Item)
	ItemOnChangeAtClient(Object);
EndProcedure

&AtClient
Procedure ItemStartChoice(Item, ChoiceData, StandardProcessing)
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	DocumentsClient.ItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

&AtClient
Procedure ItemEditTextChange(Item, Text, StandardProcessing)
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));	
	DocumentsClient.ItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

&AtClient
Procedure ItemKeyOnChange(Item)
	ItemKeyOnChangeAtClient(Object);
EndProcedure

&AtClient
Procedure ContentItemOnChange(Item)
	ItemOnChangeAtClient(Items.Content.CurrentData);	
EndProcedure

&AtClient
Procedure ContentItemStartChoice(Item, ChoiceData, StandardProcessing)
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	If Object.Type = PredefinedValue("Enum.BillOfMaterialsTypes.Work") Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", 
			PredefinedValue("Enum.ItemTypes.Product"), DataCompositionComparisonType.Equal));
	EndIf;		
	DocumentsClient.ItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

&AtClient
Procedure ContentItemEditTextChange(Item, Text, StandardProcessing)
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	If Object.Type = PredefinedValue("Enum.BillOfMaterialsTypes.Work") Then
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", 
			PredefinedValue("Enum.ItemTypes.Product"), ComparisonType.Equal));
	EndIf;		
	DocumentsClient.ItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

&AtClient
Procedure ContentItemKeyOnChange(Item)
	ItemKeyOnChangeAtClient(Items.Content.CurrentData);
EndProcedure

&AtClient
Procedure ItemOnChangeAtClient(ObjectOrRow)
	If ObjectOrRow = Undefined Then
		Return;
	EndIf;
	
	NewItemKey = CatItemsServer.GetItemKeyByItem(ObjectOrRow.Item);
	If NewItemKey <> ObjectOrRow.ItemKey Then
		ObjectOrRow.ItemKey = NewItemKey;
		ItemKeyOnChangeAtClient(ObjectOrRow);
	EndIf;
EndProcedure	

&AtClient
Procedure ItemKeyOnChangeAtClient(ObjectOrRow)
	If ObjectOrRow = Undefined Then
		Return;
	EndIf;
	
	If CommonFunctionsClientServer.ObjectHasProperty(ObjectOrRow, "Unit") Then
		ObjectOrRow.Unit = GetItemInfo.ItemUnitInfo(ObjectOrRow.ItemKey).Unit;
	EndIf;
	
	If CommonFunctionsClientServer.ObjectHasProperty(ObjectOrRow, "BillOfMaterials")
		And Object.Type = PredefinedValue("Enum.BillOfMaterialsTypes.Product") Then
		ObjectOrRow.BillOfMaterials = GetBillOfMaterialsByItemKey(ObjectOrRow.ItemKey);
	EndIf;
	
	If CommonFunctionsClientServer.ObjectHasProperty(ObjectOrRow, "Quantity") Then
		If Not ValueIsFilled(ObjectOrRow.Quantity) Then
			ObjectOrRow.Quantity = 1;
		EndIf;
	EndIf;
EndProcedure

&AtServerNoContext
Function GetBillOfMaterialsByItemKey(ItemKey)
	Return Catalogs.BillOfMaterials.GetBillOfMaterialsByItemKey(ItemKey);
EndFunction

#Region SetAsDefault

&AtClient
Procedure SetAsDefault(Command)
	If Not ValueIsFilled(Object.Ref) Or ThisObject.Modified Then
		Notify = New NotifyDescription("SetAsDefaultContinue", ThisObject);
		ShowQueryBox(Notify, R().QuestionToUser_001, QuestionDialogMode.YesNo);
	Else
		SetAsDefaultAtServer();
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure SetAsDefaultContinue(Result, AddirionalParameters = Undefined) Export
	If Result = DialogReturnCode.Yes And Write() Then
		SetAsDefaultAtServer();
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure SetAsDefaultAtServer()
	BillOfMaterialsAsDefault = Catalogs.BillOfMaterials.EmptyRef();
	If Not IsDefaultBillOfMaterials(Object.Ref, Object.ItemKey) Then
		BillOfMaterialsAsDefault = Object.Ref;
	EndIf;
	BeginTransaction();
	Try
		ItemKeyObject = Object.ItemKey.GetObject();
		ItemKeyObject.DefaultBillOfMaterials = BillOfMaterialsAsDefault;
		ItemKeyObject.Write();
		CommitTransaction();
	Except
		If TransactionActive() Then
			RollbackTransaction();
			GetUserMessages(ErrorDescription());
		EndIf;
	EndTry;
EndProcedure

&AtServerNoContext
Function IsDefaultBillOfMaterials(ObjectRef, ItemKeyRef)
	If Not ValueIsFilled(ObjectRef) Or Not ValueIsFilled(ItemKeyRef) Then
		Return False;
	EndIf;
	
	Return ObjectRef = ItemKeyRef.DefaultBillOfMaterials;
EndFunction

#EndRegion

#Region ProductionTree

&AtClientAtServerNoContext
Procedure CreateProductionTree(Object, Form, RowOwner, ArrayOfProductTreeRows)
	For Each Row In ArrayOfProductTreeRows Do
		NewRow = RowOwner.GetItems().Add();
		FillPropertyValues(NewRow, Row);
		CreateProductionTree(Object, Form, NewRow, Row.Rows);
	EndDo;
EndProcedure

&AtServerNoContext
Procedure CreateProductionTreeAtServer(RowOwner, BillOfMaterialsRef, IsTopLevel = False)
	If IsTopLevel Then
		//Top level products
		NewRow1 = New Structure("Rows", New Array());
		RowOwner.Add(NewRow1);
		NewRow1.Insert("Item"        , BillOfMaterialsRef.Item);
		NewRow1.Insert("ItemKey"     , BillOfMaterialsRef.ItemKey);
		NewRow1.Insert("Unit"        , BillOfMaterialsRef.Unit);
		NewRow1.Insert("Quantity"    , BillOfMaterialsRef.Quantity);
		NewRow1.Insert("ItemPicture" , 0);
		CreateProductionTreeAtServer(NewRow1, BillOfMaterialsRef);
		Return;
	EndIf;
	
	For Each Row In BillOfMaterialsRef.Content Do
		NewRow2 = New Structure("Rows", New Array());
		RowOwner.Rows.Add(NewRow2);
		NewRow2.Insert("Item"     , Row.Item);
		NewRow2.Insert("ItemKey"  , Row.ItemKey);
		NewRow2.Insert("Unit"     , Row.Unit);
		NewRow2.Insert("Quantity" , Row.Quantity);
		If ValueIsFilled(Row.BillOfMaterials) Then
			NewRow2.Insert("ItemPicture", 2);
			CreateProductionTreeAtServer(NewRow2, Row.BillOfMaterials);
		Else
			If Row.Item.ItemType.Type = Enums.ItemTypes.Service Then
				NewRow2.Insert("ItemPicture", 1);
			Else
				NewRow2.Insert("ItemPicture", 3);
			EndIf;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

#EndRegion

