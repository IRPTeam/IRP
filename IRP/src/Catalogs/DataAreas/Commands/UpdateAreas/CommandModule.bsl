
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Saas.AreaUpdate();
	NotifyChanged(Type("CatalogRef.DataAreas"));
	Status(R().Saas_004, , , PictureLib.AppearanceFlagGreen);
EndProcedure
