&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	SalesOrdersList.Parameters.SetParameterValue("Partner", Object.Ref);
	CommonFunctionsServer.SetConditionalAppearanceDataField(ThisObject, "SalesOrdersList.Date");
	IDInfoServer.OnCreateAtServer(ThisObject, "GroupContactInformation");
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	Items.Parent.Visible = GetFunctionalOption("ShowAlfaTestingSaas");
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

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

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	IDInfoClient.NotificationProcessing(ThisObject, Object.Ref, EventName, Parameter, Source);
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControll();
	EndIf;
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControll()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	IDInfoServer.AfterWriteAtServer(ThisObject, CurrentObject, WriteParameters);
EndProcedure

