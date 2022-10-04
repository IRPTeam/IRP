
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	MF_FormsServer.DocumentOnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetFormRules(Object, Object, ThisObject);
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	Return;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	MF_FormsServer.DocumentAfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetFormRules(Object, Object, ThisObject);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	MF_FormsServer.DocumentOnReadAtServer(Object, ThisObject, CurrentObject);
	SetFormRules(Object, Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetFormRules(Object, CurrentObject, Form)
	MF_FormsClientServer.DocumentSetFormRules(Object, CurrentObject, Form);
EndProcedure

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocumentsClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure DateOnChange(Item)
	Return;
EndProcedure

&AtClient
Procedure BusinessUnitOnChange(Item)
	Return;
EndProcedure

#Region GroupTitleDecorations

&AtClient
Procedure GroupTitleCollapsedClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure GroupTitleUncollapsedClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion
