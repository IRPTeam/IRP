Function GetSegmentsRefArrayByPartner(Partner) Export
	ReturnValue = New Array;
	Query = New Query;
	Query.Text = "SELECT
		|	PartnerSegments.Segment
		|FROM
		|	InformationRegister.PartnerSegments AS PartnerSegments
		|WHERE
		|	PartnerSegments.Partner = &Partner";
	Query.SetParameter("Partner", Partner);
	QueryExecute = Query.Execute();
	If Not QueryExecute.IsEmpty() Then
		QueryUnload = QueryExecute.Unload();
		ReturnValue = QueryUnload.UnloadColumn("Segment");
	EndIf;
	Return ReturnValue;
EndFunction