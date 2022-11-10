
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ThisObject.Company = Parameters.FillingData.Company;
	ThisObject.Branch = Parameters.FillingData.Branch;
	
	ThisObject.Sender = Parameters.FillingData.Sender;
	ThisObject.Receiver = Parameters.FillingData.Receiver;
	ThisObject.SendFinancialMovementType = Parameters.FillingData.SendFinancialMovementType;
	ThisObject.ReceiveFinancialMovementType = Parameters.FillingData.ReceiveFinancialMovementType;
	ThisObject.Currency = Parameters.FillingData.SendCurrency;
	
	ThisObject.TotalAtPOS = GetTotalAtPOS();
	ThisObject.SendAmount = ThisObject.TotalAtPOS;
	
	ThisObject.FillingData = Parameters.FillingData;
	
EndProcedure

&AtServer
Function GetTotalAtPOS()
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	R3010B_CashOnHandBalance.Currency,
	|	R3010B_CashOnHandBalance.AmountBalance
	|FROM
	|	AccumulationRegister.R3010B_CashOnHand.Balance(, Company = &Company
	|	AND Branch = &Branch
	|	AND Account = &Account
	|	AND Currency = &Currency
	|	AND CurrencyMovementType = &CurrencyMovementType) AS R3010B_CashOnHandBalance";
	
	Query.SetParameter("Company", ThisObject.Company);
	Query.SetParameter("Currency", ThisObject.Currency);
	Query.SetParameter("Branch", ThisObject.Branch);
	Query.SetParameter("Account", ThisObject.Sender);
	Query.SetParameter("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Return QuerySelection.AmountBalance;
	EndIf;
	
	Return 0;
EndFunction

&AtClient
Procedure CreateMoneyTransfer(Command)
	CreateMoneyTransferAtServer();
	Close();
EndProcedure

&AtServer
Procedure CreateMoneyTransferAtServer()
	
	FillingData.Date = CommonFunctionsServer.GetCurrentSessionDate();
	FillingData.Receiver = ThisObject.Receiver;
	FillingData.SendFinancialMovementType = ThisObject.SendFinancialMovementType;
	FillingData.ReceiveFinancialMovementType = ThisObject.ReceiveFinancialMovementType;
	FillingData.SendAmount = ThisObject.SendAmount;
	FillingData.ReceiveAmount = ThisObject.SendAmount;
	
	NewDocument = Documents.MoneyTransfer.CreateDocument();
	NewDocument.Fill(FillingData);
	NewDocument.Description = ThisObject.Description;
	
	Try
		NewDocument.Write(DocumentWriteMode.Posting);
		Message(StrTemplate(R().InfoMessage_002, NewDocument.Ref));
	Except
		Message(ErrorDescription());
	EndTry;
	
EndProcedure
