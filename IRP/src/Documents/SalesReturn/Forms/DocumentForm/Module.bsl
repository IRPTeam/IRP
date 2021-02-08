
#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocSalesReturnServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocSalesReturnClient.OnOpen(Object, ThisObject, Cancel);
	SetLockedRowsByGoodsReceipts();
	UpdateGoodsReceiptsTree();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
	
	If Not Source = ThisObject Then
		Return;
	EndIf;
	
	DocSalesReturnClient.NotificationProcessing(Object, ThisObject, EventName, Parameter, Source);

	ServerData = Undefined;		
	If TypeOf(Parameter) = Type("Structure") And Parameter.Property("AddInfo") Then
		ServerData = CommonFunctionsClientServer.GetFromAddInfo(Parameter.AddInfo, "ServerData");
	EndIf;
	
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
	
	If Upper(EventName) = Upper("CallbackHandler") Then
		CurrenciesClient.CalculateAmount(Object, ThisObject);
		CurrenciesClient.SetRatePresentation(Object, ThisObject);
				
		If ServerData <> Undefined Then
			CurrenciesClient.SetVisibleRows(Object, ThisObject, Parameter.AddInfo);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure BeforeWrite(Cancel, WriteParameters)
	Return;
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters, AddInfo = Undefined) Export
	DocSalesReturnClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
	SetLockedRowsByGoodsReceipts();
	UpdateGoodsReceiptsTree();	
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	DocSalesReturnServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocSalesReturnServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form) Export
	Form.Items.LegalName.Enabled = ValueIsFilled(Object.Partner);
EndProcedure

#EndRegion

#Region FormItemsEvents

&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure StoreOnChange(Item)
	DocSalesReturnClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnClient.PartnerOnChange(Object, ThisObject, Item);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure LegalNameOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AgreementOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PriceIncludeTaxOnChange(Item)
	DocSalesReturnClient.PriceIncludeTaxOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CurrencyOnChange(Item)
	DocSalesReturnClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemListEvents

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocSalesReturnClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	ClearGoodsReceiptsTable();
	UpdateGoodsReceiptsTree();
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	If Clone Then
		Item.CurrentData.Key = New UUID();
	EndIf;
	DocumentsClient.TableOnStartEdit(Object, ThisObject, "Object.ItemList", Item, NewRow, Clone);
EndProcedure

&AtClient
Procedure ItemListOnActivateRow(Item)
	DocSalesReturnClient.ItemListOnActivateRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	DocSalesReturnClient.ItemListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemListItemsEvents

&AtClient
Procedure ItemListItemOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemKeyOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListUnitOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnClient.ItemListUnitOnChange(Object, ThisObject, Item);
	UpdateGoodsReceiptsTree();
EndProcedure

&AtClient
Procedure ItemListQuantityOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnClient.ItemListQuantityOnChange(Object, ThisObject, Item);
	UpdateGoodsReceiptsTree();
EndProcedure

&AtClient
Procedure ItemListPriceOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnClient.ItemListPriceOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListTotalAmountOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnClient.ItemListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListTaxAmountOnChange(Item)
	DocSalesReturnClient.ItemListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListDontCalculateRowOnChange(Item)
	DocSalesReturnClient.ItemListDontCalculateRowOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListStoreOnChange(Item)
	DocSalesReturnClient.ItemListStoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemPartner

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemLegalName

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemAgreement

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemCompany

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region DescriptionEvents

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocumentsClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region Taxes
&AtClient
Procedure TaxValueOnChange(Item) Export
	DocSalesReturnClient.ItemListTaxValueOnChange(Object, ThisObject, Item);
EndProcedure

&AtServer
Function Taxes_CreateFormControls(AddInfo = Undefined) Export
	Return TaxesServer.CreateFormControls_RetailDocuments(Object, ThisObject, AddInfo);
EndFunction

#EndRegion

#Region Commands

&AtClient
Procedure OpenPickupItems(Command)
	DocSalesReturnClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocSalesReturnClient.SearchByBarcode(Barcode, Object, ThisObject);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

#Region Currencies

&AtClient
Procedure CurrenciesSelection(Item, RowSelected, Field, StandardProcessing, AddInfo = Undefined)
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ExecuteAtClient", True);
	CurrenciesClient.CurrenciesTable_Selection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing, AddInfo);
EndProcedure

&AtClient
Procedure CurrenciesRatePresentationOnChange(Item, AddInfo = Undefined)
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ExecuteAtClient", True);
	CurrenciesClient.CurrenciesTable_RatePresentationOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure CurrenciesMultiplicityOnChange(Item, AddInfo = Undefined)
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ExecuteAtClient", True);
	CurrenciesClient.CurrenciesTable_MultiplicityOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure CurrenciesAmountOnChange(Item, AddInfo = Undefined)
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ExecuteAtClient", True);
	CurrenciesClient.CurrenciesTable_AmountOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure CurrenciesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure CurrenciesBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion

#Region ExternalCommands

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

#Region SerialLotNumbers

