
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	
	Files = PictureViewerServer.GetPicturesByObjectRefAsArrayOfRefs(CommandParameter);
	Images = New Array;
	For Each File In Files Do
		If Not PictureViewerServer.isImage(CommonFunctionsServer.GetRefAttribute(File, "Extension")) Then
			Continue;           
		EndIf;
		
		PictureParameters = PictureViewerServer.CreatePictureParameters(File);
		ImagePreview = PictureViewerClient.GetPictureURL(PictureParameters);
		Images.Add(New Picture(GetFromTempStorage(ImagePreview)));
	EndDo;

	Map = GetImagesByLocation(CommandParameter);
	ImageMap = New Map;
	For Each Loc In Map Do  
		ImageArray = New Array;
		For Each FileOwner In Loc.Value Do
			Files = PictureViewerServer.GetPicturesByObjectRefAsArrayOfRefs(FileOwner);
			For Each File In Files Do
				If Not PictureViewerServer.isImage(CommonFunctionsServer.GetRefAttribute(File, "Extension")) Then
					Continue;           
				EndIf;
				
				PictureParameters = PictureViewerServer.CreatePictureParameters(File);
				ImagePreview = PictureViewerClient.GetPictureURL(PictureParameters);
				ImageArray.Add(New Picture(GetFromTempStorage(ImagePreview)));
			EndDo;
		EndDo; 
		ImageMap.Insert(Loc.Key, ImageArray);
	EndDo;
	
	Spreadsheet = New SpreadsheetDocument;
	Print(Spreadsheet, CommandParameter, Images, ImageMap);

	Spreadsheet.ShowGrid = False;
	Spreadsheet.Protection = False;
	Spreadsheet.ReadOnly = False;
	Spreadsheet.ShowHeaders = False;
	Spreadsheet.Show();
	
EndProcedure

&AtServer
Procedure Print(Spreadsheet, CommandParameter, ProjectImages, ImageMap)
	Catalogs.Projects.Print(Spreadsheet, CommandParameter, ProjectImages, ImageMap);
EndProcedure     

&AtServer
Function GetImagesByLocation(Project) Export
	
	Query = New Query;
	Query.Text = 
		"SELECT
		|	ProjectsLocationList.Ref AS Project,
		|	ProjectsLocationList.Location AS Location
		|INTO Locations
		|FROM
		|	Catalog.Projects.LocationList AS ProjectsLocationList
		|WHERE
		|	ProjectsLocationList.Ref = &ProjectRef
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	Issue.Ref AS Issue,
		|	Locations.Location AS Location,
		|	Locations.Project AS Project
		|INTO IssueList
		|FROM
		|	Locations AS Locations
		|		LEFT JOIN Document.Issue AS Issue
		|		ON Locations.Project = Issue.Project
		|			AND Locations.Location = Issue.Location
		|			AND (Issue.Posted)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	IssueList.Issue AS Issue,
		|	IssueList.Location AS Location,
		|	IssueList.Project AS Project,
		|	WorkSheetIssueList.Ref AS WorkSheet
		|FROM
		|	IssueList AS IssueList
		|		INNER JOIN Document.WorkSheet.IssueList AS WorkSheetIssueList
		|		ON IssueList.Issue = WorkSheetIssueList.Issue";
	
	Query.SetParameter("ProjectRef", Project);
	
	Result = Query.Execute().Unload();
	
	Map = New Map;
	
	For Each Row In Result Do
		
		Location = Map.Get(Row.Location);
		If Location = Undefined Then
			
			Map.Insert(Row.Location, New Array); 
			Location = Map.Get(Row.Location);
			
		EndIf;
		Location.Add(Row.WorkSheet);
	EndDo;
	
	Return Map;
	
EndFunction
