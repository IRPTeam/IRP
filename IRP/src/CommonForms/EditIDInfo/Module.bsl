&AtClient
Procedure Save(Command)
	SaveAtServer();
	Notify("IDInfoUpdate");
EndProcedure

&AtClient
Procedure SaveAndClose(Command)
	SaveAtServer();
	Notify("IDInfoUpdate");
	ThisObject.Close();
EndProcedure

&AtClient
Procedure IDInfoBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure IDInfoBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtServer
Procedure SaveAtServer()
	IDInfoServer.SaveIDInfoTypeValues(ThisObject.Ref, ThisObject.IDInfo.Unload());
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Ref = Parameters.Ref;
	
	IDInfoTypeValues = IDInfoServer.GetIDInfoTypeValues(ThisObject.Ref);
	ThisObject.IDInfo.Load(IDInfoTypeValues);
	
	For Each Row In ThisObject.IDInfo Do
		Row.TypeDef = Row.IDInfoType.ValueType;
	EndDo;
EndProcedure

&AtClient
Procedure IDInfoBeforeRowChange(Item, Cancel)
	If Item.CurrentData = Undefined Then
		Return;
	EndIf;
	
	Args = New Structure();
	Args.Insert("IDInfoType", Item.CurrentData.IDInfoType);
	Args.Insert("CurrentValue", Item.CurrentData.Value);
	Args.Insert("RelatedValues", IDInfoServer.GetRelatedIDInfoTypes(Item.CurrentData.IDInfoType, ThisObject.Ref));
	
	ArrayOfCountry = 
	IDInfoServer.GetCountryByIDInfoType(Item.CurrentData.IDInfoType, Item.CurrentData.Country, ThisObject.UUID);
	If ArrayOfCountry.Count() Then
		Cancel = True;
	EndIf;
	
	If ArrayOfCountry.Count() > 1 Then
		OpenFormArgs = New Structure();
		OpenFormArgs.Insert("ArrayOfCountry", ArrayOfCountry);
		
		Notify = New NotifyDescription("StartEditIDInfo", ThisObject, Args);
		OpenForm("ChartOfCharacteristicTypes.IDInfoTypes.Form.SelectCountryForm", OpenFormArgs, ThisObject, , , , Notify);
	ElsIf ArrayOfCountry.Count() = 1 Then
		Result = New Structure();
		Result.Insert("Country", ArrayOfCountry[0].Country);
		Result.Insert("ExternalDataProc", ArrayOfCountry[0].ExternalDataProc);
		Result.Insert("Settings", ArrayOfCountry[0].Settings);
		StartEditIDInfo(Result, Args);
	Else 
		Return;
	EndIf;
EndProcedure

&AtClient
Procedure StartEditIDInfo(Result, Parameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	OpenFormArgs = AddDataProcServer.AddDataProcInfo(Result);
	OpenFormArgs.Insert("CurrentValue", Parameters.CurrentValue);
	OpenFormArgs.Insert("Country", Result.Country);
	OpenFormArgs.Insert("RelatedValues", Parameters.RelatedValues);
	OpenFormArgs.Insert("IDInfoType", Parameters.IDInfoType);
	OpenFormArgs.Insert("Settings", Result.Settings);
	
	Parameters.Insert("Country", Result.Country);
	
	CallMetodAddDataProc(OpenFormArgs);
	Notify = New NotifyDescription("EndEditIDInfo", ThisObject, Parameters);
	
	AddDataProcClient.OpenFormAddDataProc(OpenFormArgs, Notify, "Form");
EndProcedure

&AtServer
Procedure CallMetodAddDataProc(OpenFormArgs)
	AddDataProcServer.CallMetodAddDataProc(OpenFormArgs);
EndProcedure

&AtClient
Procedure EndEditIDInfo(Result, Parameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	Filter = New Structure();
	Filter.Insert("IDInfoType", Parameters.IDInfoType);
	ArrayOfIDInfo = ThisObject.IDInfo.FindRows(Filter);
	For Each Row In ArrayOfIDInfo Do
		Row.Value = Result.Value;
		Row.Country = Parameters.Country;
	EndDo;
	ThisObject.Items.IDInfo.EndEditRow(True);
EndProcedure

&AtClient
Procedure IDInfoValueClearing(Item, StandardProcessing)
	Return;
EndProcedure

&AtClient
Procedure IDInfoOnStartEdit(Item, NewRow, Clone)
	If Item.CurrentData.Value = Undefined Then
		Item.ChildItems.IDInfoValue.TypeRestriction = Item.CurrentData.TypeDef;
	EndIf;
EndProcedure

