Procedure IDInfoOpening(Item, StandardProcessing, Object, Form) Export

	StandardProcessing = False;
	AddInfo = New Structure();
	AddInfo.Insert("Item", Item);
	AddInfo.Insert("Object", Object);
	AddInfo.Insert("Form", Form);
	If Not ValueIsFilled(Object.Ref) Or Form.Modified Then
		QuestionToUserNotify = New NotifyDescription("IDInfoOpeningNotify", ThisObject, AddInfo);
		ShowQueryBox(QuestionToUserNotify, R().QuestionToUser_001, QuestionDialogMode.YesNo);
	Else
		IDInfoOpeningNotify(DialogReturnCode.Yes, AddInfo);
	EndIf;
EndProcedure

Procedure IDInfoOpeningNotify(Result, AddInfo = Undefined) Export
	If Not (Result = DialogReturnCode.Yes And AddInfo.Form.Write()) Then
		Return;
	EndIf;

	IDInfoTypeUniqueID = Right(AddInfo.Item.Name, StrLen(AddInfo.Item.Name) - 1);
	IDInfoType = IDInfoServer.GetIDInfoRefByUniqueID(IDInfoTypeUniqueID);
	Args = New Structure();
	Args.Insert("IDInfoType", IDInfoType);
	Args.Insert("CurrentValue", AddInfo.Form[AddInfo.Item.Name]);
	Args.Insert("RelatedValues", IDInfoServer.GetRelatedIDInfoTypes(IDInfoType, AddInfo.Object.Ref));

	ArrayOfIDInfoTypes = New Array();
	ArrayOfIDInfoTypes.Add(IDInfoType);

	Country = IDInfoServer.GetCountryFromValues(AddInfo.Object.Ref, ArrayOfIDInfoTypes);

	ArrayOfCountry = IDInfoServer.GetCountryByIDInfoType(IDInfoType, Country, AddInfo.Form.UUID);

	If ArrayOfCountry.Count() > 1 Then
		OpenFormArgs = New Structure();
		OpenFormArgs.Insert("ArrayOfCountry", ArrayOfCountry);

		Notify = New NotifyDescription("StartEditIDInfo", AddInfo.Form, Args);
		OpenForm("ChartOfCharacteristicTypes.IDInfoTypes.Form.SelectCountryForm", OpenFormArgs, AddInfo.Form, , , ,
			Notify);
	ElsIf ArrayOfCountry.Count() = 1 Then
		OpenFormArgs = New Structure();
		OpenFormArgs.Insert("Country", ArrayOfCountry[0].Country);
		OpenFormArgs.Insert("ExternalDataProc", ArrayOfCountry[0].ExternalDataProc);
		OpenFormArgs.Insert("Settings", ArrayOfCountry[0].Settings);

		StartEditIDInfo(AddInfo.Form, OpenFormArgs, Args);
	Else
		Return;
	EndIf;

EndProcedure

Procedure StartEditIDInfo(Form, Result, Parameters) Export
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

	AddDataProcServer.CallMethodAddDataProc(OpenFormArgs, New Structure("ClientCall", True));

	Notify = New NotifyDescription("EndEditIDInfo", Form, Parameters);

	AddDataProcClient.OpenFormAddDataProc(OpenFormArgs, Notify, "Form");
EndProcedure

Procedure EndEditIDInfo(Object, Result, Parameters) Export
	If Result = Undefined Then
		Return;
	EndIf;

	IDInfoServer.EndEditIDInfo(Object.Ref, Result, Parameters);

	Notify("IDInfoUpdate");
EndProcedure

Procedure NotificationProcessing(Form, Ref, EventName, Parameter, Source) Export
	If EventName = "IDInfoUpdate" Then
		ArrayOfAttributes = StrSplit(Form["ListOfIDInfoAttributes"], ",");
		For Each AttributeName In ArrayOfAttributes Do
			IDInfoTypeUniqueID = Right(AttributeName, StrLen(AttributeName) - 1);
			IDInfoType = IDInfoServer.GetIDInfoRefByUniqueID(IDInfoTypeUniqueID);
			ArrayOfIDInfoTypes = New Array();
			ArrayOfIDInfoTypes.Add(IDInfoType);

			Form[AttributeName] = IDInfoServer.GetIDInfoTypeValue(Ref, ArrayOfIDInfoTypes);
		EndDo;
	EndIf;
EndProcedure