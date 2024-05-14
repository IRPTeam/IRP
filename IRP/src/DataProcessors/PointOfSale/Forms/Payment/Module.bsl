
#Region Variables

&AtClient
Var AmountFractionDigitsCount; // Number

&AtClient
Var AmountDotIsActive; // Boolean

&AtClient
Var AmountFractionDigitsMaxCount; // Number

&AtClient
Var FormCanBeClosed; // Boolean

&AtServer
Var EnableRRNCode; // Boolean

#EndRegion

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)

	Object.Amount = Parameters.Amount;
	Object.Branch = Parameters.Branch;
	Object.Workstation = Parameters.Workstation;
	Object.Discount = Parameters.Discount;
	ThisObject.IsAdvance = Parameters.IsAdvance;
	ConsolidatedRetailSales = Parameters.ConsolidatedRetailSales;
	isReturn = Parameters.isReturn;
	RetailBasis = Parameters.RetailBasis;

	If Not ConsolidatedRetailSales.IsEmpty()
		And ConsolidatedRetailSales = RetailBasis.ConsolidatedRetailSales Then
		ReturnInTheSameConsolidateSales = True;
	EndIf;

	Items.PaymentsRRNCode.Visible = isReturn;

	FillPaymentTypes();
	FillPaymentMethods();

	Items.Payment_ReturnPaymentByPaymentCard.Visible = isReturn;
	Items.Payment_PayByPaymentCard.Visible = Not isReturn;
	Items.Payment_CancelPaymentByPaymentCard.Visible = isReturn;

	Items.Cashback.Visible = Not (ThisObject.IsAdvance And isReturn);
	Items.Advance.Visible = ThisObject.IsAdvance And isReturn;

	If Not ThisObject.IsAdvance And ValueIsFilled(Parameters.RetailCustomer) Then
		AdvanceAmount = GetAdvanceByRetailCustomer(Parameters.Company, Parameters.Branch, Parameters.RetailCustomer);
		If ValueIsFilled(AdvanceAmount) Then
			AdvancePaymentType = GetAdvancePaymentType();
			If ValueIsFilled(AdvancePaymentType) Then
				AdvancePayment = ThisObject.Payments.Add();
				AdvancePayment.Amount = Min(AdvanceAmount, Parameters.Amount);
				AdvancePayment.Description     = String(AdvancePaymentType);
				AdvancePayment.PaymentType     = AdvancePaymentType;
				AdvancePayment.PaymentTypeEnum = AdvancePaymentType.Type;
			EndIf;
		EndIf;
	EndIf;

	If ThisObject.IsAdvance And isReturn And ValueIsFilled(Parameters.RetailCustomer) Then
		ThisObject.AdvanceBalance = GetAdvanceByRetailCustomer(Parameters.Company, Parameters.Branch, Parameters.RetailCustomer);
	EndIf;
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	CalculatePaymentsAmountTotal();
	FormatPaymentsAmountStringRows();
	
	If isReturn Then
		For Each Row In GetPaymentWithCert() Do
			FillPayments(Row.ButtonSettings, Row.ChoiceEndAdditionalParameters);
		EndDo;
	EndIf;
EndProcedure

&AtServer
Function GetPaymentWithCert()
	Array = New Array;
	For Each Row In RetailBasis.Payments Do
		If Row.PaymentType.Type = Enums.PaymentTypes.Certificate Then
			
			ButtonSettings = New Structure(); // See POSClient.ButtonSettings()
			ButtonSettings.Insert("PaymentType", Row.PaymentType);
			ButtonSettings.Insert("BankTerm", Row.BankTerm);
			ButtonSettings.Insert("PaymentTypeEnum", Row.PaymentType.Type);
			
			CertStatus = New Structure;
			CertStatus.Insert("CanBeDeleted", False);
			CertStatus.Insert("Certificate", Row.Certificate);
			CertStatus.Insert("Amount", Row.Amount);
			
			ChoiceEndAdditionalParameters = New Structure();
			ChoiceEndAdditionalParameters.Insert("CertStatus", CertStatus);
			
			Str = New Structure();
			Str.Insert("ButtonSettings", ButtonSettings);
			Str.Insert("ChoiceEndAdditionalParameters", ChoiceEndAdditionalParameters);
			
			Array.Add(Str);
		EndIf;
	EndDo;
	Return Array;
EndFunction

&AtServer
Function GetAdvanceByRetailCustomer(_Company, _Branch, _RetailCustomer)
	Query = New Query();
	Query.Text =
	"SELECT
	|	R2023B_AdvancesFromRetailCustomersBalance.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R2023B_AdvancesFromRetailCustomers.Balance(, Company = &Company
	|	AND Branch = &Branch
	|	AND RetailCustomer = &RetailCustomer) AS R2023B_AdvancesFromRetailCustomersBalance";
	Query.SetParameter("Company", _Company);
	Query.SetParameter("Branch", _Branch);
	Query.SetParameter("RetailCustomer", _RetailCustomer);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Amount;
	EndIf;
	Return 0;
