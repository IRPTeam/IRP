&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatAgreementsServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	CatAgreementsClient.ListBeforeAddRow(ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure