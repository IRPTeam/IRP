&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)

	If Parameters.Property("Item") And Not ValueIsFilled(Object.Ref) Then
		Object.Item = Parameters.Item;
		Items.Item.ReadOnly = True;
	EndIf;
	
	If Not ValueIsFilled(Object.Specification) Then
		AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject, "GroupAttributes");
	EndIf;
	
	If Parameters.Property("SelectedFilters") Then
		For Each Row In Parameters.SelectedFilters Do
			ThisObject[Row.Name] = Row.Value;
			Items[Row.Name].ReadOnly = True;
		EndDo;
	EndIf;
	ThisObject.UnitMode = ?(ValueIsFilled(Object.Unit), "Own", "Inherit");
	ThisObject.SpecificationMode = ValueIsFilled(Object.Specification);
	SetVisible();
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	PictureViewerClient.UpdateObjectPictures(ThisObject, Object.Ref);
	AddAttributesAndPropertiesClient.UpdateObjectAddAttributeHTML(ThisObject, Object.Ref);
EndProcedure

#Region AttributeViewer

&AtClient
Procedure AddAttributesHTMLDocumentComplete(Item)
	HTMLWindow = PictureViewerClient.InfoDocumentComplete(Item);
	AddAttributeInfo = AddAttributesAndPropertiesClient.AddAttributeInfoForHTML(Object.Ref, UUID);
	JSON = CommonFunctionsServer.SerializeJSON(AddAttributeInfo);
	HTMLWindow.fillData(JSON);
EndProcedure

#EndRegion

#Region PictureViewer

&AtClient
Procedure PictureViewHTMLDocumentComplete(Item)
	PictureViewerClient.UpdateHTMLPicture(Item, ThisForm);
EndProcedure

&AtClient
Procedure PictureViewHTMLOnClick(Item, EventData, StandardProcessing)
	StandardProcessing = True;
	If EventData.event = Undefined Then
		Return;
	EndIf;
	
	If EventData.Event.propertyName = "call1C" Then
		If Object.Ref.isEmpty() Then
			ShowMessageBox(Undefined, R()["InfoMessage_004"]);
		Else
			PictureViewerClient.HTMLEvent(ThisForm, Object, EventData.Event.Data);
		EndIf;
	EndIf;
EndProcedure

#EndRegion

&AtClient
Procedure ItemOnChange(Item)
	AddAttributesCreateFormControll();
	SetVisible();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" And Not ValueIsFilled(Object.Specification) Then
		AddAttributesCreateFormControll();
	EndIf;
	If EventName = "UpdateTypeOfItemType" Then
		OnChangeTypeOfItemType();
	EndIf;
	If EventName = "UpdateAffectPricingMD5" Then
		ThisObject.Read();
	EndIf;
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControll();
	EndIf;
	
	PictureViewerClient.HTMLEventAction(EventName, Parameter, Source, ThisForm);
EndProcedure



&AtClient
Procedure OnChangeTypeOfItemType()
	If GetTypeOfItemType(Object.Item) = PredefinedValue("Enum.ItemTypes.Service") Then
		Object.Specification = Undefined;
		ThisObject.SpecificationMode = False;
	EndIf;
	SetVisible();
EndProcedure

&AtServerNoContext
Function GetTypeOfItemType(Item)
	If Not ValueIsFilled(Item)
		Or Not ValueIsFilled(Item.ItemType) Then
		Return Enums.ItemTypes.EmptyRef();
	EndIf;
	Return Item.ItemType.Type;
EndFunction

&AtClient
Procedure SpecificationModeOnChange(Item)
	If Not ThisObject.SpecificationMode Then
		Object.Specification = Undefined;
		AddAttributesCreateFormControll();
	EndIf;
	SetVisible();
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControll()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupAttributes");
EndProcedure

&AtClient
Procedure UnitModeOnChange(Item)
	If ThisObject.UnitMode = "Inherit" Then
		Object.Unit = Undefined;
	EndIf;
	SetVisible();
EndProcedure

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If Not ValueIsFilled(Object.Specification) Then
		AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	EndIf;
EndProcedure

&AtClient
Procedure SpecificationOnChange(Item)
	SetVisible(); 
EndProcedure

&AtServer
Procedure SetVisible()
	Items.OwnUnit.Visible = ThisObject.UnitMode = "Own";
	Items.InheritUnit.Visible = ThisObject.UnitMode = "Inherit";
	Items.Specification.Visible = ThisObject.SpecificationMode;
	Items.GroupAttributes.Visible = Not ThisObject.SpecificationMode;
	Items.SpecificationMode.Visible = Not GetTypeOfItemType(Object.Item) = PredefinedValue("Enum.ItemTypes.Service");
	
	ThisObject.InheritUnit = ?(ValueIsFilled(Object.Item), Object.Item.Unit, Undefined);
	ThisObject.ItemType = ?(ValueIsFilled(Object.Item), Object.Item.ItemType, Undefined);
EndProcedure



