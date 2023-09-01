// @strict-types

#Region API

// GetDataKKT - Getting data from the KKT for the registration of the fiscal memory and subsequent work
//
// Returns:
//  Structure - GetDataKKT:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// ** CRS - DocumentRef.ConsolidatedRetailSales -
// * In - Structure:
// ** DeviceID - String - Device ID
// * InOut - Structure -
// * Out - Structure:
// ** TableParametersKKT - See TableParametersKKT
Function GetDataKKTSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "GetDataKKT");
    Str.Info.Insert("Success", False);
    Str.Info.Insert("CRS", PredefinedValue("Document.ConsolidatedRetailSales.EmptyRef"));

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);
    Str.Out.Insert("TableParametersKKT", TableParametersKKT());

    Return Str;
EndFunction

// OperationFN - Operation with the fiscal drive. After the operation, a report on the conduct of the corresponding operation is printed.
//
// Returns:
//  Structure - OperationFN:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// * In - Structure:
// ** DeviceID - String - Device ID
// ** OperationType - Number - Type of operation:
//  1 = Registration
//  2 = Change of registration parameters
//  3 = Closure of the FN
// ** ParametersFiscal - String - Data for the fiscalization of the fiscal drive
// * InOut - Structure -
// * Out - Structure:
Function OperationFNSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "OperationFN");
	Str.Info.Insert("Success", False);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("OperationType", 0);
    Str.In.Insert("ParametersFiscal", "");

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);

    Return Str;
EndFunction

// OpenShift - Opens a new shift and prints a report on the KKT about the opening of the shift.
//
// Returns:
//  Structure - OpenShift:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// * In - Structure:
// ** DeviceID - String - Device ID
// ** InputParameters - See InputParameters
// * InOut - Structure -
// * Out - Structure:
// ** OutputParameters - See OutputParameters
Function OpenShiftSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "OpenShift");
    Str.Info.Insert("Success", False);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("InputParameters", InputParameters());

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);
    Str.Out.Insert("OutputParameters", OutputParameters());

    Return Str;
EndFunction

// CloseShift - Closes the previously opened shift and prints a report on the KKT about the closing of the shift.
//
// Returns:
//  Structure - CloseShift:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// * In - Structure:
// ** DeviceID - String - Device ID
// ** InputParameters - See InputParameters
// * InOut - Structure -
// * Out - Structure:
// ** OutputParameters - See OutputParameters
Function CloseShiftSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "CloseShift");
    Str.Info.Insert("Success", False);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("InputParameters", InputParameters());

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);
    Str.Out.Insert("OutputParameters", OutputParameters());

    Return Str;
EndFunction

// ProcessCheck - Formation of a check in batch mode. A structure is passed that describes the type of check being opened, fiscal and text lines, barcodes that will be printed. Also, payment amounts are passed to close the check.
//
// Returns:
//  Structure - ProcessCheck:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// ** Document - DocumentRef.RetailSalesReceipt, DocumentRef.RetailReturnReceipt - Basis document
// * In - Structure:
// ** DeviceID - String - Device ID
// ** Electronically - Boolean - Formation of a check only in electronic form. The check is not printed.
// ** CheckPackage - See CheckPackage
// * InOut - Structure -
// * Out - Structure:
// ** DocumentOutputParameters - See DocumentOutputParameters
Function ProcessCheckSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "ProcessCheck");
    Str.Info.Insert("Success", False);
    Str.Info.Insert("Document", Undefined);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("Electronically", False);
    Str.In.Insert("CheckPackage", CheckPackage());

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);
    Str.Out.Insert("DocumentOutputParameters", DocumentOutputParameters());

    Return Str;
EndFunction

// ProcessCorrectionCheck - Formation of a correction check in batch mode. A structure is passed that describes the type of check being opened and the attributes of the check.
//
// Returns:
//  Structure - ProcessCorrectionCheck:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// * In - Structure:
// ** DeviceID - String - Device ID
// ** CheckPackage - See CheckPackage
// * InOut - Structure -
// * Out - Structure:
// ** DocumentOutputParameters - See DocumentOutputParameters
Function ProcessCorrectionCheckSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "ProcessCorrectionCheck");
   	Str.Info.Insert("Success", False);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("CheckPackage", CheckPackage());

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);
    Str.Out.Insert("DocumentOutputParameters", DocumentOutputParameters());

    Return Str;
EndFunction

// PrintTextDocument - Printing a text document (text slip-check, information receipt)
//
// Returns:
//  Structure - PrintTextDocument:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// * In - Structure:
// ** DeviceID - String - Device ID
// ** DocumentPackage - See DocumentPackage
// * InOut - Structure -
// * Out - Structure -
Function PrintTextDocumentSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "PrintTextDocument");
    Str.Info.Insert("Success", False);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("DocumentPackage", DocumentPackage());

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);

    Return Str;
EndFunction