EndFunction

&AtServer
Function GetAdvancePaymentType()
	Query = New Query();
	Query.Text =
	"SELECT
	|	PaymentTypes.Ref
	|FROM
	|	Catalog.PaymentTypes AS PaymentTypes
	|WHERE
	|	NOT PaymentTypes.DeletionMark
	|	AND PaymentTypes.Type = VALUE(Enum.PaymentTypes.Advance)";
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	EndIf;
	Return Undefined;
EndFunction

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	ErrorMessages = New Array();

	IsIncomingOutgoingAdvance = ThisObject.IsAdvance;

	If Not IsIncomingOutgoingAdvance Then
		If ThisObject.PaymentsAmountTotal < Object.Amount Then
			ErrorMessages.Add(R().POS_s1);
		EndIf;
	EndIf;

	PaymentsValue = FormAttributeToValue("Payments");

	CashPaymentFilter = New Structure();
	CashPaymentFilter.Insert("PaymentTypeEnum", Enums.PaymentTypes.Cash);
	CashAmounts = PaymentsValue.Copy(CashPaymentFilter, "Amount");
	CashAmount = CashAmounts.Total("Amount");

	CardPaymentFilter = New Structure();
	CardPaymentFilter.Insert("PaymentTypeEnum", Enums.PaymentTypes.Card);
	CardAmounts = PaymentsValue.Copy(CardPaymentFilter, "Amount");
	CardAmount = CardAmounts.Total("Amount");

	If Not IsIncomingOutgoingAdvance Then
		If CardAmount > Object.Amount Then
			ErrorMessages.Add(R().POS_s2);
		EndIf;

		If CardAmount = Object.Amount And CashAmount Then
			ErrorMessages.Add(R().POS_s3);
		EndIf;

		If Not ErrorMessages.Count() And PaymentsAmountTotal <> (Object.Amount + Object.Cashback) Then
			ErrorMessages.Add(R().POS_s4);
		EndIf;
	EndIf;

	If ErrorMessages.Count() Then
		Cancel = True;
		For Each ErrorMessage In ErrorMessages Do
			CommonFunctionsClientServer.ShowUsersMessage(ErrorMessage);
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure BeforeClose(Cancel, Exit, WarningText, StandardProcessing)
	If Not FormCanBeClosed Then
		For Each Payment In Payments Do
			If Payment.PaymentDone Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(R().POS_Error_ErrorOnClosePayment);
			EndIf;
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
		If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

#EndRegion

#Region FormTableItemsEventHandlers

&AtClient
Procedure PaymentsOnChange(Item)

	CalculatePaymentsAmountTotal();
	FormatPaymentsAmountStringRows();
	PaymentsOnActivateRow(Undefined);
EndProcedure

&AtClient
Procedure PaymentsOnActivateRow(Item)

	CurrentData = Items.Payments.CurrentData;
	If CurrentData = Undefined Then
		Items.GroupPaymentByAcquiring.Visible = False;
		Return;
	EndIf;

	CurrentData.Edited = False;
	CurrentData.AmountString = GetAmountString(CurrentData.Amount);
	Items.GroupPaymentByAcquiring.Visible = Not CurrentData.Hardware.isEmpty();

	Items.Payment_PayByPaymentCard.Enabled = Not CurrentData.PaymentDone;

	If isReturn Then
		Items.Payment_ReturnPaymentByPaymentCard.Enabled = Not CurrentData.PaymentDone;
	Else
		Items.Payment_ReturnPaymentByPaymentCard.Enabled = False;
	EndIf;
	
	If ReturnInTheSameConsolidateSales AND Not IsBlankString(CurrentData.RRNCode) Then
		Items.Payment_CancelPaymentByPaymentCard.Enabled = Not CurrentData.PaymentDone;
	Else
		Items.Payment_CancelPaymentByPaymentCard.Enabled = False;
	EndIf;

	Items.Payment_RevertLastPayment.Enabled = Not IsBlankString(CurrentData.RRNCodeCurrentOperation);

EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Async Procedure Enter(Command)

	If Not CheckFilling() Then
		Return;
	EndIf;

	For Each PaymentRow In Payments Do
		If Not PaymentRow.Hardware.IsEmpty()
			And PaymentRow.Amount > 0
			And Not PaymentRow.PaymentDone Then
				CommonFunctionsClientServer.ShowUsersMessage(R().EqAc_NotAllPaymentDone);
				Return;
		EndIf;
	EndDo;

	If Object.Cashback Then
		Row = Payments.Add();
		Row.PaymentType = CashPaymentTypes[0].PaymentType;
		Row.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.Cash");
		Row.Account = CashPaymentTypes[0].Account;
		Row.Amount = -Object.Cashback;
	EndIf;

	ReturnValue = New Structure();
	ReturnValue.Insert("Payments", Payments);
	ReturnValue.Insert("ReceiptPaymentMethod", ReceiptPaymentMethod);
	ReturnValue.Insert("PaymentForm", ThisObject);

	FormCanBeClosed = True;
	Items.Enter.Enabled = False;
	ExecuteNotifyProcessing(OnCloseNotifyDescription, ReturnValue);
