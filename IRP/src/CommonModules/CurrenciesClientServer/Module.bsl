
#Region EVENT_HANDLERS

#Region OnOpen

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	LibraryLoader.CallHandler(GetCallHandlerParameters(Object, Form, "Currencies_OnOpen", AddInfo), 
	Cancel);
	LibraryData = GetLibraryData(Object, Form, AddInfo);
	
	If Not ValueIsFilled(Object.Ref) Then
		Form.Currencies_HeaderOnChange(Undefined, AddInfo);
		Return;
	EndIf;
	
	If LibraryData.Version = "1.0" Then
		OnOpen_1_0(Object, Form, Cancel, LibraryData, AddInfo);
	ElsIf LibraryData.Version = "2.0" Then
		OnOpen_2_0(Object, Form, Cancel, LibraryData, AddInfo);
	ElsIf LibraryData.Version = "3.0" Then
		OnOpen_3_0(Object, Form, Cancel, LibraryData, AddInfo);
	Else
		Raise R().Exc_006;
	EndIf;
EndProcedure

Procedure OnOpen_1_0(Object, Form, Cancel, LibraryData, AddInfo)
	Form.Currencies_UpdateRatePresentation();
EndProcedure

Procedure OnOpen_2_0(Object, Form, Cancel, LibraryData, AddInfo)
	Form.Currencies_UpdateRatePresentation();
	Form.Currencies_SetVisibleCurrenciesRow(Undefined, True);
EndProcedure

Procedure OnOpen_3_0(Object, Form, Cancel, LibraryData, AddInfo)
	Form.Currencies_UpdateRatePresentation();
	Form.Currencies_SetVisibleCurrenciesRow(Undefined, True);
EndProcedure

#EndRegion

#Region AfterWriteAtServer

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters, AddInfo = Undefined) Export
	LibraryLoader.CallHandler(GetCallHandlerParameters(Object, Form, "Currencies_AfterWriteAtServer", AddInfo),
	CurrentObject, WriteParameters);
	LibraryData = GetLibraryData(Object, Form, AddInfo);
	If LibraryData.Version = "1.0" Then
		AfterWriteAtServer_1_0(Object, Form, CurrentObject, WriteParameters, LibraryData, AddInfo);
	ElsIf LibraryData.Version = "2.0" Then
		AfterWriteAtServer_2_0(Object, Form, CurrentObject, WriteParameters, LibraryData, AddInfo);
	ElsIf LibraryData.Version = "3.0" Then
		AfterWriteAtServer_3_0(Object, Form, CurrentObject, WriteParameters, LibraryData, AddInfo);
	Else
		Raise R().Exc_006;
	EndIf;
EndProcedure

Procedure AfterWriteAtServer_1_0(Object, Form, CurrentObject, WriteParameters, LibraryData, AddInfo)
	Form.Currencies_UpdateRatePresentation();
EndProcedure

Procedure AfterWriteAtServer_2_0(Object, Form, CurrentObject, WriteParameters, LibraryData, AddInfo)
	Form.Currencies_UpdateRatePresentation();
	Form.Currencies_SetVisibleCurrenciesRow(Undefined, True);
EndProcedure

Procedure AfterWriteAtServer_3_0(Object, Form, CurrentObject, WriteParameters, LibraryData, AddInfo)
	Form.Currencies_UpdateRatePresentation();
	Form.Currencies_SetVisibleCurrenciesRow(Undefined, True);
EndProcedure

#EndRegion

#Region AfterWrite

Procedure AfterWrite(Object, Form, WriteParameters, AddInfo = Undefined) Export
	LibraryLoader.CallHandler(GetCallHandlerParameters(Object, Form, "Currencies_AfterWrite", AddInfo), 
	AddInfo, WriteParameters);
	LibraryData = GetLibraryData(Object, Form, AddInfo);
	If LibraryData.Version = "1.0" Then
		AfterWrite_1_0(Object, Form, WriteParameters, LibraryData, AddInfo);
	ElsIf LibraryData.Version = "2.0" Then
		AfterWrite_2_0(Object, Form, WriteParameters, LibraryData, AddInfo);
	ElsIf LibraryData.Version = "3.0" Then
		AfterWrite_3_0(Object, Form, WriteParameters, LibraryData, AddInfo);
	Else
		Raise R().Exc_006;
	EndIf;
EndProcedure

Procedure AfterWrite_1_0(Object, Form, WriteParameters, LibraryData, AddInfo)
	CurrentTableName = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "Currencies_CurrentTableName");
	KeyForSetVisible = Undefined;
	If ValueIsFilled(CurrentTableName) Then
		CurrentData = Form.Items[CurrentTableName].CurrentData;
		If CurrentData <> Undefined Then
			KeyForSetVisible = CurrentData.Key;
		EndIf;
	EndIf;
	Form.Currencies_SetVisibleCurrenciesRow(KeyForSetVisible);
