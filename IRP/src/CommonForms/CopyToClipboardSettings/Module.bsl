
&AtClient
Procedure OnOpen(Cancel)
	FillSettingsAndClose();
	If TypeOf(SourceRef) = Type("DocumentRef.PhysicalCountByLocation") Then
		If FormOwner.Object.TransactionType = PredefinedValue("Enum.PhysicalCountByLocationTransactionType.Package") Then
			ThisObject.CopyQuantityAs = "PhysCount";
			FillSettingsAndClose();
		EndIf; 
	EndIf;
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
		
	Settings = CopyPasteClient.CopySettings();
	FillPropertyValues(Settings, ThisObject);
	Close();
	RunCallback(ThisObject.CallbackDescriptionOnClose, Settings);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	FillPropertyValues(ThisObject, Parameters.CopySettings);
	SourceRef = Parameters.Ref;
	
	If TypeOf(SourceRef) = Type("DocumentRef.PhysicalInventory")
		Or TypeOf(SourceRef) = Type("DocumentRef.PhysicalCountByLocation") Then
	
		ThisObject.CopyQuantityAs = "";
	EndIf;
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	
	If IsBlankString(CopyQuantityAs) Then
		Items.CopyQuantityAs.TitleTextColor = StyleColors.NegativeTextColor;
		Cancel = True;
	Else	
		Items.CopyQuantityAs.TitleTextColor = StyleColors.FieldTextColor;
	EndIf;
	
EndProcedure
