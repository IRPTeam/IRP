// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	If Object.Ref.IsEmpty() Then
		MailAccountValues = UserSettingsServer.GetUserSettings(
			SessionParameters.CurrentUser, 
			New Structure("MetadataObject, AttributeName",
				"Document.OutgoingMessage", "MailAccount")); // Array
		If MailAccountValues.Count() > 0 Then
			//@skip-check statement-type-change, property-return-type
			Object.MailAccount = MailAccountValues[0].Value;
		EndIf;
	EndIf;
	
	ReadingFormData();
	TuningForm();
	
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	SavingFormData(CurrentObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	ReadingFormData();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	
	If EventName = "Sended" and Parameter = Object.Ref Then
		SetReadOnly();
	EndIf;
	
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure AddCopyRecipients(Command)
	Items.AddCopyRecipients.Visible = False;
	Items.CopyRecipients.Visible = True;
EndProcedure

&AtClient
Procedure AddBlindCopyRecipients(Command)
	Items.AddBlindCopyRecipients.Visible = False;
	Items.BlindCopyRecipients.Visible = True;
EndProcedure

&AtClient
Procedure OpenFile(Command)
	
	If Items.Attachments.CurrentData = Undefined Then
		Return;
	EndIf;

	FileRef = Items.Attachments.CurrentData.File;
	FileParameters = GetFileParameters(FileRef);
	URL = PictureViewerClient.GetPictureURL(FileParameters);
	
	Dialog = New GetFilesDialogParameters();
	GetFileFromServerAsync(URL, FileParameters.Description, Dialog);			

EndProcedure

&AtClient
Procedure EditHTML(Command)
	
	TextHTML = "";
	AttachmentsHTML = New Structure;
	//@skip-check invocation-parameter-type-intersect
	TextLetter.GetHTML(TextHTML, AttachmentsHTML);
	
	Items.GroupOfMailPages.CurrentPage = Items.PageTextHTML;

EndProcedure

&AtClient
Procedure SaveHTML(Command)
	
	ReadLetterFromHTML(TextHTML);
	
	Items.GroupOfMailPages.CurrentPage = Items.PageDocHTML;

EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure ReadingFormData()

	LoadAddresses(Recipients, False, False);
	LoadAddresses(CopyRecipients, True, False);
	LoadAddresses(BlindCopyRecipients, True, True);
	
	NewHTML = "";
	AttachmentsHTML = New Structure;
	If ValueIsFilled(Object.Ref) Then
		SavedHTML = Object.Ref.TextLetterHTML.Get();
		If TypeOf(SavedHTML) = Type("String") Then
			NewHTML = SavedHTML;
		EndIf;
		
		SavedAttachments = Object.Ref.LetterMultimedia.Get();
		If TypeOf(SavedAttachments) = Type("Structure") Then
			AttachmentsHTML = SavedAttachments;
		EndIf;
	EndIf;
	ReadLetterFromHTML(NewHTML);

EndProcedure

&AtServer
Procedure ReadLetterFromHTML(NewHTML)
	//@skip-check invocation-parameter-type-intersect
	TextLetter.SetHTML(NewHTML, AttachmentsHTML);
EndProcedure

&AtServer
Procedure SavingFormData(CurrentObject)

	SaveAddresses(Recipients, CurrentObject, False, False);
	SaveAddresses(CopyRecipients, CurrentObject, True, False);
	SaveAddresses(BlindCopyRecipients, CurrentObject, True, True);

	NewHTML = "";
	AttachmentsHTML = New Structure;
	//@skip-check invocation-parameter-type-intersect
	TextLetter.GetHTML(NewHTML, AttachmentsHTML);
	
	CurrentObject.TextLetterHTML = New ValueStorage(NewHTML);
	CurrentObject.LetterMultimedia = New ValueStorage(AttachmentsHTML);
	
EndProcedure

&AtServer
Procedure TuningForm()

	If CopyRecipients.Count() > 0 Then
		Items.AddCopyRecipients.Visible = False;
		Items.CopyRecipients.Visible = True;
	EndIf;
	
	If BlindCopyRecipients.Count() > 0 Then
		Items.AddBlindCopyRecipients.Visible = False;
		Items.BlindCopyRecipients.Visible = True;
	EndIf;
	
	Query = New Query;
	Query.SetParameter("Message", Object.Ref);
	Query.Text =
	"SELECT Message
	|	FROM InformationRegister.MessagesQueueToSend
	|	WHERE Message = &Message";
	QuerySelect = Query.Execute().Select();
	If QuerySelect.Next() Then
		SetReadOnly();
	EndIf;
	
EndProcedure

&AtServer
Procedure SetReadOnly()
	
	ThisForm.ReadOnly = True;
	
	Items.Recipients.ReadOnly = True;
	Items.CopyRecipients.ReadOnly = True;
	Items.BlindCopyRecipients.ReadOnly = True;
	Items.TextLetter.ReadOnly = True;
	
	Items.AddCopyRecipients.Enabled = False;
	Items.AddBlindCopyRecipients.Enabled = False;
	
EndProcedure

&AtServer
//@skip-check typed-value-adding-to-untyped-collection
Procedure LoadAddresses(AddressesList, isCopy, isBlind)
	AddressesList.Clear();
	
	AddressesRecords = Object.LetterRecipients.FindRows(New Structure("isCopy, isBlind", isCopy, isBlind));
	For Each AddresseItem In AddressesRecords Do
		NewRecord = AddressesList.Add(AddresseItem.Addressee);
		If ValueIsFilled(AddresseItem.Destination) Then
			NewRecord.Presentation = String(AddresseItem.Destination);
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure SaveAddresses(AddressesList, CurrentObject, isCopy, isBlind)
	
	ToDeleting = New Array;
	AddressesRecords = CurrentObject.LetterRecipients.FindRows(New Structure("isCopy, isBlind", isCopy, isBlind));
	For Each AddressItem In AddressesRecords Do
		If AddressesList.FindByValue(AddressItem) = Undefined Then
			//@skip-check typed-value-adding-to-untyped-collection
			ToDeleting.Add(AddressItem);
		Else
			AddressesList.FindByValue(AddressItem).Check = True;
		EndIf;
	EndDo;
	For Each AddressItem In ToDeleting Do
		//@skip-check invocation-parameter-type-intersect
		CurrentObject.LetterRecipients.Delete(AddressItem);
	EndDo;
	
	For Each ListItem In AddressesList Do
		If Not ListItem.Check And ValueIsFilled(ListItem.Value) Then
			AddressItem = CurrentObject.LetterRecipients.Add();
			AddressItem.Addressee = TrimAll(String(ListItem.Value));
			AddressItem.IsCopy = isCopy;
			AddressItem.isBlind = isBlind;
		EndIf;
	EndDo;
	
EndProcedure

&AtServerNoContext
Function GetFileParameters(FileRef)
	Return PictureViewerServer.CreatePictureParameters(FileRef);
EndFunction

#EndRegion
