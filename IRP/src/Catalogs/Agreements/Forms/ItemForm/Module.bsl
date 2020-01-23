#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	CatAgreementsClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

#EndRegion


&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure


#Region ItemCompany

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	CatAgreementsClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	CatAgreementsClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemPartner

&AtClient
Procedure PartnerOnChange(Item)
	Object.LegalName = DocumentsServer.GetLegalNameByPartner(Object.Partner, Object.LegalName);
EndProcedure

#EndRegion

#Region ItemLegalName

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	CatAgreementsClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	CatAgreementsClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion


#Region ItemPartnerSegment

&AtClient
Procedure PartnerSegmentStartChoice(Item, ChoiceData, StandardProcessing)
	CatAgreementsClient.PartnerSegmentStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerSegmentEditTextChange(Item, Text, StandardProcessing)
	CatAgreementsClient.PartnerSegmentTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemType

&AtClient
Procedure TypeOnChange(Item)
	CatAgreementsClient.TypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure ApArPostingDetailOnChange(Item)
	CatAgreementsClient.ApArPostingDetailOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure KindOnChange(Item)
	CatAgreementsClient.KindOnChange(Object, ThisObject, Item);
EndProcedure