// CashInOutcome - Prints a cash deposit / withdrawal check (depends on the amount passed). Amount >= 0 - deposit, Amount < 0 - withdrawal.
//
// Returns:
//  Structure - CashInOutcome:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// ** Document - DocumentRef.CashReceipt, DocumentRef.CashExpense - Basis
// * In - Structure:
// ** DeviceID - String - Device ID
// ** InputParameters - See InputParameters
// ** Amount - Number - Deposit / withdrawal amount
// * InOut - Structure -
// * Out - Structure:
Function CashInOutcomeSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "CashInOutcome");
    Str.Info.Insert("Success", False);
    Str.Info.Insert("Document", Undefined);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("InputParameters", InputParameters());
    Str.In.Insert("Amount", 0);

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);

    Return Str;
EndFunction

// PrintXReport - Prints a shift report without closing the cash shift.
//
// Returns:
//  Structure - PrintXReport:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// * In - Structure:
// ** DeviceID - String - Device ID
// ** InputParameters - See InputParameters
// * InOut - Structure -
// * Out - Structure:
Function PrintXReportSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "PrintXReport");
    Str.Info.Insert("Success", False);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("InputParameters", InputParameters());

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);

    Return Str;
EndFunction

// PrintCheckCopy - Prints a printed duplicate of a previously fiscalized check.
//
// Returns:
//  Structure - PrintCheckCopy:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// * In - Structure:
// ** DeviceID - String - Device ID
// ** CheckNumber - String - Fiscal check number
// * InOut - Structure -
// * Out - Structure:
Function PrintCheckCopySettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "PrintCheckCopy");
    Str.Info.Insert("Success", False);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("CheckNumber", "");

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);

    Return Str;
EndFunction

// GetCurrentStatus - Getting the current status of the KKT.
//
// Returns:
//  Structure - GetCurrentStatus:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// ** CRS - DocumentRef.ConsolidatedRetailSales - Current session 
// * In - Structure:
// ** DeviceID - String - Device ID
// ** InputParameters - See InputParameters
// * InOut - Structure -
// * Out - Structure:
// ** OutputParameters - See OutputParameters
Function GetCurrentStatusSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "GetCurrentStatus");
    Str.Info.Insert("Success", False);
    Str.Info.Insert("CRS", PredefinedValue("Document.ConsolidatedRetailSales.EmptyRef"));

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("InputParameters", InputParameters());

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);
    Str.Out.Insert("OutputParameters", OutputParameters());

    Return Str;
EndFunction

// ReportCurrentStatusOfSettlements - Forms a report on the current state of settlements.
//
// Returns:
//  Structure - ReportCurrentStatusOfSettlements:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// * In - Structure:
// ** DeviceID - String - Device ID
// ** InputParameters - See InputParameters
// * InOut - Structure -
// * Out - Structure:
// ** OutputParameters - String - Output parameters of the operation
Function ReportCurrentStatusOfSettlementsSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "ReportCurrentStatusOfSettlements");
    Str.Info.Insert("Success", False);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("InputParameters", InputParameters());

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);
    Str.Out.Insert("OutputParameters", OutputParameters());

    Return Str;
EndFunction

// OpenCashDrawer - Opens the cash drawer connected to the fiscal registrar.
//
// Returns:
//  Structure - OpenCashDrawer:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// * In - Structure:
// ** DeviceID - String - Device ID
// * InOut - Structure -
// * Out - Structure:
Function OpenCashDrawerSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "OpenCashDrawer");
    Str.Info.Insert("Success", False);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);

    Return Str;
EndFunction

// GetLineLength - Gets the width of the check line in characters.
//
// Returns:
//  Structure - GetLineLength:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// * In - Structure:
// ** DeviceID - String - Device ID
// * InOut - Structure -
// * Out - Structure:
// ** LineLength - Number - Line width in characters
Function GetLineLengthSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "GetLineLength");
    Str.Info.Insert("Success", False);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);
    Str.Out.Insert("LineLength", 0);

    Return Str;
EndFunction

// OpenSessionRegistrationKM - Opens a registration session for the control module.
//
// Returns:
//  Structure - OpenSessionRegistrationKM:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// * In - Structure:
// ** DeviceID - String - Device ID
// * InOut - Structure -
// * Out - Structure:
Function OpenSessionRegistrationKMSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "OpenSessionRegistrationKM");
    Str.Info.Insert("Success", False);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);

    Return Str;
EndFunction

// CloseSessionRegistrationKM - Closes the registration session for the control module.
//
// Returns:
//  Structure - CloseSessionRegistrationKM:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// * In - Structure:
// ** DeviceID - String - Device ID
// * InOut - Structure -
// * Out - Structure:
Function CloseSessionRegistrationKMSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "CloseSessionRegistrationKM");
    Str.Info.Insert("Success", False);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);

    Return Str;
EndFunction