EndProcedure

Procedure AfterWrite_2_0(Object, Form, WriteParameters, LibraryData, AddInfo)
	Form.Currencies_SetVisibleCurrenciesRow(Undefined, True);
EndProcedure

Procedure AfterWrite_3_0(Object, Form, WriteParameters, LibraryData, AddInfo)
	Form.Currencies_SetVisibleCurrenciesRow(Undefined, True);
EndProcedure

#EndRegion

#Region NotificationProcessing

Procedure NotificationProcessing(Object, Form, EventName, Parameter, Source, AddInfo = Undefined) Export
	LibraryLoader.CallHandler(GetCallHandlerParameters(Object, Form, "Currencies_NotificationProcessing", AddInfo),
	EventName, Parameter, Source);
	
	If Upper(EventName) <> Upper("CallbackHandler") Then
		Return;
	EndIf;
	LibraryData = GetLibraryData(Object, Form, AddInfo);
	If LibraryData.FormUUID <> Source.UUID Then
		Return;
	EndIf;
	If LibraryData.Version = "1.0" Then
		NotificationProcessing_1_0(Object, Form, EventName, Parameter, Source, LibraryData, AddInfo);
	ElsIf LibraryData.Version = "2.0" Then
		NotificationProcessing_2_0(Object, Form, EventName, Parameter, Source, LibraryData, AddInfo);
	ElsIf LibraryData.Version = "3.0" Then
		NotificationProcessing_3_0(Object, Form, EventName, Parameter, Source, LibraryData, AddInfo);
	Else
		Raise R().Exc_006;
	EndIf;
EndProcedure

Procedure NotificationProcessing_1_0(Object, Form, EventName, Parameter, Source, LibraryData, AddInfo)
	// Full rebuild currency table
	Form.Currencies_ClearCurrenciesTable(Undefined);
	ArrayOfTableNames = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "Currencies_ArrayOfTableNames");
	LibraryData = GetLibraryData(Object, Form, AddInfo);
	For Each TableName In ArrayOfTableNames Do
		Names = ReplacePropertyNames(TableName, LibraryData);
		For Each Row In Object[TableName] Do
			Form.Currencies_FillCurrencyTable(Row.Key, ExtractCurrency(Object, Row), ExtractAgreement(Object, Form, Row));
			Form.Currencies_CalculateAmount(Row[Names.Columns.Amount], Row.Key);
		EndDo;
	EndDo;
	TableName = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "Currencies_CurrentTableName");
	If Not ValueIsFilled(TableName) Then
		Return;
	EndIf;
	CurrentData = Form.Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Form.Currencies_SetVisibleCurrenciesRow(Undefined);
		Return;
	EndIf;
	
	Form.Currencies_UpdateRatePresentation();
	Form.Currencies_SetVisibleCurrenciesRow(CurrentData.Key);
EndProcedure

Procedure NotificationProcessing_2_0(Object, Form, EventName, Parameter, Source, LibraryData, AddInfo)
	// Recalculate amount
	TableName = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "Currencies_CurrentTableName");
	Names = ReplacePropertyNames(TableName, LibraryData);
	Form.Currencies_CalculateAmount(Object[TableName].Total(Names.Columns.Amount), Undefined);
	Form.Currencies_UpdateRatePresentation();
	Form.Currencies_SetVisibleCurrenciesRow(Undefined, True);
EndProcedure

Procedure NotificationProcessing_3_0(Object, Form, EventName, Parameter, Source, LibraryData, AddInfo)
	Form.Currencies_CalculateAmount(Undefined, Undefined);
	Form.Currencies_UpdateRatePresentation();
	Form.Currencies_SetVisibleCurrenciesRow(Undefined, True);
EndProcedure

#EndRegion

Procedure MainTableOnActivateRow(Object, Form, Item, Addinfo = Undefined) Export
	LibraryLoader.CallHandler(GetCallHandlerParameters(Object, Form, "Currencies_MainTableOnActivateRow", AddInfo),
	Item);
	
	CurrentData = Form.Items[?(TypeOf(Item) = Type("String"), Item, Item.Name)].CurrentData;
	If CurrentData = Undefined Then
		Form.Currencies_SetVisibleCurrenciesRow(Undefined);
		Return;
	EndIf;
	Form.Currencies_SetVisibleCurrenciesRow(CurrentData.Key);
EndProcedure

