
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	List.Parameters.SetParameterValue("isItemKey"  , False);
	List.Parameters.SetParameterValue("isItem"     , False);
	List.Parameters.SetParameterValue("isItemType" , False);
	List.Parameters.SetParameterValue("ItemKeyRef" , Catalogs.ItemKeys.EmptyRef());
	List.Parameters.SetParameterValue("ItemRef"    , Catalogs.Items.EmptyRef());
	List.Parameters.SetParameterValue("ItemType"   , Catalogs.ItemTypes.EmptyRef());
	
	If Parameters.Property("SourceOfOriginOwner") Then
		ThisObject.SourceOfOriginOwner = Parameters.SourceOfOriginOwner;
		If TypeOf(Parameters.SourceOfOriginOwner) = Type("CatalogRef.ItemKeys") Then
			List.Parameters.SetParameterValue("isItemKey"  , True);
			List.Parameters.SetParameterValue("ItemKeyRef" , Parameters.SourceOfOriginOwner);
			List.Parameters.SetParameterValue("ItemRef"    , Parameters.SourceOfOriginOwner.Item);
			List.Parameters.SetParameterValue("ItemType"   , Parameters.SourceOfOriginOwner.Item.ItemType);
		ElsIf TypeOf(Parameters.SourceOfOriginOwner) = Type("CatalogRef.Items") Then
			List.Parameters.SetParameterValue("isItemKey", True);
			List.Parameters.SetParameterValue("ItemRef"  , Parameters.SourceOfOriginOwner);
			List.Parameters.SetParameterValue("ItemType" , Parameters.SourceOfOriginOwner.ItemType);
		ElsIf TypeOf(Parameters.SourceOfOriginOwner) = Type("CatalogRef.ItemTypes") Then
			List.Parameters.SetParameterValue("isItemKey" , True);
			List.Parameters.SetParameterValue("ItemType"  , Parameters.SourceOfOriginOwner);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	FormParameters = New Structure("SourceOfOriginOwner", ThisObject.SourceOfOriginOwner);
	Filter = New Structure("FillingValues", FormParameters);
	OpenForm("Catalog.SourceOfOrigins.ObjectForm", Filter);
EndProcedure

