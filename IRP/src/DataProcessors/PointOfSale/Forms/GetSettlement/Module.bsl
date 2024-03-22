// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Workstation = Parameters.Workstation;
	FiscalPrinterFind = HardwareServer.GetWorkstationHardwareByEquipmentType(Workstation, Enums.EquipmentTypes.FiscalPrinter);
	If FiscalPrinterFind.Count() = 1 Then
		FiscalPrinter = FiscalPrinterFind[0];
	EndIf;
	AcquiringList = HardwareServer.GetWorkstationHardwareByEquipmentType(Workstation, Enums.EquipmentTypes.Acquiring);

	For Each Acquiring In AcquiringList Do
		NewRow = HardwareList.Add();
		NewRow.Hardware = Acquiring;
	EndDo;

EndProcedure

&AtClient
Async Procedure PrintLastSettlement(Command)
	CurrentRow = Items.HardwareList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;

	PaymentSettings = PrintLastSettlementAtServer(CurrentRow.Hardware);

	If PaymentSettings = Undefined Then
		Return;
	EndIf;

	CRS = New Structure;
	CRS.Insert("FiscalPrinter", FiscalPrinter);

	DocumentPackage = EquipmentFiscalPrinterAPIClient.DocumentPackage();
	DocumentPackage.TextString = StrSplit(PaymentSettings.Out.Slip, Chars.LF + Chars.CR);
	PrintResult = Await EquipmentFiscalPrinterClient.PrintTextDocument(CRS, DocumentPackage); // See EquipmentFiscalPrinterAPIClient.PrintTextDocumentSettings
	If Not PrintResult.Info.Success Then
		CommonFunctionsClientServer.ShowUsersMessage(PrintResult.Info.Error);
	EndIf;
EndProcedure

// Print last settlement at server.
//
// Parameters:
//  Hardware - CatalogRef.Hardware -  Hardware
//
// Returns:
//  See EquipmentAcquiringAPIClient.SettlementSettings
&AtServer
Function PrintLastSettlementAtServer(Hardware)
	Query = New Query;
	Query.Text =
		"SELECT TOP 1
		|	HardwareLogSliceLast.Data,
		|	HardwareLogSliceLast.Result
		|FROM
		|	InformationRegister.HardwareLog AS HardwareLogSliceLast
		|WHERE
		|	HardwareLogSliceLast.Hardware = &Hardware
		|	AND HardwareLogSliceLast.Method = &Method
		|	AND NOT HardwareLogSliceLast.Request
		|
		|ORDER BY
		|	HardwareLogSliceLast.Date DESC";

	Query.SetParameter("Hardware", Hardware);
	Query.SetParameter("Method", "Settlement");

	QueryResult = Query.Execute();

	SelectionDetailRecords = QueryResult.Select();

	If SelectionDetailRecords.Next() Then
		//@skip-check invocation-parameter-type-intersect, property-return-type
		DataStr = CommonFunctionsServer.DeserializeJSON(SelectionDetailRecords.Data);
		//@skip-check property-return-type
		If SelectionDetailRecords.Result Then
			Return DataStr;
		Else
			CommonFunctionsClientServer.ShowUsersMessage(R().EqAc_LastSettlementHasError + Chars.LF + DataStr.Info.Error);
		EndIf;
	Else
		CommonFunctionsClientServer.ShowUsersMessage(R().EqAc_LastSettlementNotFound);
	EndIf;
	Return Undefined;
EndFunction

&AtClient
Async Procedure GetSettlement(Command)

	CurrentRow = Items.HardwareList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;

	SettlementSettings = EquipmentAcquiringAPIClient.SettlementSettings();

	If Not Await EquipmentAcquiringAPIClient.Settlement(CurrentRow.Hardware, SettlementSettings) Then
		CommonFunctionsClientServer.ShowUsersMessage(SettlementSettings.Info.Error);
		Return;
	EndIf;

	CRS = New Structure;
	CRS.Insert("FiscalPrinter", FiscalPrinter);
	DocumentPackage = EquipmentFiscalPrinterAPIClient.DocumentPackage();
	DocumentPackage.TextString = StrSplit(SettlementSettings.Out.Slip, Chars.LF + Chars.CR);
	PrintResult = Await EquipmentFiscalPrinterClient.PrintTextDocument(CRS, DocumentPackage); // See EquipmentFiscalPrinterAPIClient.PrintTextDocumentSettings
	If Not PrintResult.Info.Success Then
		CommonFunctionsClientServer.ShowUsersMessage(PrintResult.Info.Error);
	EndIf;

EndProcedure

