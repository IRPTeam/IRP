#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
	
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocStockAdjustmentAsSurplusServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocStockAdjustmentAsSurplusServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocStockAdjustmentAsSurplusClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	DocStockAdjustmentAsSurplusClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocStockAdjustmentAsSurplusServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocStockAdjustmentAsSurplusClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	If Clone Then
		Item.CurrentData.Key = New UUID();
	EndIf;
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocStockAdjustmentAsSurplusClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemOnChange(Item)
	DocStockAdjustmentAsSurplusClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocStockAdjustmentAsSurplusClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocStockAdjustmentAsSurplusClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocStockAdjustmentAsSurplusClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListSerialLotNumbersPresentationStartChoice(Item, ChoiceData, StandardProcessing, AddInfo = Undefined) Export
	DocStockAdjustmentAsSurplusClient.ItemListSerialLotNumbersPresentationStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListSerialLotNumbersPresentationClearing(Item, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.ItemListSerialLotNumbersPresentationClearing(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocStockAdjustmentAsSurplusClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListRevenueTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.ItemListRevenueTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListRevenueTypeEditTextChange(Item, Text, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.ItemListRevenueTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item)
	DocStockAdjustmentAsSurplusClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure StoreOnChange(Item)
	DocStockAdjustmentAsSurplusClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocStockAdjustmentAsSurplusClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocStockAdjustmentAsSurplusClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocStockAdjustmentAsSurplusClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocStockAdjustmentAsSurplusClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocStockAdjustmentAsSurplusClient.SearchByBarcode(Barcode, Object, ThisObject);
EndProcedure

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

#Region LinkedDocuments

&AtClient
Function GetLinkedDocumentsFilter()
	Filter = New Structure();
	Filter.Insert("Store"   , Object.Store);
	Filter.Insert("Ref"     , Object.Ref);
	Return Filter;
EndFunction

&AtClient
Procedure LinkUnlinkBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter"           , GetLinkedDocumentsFilter());
	FormParameters.Insert("SelectedRowInfo"  , RowIDInfoClient.GetSelectedRowInfo(Items.ItemList.CurrentData));
	FormParameters.Insert("TablesInfo"       , RowIDInfoClient.GetTablesInfo(Object));
	OpenForm("CommonForm.LinkUnlinkDocumentRows"
		, FormParameters, , , ,
		, New NotifyDescription("AddOrLinkUnlinkDocumentRowsContinue", ThisObject)
		, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AddBasisDocuments(Command)	
	FormParameters = New Structure();
	FormParameters.Insert("Filter"           , GetLinkedDocumentsFilter());
	FormParameters.Insert("TablesInfo"       , RowIDInfoClient.GetTablesInfo(Object));
	OpenForm("CommonForm.AddLinkedDocumentRows"
		, FormParameters, , , ,
		, New NotifyDescription("AddOrLinkUnlinkDocumentRowsContinue", ThisObject)
		, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure


&AtClient
Procedure AddOrLinkUnlinkDocumentRowsContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	AddOrLinkUnlinkDocumentRowsContinueAtServer(Result);
EndProcedure

&AtServer
Procedure AddOrLinkUnlinkDocumentRowsContinueAtServer(Result)
	If Result.Operation = "LinkUnlinkDocumentRows" Then
		RowIDInfoServer.LinkUnlinkDocumentRows(Object, Result.FillingValues);
	ElsIf Result.Operation = "AddLinkedDocumentRows" Then
		RowIDInfoServer.AddLinkedDocumentRows(Object, Result.FillingValues);
	EndIf;
EndProcedure

#EndRegion
