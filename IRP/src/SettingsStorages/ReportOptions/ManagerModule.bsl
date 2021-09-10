Procedure SaveProcessing(ObjectKey, SettingsKey, Settings, SettingsDescription, User)
	Option = New ValueStorage(Settings, New Deflation(9));
	ReportOptionRef = Catalogs.ReportOptions.FindByCode(SettingsKey);
	ReportOptionObj = ReportOptionRef.GetObject();
	ReportOptionObj.Option = Option;
	ReportOptionObj.Write();
EndProcedure

Procedure SetDescriptionProcessing(ObjectKey, SettingsKey, SettingsDescription, User)
	Query = New Query();
	Query.Text = "SELECT
				 |	ReportOptions.Description
				 |FROM
				 |	Catalog.ReportOptions AS ReportOptions
				 |WHERE
				 |	ReportOptions.ObjectKey = &ObjectKey
				 |	AND ReportOptions.Code = &Code";

	Query.SetParameter("ObjectKey", ObjectKey);
	Query.SetParameter("Code", SettingsKey);

	SettingsDescription.ObjectKey = ObjectKey;
	SettingsDescription.SettingsKey = SettingsKey;

	QueryExecution = Query.Execute();

	If Not QueryExecution.IsEmpty() Then
		QuerySelection = QueryExecution.Select();
		QuerySelection.Next();
		SettingsDescription.Presentation = QuerySelection.Description;
	EndIf;
EndProcedure

Procedure GetDescriptionProcessing(ObjectKey, SettingsKey, SettingsDescription, User)
	Var ReportOptionObj;

	SettingsDescription.ObjectKey = ObjectKey;
	SettingsDescription.SettingsKey = SettingsKey;

	If SettingsKey <> Undefined Then
		Query = New Query();
		Query.Text = "SELECT
					 |	ReportOptions.Ref
					 |FROM
					 |	Catalog.ReportOptions AS ReportOptions
					 |WHERE
					 |	ReportOptions.ObjectKey = &ObjectKey
					 |	AND ReportOptions.Code = &Code";

		Query.SetParameter("ObjectKey", ObjectKey);
		Query.SetParameter("Code", SettingsKey);

		QueryExecution = Query.Execute();

		If Not QueryExecution.IsEmpty() Then
			QuerySelection = QueryExecution.Select();
			QuerySelection.Next();
			ReportOptionObj = QuerySelection.Ref.GetObject();
		EndIf;
	Else
		ReportOptionObj = Catalogs.ReportOptions.CreateItem();
		ReportOptionObj.ObjectKey = SettingsDescription.ObjectKey;
		ReportOptionObj.SetNewCode();
		SettingsDescription.SettingsKey = ReportOptionObj.Code;
	EndIf;

	If IsBlankString(SettingsDescription.Presentation) Then
		SettingsDescription.Presentation = ReportOptionObj.Description;
	EndIf;

EndProcedure

Procedure LoadProcessing(ObjectKey, SettingsKey, Settings, SettingsDescription, User)
	ReportOption = Catalogs.ReportOptions.FindByCode(SettingsKey);
	Settings = ReportOption.Option.Get();
	If SettingsDescription <> Undefined Then
		SettingsDescription.Presentation = ReportOption.Description;
	EndIf;
EndProcedure