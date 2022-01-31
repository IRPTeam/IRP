
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Items.RecordType.ChoiceList.Add("All"     , R().CLV_1);
	ThisObject.Items.RecordType.ChoiceList.Add("ItemKey" , Metadata.Catalogs.ItemKeys.ObjectPresentation);
	ThisObject.Items.RecordType.ChoiceList.Add("Item"    , Metadata.Catalogs.Items.ObjectPresentation);
	ThisObject.Items.RecordType.ChoiceList.Add("ItemType", Metadata.Catalogs.ItemTypes.ObjectPresentation);
	
	If ValueIsFilled(Record.ItemKey) Then
		ThisObject.RecordType = "ItemKey";
	ElsIf ValueIsFilled(Record.Item) Then
		ThisObject.RecordType = "Item";
	ElsIf ValueIsFilled(Record.ItemType) Then
		ThisObject.RecordType = "ItemType";
	Else
		ThisObject.RecordType = "All";
	EndIf;
	SetVisible();
EndProcedure

&AtClient
Procedure RecordTypeOnChange(Item)
	SetVisible();
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If ThisObject.RecordType <> "ItemType" Then
		CurrentObject.ItemType = Undefined;
	EndIf;

	If ThisObject.RecordType <> "Item" Then
		CurrentObject.Item = Undefined;
	EndIf;

	If ThisObject.RecordType <> "ItemKey" Then
		CurrentObject.ItemKey = Undefined;
	EndIf;
EndProcedure

&AtServer
Procedure SetVisible()
	Items.ItemType.Visible = ThisObject.RecordType = "ItemType";
	Items.Item.Visible     = ThisObject.RecordType = "Item";
	Items.ItemKey.Visible  = ThisObject.RecordType = "ItemKey";
EndProcedure
