#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

Procedure GeneratePhysicalCountByLocation(Parameters, AddInfo = Undefined) Export
	
	BeginTransaction();
	HaveError = False;
	Try
		
		For Each Instance In Parameters.ArrayOfInstance Do
			
			PhysicalCountByLocationObject = Documents.PhysicalCountByLocation.CreateDocument();

			// try lock for modify
			PhysicalCountByLocationObject.Lock();
			PhysicalCountByLocationObject.Fill(Undefined);
			PhysicalCountByLocationObject.Date = CurrentSessionDate();
			PhysicalCountByLocationObject.PhysicalInventory = Parameters.PhysicalInventory;
			PhysicalCountByLocationObject.Store = Parameters.Store;
			PhysicalCountByLocationObject.RuleEditQuantity = Parameters.PhysicalInventory.RuleEditQuantity;
			PhysicalCountByLocationObject.ResponsiblePerson = Instance.ResponsiblePerson;
			PhysicalCountByLocationObject.ItemList.Clear();
			For Each ItemListRow In Instance.ItemList Do
				NewRow = PhysicalCountByLocationObject.ItemList.Add();
				NewRow.Key = ItemListRow.Key;
				NewRow.ItemKey = ItemListRow.ItemKey;
				NewRow.Unit = ItemListRow.Unit;
				NewRow.ExpCount = ItemListRow.ExpCount;
				NewRow.PhysCount = ItemListRow.PhysCount;
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
			// BSLLS:WrongUseOfRollbackTransactionMethod-off
			RollbackTransaction();
			// BSLLS:WrongUseOfRollbackTransactionMethod-on
		Else
			CommitTransaction();
		EndIf;
	EndIf;
EndProcedure

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
		Row = New Structure("Key, Ref, Number, Date, ResponsiblePerson");
		FillPropertyValues(Row, QuerySelection);
		
		Result.Add(Row);
	EndDo;
	Return Result;
EndFunction

// The procedure for filling a spreadsheet document for printing.
//
// Parameters:
//	Spreadsheet - SpreadsheetDocument - spreadsheet document to fill out and print.
//	Ref - Arbitrary - contains a reference to the object for which the print command was executed.
Procedure PrintQR(Spreadsheet, Ref) Export
	Template = Documents.PhysicalCountByLocation.GetTemplate("PrintQR");
	Query = New Query;
	Query.Text =
		"SELECT
		|	PhysicalCountByLocation.Number AS Number
		|FROM
		|	Document.PhysicalCountByLocation AS PhysicalCountByLocation
		|WHERE
		|	PhysicalCountByLocation.Ref IN (&Ref)
		|ORDER BY
		|	Number";
	Query.Parameters.Insert("Ref", Ref);
	VT = Query.Execute().Unload();

	Spreadsheet.Clear();
	SpreadsheetRight = New SpreadsheetDocument();
	
	For IndexRow = -1 To VT.Count() - 1 Do
		For Index = 0 To 4 Do
			If IndexRow = VT.Count() - 1 Then
				Break;
			Else
				IndexRow = IndexRow + 1;
			EndIf;
			Header = Template.GetArea("Row|Column");
			Selection = VT[IndexRow];
			QR = BarcodeServer.GetQRPicture(New Structure("Barcode", Format(Selection.Number, "NG=")));
			Picture = Header.Drawings.Add(SpreadsheetDocumentDrawingType.Picture);
			Picture.Height = 30;
			Picture.Width = 30;
			Picture.Picture = QR;
			Picture.PictureSize = PictureSize.RealSize;
			Picture.Left = Picture.Left + 4;
			Picture.Top = Picture.Top + 4;
			Header.Parameters.Fill(Selection);
			SpreadsheetRight.Join(Header);
		EndDo;
		Spreadsheet.Put(SpreadsheetRight);
		SpreadsheetRight = New SpreadsheetDocument();
	EndDo;
EndProcedure

#Region NewRegistersPosting
Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;

	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;

	Return QueryArray;
EndFunction

#EndRegion