EndProcedure

&AtClient
Procedure CloseButton(Command)
	Close();
EndProcedure

&AtClient
Procedure Cash(Command)
	OpenPaymentForm(ThisObject.CashPaymentTypes, PredefinedValue("Enum.PaymentTypes.Cash"));
	Items.GroupBankTypeList.Visible = False;
EndProcedure

&AtClient
Procedure Card(Command)
	OpenNewForm = False;
	If OpenNewForm Then
		OpenPaymentForm(ThisObject.BankPaymentTypes, PredefinedValue("Enum.PaymentTypes.Card"));
	Else
		Items.GroupBankTypeList.Visible = Not Items.GroupBankTypeList.Visible;
		Items.Card.Check = Items.GroupBankTypeList.Visible;
	EndIf;
EndProcedure

&AtClient
Procedure Certificate(Command)
	OpenPaymentForm(ThisObject.CertificatePaymentTypes, PredefinedValue("Enum.PaymentTypes.Certificate"));
	Items.GroupBankTypeList.Visible = False;
EndProcedure

&AtClient
Procedure PaymentAgent(Command)
	OpenPaymentForm(ThisObject.PaymentAgentTypes, PredefinedValue("Enum.PaymentTypes.PaymentAgent"));
EndProcedure

&AtClient
Procedure NumPress(Command)

	PaymentsCount = 0;
	For Each Row In ThisObject.Payments Do
		If Row.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.Advance") Then
			Continue;
		EndIf;
		PaymentsCount = PaymentsCount + 1;
	EndDo;

	If Not PaymentsCount And CashPaymentTypes.Count() Then
		ButtonSettings = POSClient.ButtonSettings();
		FillPropertyValues(ButtonSettings, CashPaymentTypes[0]);
		AdditionalParameters = New Structure();
		FillPayments(ButtonSettings, AdditionalParameters);
	EndIf;

	NumButtonPress(Command.Name);
	CurrentItem = Items.Enter;

EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject, ThisObject);
EndProcedure

&AtClient
Async Procedure ReconnectFiscalPrinter(Command)
	Hardware = CommonFunctionsServer.GetRefAttribute(ThisObject.ConsolidatedRetailSales, "FiscalPrinter");
	HardwareClient.DisconnectHardware(Hardware);
	ConnectResult = Await HardwareClient.ConnectHardware(Hardware);
	If Not ConnectResult.Result Then
		CommonFunctionsClientServer.ShowUsersMessage(ConnectResult.ErrorDescription);
	Else
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_005);
	EndIf;
	
EndProcedure

&AtClient
Procedure ActivateOKButton(Command)
	Items.Enter.Enabled = True;
EndProcedure

#EndRegion

#Region Private

// Search by barcode end.
// 
// Parameters:
//  Result - See BarcodeServer.SearchByBarcodes
//  AdditionalParameters - Structure - Additional parameters
&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export

	If Result.FoundedItems.Count() Then
		For Each Row In Result.FoundedItems Do
			If Not Row.isCertificate Then
				Return;
			Else
				CertStatus = CertificateServer.GetCertificateStatus(Row.SerialLotNumber);
				If Not isReturn And Not CertStatus.CanBeUsed Then
					CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().CERT_CertAlreadyUsed, Row.SerialLotNumber));
					Return;
				ElsIf isReturn And CertStatus.CanBeUsed Then
					CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().CERT_HasNotBeenUsed, Row.SerialLotNumber));
					Return;
				Else
					CertStatus.Insert("CanBeDeleted", True);
					OpenPaymentForm(ThisObject.CertificatePaymentTypes, PredefinedValue("Enum.PaymentTypes.Certificate"), CertStatus);
					Items.GroupBankTypeList.Visible = False;					
				EndIf;
			EndIf; 
		EndDo;
	EndIf;

	If Result.Barcodes.Count() Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_019, StrConcat(Result.Barcodes, ",")));
	EndIf;
EndProcedure

