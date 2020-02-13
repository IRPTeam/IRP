
Procedure GeneratePhysicalCountByLocation(Parameters, AddInfo = Undefined) Export
	
	BeginTransaction();
	HaveError = False;
	Try
		
		For Each Instance In Parameters.ArrayOfInstance Do
			PhysicalCountByLocationRef = FindPhysicalCountByLocation(Parameters.PhysicalInventory, 
																	 Instance.ResponsiblePerson);
			PhysicalCountByLocationObject = Undefined;
			If ValueIsFilled(PhysicalCountByLocationRef) Then
				PhysicalCountByLocationObject = PhysicalCountByLocationRef.GetObject();
			Else
				PhysicalCountByLocationObject = Documents.PhysicalCountByLocation.CreateDocument();
			EndIf;
			// try lock for modify
			PhysicalCountByLocationObject.Lock();
			PhysicalCountByLocationObject.Fill(Undefined);
			PhysicalCountByLocationObject.Date = CurrentDate();
			PhysicalCountByLocationObject.PhysicalInventory = Parameters.PhysicalInventory;
			PhysicalCountByLocationObject.Store = Parameters.Store;
			PhysicalCountByLocationObject.ResponsiblePerson = Instance.ResponsiblePerson;
			PhysicalCountByLocationObject.ItemList.Clear();
			For Each ItemListRow In Instance.ItemList Do
				NewRow = PhysicalCountByLocationObject.ItemList.Add();
				NewRow.Key = ItemListRow.Key;
				NewRow.ItemKey = ItemListRow.ItemKey;
				NewRow.Unit = ItemListRow.Unit;
				NewRow.ExpCount = ItemListRow.ExpCount;
				NewRow.Difference = ItemListRow.Difference;
			EndDo;
			PhysicalCountByLocationObject.Write();
		EndDo;
	
	Except
		HaveError = True;
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Exc_009, ErrorDescription()));
	EndTry;
	
	If TransactionActive() Then
		If HaveError Then
			RollbackTransaction();
		Else
			CommitTransaction();
		EndIf;
	EndIf;
EndProcedure

Function FindPhysicalCountByLocation(PhysicalInventoryRef, ResponsiblePersonRef, AddInfo = Undefined)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	PhysicalCountByLocation.Ref
	|FROM
	|	Document.PhysicalCountByLocation AS PhysicalCountByLocation
	|WHERE
	|	PhysicalCountByLocation.PhysicalInventory = &PhysicalInventoryRef
	|	AND PhysicalCountByLocation.ResponsiblePerson = &ResponsiblePersonRef
	|	AND
	|	NOT PhysicalCountByLocation.DeletionMark";
	Query.SetParameter("PhysicalInventoryRef", PhysicalInventoryRef);
	Query.SetParameter("ResponsiblePersonRef", ResponsiblePersonRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	Else
		Return Undefined;
	EndIf;
EndFunction

Function GetLinkedPhysicalCountByLocation(PhysicalInventoryRef, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	PhysicalCountByLocationItemList.Key,
	|	PhysicalCountByLocationItemList.Ref,
	|	PhysicalCountByLocationItemList.Ref.Number AS Number,
	|	PhysicalCountByLocationItemList.Ref.Date AS Date,
	|	PhysicalCountByLocationItemList.Ref.ResponsiblePerson AS ResponsiblePerson
	|FROM
	|	Document.PhysicalCountByLocation.ItemList AS PhysicalCountByLocationItemList
	|WHERE
	|	PhysicalCountByLocationItemList.Ref.PhysicalInventory = &PhysicalInventoryRef
	|	AND
	|	NOT PhysicalCountByLocationItemList.Ref.DeletionMark";
	Query.SetParameter("PhysicalInventoryRef", PhysicalInventoryRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Array();
	While QuerySelection.Next() Do
		Result.Add(New Structure("Key, Ref, Number, Date, ResponsiblePerson", 
		QuerySelection.Key, 
		QuerySelection.Ref,
		QuerySelection.Number,
		QuerySelection.Date,
		QuerySelection.ResponsiblePerson));
	EndDo;
	Return Result;
EndFunction
