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
	DocInventoryTransferOrderServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocInventoryTransferOrderServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocInventoryTransferOrderServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocInventoryTransferOrderClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocInventoryTransferOrderClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	If Clone Then
		Item.CurrentData.Key = New UUID();
	EndIf;
EndProcedure

&AtServerNoContext
Function GetAttributeValueByName(Ref, AttrName) Export
	Return Ref[AttrName];
EndFunction

&AtClient
Procedure ItemListItemOnChange(Item)
	DocInventoryTransferOrderClient.ItemListItemOnChange(Object, ThisObject, Item);
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
Procedure ItemListQuantityOnChange(Item)
	DocInventoryTransferOrderClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocInventoryTransferOrderClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationStatusHistoryClick(Item)
	ObjectStatusesClient.OpenHistoryByStatus(Object.Ref, ThisObject);
EndProcedure

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item)
	DocInventoryTransferOrderClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocInventoryTransferOrderClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocInventoryTransferOrderClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemStatus

&AtClient
Procedure StatusOnChange(Item)
	DocInventoryTransferOrderClient.StatusOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region StoreInfo

&AtClient
Procedure StoreSenderOnChange(Item)
	DocInventoryTransferOrderClient.StoreSenderOnChange(Object, ThisObject, Item);
	StoreSenderOnChangeAtServer();
EndProcedure

&AtServer
Procedure StoreSenderOnChangeAtServer()
	DocInventoryTransferOrderServer.StoreSenderOnChange(Object);
EndProcedure

&AtClient
Procedure StoreReceiverOnChange(Item)
	DocInventoryTransferOrderClient.StoreReceiverOnChange(Object, ThisObject, Item);
	StoreReceiverOnChangeAtServer();
EndProcedure

&AtServer
Procedure StoreReceiverOnChangeAtServer()
	DocInventoryTransferOrderServer.StoreReceiverOnChange(Object);
EndProcedure

#EndRegion

&AtClient
Procedure OpenPickupItems(Command)
	DocInventoryTransferOrderClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocInventoryTransferOrderClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocInventoryTransferOrderClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocInventoryTransferOrderClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocInventoryTransferOrderClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocInventoryTransferOrderClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocInventoryTransferOrderClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocInventoryTransferOrderClient.SearchByBarcode(Barcode, Object, ThisObject);
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

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

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

&AtClient
Procedure AfterWrite(WriteParameters)
	Notify("WriteProcurementOrder", , ThisObject);
EndProcedure

#EndRegion

#Region LinkedDocuments

&AtClient
Function GetLinkedDocumentsFilter()
	Filter = New Structure();
	Filter.Insert("Company" , Object.Company);
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
