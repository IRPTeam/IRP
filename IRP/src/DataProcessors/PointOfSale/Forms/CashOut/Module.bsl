
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
	
	ThisObject.AutoCreateMoneyTransfer = Parameters.AutoCreateMoneyTransfer;
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If ThisObject.AutoCreateMoneyTransfer Then
		CreateMoneyTransfer(Commands.CreateMoneyTransfer);
	EndIf;
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
	Close(CreateMoneyTransferAtServer());
EndProcedure

&AtServer
Function CreateMoneyTransferAtServer()
	If Not ValueIsFilled(ThisObject.SendAmount) Then
		Return Undefined;
	EndIf;
	
	FillingData.Date = CommonFunctionsServer.GetCurrentSessionDate();
	FillingData.Receiver = ThisObject.Receiver;
	FillingData.SendFinancialMovementType = ThisObject.SendFinancialMovementType;
	FillingData.ReceiveFinancialMovementType = ThisObject.ReceiveFinancialMovementType;
	FillingData.SendAmount = ThisObject.SendAmount;
	FillingData.ReceiveAmount = ThisObject.SendAmount;
	
	If ValueIsFilled(FillingData.Receiver) Then
		FillingData.Insert("ReceiveBranch", FillingData.Receiver.Branch);
	EndIf;
	
	NewDocument = Documents.MoneyTransfer.CreateDocument();
	NewDocument.Fill(FillingData);
	NewDocument.Description = ThisObject.Description;
	
	Try
		NewDocument.Write(DocumentWriteMode.Posting);
	Except
		Return ErrorDescription();
	EndTry;
	
	CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_002, NewDocument.Ref));
	
	Return NewDocument.Ref;
EndFunction
