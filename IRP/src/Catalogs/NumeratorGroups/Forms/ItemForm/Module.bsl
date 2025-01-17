
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	
	NumberParts = DocumentNumberingClientServer.GetNumberParts();
	Items.LabelNumber.Title = NumberParts.Number;
	Items.LabelBasic.Title = NumberParts.Basic;
	Items.LabelYear2.Title = NumberParts.Year2;
	Items.LabelYear4.Title = NumberParts.Year4;
	Items.LabelQuarter.Title = NumberParts.Quarter;
	Items.LabelMonth1.Title = NumberParts.Month1;
	Items.LabelMonth2.Title = NumberParts.Month2;
	Items.LabelWeek1.Title = NumberParts.Week1;
	Items.LabelWeek2.Title = NumberParts.Week2;
	
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

#EndRegion

#Region FormItemsEvent

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure ExampleOnChange(Item)
	Check(Item);
EndProcedure

&AtClient
Procedure LabelHintClick(Item)
	AddToTemplate(Item.Title);
EndProcedure

#EndRegion

#Region FormCommands

&AtClient
Procedure Check(Command)
	
	Items.ResultLabel.Title = "";
	
	If ValueIsFilled(Example) Then
		NumeratorWrapper = New Structure(
			"Ref, 
			|BasicRule, 
			|BeginDate, 
			|EndDate, 
			|ByDefault, 
			|NumberingPeriod, 
			|NumberTemplate, 
			|StartNumber, 
			|TotalLength, 
			|WithoutLeadingZeros");
		FillPropertyValues(NumeratorWrapper, Object);
		NumeratorDescription = DocumentNumberingServer.FillNumeratorDescription(NumeratorWrapper);
		DocumentDescription = DocumentNumberingServer.GetDocumentDescriptionForNumerator(Example);
		Items.ResultLabel.Title = 
			DocumentNumberingServer.MakeNumber(NumeratorDescription, DocumentDescription, Object.StartNumber);
	EndIf;
	
	If IsBlankString(Items.ResultLabel.Title) Then
		Items.ResultLabel.BackColor = WebColors.MistyRose;
	Else
		Items.ResultLabel.BackColor = WebColors.PaleGreen;
	EndIf;

EndProcedure

#EndRegion

#Region Private

&AtClient
Procedure AddToTemplate(TemplatePart)
	If StrFind(Object.NumberTemplate, TemplatePart) = 0 Then
		Object.NumberTemplate = Object.NumberTemplate + TemplatePart; 
	EndIf;
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
Procedure GeneratedFormCommandActionByNameServer(CommandName)
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion

#EndRegion