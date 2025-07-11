
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	ChartsOfCharacteristicTypesServer.OnCreateAtServerListForm(ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure Template_R4050B_StockInventory(Command)
	FillingData = New Structure();
	FillingData.Insert("UniqueID", "CheckBalance_R4050B_StockInventory");
	FillingData.Insert("IsCommon", True);
	FillingData.Insert("ValueType", New TypeDescription("Boolean"));
	OpenForm("ChartOfCharacteristicTypes.CustomUserSettings.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
EndProcedure
