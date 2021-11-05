
// VIEW
// 
// В ЭТОМ МОДУЛЕ ТОЛЬКО МОДИФИКАЦИЯ ФОРМЫ, ВПРОСЫ ПОЛЬЗОВАТЕЛЮ и прочие клиентские вещи
// ДЕЛАТЬ ИЗМЕНЕНИЯ объекта нельзя

Function GetParameters(Object, Form, Rows = Undefined)
	Parameters = New Structure();
	Parameters.Insert("Object"           , Object);
	Parameters.Insert("Form"             , Form);
	Parameters.Insert("ViewModuleName"       , "ViewClient_V2");
	Parameters.Insert("ControllerModuleName" , "ControllerClientServer_V2");
	
	If Rows <> Undefined Then
		
		// налоги
		ArrayOfTaxInfo = TaxesClient.GetArrayOfTaxInfo(Form);
		Parameters.Insert("ArrayOfTaxInfo", ArrayOfTaxInfo);
		//
		
		ArrayOfRows = New Array();
		// это имена колонок из ItemList
		ItemListColumns = "Key, ItemKey, PriceType, Price, NetAmount, OffersAmount, TaxAmount, TotalAmount";
		For Each Row In Rows Do
			NewRow = New Structure(ItemListColumns);
			FillPropertyValues(NewRow, Row);
			
			// налоги
			ArrayOfRowsTaxList = New Array();
			TaxListColumns = "Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount";
			For Each TaxRow In Object.TaxList.FindRows(New Structure("Key", Row.Key)) Do
				NewRowTaxList = New Structure(TaxListColumns);
				FillPropertyValues(NewRowTaxList, TaxRow);
				ArrayOfRowsTaxList.Add(NewRowTaxList);
			EndDo;
			
			TaxRates = New Structure();
			For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
				TaxRates.Insert(ItemOfTaxInfo.Name, Row[ItemOfTaxInfo.Name]);
			EndDo;
			NewRow.Insert("TaxRates", TaxRates);
			NewRow.Insert("TaxList" , ArrayOfRowsTaxList);
			//
			
			ArrayOfRows.Add(NewRow);
		EndDo;
		If ArrayOfRows.Count() Then
			Parameters.Insert("Rows", ArrayOfRows);
		EndIf;
	EndIf;
	
	Return Parameters;
EndFunction

Function GetRowsByCurrentData(Form, TableName, CurrentData)
	Rows = New Array();
	If CurrentData = Undefined Then
		CurrentData = Form.Items[TableName].CurrentData;
	EndIf;
	If CurrentData <> Undefined Then
		Rows.Add(CurrentData);
	EndIf;
	Return Rows;
EndFunction

Procedure PartnerOnChange(Object, Form) Export
	ControllerClientServer_V2.PartnerOnChange(GetParameters(Object, Form));
EndProcedure

Procedure ItemListPriceTypeOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListPriceTypeOnChange(GetParameters(Object, Form, Rows));
EndProcedure

Procedure OnSetLegalName(Parameters) Export
	// действия с формой при изменении LegalName
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

Procedure OnChainComplete(Parameters) Export
	// вся цепочка действий закончена, можно задавать вопросы пользователю, 
	// выводить сообщения и т.п но не моифицировать object
	
	// если ответят положительно или спрашивать не надо, то переносим данные из кэш в объект
	ControllerClientServer_V2.CommitChainChanges(Parameters);
EndProcedure