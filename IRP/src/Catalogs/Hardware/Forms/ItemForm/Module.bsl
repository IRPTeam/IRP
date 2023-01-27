
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Async Procedure OnOpen(Cancel)
	If ValueIsFilled(Parameters.Key) And Not Object.Ref.IsEmpty() And Not Object.Driver.IsEmpty() Then
		Settings = Await HardwareClient.FillDriverParametersSettings(Object.Ref);
		Settings.Callback = New NotifyDescription("FillDriverParameters_End", ThisObject);
		HardwareClient.FillDriverParameters(Settings);
	EndIf;
EndProcedure

#EndRegion

#Region DriverAPI

// Fill driver parameters end.
// 
// Parameters:
//  Result - Structure:
//  * Settings - See HardwareClient.FillDriverParametersSettings
//  Parameters - Structure - Parameters
&AtClient
Procedure FillDriverParameters_End(Result, Parameters) Export
	FillDriverParametersAtServer(Result.Settings.ParametersDriver.DriverParametersXML, Parameters);	
EndProcedure

&AtClient
Procedure FillDriverParametersAtServer(DriverParametersXML, Parameters)
	
	DriverParameter.Clear();
	
	XMLReader = New XMLReader(); 
	XMLReader.SetString(DriverParametersXML);
	XMLReader.MoveToContent();
	
	If XMLReader.Name = "Settings" And XMLReader.NodeType = XMLNodeType.StartElement Then  
		While XMLReader.Read() Do  
			
			If XMLReader.Name = "Parameter" And XMLReader.NodeType = XMLNodeType.StartElement Then  
				ReadOnlyType = ?(Upper(XMLReader.AttributeValue("ReadOnly")) = "TRUE", True, False) 
										Or ?(Upper(XMLReader.AttributeValue("ReadOnly")) = "ИСТИНА", True, False);
				Name   =  XMLReader.AttributeValue("Name");
				Caption = XMLReader.AttributeValue("Caption");
				TypeValue       = Upper(XMLReader.AttributeValue("TypeValue"));
				DefaultValue  = XMLReader.AttributeValue("DefaultValue");
				Description  = XMLReader.AttributeValue("Description");
				FieldFormat = XMLReader.AttributeValue("FieldFormat");
				
				If TypeValue = "NUMBER" Then 
					DefaultValue = Number(DefaultValue);
				ElsIf TypeValue = "BOOLEAN" Then 
					DefaultValue = Boolean(DefaultValue);
				EndIf;

				NewRow = DriverParameter.Add();
				NewRow.Caption = Caption;
				NewRow.Name = Name;
				NewRow.DefaultValue = DefaultValue;
				NewRow.Description = Description;
				NewRow.FieldFormat = FieldFormat;
				NewRow.ReadOnly = ReadOnlyType;
				NewRow.Value = NewRow.DefaultValue;
			EndIf;
			
			If XMLReader.Name = "ChoiceList" And XMLReader.NodeType = XMLNodeType.StartElement Then 
				List = New ValueList();
				While XMLReader.Read() And Not (XMLReader.Name = "ChoiceList") Do   
					If XMLReader.Name = "Item" And XMLReader.NodeType = XMLNodeType.StartElement Then  
						AttrValue = XMLReader.AttributeValue("Value"); 
						If XMLReader.Read() Then
							AttrPreview = XMLReader.Value;
						EndIf;
						If ПустаяСтрока(AttrValue) Then
							AttrValue = AttrPreview;
						EndIf;
						
						If TypeValue = "NUMBER" Then 
							List.Add(Number(AttrValue), AttrPreview);
						Else
							List.Add(AttrValue, AttrPreview)
						EndIf;
					EndIf;
				EndDo; 
				NewRow.ValueListData = List;
			EndIf;
			
		EndDo;  
		
	EndIf;
	
	XMLReader.Close(); 
	
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

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure LoadSettings(Command)
	Settings = HardwareClient.GetDefaultSettings(Object.EquipmentType);

	For Each Param In Settings Do
		Row = Object.ConnectParameters.Add();
		Row.Name = Param.Key;
		Row.Value = Param.Value;
	EndDo;
EndProcedure

&AtClient
Async Procedure ReloadSettings(Command)
	If ValueIsFilled(Parameters.Key) And Not Object.Ref.IsEmpty() And Not Object.Driver.IsEmpty() Then
		DriverParameter.Clear();
		Settings = Await HardwareClient.FillDriverParametersSettings(Object.Ref);
		Settings.Callback = New NotifyDescription("FillDriverParameters_End", ThisObject);
		HardwareClient.FillDriverParameters(Settings);
	EndIf;
EndProcedure

&AtClient
Async Procedure WriteSettings(Command)
	If Modified OR Object.Ref.IsEmpty() Then
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_024);
		Return;
	EndIf;
	
	Settings = Await HardwareClient.FillDriverParametersSettings(Object.Ref);
	Settings.ServiceCallback = New NotifyDescription("EndWriteSettings", ThisObject, Settings);
	
	For Each Row In DriverParameter Do
		If Row.ReadOnly Then
			Continue;
		EndIf;
		Settings.SetParameters.Insert(Row.Name, Row.Value);
	EndDo;
	HardwareClient.SetParameter_End(, , Settings);
EndProcedure

&AtClient
Procedure EndWriteSettings(Result, AddInfo) Export
	If Not Result Then
		Status(Result, , , PictureLib.Stop);
	Else
		Status(Result, , , PictureLib.AppearanceFlagGreen);
	EndIf;
EndProcedure

&AtClient
Async Procedure Test(Command)
	ClearMessages();
	
	If Modified OR Object.Ref.IsEmpty() Then
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_024);
		Return;
	EndIf;
	
	Settings = Await HardwareClient.FillDriverParametersSettings(Object.Ref);
	Settings.Callback = New NotifyDescription("EndTestDevice", ThisObject, Settings);
	Settings.AdditionalCommand = "CheckHealth";
	
	For Each Row In DriverParameter Do
		If Row.ReadOnly Then
			Continue;
		EndIf;
		Settings.SetParameters.Insert(Row.Name, Row.Value);
	EndDo;
	HardwareClient.TestDevice(Settings);
EndProcedure

&AtClient
Procedure Connect(Command)
	If Parameters.Key.IsEmpty() Then
		Return;
	EndIf;
	HardwareClient.ConnectClientHardware(ThisObject.Object.Ref);
EndProcedure


&AtClient
Procedure Disconnect(Command)
	If Parameters.Key.IsEmpty() Then
		Return;
	EndIf;
	HardwareClient.DiconnectClientHardware(ThisObject.Object.Ref);
EndProcedure


#EndRegion

#Region Internal

&AtClient
Procedure EndTestDevice(Result, OutParameters, AddInfo) Export
	If TypeOf(OutParameters) = Type("Array") Then
		OutParameter = StrConcat(OutParameters, Chars.LF); 
		If Not Result Then
			Status(OutParameter, , , PictureLib.Stop);
		Else
			Status(OutParameter, , , PictureLib.AppearanceFlagGreen);
		EndIf;
	EndIf;
EndProcedure

#EndRegion