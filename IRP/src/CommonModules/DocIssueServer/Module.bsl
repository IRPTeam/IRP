#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, "");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
EndProcedure

#EndRegion

#Region _TITLE

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("City");
	AttributesArray.Add("Location");
	AttributesArray.Add("IssueType");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
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