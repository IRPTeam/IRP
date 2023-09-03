
&AtClient
Procedure CommandProcessing(ConsolidatedRetailSales, CommandExecuteParameters)
	
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status");
	If Not CRS.Status = PredefinedValue("Enum.ConsolidatedRetailSalesStatuses.Open") Then
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_CanCloseOnlyOpenStatus);
		Return;
	EndIf;
	
	FormParameters = New Structure();
	FormParameters.Insert("AutoCreateMoneyTransfer", False);
	FormParameters.Insert("ConsolidatedRetailSales", ConsolidatedRetailSales);

	NotifyDescription = New NotifyDescription("CloseSessionFinish", ThisObject);

	OpenForm(
		"DataProcessor.PointOfSale.Form.SessionClosing",
		FormParameters, ThisObject, , , , NotifyDescription, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Async Procedure CloseSessionFinish(Result, AddInfo) Export
	If Result = Undefined Then
		Return;
	EndIf;

	AcquiringList = HardwareServer.GetWorkstationHardwareByEquipmentType(Result.Workstation, PredefinedValue("Enum.EquipmentTypes.Acquiring"));
	For Each Acquiring In AcquiringList Do
		SettlementSettings = EquipmentAcquiringAPIClient.SettlementSettings();
		If Not Await EquipmentAcquiringAPIClient.Settlement(Acquiring, SettlementSettings) Then
			CommonFunctionsClientServer.ShowUsersMessage(SettlementSettings.Info.Error);
			Continue;
		EndIf;

		DocumentPackage = EquipmentFiscalPrinterAPIClient.DocumentPackage();
		DocumentPackage.TextString = StrSplit(SettlementSettings.Out.Slip, Chars.LF + Chars.CR);
		PrintResult = Await EquipmentFiscalPrinterClient.PrintTextDocument(Result.ConsolidatedRetailSales, DocumentPackage); // See EquipmentFiscalPrinterAPIClient.PrintTextDocumentSettings
		If Not PrintResult.Info.Success Then
			CommonFunctionsClientServer.ShowUsersMessage(PrintResult.Info.Error);
		EndIf;
	EndDo;

	EquipmentCloseShiftResult = Await EquipmentFiscalPrinterClient.CloseShift(Result.ConsolidatedRetailSales); // See EquipmentFiscalPrinterAPIClient.OpenShiftSettings
	If EquipmentCloseShiftResult.Info.Success Then
		DocConsolidatedRetailSalesServer.DocumentCloseShift(Result.ConsolidatedRetailSales, EquipmentCloseShiftResult.Out.OutputParameters, Result);
		NotifyChanged(Type("DocumentRef.ConsolidatedRetailSales"));
	Else
		CommonFunctionsClientServer.ShowUsersMessage(EquipmentCloseShiftResult.Info.Error);
	EndIf;
EndProcedure
