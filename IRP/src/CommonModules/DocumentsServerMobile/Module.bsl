#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	If Form.Items.Find("GroupTitleDecorations") <> Undefined Then
		Form.Items.GroupTitleDecorations.Visible = False;
		If Form.Items.Find("GroupMainPages") <> Undefined Then
			MainPages = Form.Items.GroupMainPages;
		Else
			MainPages = Form.Items.Pages;
		EndIf;
		
		NewItem = Form.Items.Add("PageHead", Type("FormGroup"), MainPages);
		NewItem.Type = FormGroupType.Page;
		NewItem.Title = R().Form_035;
		Form.Items.GroupTitleItems.Group = ChildFormItemsGroup.Vertical;
		Form.Items.Move(NewItem, MainPages, MainPages.ChildItems[0]);
		Form.Items.Move(Form.Items.GroupTitle, NewItem);
		Form.Items.Move(Form.Items.FormPostAndClose, NewItem);
		MainPages.PagesRepresentation = FormPagesRepresentation.TabsOnBottom;		
	EndIf;
	
	If Form.Items.Find("GroupBottom") <> Undefined Then
		Form.Items.GroupBottom.Visible = False;
	EndIf;
	If Form.Items.Find("ItemListOpenPickupItems") <> Undefined Then
		Form.Items.ItemListOpenPickupItems.Visible = False;
	EndIf;
	If Form.Items.Find("AddBasisDocuments") <> Undefined Then
		Form.Items.AddBasisDocuments.Visible = False;
	EndIf;
	If Form.Items.Find("LinkUnlinkBasisDocuments") <> Undefined Then
		Form.Items.LinkUnlinkBasisDocuments.Visible = False;
	EndIf;

	ColumnPropertyList = ColumnPropertyList();
	If Form.Items.Find("ItemList") <> Undefined Then
		Form.Items.ItemList.ChoiceMode = True;
		Form.Items.ItemList.Header = False;
		GroupItemList_Item = Form.Items.Add("GroupItemList_Item", Type("FormGroup"), Form.Items.ItemList);
		GroupItemList_Item.Type = FormGroupType.ColumnGroup;
		GroupItemList_Item.Group = ColumnsGroup.Vertical;

		GroupItemList_ItemKey = Form.Items.Add("GroupItemList_ItemKey", Type("FormGroup"), GroupItemList_Item);
		GroupItemList_ItemKey.Type = FormGroupType.ColumnGroup;
		GroupItemList_ItemKey.Group = ColumnsGroup.Horizontal;

		TotalItemsCount = Form.Items.ItemList.ChildItems.Count() - 1;
		Diff = 0;
		For Index = 0 To TotalItemsCount Do
			ItemListColumn = Form.Items.ItemList.ChildItems[Index - Diff];

			If ColumnPropertyList.Property(ItemListColumn.Name) Then
				PropertyInfo = ColumnPropertyList[ItemListColumn.Name];
				ItemListColumn.DisplayImportance = PropertyInfo.Importance;
				ItemListColumn.Width = PropertyInfo.Width;

				Form.Items.Move(ItemListColumn, GroupItemList_ItemKey);
				Diff = Diff + 1;
			ElsIf Not TypeOf(ItemListColumn) = Type("FormGroup") Then
				ItemListColumn.Visible = False;
			EndIf;
		EndDo;
		Form.Items.Move(Form.Items.ItemListItem, GroupItemList_Item, GroupItemList_ItemKey);
	EndIf;
EndProcedure

Function ColumnPropertyList()

	PropertyInfo = New Structure();
	PropertyInfo.Insert("ItemListLineNumber", FillPropertyInfo(1));
	PropertyInfo.Insert("ItemListItem", FillPropertyInfo(10));
	PropertyInfo.Insert("ItemListItemKey", FillPropertyInfo(10));
	PropertyInfo.Insert("ItemListQuantity", FillPropertyInfo(5));
	PropertyInfo.Insert("ItemListUnit", FillPropertyInfo(5));

	Return PropertyInfo;

EndFunction

Function FillPropertyInfo(Width, Importance = "VeryHigh")

	Structure = New Structure();
	Structure.Insert("Width", Width);
	Structure.Insert("Importance", DisplayImportance[Importance]);
	Return Structure;

EndFunction
#EndRegion