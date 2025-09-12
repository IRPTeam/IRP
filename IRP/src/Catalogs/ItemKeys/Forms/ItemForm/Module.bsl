
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	
	If Parameters.Property("Item") And Not ValueIsFilled(Object.Ref) Then
		Object.Item = Parameters.Item;
		Items.Item.ReadOnly = True;
	EndIf;
	
	If ValueIsFilled(Object.Ref) Then
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
	ThisObject.PackageUnitMode = ?(ValueIsFilled(Object.PackageUnit), "Own", "Inherit");
	ThisObject.ConsignorInfoMode = ?(Object.ConsignorsInfo.Count()>0, "Own", "Inherit");
	ThisObject.SpecificationMode = ValueIsFilled(Object.Specification);
	SetVisible();
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	FillInheritConsignorsInfo();
	
	IsUseCommissionTrading = FOServer.IsUseCommissionTrading();
	Items.ConsignorInfoMode.Visible = Items.ConsignorInfoMode.Visible And IsUseCommissionTrading;
	Items.InheritConsignorsInfo.Visible = Items.InheritConsignorsInfo.Visible And IsUseCommissionTrading;
	Items.ConsignorsInfo.Visible = Items.ConsignorsInfo.Visible And IsUseCommissionTrading;
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
	JSON = AddAttributesAndPropertiesClient.AddAttributeInfoForHTML(Object.Ref, UUID);
	HTMLWindow.fillData(JSON);
EndProcedure

#EndRegion

#Region PictureViewer

&AtClient
Async Procedure PictureViewHTMLDocumentComplete(Item)
	PictureViewerClient.UpdateHTMLPicture(Item, ThisObject);
EndProcedure

&AtClient
Async Procedure PictureViewHTMLOnClick(Item, EventData, StandardProcessing)
	PictureViewerClient.PictureViewHTMLOnClick(ThisObject, Item, EventData, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure ItemOnChange(Item)
	AddAttributesCreateFormControl();
	SetVisible();
	FillInheritConsignorsInfo();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" And Not ValueIsFilled(Object.Specification) Then
		AddAttributesCreateFormControl();
	EndIf;
	If EventName = "UpdateTypeOfItemType" Then
		OnChangeTypeOfItemType();
	EndIf;
	If EventName = "UpdateAffectPricingMD5" Then
		ThisObject.Read();
	EndIf;
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;

	PictureViewerClient.HTMLEventAction(EventName, Parameter, Source, ThisObject);
EndProcedure

&AtClient
Procedure OnChangeTypeOfItemType()
	TypeOfItemType = GetTypeOfItemType(Object.Item);
	If TypeOfItemType = PredefinedValue("Enum.ItemTypes.Service") OR TypeOfItemType = PredefinedValue("Enum.ItemTypes.Certificate") Then
		Object.Specification = Undefined;
		ThisObject.SpecificationMode = False;
	EndIf;
	SetVisible();
EndProcedure

&AtServerNoContext
Function GetTypeOfItemType(Item)
	If Not ValueIsFilled(Item) Or Not ValueIsFilled(Item.ItemType) Then
		Return Enums.ItemTypes.EmptyRef();
	EndIf;
	Return Item.ItemType.Type;
EndFunction

&AtClient
Procedure SpecificationModeOnChange(Item)
	If Not ThisObject.SpecificationMode Then
		Object.Specification = Undefined;
		AddAttributesCreateFormControl();
	EndIf;
	SetVisible();
EndProcedure

&AtClient
Procedure UnitModeOnChange(Item)
	If ThisObject.UnitMode = "Inherit" Then
		Object.Unit = Undefined;
	EndIf;
	SetVisible();
EndProcedure

&AtClient
Procedure PackageUnitModeOnChange(Item)
	If ThisObject.PackageUnitMode = "Inherit" Then
		Object.PackageUnit = Undefined;
	EndIf;
	SetVisible();
EndProcedure

&AtClient
Procedure ConsignorInfoModeOnChange(Item)
	If ThisObject.ConsignorInfoMode = "Inherit" Then
		Object.ConsignorsInfo.Clear();
	Else // Onw
		Object.ConsignorsInfo.Clear();
		For Each Row In ThisObject.InheritConsignorsInfo Do
			NewRow = Object.ConsignorsInfo.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
	EndIf;
	SetVisible();
EndProcedure

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupAttributes");
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

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
	
	Items.OwnPackageUnit.Visible = ThisObject.PackageUnitMode = "Own";
	Items.InheritPackageUnit.Visible = ThisObject.PackageUnitMode = "Inherit";
	
	Items.ConsignorsInfo.Visible = ThisObject.ConsignorInfoMode = "Own";
	Items.InheritConsignorsInfo.Visible = ThisObject.ConsignorInfoMode = "Inherit";
	
	Items.Specification.Visible = ThisObject.SpecificationMode;
	Items.GroupAttributes.Visible = Not ThisObject.SpecificationMode;
	Items.SpecificationMode.Visible = Not GetTypeOfItemType(Object.Item) = PredefinedValue("Enum.ItemTypes.Service");

	ThisObject.InheritUnit = ?(ValueIsFilled(Object.Item), Object.Item.Unit, Undefined);
	ThisObject.InheritPackageUnit = ?(ValueIsFilled(Object.Item), Object.Item.PackageUnit, Undefined);
	ThisObject.ItemType = ?(ValueIsFilled(Object.Item), Object.Item.ItemType, Undefined);
EndProcedure

&AtClient
Procedure SizeOnChange(Item)
	CommonFunctionsClientServer.CalculateVolume(Object);
EndProcedure

&AtServer
Procedure FillInheritConsignorsInfo()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemsConsignorsInfo.Company,
	|	ItemsConsignorsInfo.Consignor
	|FROM
	|	Catalog.Items.ConsignorsInfo AS ItemsConsignorsInfo
	|WHERE
	|	ItemsConsignorsInfo.Ref = &Ref";
	Query.SetParameter("Ref", Object.Item);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ThisObject.InheritConsignorsInfo.Load(QueryTable);	
EndProcedure

#Region COMMANDS

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
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion