
#Region FormEvents

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	IDInfoServer.AfterWriteAtServer(ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	IDInfoClient.NotificationProcessing(ThisObject, Object.Ref, EventName, Parameter, Source);
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
	If EventName = "UpdateIDInfo" Then
		IDInfoCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	IDInfoServer.OnCreateAtServer(ThisObject, "GroupContactInformation");
EndProcedure

#EndRegion

&AtClient
Procedure UseGoodsReceiptOnChange(Item)
	If Not Object.UseGoodsReceipt  And ValueIsFilled(Object.Ref) Then
		If CheckGoodsInTransitIncoming() Then
			Object.UseGoodsReceipt = True;
		 	ThisObject.Modified = False;
		 	ShowMessageBox(, StrTemplate(R().Error_053, String(Object.Ref)));
		 EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure UseShipmentConfirmationOnChange(Item)
	If Not Object.UseShipmentConfirmation And ValueIsFilled(Object.Ref) Then
		 If CheckGoodsInTransitOutgoing() Then
		 	Object.UseShipmentConfirmation = True;
		 	ThisObject.Modified = False;
		 	ShowMessageBox(, StrTemplate(R().Error_052, String(Object.Ref)));
		 EndIf;
	EndIf;
EndProcedure

&AtServer
Function CheckGoodsInTransitIncoming()
	
	Query = New Query;
	Query.Text =
		"SELECT TOP 1
		|	GoodsInTransitIncoming.ReceiptBasis
		|FROM
		|	AccumulationRegister.GoodsInTransitIncoming AS GoodsInTransitIncoming
		|WHERE
		|	GoodsInTransitIncoming.Store = &Store";
	
	Query.SetParameter("Store", Object.Ref);
	
	Return Not Query.Execute().IsEmpty();
	
EndFunction

&AtServer
Function CheckGoodsInTransitOutgoing()
	Query = New Query;
	Query.Text =
		"SELECT TOP 1
		|	GoodsInTransitOutgoing.ShipmentBasis
		|FROM
		|	AccumulationRegister.GoodsInTransitOutgoing AS GoodsInTransitOutgoing
		|WHERE
		|	GoodsInTransitOutgoing.Store = &Store";
	
	Query.SetParameter("Store", Object.Ref);
	
	Return Not Query.Execute().IsEmpty();
EndFunction

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region IDInfo

&AtClient
Procedure IDInfoOpening(Item, StandardProcessing) Export
	IDInfoClient.IDInfoOpening(Item, StandardProcessing, Object, ThisObject);
EndProcedure

&AtClient
Procedure StartEditIDInfo(Result, Parameters) Export
	IDInfoClient.StartEditIDInfo(ThisObject, Result, Parameters);
EndProcedure

&AtClient
Procedure EndEditIDInfo(Result, Parameters) Export
	IDInfoClient.EndEditIDInfo(Object, Result, Parameters);
EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtServer
Procedure IDInfoCreateFormControl()
	IDInfoServer.CreateFormControls(ThisObject);
EndProcedure

#EndRegion