

&AtClient
Procedure OnOpen(Cancel)
	FillSettingsAndClose()
EndProcedure

&AtClient
Procedure OK(Command)
	FillSettingsAndClose();
EndProcedure

&AtClient
Procedure FillSettingsAndClose()
	If Not CheckFilling() Then
		Return;
	EndIf;
	
	Close();
		
	Settings = CopyPasteClient.PasteSettings();
	FillPropertyValues(Settings, ThisObject);
	ExecuteNotifyProcessing(ThisObject.OnCloseNotifyDescription, Settings);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	FillPropertyValues(ThisObject, Parameters.PasteSettings);
	
	If TypeOf(Parameters.Ref) = Type("DocumentRef.PhysicalInventory")
		Or TypeOf(Parameters.Ref) = Type("DocumentRef.PhysicalCountByLocation") Then
	
		ThisObject.PasteQuantityAs = "";
	EndIf;
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	
	If IsBlankString(PasteQuantityAs) Then
		Items.PasteQuantityAs.TitleTextColor = StyleColors.NegativeTextColor;
		Cancel = True;
	Else	
		Items.PasteQuantityAs.TitleTextColor = StyleColors.FieldTextColor;
	EndIf;
	
EndProcedure
