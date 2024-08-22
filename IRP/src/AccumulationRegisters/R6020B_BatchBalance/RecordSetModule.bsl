
Procedure BeforeWrite(Cancel, Replacing)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	For Each _row In ThisObject Do
		_row.TotalNetAmount = 
			  _row.InvoiceAmount 
			  + _row.IndirectCostAmount
			  + _row.ExtraCostAmountByRatio
			  + _row.ExtraDirectCostAmount
			  + _row.AllocatedCostAmount
			  - _row.AllocatedRevenueAmount;
			  
		_row.TotalTaxAmount = 
			  _row.InvoiceTaxAmount 
			  + _row.IndirectCostTaxAmount
			  + _row.ExtraCostTaxAmountByRatio
			  + _row.ExtraDirectCostTaxAmount
			  + _row.AllocatedCostTaxAmount
			  - _row.AllocatedRevenueTaxAmount;                      
			  
		_row.TotalAmount = _row.TotalNetAmount + _row.TotalTaxAmount;	  
	EndDo;
EndProcedure
