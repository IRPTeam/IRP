// Get certificate status.
// 
// Parameters:
//  Certificate - CatalogRef.SerialLotNumbers - Certificate
//  Document - DocumentRef.RetailSalesReceipt - Document
// 
// Returns:
//  Structure -  Get certificate status:
// * Certificate - CatalogRef.SerialLotNumbers -
// * Sold - Boolean - 
// * Used - Boolean - 
// * Returned - Boolean - 
// * ReturnUsed - Boolean - 
// * CanBeSold - Boolean - 
// * CanBeUsed - Boolean - 
// * Amount - Number - 
Function GetCertificateStatus(Certificate, Document = Undefined) Export
	
	Result = New Structure;
	Result.Insert("Certificate", Certificate);
	Result.Insert("Sold", False);
	Result.Insert("Used", False);
	Result.Insert("Returned", False);
	Result.Insert("ReturnUsed", False);
	Result.Insert("CanBeSold", False);
	Result.Insert("CanBeUsed", False);
	Result.Insert("Amount", 0);

	If Certificate.IsEmpty() Then
		Return Result;
	EndIf;

	 Query = New Query;
	 Query.Text =
	 	"SELECT
		|	R2006T_Certificates.Period AS Period,
		|	R2006T_Certificates.Recorder,
		|	R2006T_Certificates.Currency,
		|	R2006T_Certificates.SerialLotNumber,
		|	R2006T_Certificates.Quantity,
		|	R2006T_Certificates.Amount,
		|	R2006T_Certificates.MovementType
		|FROM
		|	AccumulationRegister.R2006T_Certificates AS R2006T_Certificates
		|WHERE
		|	R2006T_Certificates.SerialLotNumber = &SerialLotNumber
		|
		|ORDER BY
		|	Period";
 
	Query.SetParameter("SerialLotNumber", Certificate);
	
	QueryResult = Query.Execute();
	
	Status = QueryResult.Select();
	
	While Status.Next() Do
		If Status.MovementType = "Sale" Then
			If Status.Recorder = Document Then
				Result.Sold = False;
			Else
				Result.Sold = True;
			EndIf;
			Result.Amount = Status.Amount;
		ElsIf Status.MovementType = "Used" Then
			If Status.Recorder = Document Then
				Result.Used = False;
			Else
				Result.Used = True;
			EndIf;
		ElsIf Status.MovementType = "Returned" Then
			If Status.Recorder = Document Then
				Result.Returned = False;
			Else
				Result.Returned = True;
			EndIf;
		ElsIf Status.MovementType = "ReturnUsed" Then
			If Status.Recorder = Document Then
				Result.ReturnUsed = False;
			Else
				Result.ReturnUsed = True;
			EndIf;		
		EndIf;
	EndDo;
 
	Result.CanBeUsed = Result.Sold And Not Result.Used And Not Result.Returned;
	Result.CanBeSold = Not Result.Sold;
	
	Return Result;
EndFunction