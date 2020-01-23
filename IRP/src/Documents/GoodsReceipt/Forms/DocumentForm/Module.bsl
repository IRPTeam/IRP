#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	DocGoodsReceiptServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocGoodsReceiptServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocGoodsReceiptClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(CurrentObject, ThisObject);
	DocGoodsReceiptServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form) Export
	BasedOnBoxingBundling = DocumentsClientServer.DocumentBasedOnBoxingBundling(Object);
	Form.Items.LegalName.Enabled = Not BasedOnBoxingBundling AND ValueIsFilled(Object.Partner);
	Form.Items.Partner.Visible = Not BasedOnBoxingBundling;
	Form.Items.LegalName.Visible = Not BasedOnBoxingBundling;
EndProcedure

&AtClient
Procedure BeforeWrite(Cancel, WriteParameters)
	// canceling multicurrency receipt basises
	CurrenciesArray = New Array();
	For Each Row In Object.ItemList Do
		If ValueIsFilled(Row.ReceiptBasisCurrency) And CurrenciesArray.Find(Row.ReceiptBasisCurrency) = Undefined Then
			CurrenciesArray.Add(Row.ReceiptBasisCurrency);
			If CurrenciesArray.Count() > 1 Then
				CommonFunctionsClientServer.ShowUsersMessage(R().S_022);
				Cancel = True;
				Break;
			EndIf;
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

#Region Store
&AtClient
Procedure StoreOnChange(Item)
	DocGoodsReceiptClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocGoodsReceiptClient.ItemListOnChange(Object, ThisObject, Item);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure ItemListOnActivateRow(Item)
	DocGoodsReceiptClient.ItemListOnActivateRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	If Clone Then
		Item.CurrentData.Key = New UUID();
	EndIf;
EndProcedure

&AtClient
Procedure ItemListItemOnChange(Item)
	DocGoodsReceiptClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	CurrentRow = Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	CalculationSettings = New Structure();
	CalculationSettings.Insert("UpdateUnit");
	CalculationStringsClientServer.CalculateItemsRow(Object,
		CurrentRow,
		CalculationSettings);
EndProcedure

&AtClient
Procedure ItemListReceiptBasisOnChange(Item)
	Items.ItemList.CurrentData.ReceiptBasisCurrency = 
			ServiceSystemServer.GetCompositeObjectAttribute(Items.ItemList.CurrentData.ReceiptBasis, "Currency");
EndProcedure

&AtClient
Procedure ItemListReceiptBasisStartChoice(Item, ChoiceData, StandardProcessing)
	DocGoodsReceiptClient.ItemListReceiptBasisStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item)
	DocGoodsReceiptClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocGoodsReceiptClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocGoodsReceiptClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion


&AtClient
Procedure InputTypeOnChange(Item)
	DocGoodsReceiptClient.InputTypeOnChange(Object, ThisObject, Item);
EndProcedure


#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocGoodsReceiptClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLalelClick(Item)
	DocGoodsReceiptClient.DecorationGroupTitleCollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocGoodsReceiptClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLalelClick(Item)
	DocGoodsReceiptClient.DecorationGroupTitleUncollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion


&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocGoodsReceiptClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region Item
&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocGoodsReceiptClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocGoodsReceiptClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemPartner

&AtClient
Procedure PartnerOnChange(Item)
	DocGoodsReceiptClient.PartnerOnChange(Object, ThisObject, Item);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocGoodsReceiptClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocGoodsReceiptClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemLegalName

&AtClient
Procedure LegalNameOnChange(Item)
	DocGoodsReceiptClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocGoodsReceiptClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocGoodsReceiptClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Commands

&AtClient
Procedure SearchByBarcode(Command)
	DocGoodsReceiptClient.SearchByBarcode(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure GroupMainPagesOnCurrentPageChange(Item, CurrentPage)
	DocGoodsReceiptClient.GroupPagesOnCurrentPageChange(Object, ThisObject, Item, CurrentPage);
EndProcedure

&AtClient
Procedure SelectReceiptBasises(Command)
	DocGoodsReceiptClient.SelectReceiptBasises(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure FillReceiptBasis(Command)
	DocGoodsReceiptClient.FillReceiptBasises(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);	
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure


#EndRegion

