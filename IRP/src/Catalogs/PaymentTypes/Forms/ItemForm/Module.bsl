#Region FormEventHandlers

&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	
	If Object.isIconSet Then
		CurrentObject = FormAttributeToValue("Object");
		Icon = PutToTempStorage(CurrentObject.Icon.Get());
	EndIf;
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	
	If Object.isIconSet Then
		CurrentObject.Icon = New ValueStorage(GetFromTempStorage(Icon), New Deflation(9));
	EndIf;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)	
	IsPaymentAgent = Object.Type = PredefinedValue("Enum.PaymentTypes.PaymentAgent");
	Form.Items.Partner.Visible = IsPaymentAgent;
	Form.Items.LegalName.Visible = IsPaymentAgent;
	Form.Items.Agreement.Visible = IsPaymentAgent;
	Form.Items.LegalNameContract.Visible = IsPaymentAgent;
	Form.Items.Branch.Visible = IsPaymentAgent;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

#EndRegion

&AtClient
Procedure TypeOnChange(Item)
	If Object.Type <> PredefinedValue("Enum.PaymentTypes.PaymentAgent") Then
		Object.Partner = Undefined;
		Object.LegalName = Undefined;
		Object.Agreement = Undefined;
		Object.LegalNameContract = Undefined;
		Object.Branch = Undefined;
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocumentsClient.PartnerStartChoice_TransactionTypeFilter(Object, ThisObject, Item, ChoiceData, StandardProcessing, 
		PredefinedValue("Enum.SalesTransactionTypes.Sales"));
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocumentsClient.PartnerTextChange_TransactionTypeFilter(Object, ThisObject, Item, Text, StandardProcessing,
		PredefinedValue("Enum.SalesTransactionTypes.Sales"));
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocumentsClient.LegalNameStartChoice_PartnerFilter(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.Partner);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocumentsClient.LegalNameTextChange_PartnerFilter(Object, ThisObject, Item, Text, StandardProcessing, Object.Partner);
EndProcedure

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocumentsClient.AgreementStartChoice_TransactionTypeFilter(Object, ThisObject, Item, ChoiceData, StandardProcessing, 
		PredefinedValue("Enum.SalesTransactionTypes.Sales"));
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocumentsClient.AgreementTextChange_TransactionTypeFilter(Object, ThisObject, Item, Text, StandardProcessing, 
		PredefinedValue("Enum.SalesTransactionTypes.Sales"));
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

#EndRegion

&AtClient
Procedure IconClick(Item, StandardProcessing)
	StandardProcessing = False;
	If Object.isIconSet Then
		Notify = New NotifyDescription("IconOnClickEnd", ThisObject);
		QueryText = R().QuestionToUser_016;
		QueryButtons = New ValueList();
		QueryButtons.Add("Change", R().Form_017);
		QueryButtons.Add("Clear", R().Form_018);
		QueryButtons.Add("Cancel", R().Form_019);
		ShowQueryBox(Notify, QueryText, QueryButtons);
	Else
		AskForChangeIcon();
	EndIf;
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region Service

&AtClient
Procedure AskForChangeIcon()
	Var OpenFileDialog;
	Notify = New NotifyDescription("SelectFileEnd", ThisObject);
	OpenFileDialog = New FileDialog(FileDialogMode.Open);
	OpenFileDialog.Multiselect = False;
	OpenFileDialog.Title = R().S_026;
	OpenFileDialog.Filter = PictureViewerClientServer.FilterForPicturesDialog();
	//@skip-warning
	BeginPuttingFiles(Notify, , OpenFileDialog, True, UUID);
EndProcedure

&AtClient
Procedure IconOnClickEnd(Result, AdditionalParameters) Export
	If Result = "Cancel" Then
		Return;
	ElsIf Result = "Change" Then
		AskForChangeIcon();
	Else
		Icon = "";
		Object.isIconSet = False;
	EndIf;
EndProcedure

&AtClient
Procedure SelectFileEnd(Files, AdditionalParameters) Export
	If Files = Undefined Then
		Return;
	EndIf;

	BD = New BinaryData(Files[0].FullName);
	Icon = PutToTempStorage(BD, UUID);
	Object.isIconSet = True;
EndProcedure

#EndRegion
