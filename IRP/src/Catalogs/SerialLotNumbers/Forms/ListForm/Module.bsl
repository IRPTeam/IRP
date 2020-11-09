
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	List.Parameters.SetParameterValue("isItemKey", False);
	List.Parameters.SetParameterValue("isItem", False);
	List.Parameters.SetParameterValue("isItemType", False);
	List.Parameters.SetParameterValue("ItemKeyRef", Catalogs.ItemKeys.EmptyRef());
	List.Parameters.SetParameterValue("ItemRef", Catalogs.Items.EmptyRef());
	List.Parameters.SetParameterValue("ItemType", Catalogs.ItemTypes.EmptyRef());

	
	If Parameters.Property("SerialLotNumberOwner") Then
		If TypeOf(Parameters.SerialLotNumberOwner) = Type("CatalogRef.ItemKeys") Then
			List.Parameters.SetParameterValue("isItemKey", True);
			List.Parameters.SetParameterValue("ItemKeyRef", Parameters.SerialLotNumberOwner);
			List.Parameters.SetParameterValue("ItemRef", Parameters.SerialLotNumberOwner.Item);
			List.Parameters.SetParameterValue("ItemType", Parameters.SerialLotNumberOwner.Item.ItemType);
		ElsIf TypeOf(Parameters.SerialLotNumberOwner) = Type("CatalogRef.Items") Then
			List.Parameters.SetParameterValue("isItemKey", True);
			List.Parameters.SetParameterValue("ItemRef", Parameters.SerialLotNumberOwner);
			List.Parameters.SetParameterValue("ItemType", Parameters.SerialLotNumberOwner.ItemType);
		ElsIf TypeOf(Parameters.SerialLotNumberOwner) = Type("CatalogRef.ItemTypes") Then
			List.Parameters.SetParameterValue("isItemKey", True);
			List.Parameters.SetParameterValue("ItemType", Parameters.SerialLotNumberOwner);
		EndIf;	
	EndIf;
EndProcedure
