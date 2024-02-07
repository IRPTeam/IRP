
#Region ObjectFormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	
	If Not Object.Ref.Metadata().TabularSections.Find("AddAttributes") = Undefined 
		And Not Form.Items.Find("GroupOther") = Undefined Then
		AddAttributesAndPropertiesServer.OnCreateAtServer(Form, "GroupOther");
		ExtensionServer.AddAttributesFromExtensions(Form, Object.Ref, Form.Items.GroupOther);
	EndIf;

	ObjectMetdata = Object.Ref.Metadata();
	ExternalCommandsServer.CreateCommands(Form, ObjectMetdata.FullName(), Enums.FormTypes.ObjectForm);
	
	If Form.Items.Find("Code") <> Undefined Then
		NumberEditingAvailable = SessionParametersServer.GetSessionParameter("NumberEditingAvailable");
		Form.Items.Code.ReadOnly = Not NumberEditingAvailable;
	EndIf;
	
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	Return;
EndProcedure

Procedure OnWriteAtServer(Object, Form, Cancel, CurrentObject, WriteParameters) Export
	Return;
EndProcedure

#EndRegion

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	FormNamesArray = StrSplit(Form.FormName, ".");
	ChartFullName = FormNamesArray[0] + "." + FormNamesArray[1];
	ExternalCommandsServer.CreateCommands(Form, ChartFullName, Enums.FormTypes.ListForm);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	FormNamesArray = StrSplit(Form.FormName, ".");
	ChartFullName = FormNamesArray[0] + "." + FormNamesArray[1];
	ExternalCommandsServer.CreateCommands(Form, ChartFullName, Enums.FormTypes.ChoiceForm);
EndProcedure

#EndRegion