// RequestKM - Sends a request to the control module.
//
// Returns:
//  Structure - RequestKM:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// * In - Structure:
// ** DeviceID - String - Device ID
// ** RequestKM - See RequestKMInput
// * InOut - Structure -
// * Out - Structure:
// ** RequestKMResult - See RequestKMResult
Function RequestKMSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "RequestKM");
    Str.Info.Insert("Success", False);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("RequestKM", RequestKMInput());

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);
    Str.Out.Insert("RequestKMResult", RequestKMResult());

    Return Str;
EndFunction

// GetProcessingKMResult - Gets the results of processing the control module.
//
// Returns:
//  Structure - GetProcessingKMResult:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// ** Approved - Boolean - Is code string was approved
// ** GUID - String - GUID Request
// * In - Structure:
// ** DeviceID - String - Device ID
// * InOut - Structure -
// * Out - Structure:
// ** ProcessingKMResult - See ProcessingKMResult
// ** RequestStatus - Number - Request status:
// 0 = result received,
// 1 = result not yet received,
// 2 = result cannot be received
Function GetProcessingKMResultSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "GetProcessingKMResult");
    Str.Info.Insert("Success", False);
    Str.Info.Insert("Approved", False);
    Str.Info.Insert("GUID", "");

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);
    Str.Out.Insert("ProcessingKMResult", ProcessingKMResult());
    Str.Out.Insert("RequestStatus", 0);

    Return Str;
EndFunction

// ConfirmKM - Confirms or cancels the previously checked KM as part of a document on the sale of marked goods. KM must have been previously checked by the RequestKM method.
//
// Returns:
//  Structure - ConfirmKM:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// ** Success - Boolean - Operation status
// * In - Structure:
// ** DeviceID - String - Device ID
// ** GUID - String - Unique identifier of the KM request, which was previously made by the RequestKM method
// ** ConfirmationType - Number -
// 	0 = KM will be implemented as part of a document on the sale of marked goods.
// 	1 = KM will not be implemented. Will NOT be included in the document on the sale of marked goods.
// * InOut - Structure -
// * Out - Structure:
Function ConfirmKMSettings() Export
    Str = New Structure;

    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "ConfirmKM");
    Str.Info.Insert("Success", False);

    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("GUID", "");
    Str.In.Insert("ConfirmationType", 0);

    Str.Insert("InOut", New Structure);

    Str.Insert("Out", New Structure);

    Return Str;
EndFunction

#EndRegion

#Region Additional

// Processing KM Result.
//
// Returns:
//  Structure - Processing KM Result:
// * GUID - String - Unique request identifier.
// * Result - Boolean - True if the KP KM check result is positive. False if the KP KM check result is negative.
// * ResultCode - Number - Result of checking information about the product, tag 2106, Table 110
// * StatusInfo - Number - Value from 1 to 3 from table 106 (FFD). The product status is correct if the attribute has a value of 1.
// * HandleCode - Number - Request processing code. Value from 0 to 2 from table 132.
Function ProcessingKMResult() Export
    ProcessingKMResult = New Structure;
    ProcessingKMResult.Insert("GUID", "");
    ProcessingKMResult.Insert("Result", False);
    ProcessingKMResult.Insert("ResultCode", 0);
    ProcessingKMResult.Insert("StatusInfo", 0);
    ProcessingKMResult.Insert("HandleCode", 0);
    Return ProcessingKMResult;
EndFunction

// Request KM.
//
// Parameters:
//  isReturn - Boolean - Is return
//
// Returns:
//  Structure - Request KM:
// * GUID - String - Unique request identifier. Formed by 1C.
// * WaitForResult - Boolean - Whether to wait for a response from OISM. True - wait, False - do not wait for a response.
// * MarkingCode - String - Control marking code. Encoded in Base64.
// * PlannedStatus - Number - Planned status of the product. Value from 1 to 5 from table 105 (FFD).
// * Quantity - Number - Quantity
// * MeasureOfQuantity - String - Measure of the quantity of the subject of calculation. Value from table 114 (FFD).
Function RequestKMInput(isReturn = False) Export
    RequestKM = New Structure;
    RequestKM.Insert("GUID", String(New UUID()));
    RequestKM.Insert("WaitForResult", True);
    RequestKM.Insert("MarkingCode", "");
    RequestKM.Insert("PlannedStatus", ?(isReturn, 3, 1));
    RequestKM.Insert("Quantity", 1);
    RequestKM.Insert("MeasureOfQuantity", "");
    Return RequestKM;
EndFunction

// Request KM Result.
//
// Returns:
//  Structure - Request KM Result:
// * Checking - Boolean - True if the marking code has been checked by the fiscal accumulator using the KP verification key. False if the marking code cannot be checked by the fiscal accumulator using the KP verification key.
// * CheckingResult - Boolean - True if the KP KM check result by the fiscal accumulator using the KP verification key is positive. False if the KP KM check result by the fiscal accumulator using the KP verification key is negative.
Function RequestKMResult() Export
    RequestKMResult = New Structure;
    RequestKMResult.Insert("Checking", False);
    RequestKMResult.Insert("CheckingResult", False);
    Return RequestKMResult;
