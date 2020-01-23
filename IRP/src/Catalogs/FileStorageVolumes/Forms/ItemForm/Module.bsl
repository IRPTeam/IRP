&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	SetVisible();
EndProcedure

&AtClient
Procedure FilesTypeOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure UsePreview1OnChange(Item)
	SetVisible();
EndProcedure

&AtServer
Procedure SetVisible()
	Items.UsePreview1.Visible = (Object.FilesType = Enums.FileTypes.Picture);
	Items.Preview1POSTIntegrationSettings.Visible = (Object.FilesType = Enums.FileTypes.Picture) And Object.UsePreview1;
	Items.Preview1GETIntegrationSettings.Visible = (Object.FilesType = Enums.FileTypes.Picture) And Object.UsePreview1;
	Items.Preview1Sizepx.Visible = (Object.FilesType = Enums.FileTypes.Picture) And Object.UsePreview1;
EndProcedure