Procedure MainTableBeforeDeleteRow(Object, Form, Item, AddInfo = Undefined) Export
	LibraryLoader.CallHandler(GetCallHandlerParameters(Object, Form, "Currencies_MainTableBeforeDeleteRow", AddInfo),
	Item);
	
	CurrentData = Form.Items[Item.Name].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Form.Currencies_ClearCurrenciesTable(CurrentData.Key);
EndProcedure

Procedure MainTableColumnOnChange(Object, Form, Item, AddInfo = Undefined) Export
	LibraryLoader.CallHandler(GetCallHandlerParameters(Object, Form, "Currencies_MainTableColumnOnChange", AddInfo), 
	Item);
	
	TableName = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "Currencies_CurrentTableName");
	LibraryData = GetLibraryData(Object, Form, AddInfo);
	Names = ReplacePropertyNames(TableName, LibraryData);
	
	If ValueIsFilled(TableName) Then
		CurrentData = Form.Items[TableName].CurrentData;
	Else
		CurrentData = Form.Items[StrReplace(Item.Name, "Currency", "")].CurrentData;
	EndIf;
	If CurrentData = Undefined Then
		Form.Currencies_SetVisibleCurrenciesRow(Undefined);
		Return;
	EndIf;
	
	AgreementInfo = Undefined;
	If CurrentData.Property("Agreement") Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
	EndIf;
	
	Form.Currencies_ClearCurrenciesTable(CurrentData.Key);
	Form.Currencies_FillCurrencyTable(CurrentData.Key,  ExtractCurrency(Object, CurrentData), AgreementInfo);
	Form.Currencies_CalculateAmount(CurrentData[Names.Columns.Amount], CurrentData.Key);
	Form.Currencies_UpdateRatePresentation();
	Form.Currencies_SetVisibleCurrenciesRow(CurrentData.Key);
EndProcedure

#Region HeaderOnChange

Procedure HeaderOnChange(Object, Form, Item, AddInfo = Undefined) Export
	LibraryLoader.CallHandler(GetCallHandlerParameters(Object, Form, "Currencies_HeaderOnChange", AddInfo),
	Item);
	
	Form.Currencies_ClearCurrenciesTable(Undefined);
	ArrayOfTableNames = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "Currencies_ArrayOfTableNames");
	LibraryData = GetLibraryData(Object, Form, AddInfo);
	If LibraryData.Version = "1.0" Then
		HeaderOnChange_1_0(Object, Form, Item, ArrayOfTableNames, LibraryData, AddInfo);
	ElsIf LibraryData.Version = "2.0" Then
		HeaderOnChange_2_0(Object, Form, Item, ArrayOfTableNames, LibraryData, AddInfo);
	ElsIf LibraryData.Version = "3.0" Then
		HeaderOnChange_3_0(Object, Form, Item, LibraryData, AddInfo);
	Else
		Raise R().Exc_006;
	EndIf;
EndProcedure

Procedure HeaderOnChange_1_0(Object, Form, Item, ArrayOfTableNames, LibraryData, AddInfo)
	For Each TableName In ArrayOfTableNames Do
		Names = ReplacePropertyNames(TableName, LibraryData);
		For Each Row In Object[TableName] Do
			Form.Currencies_FillCurrencyTable(Row.Key, ExtractCurrency(Object, Row), ExtractAgreement(Object, Form, Row));
			Form.Currencies_CalculateAmount(Row[Names.Columns.Amount], Row.Key);
		EndDo;
	EndDo;
	
	TableName = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "Currencies_CurrentTableName");
	If Not ValueIsFilled(TableName) Then
		Return;
	EndIf;
	Form.Currencies_UpdateRatePresentation();
	CurrentData = Form.Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Form.Currencies_SetVisibleCurrenciesRow(Undefined);
		Return;
	EndIf;
	Form.Currencies_SetVisibleCurrenciesRow(CurrentData.Key);
EndProcedure

Procedure HeaderOnChange_2_0(Object, Form, Item, ArrayOfTableNames, LibraryData, AddInfo)
	For Each TableName In ArrayOfTableNames Do
		Names = ReplacePropertyNames(TableName, LibraryData);
		Form.Currencies_FillCurrencyTable(Form.UUID, ExtractCurrency(Object, Object), ExtractAgreement(Object, Form, Object));
		Form.Currencies_CalculateAmount(Object[TableName].Total(Names.Columns.Amount), Form.UUID);
	EndDo;
	Form.Currencies_UpdateRatePresentation();
	Form.Currencies_SetVisibleCurrenciesRow(Undefined, True);
EndProcedure