EndFunction

// Table parameters KKT. Registration data of the fiscal memory module.
//
// Returns:
//  Structure - Table parameters KKT:
// * KKTNumber - String - Registration number of KKT
// * KKTSerialNumber - String - Factory number of KKT
// * FirmwareVersion - String - Firmware version
// * Fiscal - Boolean - Registration sign of the fiscal accumulator
// * FFDVersionFN - String - FFD version of FN
// * FFDVersionKKT - String - FFD version of KKT
// * FNSerialNumber - String - Factory number of FN
// * DocumentNumber - String - Document number of fiscal accumulator registration
// * DateTime - Date - Date and time of fiscal accumulator registration operation
// * CompanyName - String - Organization name
// * INN - String - Organization INN
// * SaleAddress - String - Address of calculations
// * SaleLocation - String - Place of calculations
// * TaxationSystems - String - Taxation system codes
// * IsOffline - Boolean - Offline mode sign
// * IsEncrypted - Boolean - Data encryption sign
// * IsService - Boolean - Service calculations sign
// * IsExcisable - Boolean - Excisable goods sale sign
// * IsGambling - Boolean - Gambling sign
// * IsLottery - Boolean - Lottery sign
// * BSOSing - Boolean - AS BSO formation sign
// * IsOnline - Boolean - KKT for online calculations sign
// * IsAutomaticPrinter - Boolean - Printer in automatic mode sign
// * IsAutomatic - Boolean - Automatic mode sign
// * IsMarking - Boolean - Marking sign for goods
// * IsPawnshop - Boolean - Pawnshop lending sign
// * IsAssurance - Boolean - Insurance activity sign
// * AgentTypes - String - Agent signs codes
// * AutomaticNumber - String - Automatic number for automatic mode
// * OFDCompany - String - OFD organization name
// * OFDCompanyINN - String - OFD organization INN
// * FNSURL - String - FNS website address
// * SenderEmail - String - Sender's email address for the check
Function TableParametersKKT() Export
	Str = New Structure;
	Str.Insert("KKTNumber", "");
	Str.Insert("KKTSerialNumber", "");
	Str.Insert("FirmwareVersion", "");
	Str.Insert("Fiscal", False);
	Str.Insert("FFDVersionFN", "");
	Str.Insert("FFDVersionKKT", "");
	Str.Insert("FNSerialNumber", "");
	Str.Insert("DocumentNumber", "");
	Str.Insert("DateTime", Date(1, 1, 1));
	Str.Insert("CompanyName", "");
	Str.Insert("INN", "");
	Str.Insert("SaleAddress", "");
	Str.Insert("SaleLocation", "");
	Str.Insert("TaxationSystems", "");
	Str.Insert("IsOffline", False);
	Str.Insert("IsEncrypted", False);
	Str.Insert("IsService", False);
	Str.Insert("IsExcisable", False);
	Str.Insert("IsGambling", False);
	Str.Insert("IsLottery", False);
	Str.Insert("BSOSing", False);
	Str.Insert("IsOnline", False);
	Str.Insert("IsAutomaticPrinter", False);
	Str.Insert("IsAutomatic", False);
	Str.Insert("IsMarking", False);
	Str.Insert("IsPawnshop", False);
	Str.Insert("IsAssurance", False);
	Str.Insert("AgentTypes", "");
	Str.Insert("AutomaticNumber", "");
	Str.Insert("OFDCompany", "");
	Str.Insert("OFDCompanyINN", "");
	Str.Insert("FNSURL", "");
	Str.Insert("SenderEmail", "");
	Return Str;
EndFunction

// Input parameters.
//
// Returns:
//  Structure - Input parameters:
// * CashierName - String - Full name and position of the authorized person for the operation
// * CashierINN - String - INN of the authorized person for the operation
// * SaleAddress - String - Address of calculations
// * SaleLocation - String - Place of calculations
Function InputParameters() Export
	Str = New Structure;
	Str.Insert("CashierName", "");
	Str.Insert("CashierINN", "");
	Str.Insert("SaleAddress", "");
	Str.Insert("SaleLocation", "");
	Return Str;
EndFunction

