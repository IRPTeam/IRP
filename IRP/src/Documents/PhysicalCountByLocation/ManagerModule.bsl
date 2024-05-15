#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion
#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Branch", Obj.Branch);
	AccessKeyMap.Insert("Store", Obj.Store);
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Service

Procedure GeneratePhysicalCountByLocation(Parameters, AddInfo = Undefined) Export

	BeginTransaction();
	Try
		For Each Instance In Parameters.ArrayOfInstance Do

			Wrapper = BuilderAPI.Initialize("PhysicalCountByLocation");
			BuilderAPI.SetProperty(Wrapper, "Date", CommonFunctionsServer.GetCurrentSessionDate());
			BuilderAPI.SetProperty(Wrapper, "PhysicalInventory", Parameters.PhysicalInventory);
			BuilderAPI.SetProperty(Wrapper, "Store", Parameters.Store);
			BuilderAPI.SetProperty(Wrapper, "Branch", Parameters.Branch);
			BuilderAPI.SetProperty(Wrapper, "UseSerialLot", Parameters.PhysicalInventory.UseSerialLot);
			BuilderAPI.SetProperty(Wrapper, "RuleEditQuantity", Parameters.PhysicalInventory.RuleEditQuantity);
			BuilderAPI.SetProperty(Wrapper, "TransactionType", Enums.PhysicalCountByLocationTransactionType.PhysicalInventory);

			For Each ItemListRow In Instance.ItemList Do
				NewRow = BuilderAPI.AddRow(Wrapper, "Wrapper");
				BuilderAPI.SetRowProperty(Wrapper, NewRow, "ItemKey", ItemListRow.ItemKey);
				BuilderAPI.SetRowProperty(Wrapper, NewRow, "Unit", ItemListRow.Unit);
				BuilderAPI.SetRowProperty(Wrapper, NewRow, "ExpCount", ItemListRow.ExpCount);
				BuilderAPI.SetRowProperty(Wrapper, NewRow, "PhysCount", ItemListRow.PhysCount);
				BuilderAPI.SetRowProperty(Wrapper, NewRow, "Difference", ItemListRow.PhysCount);
			EndDo;
			BuilderAPI.Write(Wrapper);
		EndDo;
		CommitTransaction();
	Except
		RollbackTransaction();
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Exc_009, ErrorDescription()));
	EndTry;

EndProcedure

Function GetLinkedPhysicalCountByLocation(PhysicalInventoryRef, AddInfo = Undefined) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	Doc.Ref,
	|	Doc.Number AS Number,
	|	Doc.Date AS Date
	|FROM
	|	Document.PhysicalCountByLocation AS Doc
	|WHERE
	|	Doc.PhysicalInventory = &PhysicalInventoryRef
	|	AND NOT Doc.DeletionMark";
	Query.SetParameter("PhysicalInventoryRef", PhysicalInventoryRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Array;
	While QuerySelection.Next() Do
		Row = New Structure("Ref, Number, Date");
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
	//@skip-check undefined-function
	Template = GetTemplate("PrintQR");
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
	SpreadsheetRight = New SpreadsheetDocument;

	For IndexRow = -1 To VT.Count() - 1 Do
		For Index = 0 To 4 Do
			If IndexRow = VT.Count() - 1 Then
				Break;
			Else
				IndexRow = IndexRow + 1;
			EndIf;
			Header = Template.GetArea("Row|Column");
			Selection = VT[IndexRow];
			
			BarcodeParameters = BarcodeServer.GetBarcodeDrawParameters();
			BarcodeParameters.Width = Round(30 / 0.1);
			BarcodeParameters.Height = Round(30 / 0.1);
			BarcodeParameters.Barcode = Format(Selection.Number, "NG=");
			BarcodeParameters.CodeType = "QR";
			QR = BarcodeServer.GetBarcodePicture(BarcodeParameters);
			
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
		SpreadsheetRight = New SpreadsheetDocument;
	EndDo;
EndProcedure

#EndRegion