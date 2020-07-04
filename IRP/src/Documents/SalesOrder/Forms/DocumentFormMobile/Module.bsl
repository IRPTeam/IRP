#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	DocSalesOrderServer.OnCreateAtServerMobile(Object, ThisObject, Cancel, StandardProcessing);
	
	ThisObject.TaxAndOffersCalculated = True;
	
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	DocSalesOrderClient.NotificationProcessing(Object, ThisObject, EventName, Parameter, Source);
EndProcedure

&AtClient
Procedure BeforeWrite(Cancel, WriteParameters)
	DocSalesOrderClient.BeforeWrite(Object, ThisObject, Cancel, WriteParameters);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocSalesOrderClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

#EndRegion

#Region ItemListEvents

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocSalesOrderClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocSalesOrderClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PartnerEvents

&AtClient
Procedure PartnerOnChange(Item)
	Settings = New Structure();
	Settings.Insert("Actions", New Structure());
	DocSalesOrderClient.PartnerOnChange(Object, ThisObject, Item, Settings);
EndProcedure

#EndRegion

#Region AgreementEvents

&AtClient
Procedure AgreementOnChange(Item)
	DocSalesOrderClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PriceIncludeTaxEvents

&AtClient
Procedure PriceIncludeTaxOnChange(Item)
	DocSalesOrderClient.PriceIncludeTaxOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion


#Region SpecialOffers

#Region AutomaticalOffers

&AtClient
Procedure SetSpecialOffers(Command)
	OffersClient.OpenFormPickupSpecialOffers_ForDocument(Object,
		ThisObject,
		"SpecialOffersEditFinish_Automatically");
EndProcedure

&AtClient
Procedure SpecialOffersEditFinish_Automatically(Result, AdditionalParameters) Export
	OffersClient.SpecialOffersEditFinish_ForDocument(Result, Object, ThisObject, AdditionalParameters);
EndProcedure

#EndRegion

#Region ManualInputValueOffers

&AtClient
Procedure CheckOffersInRow(Command)
	OffersClient.OpenFormPickupSpecialOffers_ForRow(Object,
		Items.ItemList.CurrentData,
		ThisObject,
		"SpecialOffersEditFinish_Manual");
EndProcedure

&AtClient
Procedure SpecialOffersEditFinish_Manual(Result, AdditionalParameters) Export
	OffersClient.SpecialOffersEditFinish_ForRow(Result, Object, ThisObject, AdditionalParameters);
EndProcedure

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesOrderClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocSalesOrderClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure DeliveryDateOnChange(Item)
	Return;
EndProcedure

#EndRegion

#EndRegion


&AtClient
Procedure SearchByBarcode(Command)
	DocSalesOrderClient.SearchByBarcode(Command, Object, ThisObject);
EndProcedure

&AtClient
Procedure CommandEmpty(Command)
	Return;
EndProcedure

&AtClient
Procedure ChangeRowQuantity(Row) Export
	
	NotifyParameters = New Structure;
	NotifyParameters.Insert("CurrentRow", Row);
	NotifyDescription = "Input quantity";
	Notify = New NotifyDescription("ChangeQuantityEnd", THisObject, NotifyParameters);
	ShowInputNumber(Notify, Row.Quantity, NotifyDescription);
	
EndProcedure

&AtClient
Procedure ChangeQuantity(Command)
	CurrentRow = Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	ChangeRowQuantity(CurrentRow);
EndProcedure


&AtClient
Procedure ChangeQuantityEnd(InputNumber, Parameters) Export
	If Not InputNumber = Undefined Then
		CurrentRow = Parameters.CurrentRow;
		CurrentRow.Quantity = InputNumber;
		DocSalesOrderClient.ItemListOnChange(Object, ThisObject);
	EndIf;
EndProcedure

