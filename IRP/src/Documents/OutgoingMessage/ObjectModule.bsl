// @strict-types

#If Server Or ThickClientOrdinaryApplication Or ExternalConnection Then

#Region Public

// Enter code here.

#EndRegion

#Region EventHandlers

Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	RecipientsArray = New Array; // Array of String
	For Each AddressItem In LetterRecipients Do
		RecipientsArray.Add(AddressItem.Addressee);
	EndDo;
	LetterRecipientsString = StrConcat(RecipientsArray, "; ");
	
	HasAttachments = Attachments.Count() > 0;
	
	TextLetter = TextLetterHTML.Get();
	If TextLetter = Undefined Then
		TextLetter = "";
	EndIf;
	LetterSize = StrLen(TextLetter) * 4;
	
	For Each AttachmentItem In Attachments Do
		LetterSize = LetterSize + AttachmentItem.File.SizeBytes; 
	EndDo;
	
EndProcedure

//@skip-check statement-type-change, property-return-type
Procedure Filling(FillingData, FillingText, StandardProcessing)
	
	If TypeOf(FillingData) = Type("Structure") Then
		
		If FillingData.Property("Subject") Then
			ThisObject.Subject = FillingData.Subject;
		EndIf;
		
		If FillingData.Property("BasisDocument") Then
			ThisObject.BasisDocument = FillingData.BasisDocument;
			FillingByBasisDocument();			 
		EndIf;
		
		If FillingData.Property("FileRef") Then
			If ValueIsFilled(FillingData.FileRef) Then
				FileRecord = Attachments.Add();
				FileRecord.File = FillingData.FileRef;
				FileRecord.PresentationInLetter = String(FillingData.FileRef);
			EndIf;
		EndIf;
		
	EndIf;

EndProcedure

#EndRegion

#Region Private

//@skip-check invocation-parameter-type-intersect, property-return-type, statement-type-change
Procedure FillingByBasisDocument()
	
	If NOT ValueIsFilled(ThisObject.BasisDocument) Then
		Return;
	EndIf;
	
	If IsBlankString(ThisObject.Subject) Then
		ThisObject.Subject = String(ThisObject.BasisDocument);
	EndIf;
	
	EmailTypes = New Array; // Array of Type
	EmailTypes.Add(Type("CatalogRef.Partners"));
	EmailTypes.Add(Type("CatalogRef.RetailCustomers"));
	EmailTypes.Add(Type("CatalogRef.Users"));
	
	For Each MetaAttribute In ThisObject.BasisDocument.Metadata().Attributes Do
		AttributeName = MetaAttribute.Name;
		AttributeValue = ThisObject.BasisDocument[AttributeName]; // Arbitrary
		If ValueIsFilled(AttributeValue) Then
			Continue;
		EndIf;
		
		For Each EmailType In EmailTypes Do
			If MetaAttribute.Type.ContainsType(EmailType) AND TypeOf(AttributeValue) = EmailType Then
				AddressRecord = ThisObject.LetterRecipients.Add();
				AddressRecord.Addressee = AttributeValue.Email;
				AddressRecord.Destination = AttributeValue;
				Break;
			EndIf;
		EndDo;
	EndDo;
	
EndProcedure

#EndRegion

#EndIf
