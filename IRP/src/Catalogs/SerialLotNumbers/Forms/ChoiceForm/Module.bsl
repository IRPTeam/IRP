&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Property("FillingData") Then
		ThisObject.FillingData = CommonFunctionsServer.SerializeXMLUseXDTO(Parameters.FillingData);
	EndIf;

	If Parameters.Property("ItemType") And Parameters.Property("Item") And Parameters.Property("ItemKey") Then
		ThisObject.List.Parameters.SetParameterValue("UseFilter", True);
		ThisObject.List.Parameters.SetParameterValue("ItemType", Parameters.ItemType);
		ThisObject.List.Parameters.SetParameterValue("Item", Parameters.Item);
		ThisObject.List.Parameters.SetParameterValue("ItemKey", Parameters.ItemKey);
	Else
		ThisObject.List.Parameters.SetParameterValue("UseFilter", False);
		ThisObject.List.Parameters.SetParameterValue("ItemType", Undefined);
		ThisObject.List.Parameters.SetParameterValue("Item", Undefined);
		ThisObject.List.Parameters.SetParameterValue("ItemKey", Undefined);
	EndIf;
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	CommonFormActions.DynamicListBeforeAddRow(ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter,
		"Catalog.SerialLotNumbers.ObjectForm");
EndProcedure