// Check package.
//
// Returns:
//  Structure - Input parameters:
// * Parameters - Structure:
// ** CashierName - String - Full name and position of the authorized person for the operation
// ** CashierINN - String - Taxpayer Identification Number of the authorized person
// ** OperationType - Number - Type of operation
// ** CorrectionData - Structure - Data for correction operation
// ** TaxationSystem - Number - Taxation system code
// ** CustomerDetail - Structure - Customer (client) details:
// *** Info - String - Name of the organization or surname, name, patronymic (if available)
// *** INN - String - INN of the organization or buyer (client)
// *** DateOfBirth - String - Date of birth of the buyer (client) in the format "DD.MM.YYYY"
// *** Citizenship - String - Numeric code of the country of which the buyer (client) is a citizen. The country code is specified in accordance with the All-Russian Classifier of Countries of the World OKSM.
// *** DocumentTypeCode - Number - Numeric code of the type of identity document (FFD, Table 116)
// *** DocumentData - String - Data of the identity document
// *** Address - String - Address of the buyer (client)
// ** CustomerEmail - String - Customer's email
// ** CustomerPhone - String - Customer's phone number
// ** SenderEmail - String - Sender's email address
// ** SaleAddress - String - Sale address
// ** SaleLocation - String - Sale location
// ** AutomatNumber - String - Automat number
// ** AgentType - Number - Agent type indicator
// ** AgentData - Structure - Agent's data for the item:
// *** AgentOperation - String - Operation of the payment agent
// *** AgentPhone - String - Phone of the payment agent. Multiple values allowed, separated by ","
// *** PaymentProcessorPhone - String - Phone of the payment processor. Multiple values allowed, separated by ","
// *** AcquirerOperatorPhone - String - Phone of the acquirer operator. Multiple values allowed, separated by ","
// *** AcquirerOperatorName - String - Name of the acquirer operator
// *** AcquirerOperatorAddress - String - Address of the acquirer operator
// *** AcquirerOperatorINN - String - INN of the acquirer operator
// ** VendorData - Structure - Vendor's data for the item:
// *** VendorPhone - String - Phone of the vendor. Multiple values allowed, separated by ","
// *** VendorName - String - Name of the vendor
// *** VendorINN - String - INN of the vendor
// ** UserAttribute - Structure - Additional user attribute
// ** AdditionalAttribute - String - Additional check attribute
// ** OperationalAttribute - Structure - Operational attribute of the check
// ** IndustryAttribute - Structure - Industry attribute of the check
// * Positions - Structure:
// ** FiscalStrings - Array Of See CheckPackage_FiscalString
// ** FiscalStringJSON - String - Serialazed for server call function CheckPackage_FiscalString
// ** TextStrings - Array Of String - Additional non fiscal string for print
// ** Barcode - Structure:
// *** Type - String - String defining the barcode type
// *** Value - String - Barcode value
// * Payments - Structure:
// ** Cash - Number - Cash payment amount
// ** ElectronicPayment - Number - Non-cash payment amount
// ** PrePayment - Number - Amount of credited prepayment or advance
// ** PostPayment - Number - Credit payment amount
// ** Barter - Number - Payment amount by counter provision
Function CheckPackage() Export
    Str = New Structure;

    // Parameters section
    Str.Insert("Parameters", New Structure);
    Str.Parameters.Insert("CashierName", "");
    Str.Parameters.Insert("CashierINN", "");
    Str.Parameters.Insert("OperationType", 0);
    Str.Parameters.Insert("CorrectionData", New Structure);
    Str.Parameters.Insert("TaxationSystem", 0);

    CustomerDetail = New Structure;
    CustomerDetail.Insert("Info", "");
    CustomerDetail.Insert("INN", "");
    CustomerDetail.Insert("DateOfBirth", "");
    CustomerDetail.Insert("Citizenship", "");
    CustomerDetail.Insert("DocumentTypeCode", 0);
    CustomerDetail.Insert("DocumentData", "");
    CustomerDetail.Insert("Address", "");
    Str.Parameters.Insert("CustomerDetail", CustomerDetail);

    Str.Parameters.Insert("CustomerEmail", "");
    Str.Parameters.Insert("CustomerPhone", "");
    Str.Parameters.Insert("SenderEmail", "");
    Str.Parameters.Insert("SaleAddress", "");
    Str.Parameters.Insert("SaleLocation", "");
    Str.Parameters.Insert("AutomatNumber", "");
    Str.Parameters.Insert("AgentType", 0);

    AgentData = New Structure;
    AgentData.Insert("AgentOperation", "");
    AgentData.Insert("AgentPhone", "");
    AgentData.Insert("PaymentProcessorPhone", "");
    AgentData.Insert("AcquirerOperatorPhone", "");
    AgentData.Insert("AcquirerOperatorName", "");
    AgentData.Insert("AcquirerOperatorAddress", "");
    AgentData.Insert("AcquirerOperatorINN", "");
    Str.Parameters.Insert("AgentData", AgentData);

	VendorData = New Structure;
    VendorData.Insert("VendorPhone", "");
    VendorData.Insert("VendorName", "");
    VendorData.Insert("VendorINN", "");
    Str.Parameters.Insert("VendorData", VendorData);

    Str.Parameters.Insert("UserAttribute", New Structure);
    Str.Parameters.Insert("AdditionalAttribute", "");
    Str.Parameters.Insert("OperationalAttribute", New Structure);
    Str.Parameters.Insert("IndustryAttribute", New Structure);

    // Positions section
    Str.Insert("Positions", New Structure);

    Str.Positions.Insert("FiscalStrings", New Array);
    Str.Positions.Insert("FiscalStringJSON", CommonFunctionsServer.SerializeJSON(CheckPackage_FiscalString()));

    Str.Positions.Insert("TextStrings", New Array);

    Barcode = New Structure;
    Barcode.Insert("Type", "QR");
    Barcode.Insert("Value", "");
    Str.Positions.Insert("Barcode", Barcode);

    // Payments section
    Str.Insert("Payments", New Structure);
    Str.Payments.Insert("Cash", 0);
    Str.Payments.Insert("ElectronicPayment", 0);
    Str.Payments.Insert("PrePayment", 0);
    Str.Payments.Insert("PostPayment", 0);
    Str.Payments.Insert("Barter", 0);
    Return Str;
