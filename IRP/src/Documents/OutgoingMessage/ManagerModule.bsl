// @strict-types
 
#Region Public

// Send message.
// 
// Parameters:
//  Message - DocumentRef.OutgoingMessage - Message
Procedure SendMessage(Message) Export
	
	If Message.MessageType = Enums.MessageTypes.Email Then
		SendEmail(Message);
	Else
		Raise R().ATC_001;
	EndIf;
			
EndProcedure

// Send Email.
// 
// Parameters:
//  Message - DocumentRef.OutgoingMessage - Message
//@skip-check property-return-type, statement-type-change, invocation-parameter-type-intersect
Procedure SendEmail(Message) Export
	
	MessageDescription = EmailMessageServer.GetMessageDescription();
	
	MessageDescription.MailAccount = Message.MailAccount;
	MessageDescription.Subject = Message.Subject;
	
	MessageDescription.Importance = 
		?(Message.Importance = Enums.MessagesImportance.High, InternetMailMessageImportance.High, 
		?(Message.Importance = Enums.MessagesImportance.Low, InternetMailMessageImportance.Low, 
			InternetMailMessageImportance.Normal));
	
	MessageDescription.RequestDeliveryReceipt = Message.NotifyDelivery;
	MessageDescription.RequestReadReceipt = Message.NotifyReading;
	
	AddressesRecords = Message.LetterRecipients.FindRows(New Structure("isCopy, isBlind", False, False));
	For Each AddressItem In AddressesRecords Do
		MessageDescription.To.Add(AddressItem.Addressee);
	EndDo;
	AddressesRecords = Message.LetterRecipients.FindRows(New Structure("isCopy, isBlind", True, False));
	For Each AddressItem In AddressesRecords Do
		MessageDescription.Cc.Add(AddressItem.Addressee);
	EndDo;
	AddressesRecords = Message.LetterRecipients.FindRows(New Structure("isCopy, isBlind", True, True));
	For Each AddressItem In AddressesRecords Do
		MessageDescription.Bcc.Add(AddressItem.Addressee);
	EndDo;
	
	For Each AttachmentItem In Message.Attachments Do
		AttachmentDescription = EmailMessageServer.GetMessageAttachmentDescription();
		AttachmentDescription.BinaryData = PictureViewerServer.GetFileBinaryData(AttachmentItem.File);
		AttachmentDescription.Description = AttachmentItem.PresentationInLetter;
		MessageDescription.Attachments.Add(AttachmentDescription);
	EndDo;
	
	MailText = Message.TextLetterHTML.Get();
	If MailText = Undefined Then
		MailText = Message.Subject;
	EndIf;
		
	SavedAttachments = Message.LetterMultimedia.Get();
	If TypeOf(SavedAttachments) = Type("Structure") Then
		For Each SavedAttachmentKeyValue In SavedAttachments Do
			PictureID = SavedAttachmentKeyValue.Key; // String
			PictureData = SavedAttachmentKeyValue.Value; // Picture
			TextID = """" + PictureID + """";
			If StrFind(MailText, "src=" + TextID) Then
				AttachmentDescription = EmailMessageServer.GetMessageAttachmentDescription();
				AttachmentDescription.CID = String(New UUID());
				AttachmentDescription.Name = PictureID;
				AttachmentDescription.Description = PictureID;
				AttachmentDescription.MIMEType = "image/png";
				
				PictureData.Convert(PictureFormat.PNG);
				AttachmentDescription.BinaryData = PictureData.GetBinaryData();
				
				MailText = StrReplace(MailText, "src=" + TextID, "src=""cid:" + AttachmentDescription.CID + """");
			EndIf; 
		EndDo;
	EndIf;
	
	MessageDescription.Texts.Add(MailText);
	
	Answer = EmailMessageServer.SendMessage(MessageDescription);
	If Not IsBlankString(Answer) Then
		Raise Answer;
	EndIf;
			
EndProcedure

#EndRegion

#Region Internal

#Region Posting_Info

// Get information about movements.
// 
// Parameters:
//  Ref - DocumentRefDocumentName - Ref
// 
// Returns:
//  Structure - Get information about movements:
// * QueryParameters - Structure - :
// ** Ref - DocumentRefDocumentName
// * QueryTextsMasterTables - Array - 
// * QueryTextsSecondaryTables - Array - 
Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region PRINT_FORM

// Get print form.
// 
// Parameters:
//  Ref - DocumentRefDocumentName - Ref
//  PrintFormName - String - Print form name
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Undefined - Get print form
Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#EndRegion