&AtClient
Procedure ItemListSerialLotNumbersPresentationStartChoice(Item, ChoiceData, StandardProcessing, AddInfo = Undefined) Export
	SerialLotNumberClient.PresentationStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListSerialLotNumbersPresentationClearing(Item, StandardProcessing)
	SerialLotNumberClient.PresentationClearing(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region GoodsReceiptsTree

&AtClient
Procedure SetLockedRowsByGoodsReceipts()
	If Not Object.GoodsReceipts.Count() Then
		Return;
	EndIf;
	
	For Each Row In Object.ItemList Do
		Row.LockedRow = Object.GoodsReceipts.FindRows(New Structure("Key", Row.Key)).Count() > 0;
	EndDo;
EndProcedure

&AtClient
Procedure ClearGoodsReceiptsTable()
	If Not Object.GoodsReceipts.Count() Then
		Return;
	EndIf;
	
	ArrayOfRows = New Array();
	For Each Row In Object.GoodsReceipts Do
		If Not Object.ItemList.FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayOfRows.Add(Row);
		EndIf;
	EndDo;
	
	For Each Row In ArrayOfRows Do
		Object.GoodsReceipts.Delete(Row);
	EndDo;
EndProcedure	

&AtClient
Procedure UpdateGoodsReceiptsTree()
	ThisObject.GoodsReceiptsTree.GetItems().Clear();
	
	If Not Object.GoodsReceipts.Count() Then
		Return;
	EndIf;
	
	ArrayOfRows = New Array();
	For Each Row In Object.ItemList Do
		ArrayOfGoodsReceipts = Object.GoodsReceipts.FindRows(New Structure("Key", Row.Key));
		
		If Not ArrayOfGoodsReceipts.Count() Then
			Continue;
		EndIf;
		
		NewRow = New Structure();
		NewRow.Insert("Key"         , Row.Key);
		NewRow.Insert("Item"        , Row.Item);
		NewRow.Insert("ItemKey"     , Row.ItemKey);
		NewRow.Insert("QuantityUnit", Row.Unit);
		NewRow.Insert("Unit"        );
		NewRow.Insert("Quantity"    , Row.Quantity);
		ArrayOfRows.Add(NewRow);
	EndDo;
	RecalculateInvoiceQuantity(ArrayOfRows);

	For Each Row In ArrayOfRows Do		
		NewRow0 = ThisObject.GoodsReceiptsTree.GetItems().Add();
		NewRow0.Level             = 1;
		NewRow0.Key               = Row.Key;
		NewRow0.Item              = Row.Item;
		NewRow0.ItemKey           = Row.ItemKey;
		NewRow0.QuantityInInvoice = Row.Quantity;
		
		ArrayOfGoodsReceipts = Object.GoodsReceipts.FindRows(New Structure("Key", Row.Key));
		
		If ArrayOfGoodsReceipts.Count() = 1 
		And ArrayOfGoodsReceipts[0].Quantity <> Row.Quantity Then
			ArrayOfGoodsReceipts[0].Quantity = Row.Quantity;
		EndIf;
		
		For Each ItemOfArray In ArrayOfGoodsReceipts Do
			NewRow1 = NewRow0.GetItems().Add();
			NewRow1.Level                  = 2;
			NewRow1.Key                    = ItemOfArray.Key;
			NewRow1.GoodsReceipt           = ItemOfArray.GoodsReceipt;
			NewRow1.Quantity               = ItemOfArray.Quantity;
			NewRow1.QuantityInGoodsReceipt = ItemOfArray.QuantityInGoodsReceipt;
			NewRow1.PictureEdit            = True;
			NewRow0.Quantity               = NewRow0.Quantity + ItemOfArray.Quantity;
			NewRow0.QuantityInGoodsReceipt = NewRow0.QuantityInGoodsReceipt + ItemOfArray.QuantityInGoodsReceipt;
		EndDo;
	EndDo;
	
	For Each ItemTreeRows In ThisObject.GoodsReceiptsTree.GetItems() Do
		ThisObject.Items.GoodsReceiptsTree.Expand(ItemTreeRows.GetID());
	EndDo;	
EndProcedure

&AtServerNoContext
Procedure RecalculateInvoiceQuantity(ArrayOfRows)
	For Each Row In ArrayOfRows Do
		Row.Unit = ?(ValueIsFilled(Row.ItemKey.Unit), 
		Row.ItemKey.Unit, Row.ItemKey.Item.Unit);
		DocumentsServer.RecalculateQuantityInRow(Row);
	EndDo;
EndProcedure	

&AtClient
Procedure GoodsReceiptsTreeQuantityOnChange(Item)
	CurrentRow = Items.GoodsReceiptsTree.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	RowParent = CurrentRow.GetParent();
	TotalQuantity = 0;
	For Each Row In RowParent.GetItems() Do
		TotalQuantity = TotalQuantity + Row.Quantity;
	EndDo;
	RowParent.Quantity = TotalQuantity;
	ArrayOfRows = Object.GoodsReceipts.FindRows(
	New Structure("Key, GoodsReceipt", CurrentRow.Key, CurrentRow.GoodsReceipt));
	For Each Row In ArrayOfRows Do
		Row.Quantity = CurrentRow.Quantity;
	EndDo;
EndProcedure

&AtClient
Procedure GoodsReceiptsTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;	
EndProcedure

&AtClient
Procedure GoodsReceiptsTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

#EndRegion