EndFunction

// Check package - Fiscal string.
//
// Returns:
//  Structure - Fiscal string:
// * Name - String - Name of the product
// * Quantity - Number - Quantity of the product
// * PriceWithDiscount - Number - Price per product unit with discounts/surcharges
// * AmountWithDiscount - Number - Final amount for the item with all discounts/surcharges
// * DiscountAmount - Number - Amount of discounts and surcharges
// * Department - Number - Department where the sale is conducted
// * VATRate - String - VAT rate
// * VATAmount - Number - VAT amount for the item
// * PaymentMethod - Number - Payment method indicator
// * CalculationSubject - Number - Calculation subject indicator
// * CalculationAgent - Number - Calculation agent indicator
// * AgentData - Structure - Agent's data for the item:
// ** AgentOperation - String - Operation of the payment agent
// ** AgentPhone - String - Phone of the payment agent. Multiple values allowed, separated by ","
// ** PaymentProcessorPhone - String - Phone of the payment processor. Multiple values allowed, separated by ","
// ** AcquirerOperatorPhone - String - Phone of the acquirer operator. Multiple values allowed, separated by ","
// ** AcquirerOperatorName - String - Name of the acquirer operator
// ** AcquirerOperatorAddress - String - Address of the acquirer operator
// ** AcquirerOperatorINN - String - INN of the acquirer operator
// * VendorData - Structure - Vendor's data for the item:
// ** VendorPhone - String - Phone of the vendor. Multiple values allowed, separated by ","
// ** VendorName - String - Name of the vendor
// ** VendorINN - String - INN of the vendor
// * MeasureOfQuantity - Number - Measure of quantity for the item
// * FractionalQuantity - Structure:
// ** Numerator - Number - Fractional quantity of marked product (numerator)
// ** Denominator - Number - Fractional quantity of marked product (denominator)
// * GoodCodeData - Structure - Data of the good code
// * MarkingCode - String - Control marking code
// * CountryOfOrigin - String - Digital code of the product's country of origin
// * CustomsDeclaration - String - Customs declaration registration number
// * AdditionalAttribute - String - Additional attribute of the item
// * ExciseAmount - Number - Excise amount included in the item's price
// * IndustryAttribute - Structure - Industry attribute of the item
Function CheckPackage_FiscalString() Export
    Str = New Structure;

    Str.Insert("Name", "");
    Str.Insert("Quantity", 0);
    Str.Insert("PriceWithDiscount", 0);
    Str.Insert("AmountWithDiscount", 0);
    Str.Insert("DiscountAmount", 0);
    Str.Insert("Department", 0);
    Str.Insert("VATRate", "");
    Str.Insert("VATAmount", 0);
    Str.Insert("PaymentMethod", 0);
    Str.Insert("CalculationSubject", 0);
    Str.Insert("CalculationAgent", -1);

    Str.Insert("AgentData", New Structure);
    Str.AgentData.Insert("AgentOperation", "");
    Str.AgentData.Insert("AgentPhone", "");
    Str.AgentData.Insert("PaymentProcessorPhone", "");
    Str.AgentData.Insert("AcquirerOperatorPhone", "");
    Str.AgentData.Insert("AcquirerOperatorName", "");
    Str.AgentData.Insert("AcquirerOperatorAddress", "");
    Str.AgentData.Insert("AcquirerOperatorINN", "");

    Str.Insert("VendorData", New Structure);
    Str.VendorData.Insert("VendorPhone", "");
    Str.VendorData.Insert("VendorName", "");
    Str.VendorData.Insert("VendorINN", "");

    Str.Insert("MeasureOfQuantity", 0);
    Str.Insert("FractionalQuantity", New Structure);
    Str.FractionalQuantity.Insert("Numerator", 0);
    Str.FractionalQuantity.Insert("Denominator", 0);
    Str.Insert("GoodCodeData", New Structure);
    Str.Insert("MarkingCode", "");
    Str.Insert("CountryOfOrigin", "");
    Str.Insert("CustomsDeclaration", "");
    Str.Insert("AdditionalAttribute", "");
    Str.Insert("ExciseAmount", 0);
    Str.Insert("IndustryAttribute", New Structure);

    Return Str;