&AtClient
Procedure OpenPaymentForm(PaymentTypesTable, PaymentType, CertStatus = Undefined)

	If PaymentTypesTable.Count() > 1 Then
		NotifyParameters = New Structure();
		NotifyParameters.Insert("CertStatus", CertStatus);
		NotifyDescription = New NotifyDescription("FillPayments", ThisObject, NotifyParameters);
		PayButtons = New Array();
		For Each CollectionItem In PaymentTypesTable Do
			ButtonSettings = POSClient.ButtonSettings();
			FillPropertyValues(ButtonSettings, CollectionItem);
			ButtonSettings.PaymentTypeEnum = PaymentType;
			PayButtons.Add(ButtonSettings);
		EndDo;

		OpeningFormParameters = New Structure();
		OpeningFormParameters.Insert("PayButtons", PayButtons);
		OpenForm("DataProcessor.PointOfSale.Form.PaymentTypes", OpeningFormParameters, ThisObject, UUID, , ,
			NotifyDescription, FormWindowOpeningMode.LockWholeInterface);
	Else
		ButtonSettings = POSClient.ButtonSettings();

		FillPropertyValues(ButtonSettings, PaymentTypesTable[0]);
		ButtonSettings.PaymentTypeEnum = PaymentType;
		ChoiceEndAdditionalParameters = New Structure();
		ChoiceEndAdditionalParameters.Insert("CertStatus", CertStatus);
		FillPayments(ButtonSettings, ChoiceEndAdditionalParameters);
	EndIf;

EndProcedure

&AtClient
Procedure CalculatePaymentsAmountTotal()
	ThisObject.PaymentsAmountTotal = Payments.Total("Amount");

	CashFilter = New Structure();
	CashFilter.Insert("PaymentTypeEnum", PredefinedValue("Enum.PaymentTypes.Cash"));
	CashRows = Payments.FindRows(CashFilter);

	PaymentCashAmount = 0;
	For Each CashRow In CashRows Do
		PaymentCashAmount = PaymentCashAmount + CashRow.Amount;
	EndDo;

	If ThisObject.PaymentsAmountTotal > Object.Amount
		And ThisObject.PaymentsAmountTotal - Object.Amount <= PaymentCashAmount Then
		CashbackValue = ThisObject.PaymentsAmountTotal - Object.Amount;
	Else
		CashbackValue = 0;
	EndIf;

	Object.Cashback = CashbackValue;
EndProcedure

&AtClient
Procedure FormatPaymentsAmountStringRows()

	For Each Row In Payments Do
		Row.AmountString = GetAmountString(Row.Amount);
	EndDo;

EndProcedure

&AtClient
Procedure NumButtonPress(CommandName)

	CurrentData = Items.Payments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	If CurrentData.PaymentDone Then
		Return;
	EndIf;

	If Not CurrentData.Edited Then
		CurrentData.Amount = 0;
		CurrentData.Edited = True;
		AmountDotIsActive = False;
		AmountFractionDigitsCount = 0;
	EndIf;

	ButtonValue = StrReplace(CommandName, "Numpad", "");

	If ButtonValue = "Dot" Then
		ProcessDotButtonPress(CurrentData);
	ElsIf ButtonValue = "0" Then
		ProcessZeroButtonPress(CurrentData);
	ElsIf ButtonValue = "Backspace" Then
		ProcessBackspaceButtonPress(CurrentData);
	ElsIf ButtonValue = "Clear" Then
		ProcessClearButtonPress(CurrentData);
	Else
		ProcessDigitButtonPress(CurrentData, ButtonValue);
	EndIf;

	SetAmountInPaymentAndUpdate(CurrentData);

EndProcedure

&AtClient
Procedure SetAmountInPaymentAndUpdate(CurrentData)

	If AmountDotIsActive Then
		If AmountFractionDigitsCount Then
			NFDValue = "NFD=" + String(AmountFractionDigitsCount) + ";";
			AmountString = Format(CurrentData.Amount, NFDValue);
		Else
			AmountString = String(CurrentData.Amount) + Mid(String(0.1), 2, 1);
		EndIf;
	Else
		AmountString = String(CurrentData.Amount);
	EndIf;
	CurrentData.AmountString = AmountString;
	CalculatePaymentsAmountTotal();
EndProcedure

&AtClient
Procedure PaymentsBeforeDeleteRow(Item, Cancel)
	CurrentData = Items.Payments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If CurrentData.PaymentDone Then
		If Not CurrentData.CanBeDeleted Then
			Cancel = True;
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure ProcessDotButtonPress(CurrentData)

	If Not AmountDotIsActive Then
		AmountDotIsActive = True;
		AmountFractionDigitsCount = 0;
	EndIf;

EndProcedure

&AtClient
Procedure ProcessZeroButtonPress(CurrentData)

	Ten = 10;
	If AmountDotIsActive Then
		If (AmountFractionDigitsCount + 1) < AmountFractionDigitsMaxCount Then
			AmountFractionDigitsCount = AmountFractionDigitsCount + 1;
		EndIf;
	Else
		CurrentData.Amount = CurrentData.Amount * Ten;
	EndIf;

EndProcedure

