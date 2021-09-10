#Region Public

Function OpenFormAddDataProc(Info, NotifyDescription = Undefined, FormName = Undefined, AddInfo = Undefined) Export
	ExternalOrInternalDataProcessor = "";
	If AddDataProcServer.UseInternalDataProcessor(Info.ExternalDataProcName) Then
		ExternalOrInternalDataProcessor = "DataProcessor";
	Else
		ExternalOrInternalDataProcessor = "ExternalDataProcessor";
	EndIf;
	FormName = ExternalOrInternalDataProcessor + "." + Info.ExternalDataProcName + ".Form" + ?(ValueIsFilled(FormName),
		"." + FormName, "");
	OpenForm(FormName, Info, , , , , NotifyDescription, FormWindowOpeningMode.LockWholeInterface);

	Return Undefined;
EndFunction

Function GetFormAddDataProc(Info, Owner = Undefined, FormName = Undefined, AddInfo = Undefined) Export
	ExternalOrInternalDataProcessor = "";
	If AddDataProcServer.UseInternalDataProcessor(Info.ExternalDataProcName) Then
		ExternalOrInternalDataProcessor = "DataProcessor";
	Else
		ExternalOrInternalDataProcessor = "ExternalDataProcessor";
	EndIf;

	ReceivedForm = GetForm(ExternalOrInternalDataProcessor + "." + Info.ExternalDataProcName + ".Form" + ?(
		ValueIsFilled(FormName), "." + FormName, ""), Info, Owner);

	Return ReceivedForm;
EndFunction

#EndRegion