EndFunction

// Builds a structure based on the provided shift information table.
//
// Returns:
//  Structure - Input parameters:
// * ShiftNumber - Number - Number of the opened/closed shift
// * CheckNumber - Number - Number of the last fiscal document
// * ShiftClosingCheckNumber - Number - Number of the last check for the shift
// * DateTime - Date - Date and time of the fiscal document formation
// * ShiftState - Number - Shift state (1 - Closed, 2 - Opened, 3 - Expired)
// * CountersOperationType1 - See OperationCounters
// * CountersOperationType2 - See OperationCounters
// * CountersOperationType3 - See OperationCounters
// * CountersOperationType4 - See OperationCounters
// * CashBalance - Number - Cash balance in the cash register
// * BacklogDocumentsCounter - Number - Number of undelivered documents
// * BacklogDocumentFirstNumber - Number - Number of the first undelivered document
// * BacklogDocumentFirstDateTime - Date - Date and time of the first undelivered document
// * FNError - Boolean - Indicator of the urgent need to replace the FN
// * FNOverflow - Boolean - FN memory overflow indicator
// * FNFail - Boolean - Indicator of FN resource exhaustion
Function OutputParameters() Export
    Str = New Structure;

    // Parameters section
    Str.Insert("ShiftNumber", 0);
    Str.Insert("CheckNumber", 0);
    Str.Insert("ShiftClosingCheckNumber", 0);
    Str.Insert("DateTime", Date(1, 1, 1));
    Str.Insert("ShiftState", 0);
    Str.Insert("CountersOperationType1", OperationCounters());
    Str.Insert("CountersOperationType2", OperationCounters());
    Str.Insert("CountersOperationType3", OperationCounters());
    Str.Insert("CountersOperationType4", OperationCounters());
    Str.Insert("CashBalance", 0);
    Str.Insert("BacklogDocumentsCounter", 0);
    Str.Insert("BacklogDocumentFirstNumber", 0);
    Str.Insert("BacklogDocumentFirstDateTime", Date(1, 1, 1));
    Str.Insert("FNError", False);
    Str.Insert("FNOverflow", False);
    Str.Insert("FNFail", False);

    Return Str;
EndFunction

// Operation сounters.
//
// Returns:
//  Structure - Input parameters:
// * CheckCount - Number - Number of checks for the operation of this type
// * TotalChecksAmount - Number - Total amount of checks for the operations of this type
// * CorrectionCheckCount - Number - Number of correction checks for the operation of this type
// * TotalCorrectionChecksAmount - Number - Total amount of correction checks for the operations of this type
Function OperationCounters() Export
    Str = New Structure;

    // OperationCounters section
    Str.Insert("CheckCount", 0);
    Str.Insert("TotalChecksAmount", 0);
    Str.Insert("CorrectionCheckCount", 0);
    Str.Insert("TotalCorrectionChecksAmount", 0);

    Return Str;
EndFunction

// Document package.
//
// Returns:
//  Structure - Document package:
// * TextString - Array Of String - Text for print
// * Barcode - Structure - Print barcode, if value is filled:
// ** Type - String - EAN8, EAN13, CODE39, QR
// ** Value - String - Barcode value
Function DocumentPackage() Export
    Str = New Structure;

    Str.Insert("TextString", New Array);

    Barcode = New Structure;
    Barcode.Insert("Type", "QR");
    Barcode.Insert("Value", "");

    Str.Insert("Barcode", Barcode);

    Return Str;
EndFunction

// Document Output Parameters constructor.
//
// Returns:
//  Structure - Document Output Parameters:
// * ShiftNumber - Number - Number of the open shift/Number of the closed shift
// * CheckNumber - Number - Number of the fiscal document
// * ShiftClosingCheckNumber - Number - Check number for the shift
// * AddressSiteInspections - String - Address of the inspection site
// * FiscalSign - String - Fiscal sign
// * DateTime - Date - Date and time of document creation
Function DocumentOutputParameters() Export
    DocumentOutputParameters = New Structure;
    DocumentOutputParameters.Insert("ShiftNumber", 0);
    DocumentOutputParameters.Insert("CheckNumber", 0);
    DocumentOutputParameters.Insert("ShiftClosingCheckNumber", 0);
    DocumentOutputParameters.Insert("AddressSiteInspections", "");
    DocumentOutputParameters.Insert("FiscalSign", "");
    DocumentOutputParameters.Insert("DateTime", Date(1, 1, 1));
    Return DocumentOutputParameters;
EndFunction

#EndRegion

#Region Device

