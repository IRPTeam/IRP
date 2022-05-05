
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	For Each FunctionalOption In Metadata.FunctionalOptions Do
		If StrStartsWith(FunctionalOption.Name, "Use") Then
			NewRow = ThisObject.FunctionalOptions.Add();
			NewRow.OptionName = FunctionalOption.Name;
			NewRow.OptionPresentation = FunctionalOption.Synonym;
			NewRow.Use = Constants[FunctionalOption.Name].Get();
		EndIf;
	EndDO;
EndProcedure

&AtClient
Procedure Save(Command)
	SeveAtServer();
EndProcedure

&AtServer
Procedure SeveAtServer()
	For Each FunctionalOption In ThisObject.FunctionalOptions Do
		Constants[FunctionalOption.OptionName].Set(FunctionalOption.Use);
	EndDo;	
EndProcedure	

&AtClient
Procedure FunctionalOptionsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure FunctionalOptionsBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure





