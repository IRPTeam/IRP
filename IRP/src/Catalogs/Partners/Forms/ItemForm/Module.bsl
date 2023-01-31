
#Region FormEvents

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
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	IDInfoServer.OnCreateAtServer(ThisObject, "GroupContactInformation");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref, Items.GroupMainPages);
	
	If Not FOServer.IsUsePartnersHierarchy() Then
		Items.Parent.Visible = False;
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
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.CommandBar.ChildItems.FormInformationRegisterRetailWorkersRetailWorkers.Visible = Object.Employee;
	
	Form.Items.GroupStaffing.Visible = Object.Employee;
	
	StaffingFilter = Form.Staffing.Filter.Items;
	StaffingFilter.Clear();
	NewFilter = StaffingFilter.Add(Type("DataCompositionFilterItem"));
	NewFilter.LeftValue = New DataCompositionField("Employee");
	NewFilter.ComparisonType = DataCompositionComparisonType.Equal;
	NewFilter.RightValue = Object.Ref;
EndProcedure

&AtClient
Procedure StaffingBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	If Not ValueIsFilled(Object.Ref) Then
		Cancel = True;
		// write object to continue?
		NotifyParameters = New Structure();
		NotifyParameters.Insert("Owner", Item);
		Notify = New NotifyDescription("StaffingAddContinue", ThisObject, NotifyParameters);
		ShowQueryBox(Notify, R().QuestionToUser_001, QuestionDialogMode.YesNo);
	EndIf;	
EndProcedure

&AtClient
Procedure StaffingAddContinue(Result, AdditionalParameters) Export
	If Result = DialogReturnCode.Yes And ThisObject.CheckFilling() Then
		Write();
		FormParameters = New Structure();
		FormParameters.Insert("FillingValues", New Structure("Employee", Object.Ref));
		OpenForm("InformationRegister.Staffing.RecordForm", FormParameters, 
			AdditionalParameters.Owner, , , , , FormWindowOpeningMode.LockOwnerWindow);	
	EndIf;
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

&AtServer
Procedure IDInfoCreateFormControl()
	IDInfoServer.CreateFormControls(ThisObject);
EndProcedure

#EndRegion