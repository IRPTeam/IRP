
#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	IDInfoServer.OnCreateAtServer(ThisObject, "GroupContactInformation");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref, Items.GroupMainPages);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	
	If Not FOServer.IsUsePartnersHierarchy() Then
		Items.Parent.Visible = False;
	EndIf;
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	If ThisIsNew Then
		Notify("NewPartnerCreated", Object.Ref);
	EndIf;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	IDInfoServer.AfterWriteAtServer(ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	IDInfoClient.NotificationProcessing(ThisObject, Object.Ref, EventName, Parameter, Source);
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
	If EventName = "UpdateIDInfo" Then
		IDInfoCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	ThisIsNew = Parameters.Key.IsEmpty();
EndProcedure

&AtClient
Procedure CustomerOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure VendorOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure EmployeeOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure ConsignorOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure TradeAgentOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OtherOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)

	RetailWorkersNavigation = Form.CommandBar.ChildItems.Find("FormInformationRegisterRetailWorkersRetailWorkers");
	If Not RetailWorkersNavigation = Undefined Then
		RetailWorkersNavigation.Visible = Object.Employee;
	EndIf;
	
	Form.Items.GroupStaffing.Visible = Object.Employee;
	
	StaffingFilter = Form.Staffing.Filter.Items;
	StaffingFilter.Clear();
	NewFilter = StaffingFilter.Add(Type("DataCompositionFilterItem"));
	NewFilter.LeftValue = New DataCompositionField("Employee");
	NewFilter.ComparisonType = DataCompositionComparisonType.Equal;
	NewFilter.RightValue = Object.Ref;
EndProcedure

#EndRegion

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure IDInfoOpening(Item, StandardProcessing) Export
	IDInfoClient.IDInfoOpening(Item, StandardProcessing, Object, ThisObject);
EndProcedure

&AtClient
Procedure StartEditIDInfo(Result, Parameters) Export
	IDInfoClient.StartEditIDInfo(ThisObject, Result, Parameters);
EndProcedure

&AtClient
Procedure EndEditIDInfo(Result, Parameters) Export
	IDInfoClient.EndEditIDInfo(Object, Result, Parameters);
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

&AtServer
Procedure IDInfoCreateFormControl()
	IDInfoServer.CreateFormControls(ThisObject);
EndProcedure

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

#EndRegion