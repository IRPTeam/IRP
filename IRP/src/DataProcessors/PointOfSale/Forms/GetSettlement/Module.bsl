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
	Str = New Structure("Payments", New Array);
	//@skip-check typed-value-adding-to-untyped-collection
	Str.Payments.Add(New Structure("PaymentInfo", PaymentSettings));
	Await EquipmentFiscalPrinterClient.PrintTextDocument(CRS, Str); 
EndProcedure

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
		DataStr = CommonFunctionsServer.DeserializeJSON(SelectionDetailRecords.Data);
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
	ResultSettlement = Await EquipmentAcquiringAPIClient.Settlement(CurrentRow.Hardware, SettlementSettings);
	Str = New Structure("Payments", New Array);
	//@skip-check typed-value-adding-to-untyped-collection
	Str.Payments.Add(New Structure("PaymentInfo", SettlementSettings));
	CRS = New Structure;
	CRS.Insert("FiscalPrinter", FiscalPrinter);
	If ResultSettlement Then
		Await EquipmentFiscalPrinterClient.PrintTextDocument(CRS, Str);
	EndIf;
	
EndProcedure

