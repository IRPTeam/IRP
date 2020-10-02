
Procedure SetBasisDocumentReadOnly(Object, CurrentData = Undefined) Export
	ArrayOfAgreements = New Array();
	If CurrentData <> Undefined Then
		If ValueIsFilled(CurrentData.Agreement) Then
			ArrayOfAgreements.Add(New Structure("ReadOnly, Agreement", False, CurrentData.Agreement));
			CurrentData.BasisDocumentReadOnly = 
			DocCreditDebitNoteServer.IsBasisDocumentReadOnly(ArrayOfAgreements)[0].ReadOnly;
		Else
			CurrentData.BasisDocumentReadOnly = False;
		EndIf;  
	Else		
		For Each Row In Object.Transactions Do
			ArrayOfAgreements.Add(New Structure("ReadOnly, Agreement", False, Row.Agreement));
		EndDo;
		ArrayOfAgreements = DocCreditDebitNoteServer.IsBasisDocumentReadOnly(ArrayOfAgreements);
		For Index = 0 To ArrayOfAgreements.Count() - 1 Do
			Object.Transactions[Index].BasisDocumentReadOnly = ArrayOfAgreements[Index].ReadOnly;
		EndDo;
	EndIf;
EndProcedure
