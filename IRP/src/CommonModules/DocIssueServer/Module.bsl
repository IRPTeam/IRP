#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	ViewServer_V2.OnCreateAtServer(Object, Form, "");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	Return;
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
EndProcedure

#EndRegion

#Region LIST_FORM

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region CHOICE_FORM

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region Generate

Function GetLocationIssuesBasedOnProject(Project) Export
	
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
		|			AND Locations.Location = Issue.Location AND Issue.Posted		
		|	
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	IssueList.Location AS Location
		|FROM
		|	IssueList AS IssueList
		|WHERE
		|	IssueList.Issue IS NULL";
	
	Query.SetParameter("ProjectRef", Project);
	
	Return Query.Execute().Unload().UnloadColumn("Location");
	
EndFunction

Procedure CreateIssueBasedOnLocations(Project, LocationList) Export
	For Each Location In LocationList Do
		Issue = Documents.Issue.CreateDocument();
		Issue.Date = Project.StartDate;
		Issue.Country = Location.Parent.City.Owner;
		Issue.City = Location.Parent.City;
		Issue.Location = Location;
		Issue.IssueType = Project.IssueType;
		Issue.IssueDetails = Project.JobDescription;
		Issue.DueDate = Project.DueDate;
		Issue.Project = Project; 
		Try
			Issue.Write(DocumentWriteMode.Posting);
			CommonFunctionsClientServer.ShowUsersMessage(Issue.Ref, , , , Issue.Ref);
		Except
			ErrorInfo = ErrorInfo();
			Log.Write("Write new Issue", ErrorProcessing.DetailErrorDescription(ErrorInfo));
			CommonFunctionsClientServer.ShowUsersMessage(ErrorProcessing.BriefErrorDescription(ErrorInfo));
		EndTry;

	EndDo;
EndProcedure

#EndRegion