&AtClient
Procedure ProcessBackspaceButtonPress(CurrentData)

	Ten = 10;
	If AmountDotIsActive Then
		If AmountFractionDigitsCount Then
			AmountFractionDigitsCount = AmountFractionDigitsCount - 1;
			AmountFractionDigits = CurrentData.Amount - Int(CurrentData.Amount);
			AmountValue = Int(AmountFractionDigits * Pow(Ten, AmountFractionDigitsCount)) / Pow(Ten,
				AmountFractionDigitsCount);
			CurrentData.Amount = Int(CurrentData.Amount) + AmountValue;
		Else
			AmountDotIsActive = False;
		EndIf;
	Else
		If Int(CurrentData.Amount / Ten) Then
			CurrentData.Amount = Int(CurrentData.Amount / Ten);
		Else
			CurrentData.Amount = 0;
		EndIf;
	EndIf;

EndProcedure

&AtClient
Procedure ProcessClearButtonPress(CurrentData)

	CurrentData.Amount = 0;
	CurrentData.Edited = False;
	AmountDotIsActive = False;
	AmountFractionDigitsCount = 0;

EndProcedure

&AtClient
Procedure ProcessDigitButtonPress(CurrentData, Val ButtonValue)

	Ten = 10;
	CurrentAmountValue = CurrentData.Amount;
	If AmountDotIsActive Then
		If AmountFractionDigitsCount < AmountFractionDigitsMaxCount Then
			CurrentData.Amount = CurrentData.Amount + Number(ButtonValue) / Pow(Ten, AmountFractionDigitsCount + 1);
			AmountFractionDigitsCount = AmountFractionDigitsCount + 1;
		EndIf;
	Else
		CurrentData.Amount = CurrentData.Amount * Ten + Number(ButtonValue);
		If (CurrentAmountValue * Ten + Number(ButtonValue)) <> CurrentData.Amount Then
			CurrentData.Amount = CurrentAmountValue;
		EndIf;
	EndIf;

EndProcedure

&AtServer
Procedure FillPaymentTypes()

	FillPaymentsAtServer();

EndProcedure

&AtServer
Procedure FillPaymentsAtServer()
	CashPaymentTypesValue = POSServer.GetCashPaymentTypesValue(Object.Workstation.CashAccount);
	ValueToFormAttribute(CashPaymentTypesValue, "CashPaymentTypes");

	BankPaymentTypesValue = POSServer.GetBankPaymentTypesValue(Object.Branch);
	ValueToFormAttribute(BankPaymentTypesValue, "BankPaymentTypes");

	CertificatePaymentTypesValue = POSServer.GetCertificatePaymentTypesValue(Object.Workstation.CashAccount);
	ValueToFormAttribute(CertificatePaymentTypesValue, "CertificatePaymentTypes");

	IsIncomingOutgoingAdvance = ThisObject.IsAdvance;

	If Not IsIncomingOutgoingAdvance Then
		PaymentAgentValue = POSServer.GetPaymentAgentTypesValue(Object.Branch);
		ValueToFormAttribute(PaymentAgentValue, "PaymentAgentTypes");
	EndIf;

	BankPaymentTypeList.Parameters.SetParameterValue("Branch", Object.Branch);
	Items.Cash.Enabled = ThisObject.CashPaymentTypes.Count();
	Items.Card.Enabled = ThisObject.BankPaymentTypes.Count();
	Items.PaymentAgent.Enabled = ThisObject.PaymentAgentTypes.Count();
EndProcedure

&AtServer
Procedure FillPaymentMethods()

	ReceiptPaymentMethod = Enums.ReceiptPaymentMethods.FullCalculation;

EndProcedure

