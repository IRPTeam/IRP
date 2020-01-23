&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If NeedCreateFormFilelds(Parameters) Then
		ThisObject.Item = Parameters.Filter.Item;
		
		ArrayOfAttributes = New Array();
		For Each Row In ThisObject.Item.ItemType.AvailableAttributes Do
			AttributeStructure = New Structure("Attribute, InterfaceGroup", Row.Attribute, Undefined);
			ArrayOfAttributes.Add(AttributeStructure);
		EndDo;
		
		FormAttributes = AddAttributesAndPropertiesServer.FormAttributes(ArrayOfAttributes);
		
		ThisObject.ChangeAttributes(FormAttributes.Attributes);
		
		For Each Row In FormAttributes.FormAttributesInfo Do
			ThisObject[Row.Name_owner] = Row.Ref;
			NewRowSelectedFilters = ThisObject.SelectedFilters.Add();
			NewRowSelectedFilters.Attribute = Row.Ref;
			NewRowSelectedFilters.Name = Row.Name;
		EndDo;
		
		ArrayOfFormElements = AddAttributesAndPropertiesServer.CreateFormItemFields(ThisObject,
				"GroupFilter",
				FormAttributes.FormAttributesInfo);
		
		For Each Row In ArrayOfFormElements Do
			Row.SetAction("OnChange", "AddAttributeOnChange");
		EndDo;
	EndIf;
	
	IsSpecificationFilter = "all";
EndProcedure

&AtServer
Function NeedCreateFormFilelds(Parameters)
	Return Parameters.ChoiceMode
		And Parameters.Filter.Property("Item")
		And ValueIsFilled(Parameters.Filter.Item)
		And ValueIsFilled(Parameters.Filter.Item.ItemType);
EndFunction

&AtServer
Procedure OnLoadDataFromSettingsAtServer(Settings)
	UpdateListWithFilter();
EndProcedure


&AtClient
Procedure IsSpecificationFilterOnChange(Item)
	UpdateListWithFilter();
EndProcedure

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure AddAttributeOnChange(Item) Export
	SetFilterAtServer(Item.Name);
EndProcedure

&AtServer
Procedure SetFilterAtServer(ItemName)
	ArrayOfRows = ThisObject.SelectedFilters.FindRows(New Structure("Name", ItemName));
	For Each Row In ArrayOfRows Do
		Row.Value = ThisObject[ItemName];
	EndDo;
	
	UpdateListWithFilter();
EndProcedure

&AtClient
Procedure CreateNewItemKey(Command)
	NotifyDescription = New NotifyDescription("CreateNewItemsFinish", ThisObject);
	OpenParameters = New Structure();
	OpenParameters.Insert("Item", ThisObject.Item);
	OpenParameters.Insert("SelectedFilters", New Array());
	
	For Each Row In ThisObject.SelectedFilters Do
		If ValueIsFilled(Row.Value) Then
			OpenParameters.SelectedFilters.Add(New Structure("Name, Value", Row.Name, Row.Value));
		EndIf;
	EndDo;
	
	OpenForm("Catalog.ItemKeys.Form.ItemForm",
		OpenParameters,
		ThisObject, New UUID(), , ,
		NotifyDescription,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure CreateNewItemsFinish(Result, Args) Export
	UpdateListWithFilter();
EndProcedure

&AtServer
Procedure UpdateListWithFilter()
	ArrayForDelete = New Array();
	SelectedFiltersCopy = ThisObject.SelectedFilters.Unload();
	For Each Row In SelectedFiltersCopy Do
		If Not ValueIsFilled(Row.Value) Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each Row In ArrayForDelete Do
		SelectedFiltersCopy.Delete(Row);
	EndDo;
	
	ArrayOfItemKeys = Catalogs.ItemKeys.GetRefsByPropertiesWithSpecifications(SelectedFiltersCopy, ThisObject.Item);
	Items.CreateNewItemKey.Enabled = Not ArrayOfItemKeys.Count();
	
	If ValueIsFilled(SearchString) Then
		ArrayOfItemKeysBySearchString = Catalogs.ItemKeys.GetRefsBySearchString(ThisObject.Item, ThisObject.SearchString);
		Query = New Query();
		Query.Text =
			"SELECT
			|	tmp.Ref AS Ref
			|INTO tmp1
			|FROM
			|	&Table1 AS tmp
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|SELECT
			|	tmp.Ref AS Ref
			|INTO tmp2
			|FROM
			|	&Table2 AS tmp
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|SELECT
			|	tmp1.Ref
			|FROM
			|	tmp1 AS tmp1
			|		INNER JOIN tmp2 AS tmp2
			|		ON tmp2.Ref = tmp1.Ref";
		Table1 = New ValueTable();
		Table1.Columns.Add("Ref", New TypeDescription("CatalogRef.ItemKeys"));
		For Each Row In ArrayOfItemKeys Do
			Table1.Add().Ref = Row;
		EndDo;
		
		Table2 = New ValueTable();
		Table2.Columns.Add("Ref", New TypeDescription("CatalogRef.ItemKeys"));
		For Each Row In ArrayOfItemKeysBySearchString Do
			Table2.Add().Ref = Row;
		EndDo;
		
		Query.SetParameter("Table1", Table1);
		Query.SetParameter("Table2", Table2);
		
		QueryResult = Query.Execute();
		ArrayOfItemKeys = QueryResult.Unload().UnloadColumn("Ref");
	EndIf;
	
	ThisObject.List.Filter.Items.Clear();
	FilterItem = ThisObject.List.Filter.Items.Add(Type("DataCompositionFilterItem"));
	FilterItem.LeftValue = New DataCompositionField("Ref");
	FilterItem.ComparisonType = DataCompositionComparisonType.InList;
	FilterItem.RightValue = ArrayOfItemKeys;
	
	If ThisObject.IsSpecificationFilter = "single" Or ThisObject.IsSpecificationFilter = "specification" Then
		FilterItem = ThisObject.List.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.LeftValue = New DataCompositionField("IsSpecificationFlag");
		FilterItem.ComparisonType = DataCompositionComparisonType.Equal;
		FilterItem.RightValue = ThisObject.IsSpecificationFilter = "specification";
	EndIf;
EndProcedure

&AtClient
Procedure SearchStringEditTextChange(Item, Text, StandardProcessing)
	StandardProcessing = False;
	ThisObject.SearchString = Text;
	UpdateListWithFilter();
EndProcedure

&AtClient
Procedure SearchStringClearing(Item, StandardProcessing)
	StandardProcessing = False;
	ThisObject.SearchString = "";
	UpdateListWithFilter();
EndProcedure

