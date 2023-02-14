
&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	Settings = BarcodeClient.GetBarcodeSettings();
	Settings.ServerSettings.SearchUserByBarcode = True;
	DocumentsClient.SearchByBarcode(Barcode, New Structure(), ThisObject, ThisObject, ,Settings);
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export
	If Result.FoundedItems.Count() Then
		ThisObject.UserAdmin = Result.FoundedItems[0].User;
	EndIf;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtClient
Procedure Ok(Command)
	Close(New Structure("UserAdmin, KeepRights", ThisObject.UserAdmin, ThisObject.KeepRights));
EndProcedure