// Fill payments
//
// Parameters:
//  Result - See POSClient.ButtonSettings
//  AdditionalParameters - Arbitrary - Additional parameters
&AtClient
Procedure FillPayments(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;

	FoundPayment = ThisObject.Payments.FindRows(Result);
	If FoundPayment.Count() AND Result.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.Cash") Then
		Row = FoundPayment[0];
		Row.Amount = 0;
	Else
		Row = Payments.Add();
		Row.PaymentType = Result.PaymentType;
		Row.BankTerm = Result.BankTerm;
		Row.PaymentTypeEnum = Result.PaymentTypeEnum;

		DefaultPaymentFilter = New Structure;
		DefaultPaymentFilter.Insert("PaymentType", Result.PaymentType);

		If Result.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.Card") Then
			DefaultPaymentFilter.Insert("BankTerm", Result.BankTerm);
			DefaultPayment = BankPaymentTypes.FindRows(DefaultPaymentFilter);
			Row.Percent = DefaultPayment[0].Percent;
			Row.Account = DefaultPayment[0].Account;

			If isReturn Then
				Row.RRNCode = GetRRNCode(Row.PaymentType); // String
			EndIf;

		ElsIf Result.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.PaymentAgent") Then
			DefaultPayment = CashPaymentTypes.FindRows(DefaultPaymentFilter);
			PaymentAgentInfo = PaymentAgentTypes.FindRows(New Structure("PaymentType", Result.PaymentType));
			Row.PaymentAgentLegalName = PaymentAgentInfo[0].Legalname;
			Row.PaymentAgentPartner = PaymentAgentInfo[0].Partner;
			Row.PaymentAgentLegalNameContract = PaymentAgentInfo[0].LegalNameContract;
			Row.PaymentAgentPartnerTerms = PaymentAgentInfo[0].PartnerTerms;
			Row.BankTerm = PaymentAgentInfo[0].BankTerm;
			Row.Percent = PaymentAgentInfo[0].Percent;
		ElsIf Result.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.Certificate") Then
			Row.Certificate = AdditionalParameters.CertStatus.Certificate;
			If AdditionalParameters.CertStatus.Amount > Object.Amount - Payments.Total("Amount") Then
				Row.Amount = Object.Amount - Payments.Total("Amount");
			Else
				Row.Amount = AdditionalParameters.CertStatus.Amount; 
			EndIf;
			Row.Edited = False;		
			Row.CanBeDeleted = AdditionalParameters.CertStatus.CanBeDeleted;	
			Row.PaymentDone = True;
		Else
			DefaultPayment = CashPaymentTypes.FindRows(DefaultPaymentFilter);
			Row.Account = DefaultPayment[0].Account;
		EndIf;
	EndIf;

	If Row.Amount = 0 Then
		If (Object.Amount - Payments.Total("Amount")) <= 0 Then
			RemainingAmount = 0;
		Else
			RemainingAmount = Object.Amount - Payments.Total("Amount");
		EndIf;
		Row.Amount = RemainingAmount;
	EndIf;

	If Result.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.Cash") Then
		Row.AmountString = GetAmountString(Row.Amount);
	ElsIf Result.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.Card") Then
		Settings = EquipmentAcquiringServer.GetAcquiringHardwareSettings();
		Settings.Account = Row.Account;
		Row.Hardware = EquipmentAcquiringServer.GetAcquiringHardware(Settings);
	EndIf;

	Items.Payments.CurrentRow = Row.GetID();
	Items.Payments.CurrentData.Edited = False;
	CurrentItem = Items.Enter;

	CalculatePaymentsAmountTotal();
	FormatPaymentsAmountStringRows();
EndProcedure

&AtClient
Function GetAmountString(Val AmountValue)

	Return Format(AmountValue, "NFD=" + Format(AmountFractionDigitsMaxCount, "NG=0;"));

EndFunction

&AtServerNoContext
Function GetFractionDigitsMaxCount()

	Return Metadata.DefinedTypes.typeAmount.Type.NumberQualifiers.FractionDigits;

EndFunction

#EndRegion

#Region BankPaymentList

&AtClient
Procedure PaymentsDrag(Item, DragParameters, StandardProcessing, Row, Field)
	StandardProcessing = False;
	PaymentRef = DragParameters.Value;
	PaymentRows = BankPaymentTypes.FindRows(New Structure("PaymentType", PaymentRef));
	If PaymentRows.Count() = 0 Then
		Return;
	EndIf;
	Result = POSClient.ButtonSettings();
	FillPropertyValues(Result, PaymentRows[0]);
	Result.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.Card");
	FillPayments(Result, Undefined);
EndProcedure

&AtClient
Procedure BankPaymentTypeListDragStart(Item, DragParameters, Perform)
	PaymentRow = DragParameters.Value;
	If Not BankPaymentTypes.FindRows(New Structure("PaymentType", PaymentRow)).Count() = 0 Then
		Perform = False;
	EndIf;
EndProcedure

&AtClient
Procedure BankPaymentTypeListOnActivateRow(Item)
	Items.BankPaymentTypeList.Expand(Items.BankPaymentTypeList.CurrentRow);
EndProcedure

&AtClient
Procedure BankPaymentTypeListValueChoice(Item, Value, StandardProcessing)
	PaymentRows = BankPaymentTypes.FindRows(New Structure("PaymentType", Value));
	If PaymentRows.Count() = 0 Then
		Return;
	EndIf;
	Result = POSClient.ButtonSettings();
	FillPropertyValues(Result, PaymentRows[0]);
	Result.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.Card");
	FillPayments(Result, Undefined);
EndProcedure

#EndRegion

#Region Acquiring

&AtClient
Async Procedure Payment_PayByPaymentCardManual(Command)
	PaymentRow = Items.Payments.CurrentData;
	If PaymentRow = Undefined Then
		Return;
	EndIf;
	
	If PaymentRow.Amount = 0 Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().ATC_ErrorPaymentsAmountIsZero, Payments.IndexOf(PaymentRow)+1));
		Return;
	EndIf;
	
	Await Payment_PayByPaymentCard(PaymentRow);
	PaymentsOnActivateRow(Undefined);
EndProcedure

