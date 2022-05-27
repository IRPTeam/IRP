Function SeparationUsed() Export
	Return Constants.SaasMode.Get();
EndFunction

Function isAreaActive() Export
	AreaMode = Not Saas.SeparationUsed() Or (Saas.SeparationUsed() And SessionParameters.IDUse);
	Return AreaMode;
EndFunction

Procedure SetSeparationParameters(Separators) Export
	For Each DataSeparation In Separators Do
		SessionParameters[DataSeparation.Key + "Value"] = DataSeparation.Value;
		SessionParameters[DataSeparation.Key + "Use"] = ValueIsFilled(DataSeparation.Value);
	EndDo;
EndProcedure

Function CurrentAreaStatus() Export
	Answer = New Structure("isError, Status", False, "");
	If SessionParameters.IDUse Then
		Area = Catalogs.DataAreas.FindByCode(SessionParameters.IDValue);
		If Area.IsEmpty() Then
			Answer.isError = True;
			Answer.Status = StrTemplate(R().Saas_001, SessionParameters.IDValue);
		Else
			If Not Area.DataAreaStatus = Enums.DataAreaStatus.Working Then
				Answer.isError = True;
				Answer.Status = StrTemplate(R().Saas_002, Area.DataAreaStatus);
			EndIf;
		EndIf;
	EndIf;
	Return Answer;
EndFunction

Procedure AreaUpdate() Export

	If Not SeparationUsed() Then
		Return;
	EndIf;

	Query = New Query();
	Query.Text =
	"SELECT
	|	DataAreas.Ref AS Ref,
	|	DataAreas.Code AS Code,
	|	DataAreas.AdminLogin AS AdminLogin,
	|	DataAreas.AdminPassword AS AdminPassword,
	|	DataAreas.AdminLocalization AS AdminLocalization,
	|	DataAreas.CompanyName AS CompanyName,
	|	DataAreas.InterfaceLocalizationCode
	|FROM
	|	Catalog.DataAreas AS DataAreas
	|WHERE
	|	DataAreas.DataAreaStatus = VALUE(Enum.DataAreaStatus.AreaPreparation)
	|	AND NOT DataAreas.DeletionMark
	|	AND DataAreas.Code > 0";

	QueryResult = Query.Execute();

	CurrentArea = QueryResult.Select();

	While CurrentArea.Next() Do
		// Change area
		AreaSettings = New Structure("ID", CurrentArea.Code);
		SetSeparationParameters(AreaSettings);
		
		// User group
		UserGroup = Catalogs.UserGroups.CreateItem();
		UserGroup.Description_en = "Main group";
		UserGroup.Write();
		
		// User
		User = Catalogs.Users.CreateItem();
		DescriptionStructure = New Structure();
		DescriptionStructure.Insert("Description_" + LocalizationReuse.GetLocalizationCode(), CurrentArea.AdminLogin);
		DescriptionStructure.Insert("Description_en", CurrentArea.AdminLogin);
		DescriptionStructure.Insert("Description", CurrentArea.AdminLogin);

		FillPropertyValues(User, DescriptionStructure);
		If ValueIsFilled(CurrentArea.AdminLocalization) Then
			User.LocalizationCode = CurrentArea.AdminLocalization;
		Else
			User.LocalizationCode = Metadata.DefaultLanguage.LanguageCode;
		EndIf;
		User.InterfaceLocalizationCode = CurrentArea.InterfaceLocalizationCode;
		User.ShowInList = True;
		User.UserGroup = UserGroup.Ref;
		User.AdditionalProperties.Insert("Password", CurrentArea.AdminPassword);
		User.Write();
				
		// logout area
		AreaSettings = New Structure("ID", 0);
		SetSeparationParameters(AreaSettings);

		CurrentAreaObject = CurrentArea.Ref.GetObject();
		CurrentAreaObject.DataAreaStatus = Enums.DataAreaStatus.Working;
		CurrentAreaObject.Write();

	EndDo;

EndProcedure

Function CurrentAreaID() Export
	Return SessionParameters.IDValue;
EndFunction

Function GetCurrencyMovementType_Legal() Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	CurrencyMovementType.Ref
	|FROM
	|	ChartOfCharacteristicTypes.CurrencyMovementType AS CurrencyMovementType
	|WHERE
	|	CurrencyMovementType.Type = VALUE(Enum.CurrencyType.Legal)";
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	Else
		Return ChartsOfCharacteristicTypes.CurrencyMovementType.EmptyRef();
	EndIf;
EndFunction

Function GetCurrencyMovementType_Transaction() Export
	Return ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency;
EndFunction

Function isSaasMode() Export
	Return GetFunctionalOption("SaasMode");
EndFunction