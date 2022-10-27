&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatAgreementsServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	CommonFormActions.DynamicListBeforeAddRow(ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter, "Catalog.Agreements.ObjectForm");
EndProcedure