Procedure HeaderOnChange_3_0(Object, Form, Item, LibraryData, AddInfo)
	Form.Currencies_FillCurrencyTable(Undefined, Undefined, Undefined);
	Form.Currencies_CalculateAmount(Undefined, Undefined);
	Form.Currencies_UpdateRatePresentation();
	Form.Currencies_SetVisibleCurrenciesRow(Undefined, True);
EndProcedure

#EndRegion

#Region MainTableAmountOnChange

Procedure MainTableAmountOnChange(Object, Form, Item, AddInfo = Undefined) Export
	LibraryLoader.CallHandler(
	GetCallHandlerParameters(Object, Form, "Currencies_MainTableAmountOnChange", AddInfo),
	Item);
	
	LibraryData = GetLibraryData(Object, Form, AddInfo);
	If LibraryData.Version = "1.0" Then
		MainTableAmountOnChange_1_0(Object, Form, Item, LibraryData, AddInfo);
	ElsIf LibraryData.Version = "2.0" Then
		MainTableAmountOnChange_2_0(Object, Form, Item, LibraryData, AddInfo);
	ElsIf LibraryData.Version = "3.0" Then
		MainTableAmountOnChange_3_0(Object, Form, Item, LibraryData, AddInfo);
	Else
		Raise R().Exc_006;
	EndIf;
EndProcedure

Procedure MainTableAmountOnChange_1_0(Object, Form, Item, LibraryData, AddInfo)
	TableName = Item.Parent.Name;
	Names = ReplacePropertyNames(TableName, LibraryData);
	CurrentData = Form.Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Form.Currencies_CalculateAmount(CurrentData[Names.Columns.Amount], CurrentData.Key);
	Form.Currencies_UpdateRatePresentation();
	Form.Currencies_SetVisibleCurrenciesRow(CurrentData.Key);
EndProcedure

Procedure MainTableAmountOnChange_2_0(Object, Form, Item, LibraryData, AddInfo)
	TableName = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "Currencies_CurrentTableName");
	Names = ReplacePropertyNames(TableName, LibraryData);
	Form.Currencies_CalculateAmount(Object[TableName].Total(Names.Columns.Amount), Undefined);
	Form.Currencies_UpdateRatePresentation();
	Form.Currencies_SetVisibleCurrenciesRow(Undefined, True);
EndProcedure

Procedure MainTableAmountOnChange_3_0(Object, Form, Item, LibraryData, AddInfo)
	Form.Currencies_CalculateAmount(Undefined, Undefined);
	Form.Currencies_UpdateRatePresentation();
	Form.Currencies_SetVisibleCurrenciesRow(Undefined, True);
EndProcedure

#EndRegion

#EndRegion

Function GetLibraryData(Object, Form, AddInfo = Undefined) Export
	If AddInfo = Undefined Then
		LibraryData = CommonFunctionsServer.DeserializeXMLUseXDTO(Form["LibraryCurrencies"]);
	Else
		LibraryData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "LibraryCurrencies_Data_");
	EndIf;
	If Not LibraryData.Property("Version") Then
		Raise R().Exc_006;
	EndIf;
	Return LibraryData;
EndFunction

Function GetPropertiesForReplace() Export
	Columns = New Structure();
	Columns.Insert("Amount", "Amount");
	Columns.Insert("Currency", "Currency");
	Return Columns;
EndFunction

Function ReplacePropertyNames(TableName, Data) Export
	Result = New Structure();
	Result.Insert("Columns", GetPropertiesForReplace());
	If Data = Undefined Then
		Return Result;
	EndIf;
	If Data.Property("TableColumns") Then
		FillPropertyValues(Result.Columns, Data.TableColumns[TableName]);
	EndIf;
	Return Result;
EndFunction

Function FindRowByUUID(Object, TableName, RowKey) Export
	For Each Row In Object[TableName] Do
		If Row.Key = RowKey Then
			Return Row;
		EndIf;
	EndDo;
	Return Undefined;
EndFunction

Function ExtractCurrency(Header, Row)
	If Row.Property("Currency") Then
		Return Row.Currency;
	ElsIf Header.Property("Currency") Then
		Return Header.Currency;
	Else
		Raise R().Exc_006;
	EndIf;
EndFunction

Function ExtractAgreement(Object, Form, Row)
	AgreementInfo = Undefined;
	If Row.Property("Agreement") Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Row.Agreement);
	EndIf;
	Return AgreementInfo;
EndFunction

Function GetCallHandlerParameters(Object, Form, HandlerID, AddInfo)
	Parameters = LibraryLoader.GetCallHandlerParameters();
	Parameters.Object = Object;
	Parameters.Form = Form;
	Parameters.LibraryName = "LibraryCurrencies";
	Parameters.HandlerID = HandlerID;
	Parameters.AddInfo = AddInfo;
	Return Parameters;
EndFunction