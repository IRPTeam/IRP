
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Not Parameters.Property("Values") Then
		Cancel = True;
	EndIf;
	AddInfo = Undefined;
	Parameters.Property("AddInfo", AddInfo);
	ThisObject.DescriptionTemplate = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "DescriptionTemplate");
	LocalizationEvents.CreateSubFormItemDescription(ThisObject, Parameters.Values, "GroupDescriptions", AddInfo);
EndProcedure

&AtClient
Procedure Ok(Command)
	Result = New Structure();
	For Each Attribute In LocalizationReuse.AllDescription() Do
		Result.Insert(Attribute, ThisObject[Attribute]);
	EndDo;
	Close(Result);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtClient
Procedure FillDescriptionByTemplate(Command)
	If Not ValueIsFilled(ThisObject.DescriptionTemplate) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().FormulaEditor_Error05);
		Return;
	EndIf;
	
	LanguageCode = TrimAll(StrSplit(Command.Name, "_")[1]);
	For Each Attribute In LocalizationReuse.AllDescription() Do
		AttributePrefix = TrimAll(StrSplit(Attribute, "_")[1]);
		If LanguageCode = AttributePrefix Then			
			ThisObject[Attribute] = GetItemInfo.GetDescriptionByTemplate(ThisObject.FormOwner.Object, ThisObject.DescriptionTemplate, LanguageCode);
			Break;
		EndIf;
	EndDo;
EndProcedure