&AtClient
Async Function Payment_PayByPaymentCard(PaymentRow)
	PaymentSettings = EquipmentAcquiringAPIClient.PayByPaymentCardSettings();
	PaymentSettings.In.Amount = PaymentRow.Amount;
	PaymentSettings.Form.ElementToLock = ThisObject;
	PaymentSettings.Form.ElementToHideAndShow = Items.GroupWait;
	Result = Await EquipmentAcquiringAPIClient.PayByPaymentCard(PaymentRow.Hardware, PaymentSettings);
	PaymentRow.PaymentInfo = CommonFunctionsServer.SerializeJSON(PaymentSettings);
	If Result Then
		PaymentRow.RRNCode = PaymentSettings.Out.RRNCode;
		PaymentRow.RRNCodeCurrentOperation = PaymentSettings.Out.RRNCode;
		PaymentRow.PaymentDone = True;
		PrintSlip(PaymentRow.Hardware, PaymentSettings);
	Else
		CommonFunctionsClientServer.ShowUsersMessage(PaymentSettings.Info.Error);
	EndIf;

	Return Result;
EndFunction

&AtClient
Async Procedure Payment_ReturnPaymentByPaymentCardManual(Command)
	PaymentRow = Items.Payments.CurrentData;
	If PaymentRow = Undefined Then
		Return;
	EndIf;
	
	If PaymentRow.Amount = 0 Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().ATC_ErrorPaymentsAmountIsZero, Payments.IndexOf(PaymentRow)+1));
		Return;
	EndIf;
	
	Await Payment_ReturnPaymentByPaymentCard(PaymentRow);
	PaymentsOnActivateRow(Undefined);
EndProcedure

&AtClient
Async Function Payment_ReturnPaymentByPaymentCard(PaymentRow)

	PaymentSettings = EquipmentAcquiringAPIClient.ReturnPaymentByPaymentCardSettings();
	PaymentSettings.In.Amount = PaymentRow.Amount;
	PaymentSettings.InOut.RRNCode = PaymentRow.RRNCode;
	PaymentSettings.Form.ElementToLock = ThisObject;
	PaymentSettings.Form.ElementToHideAndShow = Items.GroupWait;
	Result = Await EquipmentAcquiringAPIClient.ReturnPaymentByPaymentCard(PaymentRow.Hardware, PaymentSettings);

	If Result Then
		PaymentRow.PaymentInfo = CommonFunctionsServer.SerializeJSON(PaymentSettings);
		PaymentRow.PaymentDone = True;
		PaymentRow.RRNCode = PaymentSettings.InOut.RRNCode;
		PaymentRow.RRNCodeCurrentOperation = PaymentSettings.InOut.RRNCode;
		
		PrintSlip(PaymentRow.Hardware, PaymentSettings);
	Else
		CommonFunctionsClientServer.ShowUsersMessage(PaymentSettings.Info.Error);
	EndIf;
	Return Result;
EndFunction

&AtClient
Procedure Payment_CancelPaymentByPaymentCardManual(Command)
	PaymentRow = Items.Payments.CurrentData;
	If PaymentRow = Undefined Then
		Return;
	EndIf;
	
	If PaymentRow.Amount = 0 Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().ATC_ErrorPaymentsAmountIsZero, Payments.IndexOf(PaymentRow)+1));
		Return;
	EndIf;
	
	Notify = New NotifyDescription(
		"Payment_CancelPaymentByPaymentCardManual_End", ThisObject, PaymentRow);
	OpenForm(
		"DataProcessor.PointOfSale.Form.CancellationConfirmation",
		New Structure("WarningMessage", R().POS_Warning_ReturnInDay),
		ThisObject,,,, Notify);
EndProcedure

&AtClient
Async Procedure Payment_CancelPaymentByPaymentCardManual_End(Answer, PaymentRow) Export
	If Answer = True Then
		Await Payment_CancelPaymentByPaymentCard(PaymentRow);
		PaymentsOnActivateRow(Undefined);
	EndIf;
EndProcedure

&AtClient
Async Function Payment_CancelPaymentByPaymentCard(PaymentRow)

	PaymentSettings = EquipmentAcquiringAPIClient.CancelPaymentByPaymentCardSettings();
	PaymentSettings.In.Amount = PaymentRow.Amount;
	PaymentSettings.In.RRNCode = PaymentRow.RRNCode; // String
		
	Result = Await EquipmentAcquiringAPIClient.CancelPaymentByPaymentCard(PaymentRow.Hardware, PaymentSettings);
	If Result Then
		If ReturnInTheSameConsolidateSales Then
			PaymentRow.PaymentDone = True;
		Else
			PaymentRow.PaymentDone = False;
		EndIf;
	EndIf;
	
	If Not Result Then
		CommonFunctionsClientServer.ShowUsersMessage(PaymentSettings.Info.Error);
	EndIf;
	
	PrintSlip(PaymentRow.Hardware, PaymentSettings);

	Return Result;
