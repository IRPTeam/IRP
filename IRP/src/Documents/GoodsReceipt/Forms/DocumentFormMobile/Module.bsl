#Region FormEvents

&AtClient
Procedure OnOpen(Cancel)
	DocGoodsReceiptClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocGoodsReceiptServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure SelectReceiptBasises(Command)
	DocGoodsReceiptClient.SelectReceiptBasises(Object, ThisObject, Command);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

#EndRegion


#Region DescriptionEvents

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocGoodsReceiptClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocGoodsReceiptClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure


&AtClient
Procedure SearchByBarcode(Command)
	DocGoodsReceiptClient.SearchByBarcode(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure LegalNameOnChange(Item)
	DocGoodsReceiptClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerOnChange(Item)
	DocGoodsReceiptClient.PartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocGoodsReceiptClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyOnChange(Item)
	DocGoodsReceiptClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocGoodsReceiptClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocGoodsReceiptClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocGoodsReceiptClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	DocGoodsReceiptClient.ItemListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure InputTypeOnChange(Item)
	DocGoodsReceiptClient.InputTypeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemBasisListOnChange(Item)
	DocGoodsReceiptClient.ItemBasisListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SerialLotNumberListOnChange(Item)
	DocGoodsReceiptClient.SerialLotNumberListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure GroupPagesOnCurrentPageChange(Item, CurrentPage)
	DocGoodsReceiptClient.GroupPagesOnCurrentPageChange(Object, ThisObject, Item, CurrentPage);
EndProcedure

