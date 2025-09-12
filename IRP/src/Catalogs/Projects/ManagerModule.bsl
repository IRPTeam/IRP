
Procedure Print(Spreadsheet, Ref, ProjectImages, ImageMap) Export
	//{{_PRINT_WIZARD(Print)
	Template = Catalogs.Projects.GetTemplate("Print");
	Query = New Query;
	Query.Text =
	"SELECT
	|	Projects.Ref,
	|	Projects.DueDate,
	|	Projects.IssueType,
	|	Projects.JobDescription,
	|	Projects.StartDate,
	|	Projects.LocationList.(
	|		Location
	|	)
	|FROM
	|	Catalog.Projects AS Projects
	|WHERE
	|	Projects.Ref IN (&Ref)";
	Query.Parameters.Insert("Ref", Ref);
	Selection = Query.Execute().Select();

	Header = Template.GetArea("Header");
	AreaLocationList = Template.GetArea("LocationList");
	Spreadsheet.Clear();

	InsertPageBreak = False;
	While Selection.Next() Do
		If InsertPageBreak Then
			Spreadsheet.PutHorizontalPageBreak();
		EndIf;

		Header.Parameters.Fill(Selection); 
		Header.Parameters.Project = Selection.Ref;
		Spreadsheet.Put(Header, Selection.Level());
		
		If ProjectImages.Count() > 0 Then
			Index = 0;
			ImageRow = Template.GetArea("ImageRow");
			
			For Each Image In ProjectImages Do
				NeedPut = True;
				ImageRow.Drawings.Get(Index).Picture = Image;
				Index = Index + 1;
				
				If Index = 3 Then
					Index = 0;  
					Spreadsheet.Put(ImageRow);
					ImageRow = Template.GetArea("ImageRow");
					NeedPut = False;
				EndIf;
			EndDo;  
			
			If NeedPut Then
				Spreadsheet.Put(ImageRow);
			EndIf;
		EndIf;
		
		SelectionLocationList = Selection.LocationList.Select();
		While SelectionLocationList.Next() Do
			AreaLocationList.Parameters.Fill(SelectionLocationList);
			Spreadsheet.Put(AreaLocationList, SelectionLocationList.Level()); 
			
			ImageArray = ImageMap.Get(SelectionLocationList.Location);
			If Not ImageArray = Undefined And ImageArray.Count() > 0 Then
				Index = 0;
				ImageRow = Template.GetArea("ImageRow");
				
				For Each Image In ImageArray Do
					NeedPut = True;
					ImageRow.Drawings.Get(Index).Picture = Image;
					Index = Index + 1;
					
					If Index = 3 Then
						Index = 0;  
						Spreadsheet.Put(ImageRow);
						ImageRow = Template.GetArea("ImageRow");
						NeedPut = False;
					EndIf;
				EndDo;  
				
				If NeedPut Then
					Spreadsheet.Put(ImageRow);
				EndIf;
			EndIf;
		EndDo;

		InsertPageBreak = True;
	EndDo;
	//}}
EndProcedure