// GetDataKKT.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See GetDataKKTSettings
//
// Returns:
//  Boolean - Getting data from the KKT for the registration of the fiscal memory and subsequent work
Async Function GetDataKKT(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.GetDataKKT(Hardware, Settings);
EndFunction

// OperationFN.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See OperationFNSettings
//
// Returns:
//  Boolean - Operation with the fiscal drive. After the operation, a report on the conduct of the corresponding operation is printed.
Async Function OperationFN(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.OperationFN(Hardware, Settings);
EndFunction

// OpenShift.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See OpenShiftSettings
//
// Returns:
//  Boolean - Opening of the shift in the KKT. After the operation, a shift opening report is printed.
Async Function OpenShift(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.OpenShift(Hardware, Settings);
EndFunction

// CloseShift.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See CloseShiftSettings
//
// Returns:
//  Boolean - Closing of the shift in the KKT. After the operation, a shift closing report is printed.
Async Function CloseShift(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.CloseShift(Hardware, Settings);
EndFunction

// ProcessCheck.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See ProcessCheckSettings
//
// Returns:
//  Boolean - Formation of a check (receipt) in the KKT. After the operation, a check (receipt) is printed.
Async Function ProcessCheck(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.ProcessCheck(Hardware, Settings);
EndFunction

// ProcessCorrectionCheck.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See ProcessCorrectionCheckSettings
//
// Returns:
//  Boolean - Formation of a correction check in the KKT. After the operation, a correction check is printed.
Async Function ProcessCorrectionCheck(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.ProcessCorrectionCheck(Hardware, Settings);
EndFunction

// PrintTextDocument.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See PrintTextDocumentSettings
//
// Returns:
//  Boolean - Printing a text document on the KKT.
Async Function PrintTextDocument(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.PrintTextDocument(Hardware, Settings);
EndFunction

// CashInOutcome.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See CashInOutcomeSettings
//
// Returns:
//  Boolean - Printing a check of income or withdrawal of cash from the cash register.
Async Function CashInOutcome(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.CashInOutcome(Hardware, Settings);
EndFunction

// PrintXReport.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See PrintXReportSettings
//
// Returns:
//  Boolean - Printing a report without resetting.
Async Function PrintXReport(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.PrintXReport(Hardware, Settings);
EndFunction

// PrintCheckCopy.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See PrintCheckCopySettings
//
// Returns:
//  Boolean - Printing a copy of the check.
Async Function PrintCheckCopy(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.PrintCheckCopy(Hardware, Settings);
EndFunction

// GetCurrentStatus.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See GetCurrentStatusSettings
//
// Returns:
//  Boolean - Getting the current state of the KKT.
Async Function GetCurrentStatus(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.GetCurrentStatus(Hardware, Settings);
EndFunction

// ReportCurrentStatusOfSettlements.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See ReportCurrentStatusOfSettlementsSettings
//
// Returns:
//  Boolean - Getting a report on the current state of settlements.
Async Function ReportCurrentStatusOfSettlements(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.ReportCurrentStatusOfSettlements(Hardware, Settings);
EndFunction

// OpenCashDrawer.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See OpenCashDrawerSettings
//
// Returns:
//  Boolean - Opening the cash drawer.
Async Function OpenCashDrawer(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.OpenCashDrawer(Hardware, Settings);
EndFunction

// GetLineLength.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See GetLineLengthSettings
//
// Returns:
//  Boolean - Getting the line length for the KKT.
Async Function GetLineLength(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.GetLineLength(Hardware, Settings);
EndFunction

// OpenSessionRegistrationKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See OpenSessionRegistrationKMSettings
//
// Returns:
//  Boolean - Opening a registration session in the control module.
Async Function OpenSessionRegistrationKM(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.OpenSessionRegistrationKM(Hardware, Settings);
EndFunction

// CloseSessionRegistrationKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See CloseSessionRegistrationKMSettings
//
// Returns:
//  Boolean - Closing a registration session in the control module.
Async Function CloseSessionRegistrationKM(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.CloseSessionRegistrationKM(Hardware, Settings);
EndFunction

// RequestKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See RequestKMSettings
//
// Returns:
//  Boolean - Sending a request to the control module.
Async Function RequestKM(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.RequestKM(Hardware, Settings);
EndFunction

// GetProcessingKMResult.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See GetProcessingKMResultSettings
//
// Returns:
//  Boolean - The method requests the results of the marking code check in the OISM.
Async Function GetProcessingKMResult(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.GetProcessingKMResult(Hardware, Settings);
EndFunction

// ConfirmKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See ConfirmKMSettings
//
// Returns:
//  Boolean - Confirms or cancels the previously checked KM as part of the document on the sale of marked goods. KM must have been previously checked by the RequestKM method.
Async Function ConfirmKM(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.ConfirmKM(Hardware, Settings);
EndFunction

#EndRegion
