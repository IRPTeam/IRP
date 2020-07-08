&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ParameterFillingData = Undefined;
	If Parameters.Property("FillingData", ParameterFillingData) Then
		FillingData = CommonFunctionsServer.SerializeXMLUseXDTO(ParameterFillingData);
	EndIf;
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	CommonFormActions.DynamicListBeforeAddRow(
				ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter, "Catalog.PartnerSegments.ObjectForm");
EndProcedure