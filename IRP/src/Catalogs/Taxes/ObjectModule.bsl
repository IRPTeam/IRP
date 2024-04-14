Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	If ThisObject.Type = Enums.TaxType.Amount Then
		ThisObject.TaxRates.Clear();
		RecordSet = InformationRegisters.TaxSettings.CreateRecordSet();
		RecordSet.Filter.Tax.Set(ThisObject.Ref);
		RecordSet.Clear();
		RecordSet.Write();
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	ThisObject.Type = Enums.TaxType.Rate;
	ThisObject.TaxPayer = Enums.TaxPayers.Company;
EndProcedure