EndFunction

&AtClient
Async Procedure Payment_RevertLastPaymentManual(Command)
	PaymentRow = Items.Payments.CurrentData;
	If PaymentRow = Undefined Then
		Return;
	EndIf;
	
	If PaymentRow.Amount = 0 Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().ATC_ErrorPaymentsAmountIsZero, Payments.IndexOf(PaymentRow)+1));
		Return;
	EndIf;
	
	Notify = New NotifyDescription(
		"Payment_RevertLastPaymentManual_End", ThisObject, PaymentRow);
	OpenForm(
		"DataProcessor.PointOfSale.Form.CancellationConfirmation",
		New Structure("WarningMessage", R().POS_Warning_Revert),
		ThisObject,,,, Notify);
EndProcedure

&AtClient
Async Procedure Payment_RevertLastPaymentManual_End(Answer, PaymentRow) Export
	If Answer = True Then
		Await Payment_RevertLastPayment(PaymentRow);
		PaymentsOnActivateRow(Undefined);
	EndIf;
EndProcedure

&AtClient
Async Function Payment_RevertLastPayment(PaymentRow)

	PaymentSettings = EquipmentAcquiringAPIClient.CancelPaymentByPaymentCardSettings();

	PaymentInfo = CommonFunctionsServer.DeserializeJSON(PaymentRow.PaymentInfo); // Structure

	PaymentSettings.In.Amount = PaymentInfo.In.Amount;
	PaymentSettings.In.RRNCode = PaymentRow.RRNCodeCurrentOperation; // String
		
	Result = Await EquipmentAcquiringAPIClient.CancelPaymentByPaymentCard(PaymentRow.Hardware, PaymentSettings);
	If Result Then
		PaymentRow.PaymentDone = False;
		PaymentRow.RRNCodeCurrentOperation = "";
	EndIf;
	
	If Not Result Then
		CommonFunctionsClientServer.ShowUsersMessage(PaymentSettings.Info.Error);
	EndIf;
	
	PrintSlip(PaymentRow.Hardware, PaymentSettings);

	Return Result;
EndFunction

&AtClient
Async Procedure PrintSlip(Hardware, PaymentSettings)
	SlipInfo = PaymentSettings.Out.Slip;
	Cutter = CommonFunctionsServer.GetRefAttribute(Hardware, "Cutter");
	SlipInfoTmp = StrReplace(SlipInfo, Cutter, "⚪");
	SlipArray = StrSplit(SlipInfoTmp, "⚪", False);

	If SlipArray.Count() = 1 And CommonFunctionsServer.GetRefAttribute(Hardware, "PrintCopyIfCutterNotFound") Then
		SlipArray.Add(SlipArray[0]);
	EndIf;

	For Each SlipInfoPart In SlipArray Do
		PaymentSettings.Out.Slip = SlipInfoPart;
		DocumentPackage = EquipmentFiscalPrinterAPIClient.DocumentPackage();
		DocumentPackage.TextString = StrSplit(SlipInfoPart, Chars.LF + Chars.CR);
		PrintResult = Await EquipmentFiscalPrinterClient.PrintTextDocument(ConsolidatedRetailSales, DocumentPackage); // See EquipmentFiscalPrinterAPIClient.PrintTextDocumentSettings
		If Not PrintResult.Info.Success Then
			CommonFunctionsClientServer.ShowUsersMessage(PrintResult.Info.Error);
		EndIf;
	EndDo;
	PaymentSettings.Out.Slip = SlipInfo;
EndProcedure

// Get RRNCode.
//
// Parameters:
//  PaymentType - CatalogRef.PaymentTypes - Payment type
//  OnlyFirst - Boolean - Only first
//
// Returns:
//  String - Get RRNCode
&AtServer
Function GetRRNCode(PaymentType)
	If EnableRRNCode Then
		Rows = RetailBasis.Payments.FindRows(New Structure("PaymentType", PaymentType));
		For Each Row In Rows Do
			Return Row.RRNCode;
		EndDo;
	EndIf;
	Return "";
EndFunction

&AtClient
Procedure SetPaymentCheck(Command)
	PaymentRow = Items.Payments.CurrentData;
	If PaymentRow = Undefined Then
		Return;
	EndIf;
	PaymentRow.PaymentDone = True;
	PaymentsOnActivateRow(Undefined);
EndProcedure

&AtClient
Procedure SetPaymentUncheck(Command)
	PaymentRow = Items.Payments.CurrentData;
	If PaymentRow = Undefined Then
		Return;
	EndIf;
	PaymentRow.PaymentDone = False;
	PaymentsOnActivateRow(Undefined);
EndProcedure

#EndRegion

AmountFractionDigitsCount = 0;
AmountDotIsActive = False;
AmountFractionDigitsMaxCount = GetFractionDigitsMaxCount();
FormCanBeClosed = False;
EnableRRNCode = True;
