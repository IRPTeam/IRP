
&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("LoadCountryList", 0.1, True);
EndProcedure

&AtClient
Procedure CreateSelected(Command)
	RowIDList = New Array;
	For Each RowID In Items.CountryList.SelectedRows Do
		RowIDList.Add(RowID);
	EndDo;
	CreateSelectedAtServer(RowIDList);
	
	NotifyChanged(Type("CatalogRef.Countries"));
EndProcedure

&AtServer
Procedure CreateSelectedAtServer(RowIDList)
	
	LangMap = LocalizationReuse.ISO639();
	
	For Each RowID In RowIDList Do
		Row = CountryList.FindByID(RowID);
		If Row.Exists Then
			Continue;
		EndIf; 
		
		Country = CommonFunctionsServer.DeserializeXMLUseXDTO(Row.Data).Get();
		
		NewCountry = Catalogs.Countries.CreateItem();
		NewCountry.Code = Country["ccn3"];
		NewCountry.AlphaCode3 = Country["cca3"];
		NewCountry.AlphaCode2 = Country["cca2"];
		NewCountry.CIOCCode = Country["cioc"];
		NewCountry.PhonePrefix = Country["idd"]["root"] + "(" + StrConcat(Country["idd"]["suffixes"], ";") + ")";
		NewCountry.Currency = Country["ccn3"];
		NewCountry.Description_en = Country["name"]["common"];
		NewCountry.Description_ru = GetLangName(Country, LangMap.ru);
		NewCountry.Description_tr = GetLangName(Country, LangMap.tr);
		//https://flagcdn.com/w20/ua.png
		HTTP = New HTTPConnection("flagcdn.com", , , , , True);
		Request = New HTTPRequest("/w20/" + Lower(NewCountry.AlphaCode2) + ".png");
		Result = HTTP.Get(Request);
		If Result.StatusCode = 200 Then
			NewCountry.Flag = New ValueStorage(Result.GetBodyAsBinaryData());
		EndIf;
		
		NewCountry.Write();
		Row.Exists = True;
	EndDo;
EndProcedure

&AtServer
Function GetLangName(Country, LangCode)
	LangData = Country["translations"].Get(LangCode);
	If LangData = Undefined Then
		Return "";
	Else
		Return LangData["common"];
	EndIf;
EndFunction

&AtClient
Procedure LoadCountryList()
	LoadCountryListAtServer();
	Items.GroupLoading.Visible = False;
EndProcedure

&AtServer
Procedure LoadCountryListAtServer()
	ZIP = Catalogs.Countries.GetTemplate("CountryList");
	
	JSONBD = CommonFunctionsServer.StringFromBase64ZIP(ZIP);
	
	JSON = GetStringFromBinaryData(JSONBD);
	
	CountryData = CommonFunctionsServer.DeserializeJSON(JSON, True); // Array Of Map
	
	LangCode = Undefined;
	LocalizationReuse.ISO639().Property(SessionParameters.LocalizationCode, LangCode);
	
	For Each Country In CountryData Do
		NewRow = CountryList.Add();
		NewRow.Code = Country["ccn3"];
		NewRow.Description = Country["name"]["common"];
		NewRow.Exists = Not Catalogs.Countries.FindByCode(NewRow.Code).IsEmpty();
		NewRow.Data = CommonFunctionsServer.SerializeXMLUseXDTO(New ValueStorage(Country, New Deflation(9)));
		
		If LangCode = Undefined Then
			NewRow.UserLangDescription = NewRow.Description;
		Else
			NewRow.UserLangDescription = GetLangName(Country, LangCode);
		EndIf;
	EndDo;
	
EndProcedure