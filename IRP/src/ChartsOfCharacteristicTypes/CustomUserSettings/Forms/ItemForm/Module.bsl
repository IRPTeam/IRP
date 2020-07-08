&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	SetVisible();
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure RefersToObjectsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure IsCommonOnChange(Item)
	Object.RefersToObjects.Clear();
	SetVisible();
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisible();
EndProcedure

&AtServer
Procedure SetVisible()
	Items.GroupRefersToObjects.Visible = Not Object.IsCommon;
	For Each Row In Object.RefersToObjects Do
		ArrayOfSegments = StrSplit(Row.FullName, ".");
		If ArrayOfSegments.Count() = 2 Then
			If Metadata.Catalogs.Find(ArrayOfSegments[1]) <> Undefined Then
				Row.PictureIndex = 8;
			ElsIf Metadata.Documents.Find(ArrayOfSegments[1]) <> Undefined Then
				Row.PictureIndex = 1;
			Else
				Row.PictureIndex = 0;
			EndIf;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure AddRefersToObject(Command)
	ArrayOfSelectedObjects = New Array();
	For Each Row In Object.RefersToObjects Do
		ArrayOfSelectedObjects.Add(Row.FullName);
	EndDo;
	Notify = New NotifyDescription("AddRefersToObjectEnd", ThisObject);
	OpenForm("ChartOfCharacteristicTypes.CustomUserSettings.Form.SelectMetadataForm",
		New Structure("ArrayOfSelectedObjects", ArrayOfSelectedObjects), ThisObject, , , , Notify);
EndProcedure

&AtClient
Procedure AddRefersToObjectEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Object.RefersToObjects.Clear();
	For Each ArrayItem In Result.ArrayOfSelectedObjects Do
		NewRow = Object.RefersToObjects.Add();
		NewRow.FullName = ArrayItem.FullName;
		NewRow.Synonym = ArrayItem.Synonym;
	EndDo;
	SetVisible();
EndProcedure