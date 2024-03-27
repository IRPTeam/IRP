#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref, Items.GroupMainPages);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	Notify("UpdateAddAttributeAndPropertySets", New Structure(), ThisObject);
	Notify("UpdateTypeOfItemType", New Structure(), ThisObject);
	Notify("UpdateAffectPricing", New Structure(), ThisObject);
	Notify("UpdateAffectPricingMD5", New Structure(), ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure TypeOnChange(Item)
	If Object.Type = PredefinedValue("Enum.ItemTypes.Service") Then
		Object.UseSerialLotNumber = False;
		Object.StockBalanceDetail = PredefinedValue("Enum.StockBalanceDetail.ByItemKey");
	ElsIf Object.Type = PredefinedValue("Enum.ItemTypes.Certificate") Then
		Object.UseSerialLotNumber = True;
		Object.AlwaysAddNewRowAfterScan = True;
		Object.EachSerialLotNumberIsUnique = True;
		Object.NotUseLineGrouping = True;
		Object.StockBalanceDetail = PredefinedValue("Enum.StockBalanceDetail.EmptyRef");
		Object.SingleRow = True;
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure UseSerialLotNumberOnChange(Item)
	If Not Object.UseSerialLotNumber Then
		Object.StockBalanceDetail = PredefinedValue("Enum.StockBalanceDetail.ByItemKey");
		Object.SingleRow = False;
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure SingleRowOnChange(Item)
	If Object.SingleRow Then
		Object.AlwaysAddNewRowAfterScan = True;
		Object.NotUseLineGrouping = True;
	EndIf; 
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure AlwaysAddNewRowAfterScanOnChange(Item)
	If Object.AlwaysAddNewRowAfterScan Then
		Object.NotUseLineGrouping = True;
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);	
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsProduct = (Object.Type = PredefinedValue("Enum.ItemTypes.Product"));
	IsCertificate = (Object.Type = PredefinedValue("Enum.ItemTypes.Certificate"));
	IsService = (Object.Type = PredefinedValue("Enum.ItemTypes.Service"));
	
	If IsProduct Then
		Form.Items.UseSerialLotNumber.ReadOnly = False;
		Form.Items.AlwaysAddNewRowAfterScan.ReadOnly = Object.UseSerialLotNumber And Object.SingleRow;
		Form.Items.EachSerialLotNumberIsUnique.ReadOnly = False;
		Form.Items.StockBalanceDetail.ReadOnly = Not Object.UseSerialLotNumber;
		Form.Items.NotUseLineGrouping.ReadOnly = Object.SingleRow OR Object.AlwaysAddNewRowAfterScan;
	ElsIf IsService Then
		Form.Items.UseSerialLotNumber.ReadOnly = False;
		Form.Items.AlwaysAddNewRowAfterScan.ReadOnly = False;
		Form.Items.EachSerialLotNumberIsUnique.ReadOnly = False;
		Form.Items.StockBalanceDetail.ReadOnly = Not Object.UseSerialLotNumber;
		Form.Items.NotUseLineGrouping.ReadOnly = Object.SingleRow OR Object.AlwaysAddNewRowAfterScan;
	ElsIf IsCertificate Then
		Form.Items.StockBalanceDetail.ReadOnly = True;
		Form.Items.UseSerialLotNumber.ReadOnly = True;
		Form.Items.AlwaysAddNewRowAfterScan.ReadOnly = True;
		Form.Items.EachSerialLotNumberIsUnique.ReadOnly = True;
		Form.Items.NotUseLineGrouping.ReadOnly = True;
	EndIf;
	
	Form.Items.PageSerialLotNumbersSettings.Visible = Object.UseSerialLotNumber;
	
EndProcedure

#EndRegion

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure EditItemDescriptionTemplate(Command)
	EditItemTemplate("ItemDescriptionTemplate");
EndProcedure

&AtClient
Procedure EditItemLocalFullDescriptionTemplate(Command)
	EditItemTemplate("ItemLocalFullDescriptionTemplate");
EndProcedure

&AtClient
Procedure EditItemForeignFullDescriptionTemplate(Command)
	EditItemTemplate("ItemForeignFullDescriptionTemplate");
EndProcedure

&AtClient
Procedure EditItemTemplate(TemplateName)
	If ThisObject.Modified Then
		ShowQueryBox(New NotifyDescription("EditItemTemplateEnd", ThisObject, New Structure("TemplateName", TemplateName)), 
			R().QuestionToUser_001, QuestionDialogMode.OKCancel);
	Else
		EditItemTemplateAtClient(TemplateName);
	EndIf;
EndProcedure

&AtClient
Procedure EditItemTemplateEnd(Result, NotifyParameters) Export
	If Result = DialogReturnCode.OK Then
		If Write() Then
			EditItemTemplateAtClient(NotifyParameters.TemplateName);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure EditItemTemplateAtClient(TemplateName)
	Notify = New NotifyDescription("OnFinishEditItemTemplate", ThisObject, New Structure("TemplateName", TemplateName));
	FormParameters = New Structure();
	FormParameters.Insert("Formula", Object[TemplateName]);
	FormParameters.Insert("PropertySet"   , PredefinedValue("Catalog.AddAttributeAndPropertySets.Catalog_Items"));
	FormParameters.Insert("TemplateOwner" , "ItemTypes");
	FormParameters.Insert("TemplateName"  , "ItemTemplate");
	
	OpenForm("CommonForm.FormulaEditor", FormParameters, ThisObject,,,,Notify,FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure OnFinishEditItemTemplate(Result, NotfyParameters) Export
	If ValueIsFilled(Result) And Object.ItemDescriptionTemplate <> Result Then
		ThisObject.Modified = True;
		Object[NotfyParameters.TemplateName] = Result;
	EndIf;
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion
