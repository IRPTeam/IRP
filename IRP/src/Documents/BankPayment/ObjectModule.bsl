Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	ThisObject.DocumentAmount = ThisObject.PaymentList.Total("Amount");
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	DocumentsServer.CheckPaymentList(ThisObject, Cancel, CheckedAttributes);
	DocumentsServer.FillCheckBankCashDocuments(ThisObject, CheckedAttributes);
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") And FillingData.Property("BasedOn")   Then
		If  FillingData.BasedOn = "CashTransferOrder" Or
				FillingData.BasedOn = "OutgoingPaymentOrder" Or
				FillingData.BasedOn = "PurchaseInvoice" Then
			Filling_BasedOn(FillingData);
		EndIf;
	EndIf;
	For Each Row In ThisObject.PaymentList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
		AgreementInfo = Undefined;
		If ValueIsFilled(Row.BasisDocument) 
			And Row.BasisDocument.Metadata().Attributes.Find("Agreement") <> Undefined
			And ValueIsFilled(Row.BasisDocument.Agreement) Then
			AgreementInfo = CatAgreementsServer.GetAgreementInfo(Row.BasisDocument.Agreement);
		EndIf;
	EndDo;
EndProcedure

Procedure Filling_BasedOn(FillingData)
	ThisObject.Company = FillingData.Company;
	ThisObject.Account = FillingData.Account;
	ThisObject.TransitAccount = FillingData.TransitAccount;
	ThisObject.Currency = FillingData.Currency;
	ThisObject.TransactionType = FillingData.TransactionType;
	For Each Row In FillingData.PaymentList Do
		NewRow = ThisObject.PaymentList.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;
	ThisObject.DocumentAmount = ThisObject.PaymentList.Total("Amount");
EndProcedure
