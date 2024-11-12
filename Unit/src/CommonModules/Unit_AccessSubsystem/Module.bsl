
#Region Info

Function Tests() Export
	TestList = New Array;
	TestList.Add("CheckDocument");
	TestList.Add("AccumulationRegisters");	
	TestList.Add("InformationRegisters");	
	TestList.Add("GenerateDocuments");	
	TestList.Add("GenerateAccumulationRegisters");	
	TestList.Add("GenerateInformationRegisters");	
	Return TestList;
EndFunction

#EndRegion

#Region Document

Function CheckDocument() Export
	ArrayOfErrors = New Array();
	
	For Each Doc In Metadata.Documents Do
			
		EmptyRef = Documents[Doc.Name].EmptyRef();			
		
		Try
			Documents[Doc.Name].GetAccessKey(EmptyRef);
		Except
			ArrayOfErrors.Add("GetAccessKey error:" + Doc.FullName());
			ArrayOfErrors.Add(ErrorProcessing.DetailErrorDescription(ErrorInfo()));
			ArrayOfErrors.Add("--------------------------");
			ArrayOfErrors.Add();
		EndTry;
		
		ReadResult = AccessParameters("Read", Doc, "Ref", Metadata.Roles.TemplateDocument);
		If Not ReadResult.Accessibility Then
			ArrayOfErrors.Add("Set Read access to Role TemplateDocument:" + Doc.FullName());
			ArrayOfErrors.Add("--------------------------");
		EndIf; 
		If Not ReadResult.RestrictionByCondition Then
			ArrayOfErrors.Add("Set Read template:" + Doc.FullName());
			ArrayOfErrors.Add("--------------------------");
		EndIf; 
		
		ReadResult = AccessParameters("Update", Doc, "Ref", Metadata.Roles.TemplateDocument);
		If Not ReadResult.Accessibility Then
			ArrayOfErrors.Add("Set Update access to Role TemplateDocument:" + Doc.FullName());
			ArrayOfErrors.Add("--------------------------");
		EndIf; 
		If Not ReadResult.RestrictionByCondition Then
			ArrayOfErrors.Add("Set Update template:" + Doc.FullName());
			ArrayOfErrors.Add("--------------------------");
		EndIf; 
		
		ReadResult = AccessParameters("Insert", Doc, "Ref", Metadata.Roles.TemplateDocument);
		If Not ReadResult.Accessibility Then
			ArrayOfErrors.Add("Set Insert access to Role TemplateDocument:" + Doc.FullName());
			ArrayOfErrors.Add("--------------------------");
		EndIf; 
		If Not ReadResult.RestrictionByCondition Then
			ArrayOfErrors.Add("Set Insert template:" + Doc.FullName());
			ArrayOfErrors.Add("--------------------------");
		EndIf; 
		
		Query = New Query("Select ALLOWED TOP 1 Obj.* FROM " + Doc.FullName() + " AS Obj");
		
		Try
			Query.Execute();
		Except
			ArrayOfErrors.Add("Can't select data. Check template in Role. Error:" + Doc.FullName());
			ArrayOfErrors.Add(ErrorProcessing.DetailErrorDescription(ErrorInfo()));
			ArrayOfErrors.Add("--------------------------");
			ArrayOfErrors.Add();
		EndTry;
	EndDo;
			
	
	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse(StrConcat(ArrayOfErrors, Chars.LF));
	EndIf;
	Return "";
EndFunction

Function GenerateDocuments() Export
	
	Data = GenerateDataForAccessTest();

	AllDoc = New Array;
	For Each MetaObj In Metadata.Documents Do
		
		EmptyRef = Documents[MetaObj.Name].EmptyRef();			
		AccessKey = Documents[MetaObj.Name].GetAccessKey(EmptyRef); // Map
		If AccessKey.Count() = 0 Then
			Continue;
		EndIf;
		
		Keys = PrepareAccess_Document(AccessKey, MetaObj);
		
		Table = GetAllCase(Data, Keys);
		
		For Each Row In Table Do
			Descr = "";
			For Each Column In Table.Columns Do
				Descr = Descr + Column.Name + ": " + Row[Column.Name] + ";";
			EndDo;
			Descr = MetaObj.FullName() + " " + Descr;
			NewDoc = CreateDoc(Row, MetaObj);
			NewDoc.Comment = Descr;
			NewDoc.Write();
			AllDoc.Add(NewDoc.Comment);
			
			StrTables = New Structure;
			StrTables.Insert("AllocationList", "Store");
			StrTables.Insert("ItemList", "Store");
			For Each TableCheck In StrTables Do
				CreateDocumentsWithTable(Data, MetaObj, TableCheck.Key, TableCheck.Value, Descr, Row, AllDoc);
			EndDo;
		EndDo;
	EndDo;
	
	CommonFunctionsClientServer.ShowUsersMessage("Total documents: " + AllDoc.Count());
	CommonFunctionsClientServer.ShowUsersMessage(StrConcat(AllDoc, Chars.LF));
	
	Return "";
EndFunction

Procedure CreateDocumentsWithTable(Data, MetaObj, TabSection, AttrName, Descr, Row, AllDoc)
	TabSectionMeta = MetaObj.TabularSections.Find(TabSection);
	If TabSectionMeta = Undefined Then
		Return;
	EndIf;
	
	If TabSectionMeta.Attributes.Find(AttrName) = Undefined Then
		Return;
	EndIf;
	
	NewDoc = CreateDoc(Row, MetaObj);
	NewRow = AddRowToDocTable(NewDoc, MetaObj, TabSection);
	NewRow[AttrName] = Data[AttrName][0];
	NewDoc.Comment = Descr + AttrName + ": " + Data[AttrName][0];
	NewDoc.Write();
	AllDoc.Add(NewDoc.Comment);
	
	NewDoc = CreateDoc(Row, MetaObj);
	NewRow = AddRowToDocTable(NewDoc, MetaObj, TabSection);
	NewRow[AttrName] = Data[AttrName][1];
	NewDoc.Comment = Descr + AttrName + ": " + Data[AttrName][1];
	NewDoc.Write();
	AllDoc.Add(NewDoc.Comment);
	
	NewDoc = CreateDoc(Row, MetaObj);
	NewRow = AddRowToDocTable(NewDoc, MetaObj, TabSection);
	NewRow[AttrName] = Data[AttrName][2];
	NewDoc.Comment = Descr + AttrName + ": " + Data[AttrName][2];
	NewDoc.Write();
	AllDoc.Add(NewDoc.Comment);
	
	NewDoc = CreateDoc(Row, MetaObj);
	NewRow = AddRowToDocTable(NewDoc, MetaObj, TabSection);
	NewRow[AttrName] = Data[AttrName][0];
	NewRow = AddRowToDocTable(NewDoc, MetaObj, TabSection);
	NewRow[AttrName] = Data[AttrName][1];
	NewDoc.Comment = Descr + AttrName + ": " + Data[AttrName][0] + "&" + Data[AttrName][1];
	NewDoc.Write();
	AllDoc.Add(NewDoc.Comment);
	
	NewDoc = CreateDoc(Row, MetaObj);
	NewRow = AddRowToDocTable(NewDoc, MetaObj, TabSection);
	NewRow[AttrName] = Data[AttrName][1];
	NewRow = AddRowToDocTable(NewDoc, MetaObj, TabSection);
	NewRow[AttrName] = Data[AttrName][2];
	NewDoc.Comment = Descr + AttrName + ": " + Data[AttrName][1] + "&" + Data[AttrName][2];
	NewDoc.Write();
	AllDoc.Add(NewDoc.Comment);
	
	NewDoc = CreateDoc(Row, MetaObj);
	NewRow = AddRowToDocTable(NewDoc, MetaObj, TabSection);
	NewRow[AttrName] = Data[AttrName][0];
	NewRow = AddRowToDocTable(NewDoc, MetaObj, TabSection);
	NewRow[AttrName] = Data[AttrName][2];
	NewDoc.Comment = Descr + AttrName + ": " + Data[AttrName][0] + "&" + Data[AttrName][2];
	NewDoc.Write();
	AllDoc.Add(NewDoc.Comment);
	
	NewDoc = CreateDoc(Row, MetaObj);
	NewRow = AddRowToDocTable(NewDoc, MetaObj, TabSection);
	NewRow[AttrName] = Data[AttrName][0];
	NewRow = AddRowToDocTable(NewDoc, MetaObj, TabSection);
	NewRow[AttrName] = Data[AttrName][1];
	NewRow = AddRowToDocTable(NewDoc, MetaObj, TabSection);
	NewRow[AttrName] = Data[AttrName][2];	
	NewDoc.Comment = Descr + AttrName + ": " + Data[AttrName][0] + "&" + Data[AttrName][1] + "&" + Data[AttrName][2];		
	NewDoc.Write();
	AllDoc.Add(NewDoc.Comment);
EndProcedure

Function CreateDoc(Row, MetaObj)
	NewDoc = Documents[MetaObj.Name].CreateDocument();
	NewDoc.Date = CurrentDate();
	NewDoc.DataExchange.Load = True;
	NewDoc.SetNewNumber();
	FillPropertyValues(NewDoc, Row);
	NewDoc.DeletionMark = True;
	Return NewDoc;
EndFunction

Function AddRowToDocTable(DocObject, DocMetadata, TabSectionName)
	NewRow = DocObject[TabSectionName].Add();
	If DocMetadata.TabularSections[TabSectionName].Attributes.Find("Key") <> Undefined Then
		NewRow.Key = String(New UUID());
	EndIf;
	Return NewRow;
EndFunction
	
Function PrepareAccess_Document(Keys, MetaObj)
	
	AccessKey = New Structure;
	For Each KeyData In Keys Do
		
		If Not CommonFunctionsServer.isCommonAttributeUseForMetadata(KeyData.Key, MetaObj)
			AND MetaObj.Attributes.Find(KeyData.Key) = Undefined Then
			Continue;
		EndIf;
		
		AccessKey.Insert(KeyData.Key, KeyData.Key);
	EndDo;
	
	If Not MetaObj.Attributes.Find("OtherCompany") = Undefined Then
		AccessKey.Insert("OtherCompany", "Company");
	EndIf;
	
	If Not MetaObj.Attributes.Find("ReceiveBranch") = Undefined Then
		AccessKey.Insert("ReceiveBranch", "Branch");
	EndIf;
	
//	If Not MetaObj.Attributes.Find("BusinessUnit") = Undefined Then
//		AccessKey.Insert("BusinessUnit", "Branch");
//	EndIf;
	
	If Not MetaObj.Attributes.Find("TransitAccount") = Undefined Then
		AccessKey.Insert("TransitAccount", "Account");
	EndIf;

	If Not MetaObj.Attributes.Find("Sender") = Undefined Then
		AccessKey.Insert("Sender", "Account");
	EndIf;
	
	If Not MetaObj.Attributes.Find("Receiver") = Undefined Then
		AccessKey.Insert("Receiver", "Account");
	EndIf;
	
	If Not MetaObj.Attributes.Find("AccountDebit") = Undefined Then
		AccessKey.Insert("AccountDebit", "Account");
	EndIf;
	
	If Not MetaObj.Attributes.Find("AccountCredit") = Undefined Then
		AccessKey.Insert("AccountCredit", "Account");
	EndIf;

	If Not MetaObj.Attributes.Find("CashAccount") = Undefined Then
		AccessKey.Insert("CashAccount", "Account");
	EndIf;
	
	If Not MetaObj.Attributes.Find("StoreReceiver") = Undefined Then
		AccessKey.Insert("StoreReceiver", "Store");
	EndIf;
	
	If Not MetaObj.Attributes.Find("StoreSender") = Undefined Then
		AccessKey.Insert("StoreSender", "Store");
	EndIf;
	
	If Not MetaObj.Attributes.Find("StoreTransit") = Undefined Then
		AccessKey.Insert("StoreTransit", "Store");
	EndIf;
	
	If Not MetaObj.Attributes.Find("StoreProduction") = Undefined Then
		AccessKey.Insert("StoreProduction", "Store");
	EndIf;

	Return AccessKey;
	
EndFunction

#EndRegion

#Region AccumulationRegisters

Function AccumulationRegisters() Export
	ArrayOfErrors = New Array();
	
	For Each MetaObj In Metadata.AccumulationRegisters Do
			
		
		Try
			AccumulationRegisters[MetaObj.Name].GetAccessKey();
		Except
			ArrayOfErrors.Add("GetAccessKey error:" + MetaObj.FullName());
			ArrayOfErrors.Add(ErrorProcessing.DetailErrorDescription(ErrorInfo()));
			ArrayOfErrors.Add("--------------------------");
			ArrayOfErrors.Add();
		EndTry;
		
		ReadResult = AccessParameters("Read", MetaObj, MetaObj.Dimensions[0].Name, Metadata.Roles.TemplateAccumulationRegisters);
		If Not ReadResult.Accessibility Then
			ArrayOfErrors.Add("Set Read access to Role TemplateAccumulationRegisters:" + MetaObj.FullName());
			ArrayOfErrors.Add("--------------------------");
		EndIf;
		
		If Not ReadResult.RestrictionByCondition Then
			ArrayOfErrors.Add("Set Read template:" + MetaObj.FullName());
			ArrayOfErrors.Add("--------------------------");
		EndIf; 
		
		ReadResult = AccessParameters("Update", MetaObj, MetaObj.Dimensions[0].Name, Metadata.Roles.TemplateAccumulationRegisters);
		If ReadResult.Accessibility Then
			ArrayOfErrors.Add("Remove Update access from Role TemplateAccumulationRegisters:" + MetaObj.FullName());
			ArrayOfErrors.Add("--------------------------");
		EndIf; 

		Query = New Query("Select ALLOWED TOP 1 * FROM " + MetaObj.FullName());
		
		Try
			Query.Execute();
		Except
			ArrayOfErrors.Add("Can't select data. Check template in Role. Error:" + MetaObj.FullName());
			ArrayOfErrors.Add(ErrorProcessing.DetailErrorDescription(ErrorInfo()));
			ArrayOfErrors.Add("--------------------------");
			ArrayOfErrors.Add();
		EndTry;
	EndDo;
			
	
	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse(StrConcat(ArrayOfErrors, Chars.LF));
	EndIf;
	Return "";
EndFunction

Function GenerateAccumulationRegisters() Export
	
	Data = GenerateDataForAccessTest();

	AllReg = New Array;
	For Each MetaObj In Metadata.AccumulationRegisters Do
		
		AccessKey = AccumulationRegisters[MetaObj.Name].GetAccessKey(); // Map
		If AccessKey.Count() = 0 Then
			Continue;
		EndIf;
		
		Keys = PrepareAccess_AccumulationRegisters(AccessKey, MetaObj);
		
		Table = GetAllCase(Data, Keys);
		
		
		DocType = MetaObj.StandardAttributes.Recorder.Type.Types()[0]; // Type
		MetaDoc = Metadata.FindByType(DocType);
		DocRef = Documents[MetaDoc.Name].GetRef(New UUID("11111111-1111-1111-1111-111111111111"));
		
		NewReg = AccumulationRegisters[MetaObj.Name].CreateRecordSet();
		NewReg.DataExchange.Load = True;
		NewReg.Filter.Recorder.Set(DocRef);
		NewReg.Write();
		
		For Each Row In Table Do

			
			NewRow = NewReg.Add();
			NewRow.Recorder = DocRef;
			NewRow.Period = CurrentDate();
			FillPropertyValues(NewRow, Row);

			
			Descr = "";
			For Each Column In Table.Columns Do
				Descr = Descr + Column.Name + ": " + Row[Column.Name] + ";";
			EndDo;
			
			AllReg.Add(MetaObj.FullName() + " " + Descr);
			
		EndDo;
		NewReg.Write();
		
	EndDo;
	
	CommonFunctionsClientServer.ShowUsersMessage("Total accumulation reg: " + AllReg.Count());
	CommonFunctionsClientServer.ShowUsersMessage(StrConcat(AllReg, Chars.LF));
	
	Return "";
EndFunction

Function PrepareAccess_AccumulationRegisters(Keys, MetaObj)
	
	AccessKey = New Structure;
	For Each KeyData In Keys Do
		
		If MetaObj.Dimensions.Find(KeyData.Key) = Undefined Then
			Continue;
		EndIf;
		
		AccessKey.Insert(KeyData.Key, KeyData.Key);
	EndDo;
	
	If Not MetaObj.Dimensions.Find("SurplusStore") = Undefined Then
		AccessKey.Insert("SurplusStore", "Store");
	EndIf;
	
	If Not MetaObj.Dimensions.Find("WriteoffStore") = Undefined Then
		AccessKey.Insert("WriteoffStore", "Store");
	EndIf;
	
	If Not MetaObj.Dimensions.Find("StoreSender") = Undefined Then
		AccessKey.Insert("StoreSender", "Store");
	EndIf;
	
	If Not MetaObj.Dimensions.Find("StoreReceiver") = Undefined Then
		AccessKey.Insert("StoreReceiver", "Store");
	EndIf;
	
	If Not MetaObj.Dimensions.Find("IncomingStore") = Undefined Then
		AccessKey.Insert("IncomingStore", "Store");
	EndIf;
	
	If Not MetaObj.Dimensions.Find("RequesterStore") = Undefined Then
		AccessKey.Insert("RequesterStore", "Store");
	EndIf;

	If Not MetaObj.Dimensions.Find("FromAccount") = Undefined Then
		AccessKey.Insert("FromAccount", "Account");
	EndIf;
	
	If Not MetaObj.Dimensions.Find("ToAccount") = Undefined Then
		AccessKey.Insert("ToAccount", "Account");
	EndIf;
	
	If Not MetaObj.Dimensions.Find("ReceiptingAccount") = Undefined Then
		AccessKey.Insert("ReceiptingAccount", "Account");
	EndIf;
	
	Return AccessKey;
	
EndFunction

#EndRegion

#Region InformationRegisters

Function InformationRegisters() Export
	ArrayOfErrors = New Array();
	
	For Each MetaObj In Metadata.InformationRegisters Do
			
		
		Try
			InformationRegisters[MetaObj.Name].GetAccessKey();
		Except
			ArrayOfErrors.Add("GetAccessKey error:" + MetaObj.FullName());
			ArrayOfErrors.Add(ErrorProcessing.DetailErrorDescription(ErrorInfo()));
			ArrayOfErrors.Add("--------------------------");
			ArrayOfErrors.Add();
		EndTry;
		
		ReadResult = AccessParameters("Read", MetaObj, MetaObj.Dimensions[0].Name, Metadata.Roles.TemplateInformationRegisters);
		If Not ReadResult.Accessibility Then
			ArrayOfErrors.Add("Set Read access to Role TemplateInformationRegisters:" + MetaObj.FullName());
			ArrayOfErrors.Add("--------------------------");
		EndIf;
		
		ReadResult = AccessParameters("Update", MetaObj, MetaObj.Dimensions[0].Name, Metadata.Roles.TemplateInformationRegisters);
		If ReadResult.Accessibility Then
			ArrayOfErrors.Add("Remove Update access from Role TemplateInformationRegisters:" + MetaObj.FullName());
			ArrayOfErrors.Add("--------------------------");
		EndIf; 

		Query = New Query("Select ALLOWED TOP 1 * FROM " + MetaObj.FullName());
		
		Try
			Query.Execute();
		Except
			ArrayOfErrors.Add("Can't select data. Check template in Role. Error:" + MetaObj.FullName());
			ArrayOfErrors.Add(ErrorProcessing.DetailErrorDescription(ErrorInfo()));
			ArrayOfErrors.Add("--------------------------");
			ArrayOfErrors.Add();
		EndTry;
	EndDo;
			
	
	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse(StrConcat(ArrayOfErrors, Chars.LF));
	EndIf;
	Return "";
EndFunction

Function GenerateInformationRegisters() Export
	
	Data = GenerateDataForAccessTest();

	AllReg = New Array;
	For Each MetaObj In Metadata.InformationRegisters Do
		
		AccessKey = InformationRegisters[MetaObj.Name].GetAccessKey(); // Map
		If AccessKey.Count() = 0 Then
			Continue;
		EndIf;
		
		Keys = PrepareAccess_InformationRegisters(AccessKey, MetaObj);
		
		Table = GetAllCase(Data, Keys);
		
		If MetaObj.WriteMode = Metadata.ObjectProperties.RegisterWriteMode.RecorderSubordinate Then 
			DocType = MetaObj.StandardAttributes.Recorder.Type.Types()[0]; // Type
			MetaDoc = Metadata.FindByType(DocType);
			DocRef = Documents[MetaDoc.Name].GetRef(New UUID("11111111-1111-1111-1111-111111111111"));
			
			NewReg = InformationRegisters[MetaObj.Name].CreateRecordSet();
			NewReg.DataExchange.Load = True;
			NewReg.Filter.Recorder.Set(DocRef);
			NewReg.Write();
			
			For Each Row In Table Do
	
				
				NewRow = NewReg.Add();
				NewRow.Recorder = DocRef;
				NewRow.Period = CurrentDate();
				FillPropertyValues(NewRow, Row);
	
				
				Descr = "";
				For Each Column In Table.Columns Do
					Descr = Descr + Column.Name + ": " + Row[Column.Name] + ";";
				EndDo;
				
				AllReg.Add(MetaObj.FullName() + " " + Descr);
				
			EndDo;
			NewReg.Write();
		Else
			NewReg = InformationRegisters[MetaObj.Name].CreateRecordSet();
			NewReg.DataExchange.Load = True;
			NewReg.Write();
			
			For Each Row In Table Do
				NewRow = NewReg.Add();
				FillPropertyValues(NewRow, Row);
				Descr = "";
				For Each Column In Table.Columns Do
					Descr = Descr + Column.Name + ": " + Row[Column.Name] + ";";
				EndDo;
				AllReg.Add(MetaObj.FullName() + " " + Descr);
			EndDo;
			NewReg.Write();
		EndIf;
	EndDo;
	
	CommonFunctionsClientServer.ShowUsersMessage("Total Information reg: " + AllReg.Count());
	CommonFunctionsClientServer.ShowUsersMessage(StrConcat(AllReg, Chars.LF));
	
	Return "";
EndFunction

Function PrepareAccess_InformationRegisters(Keys, MetaObj)
	
	AccessKey = New Structure;
	For Each KeyData In Keys Do
		
		If MetaObj.Dimensions.Find(KeyData.Key) = Undefined Then
			Continue;
		EndIf;
		
		AccessKey.Insert(KeyData.Key, KeyData.Key);
	EndDo;
	
	If Not MetaObj.Dimensions.Find("CashAccount") = Undefined Then
		AccessKey.Insert("CashAccount", "Account");
	EndIf;
	
	Return AccessKey;
	
EndFunction

#EndRegion

#Region Service

Function GetAllCase(Val Data, Val AccessKey)

	Table = New ValueTable();
	For Each El In AccessKey Do
		Table.Columns.Add(El.Key, , El.Value);
	EndDo;
	
	For Each Columns In Table.Columns Do
		TmpTable = Table.Copy();
		ValueArray = Data[Columns.Title];
		If ValueArray.Count() = 0 Then
			Continue;
		EndIf;
		Table.Clear();
		For Each Value In ValueArray Do
			If TmpTable.Count() > 0 Then
				For Each ResRow In TmpTable Do
					NewRow = Table.Add();
					FillPropertyValues(NewRow, ResRow);
					NewRow[Columns.Name] = Value;
				EndDo;
			Else
				NewRow = Table.Add();
				NewRow[Columns.Name] = Value;
			EndIf;
		EndDo;
	EndDo;
	Return Table
EndFunction

Function GenerateDataForAccessTest()
	
	Data = New Structure;
	Data.Insert("AccessGroup", Catalogs.AccessGroups.GetRef(New UUID("44444444-4444-4444-4444-444444444444")));

	Data.Insert("Company", New Array);
	Data.Company.Add(Catalogs.Companies.GetRef(New UUID("11111111-1111-1111-1111-111111111111")));
	Data.Company.Add(Catalogs.Companies.GetRef(New UUID("22222222-2222-2222-2222-222222222222")));
	Data.Company.Add(Catalogs.Companies.GetRef(New UUID("33333333-3333-3333-3333-333333333333")));

	Data.Insert("Branch", New Array);
	Data.Branch.Add(Catalogs.BusinessUnits.GetRef(New UUID("11111111-1111-1111-1111-111111111111")));
	Data.Branch.Add(Catalogs.BusinessUnits.GetRef(New UUID("22222222-2222-2222-2222-222222222222")));
	Data.Branch.Add(Catalogs.BusinessUnits.GetRef(New UUID("33333333-3333-3333-3333-333333333333")));

	Data.Insert("Store", New Array);
	Data.Store.Add(Catalogs.Stores.GetRef(New UUID("11111111-1111-1111-1111-111111111111")));
	Data.Store.Add(Catalogs.Stores.GetRef(New UUID("22222222-2222-2222-2222-222222222222")));
	Data.Store.Add(Catalogs.Stores.GetRef(New UUID("33333333-3333-3333-3333-333333333333")));

	Data.Insert("Account", New Array);
	Data.Account.Add(Catalogs.CashAccounts.GetRef(New UUID("11111111-1111-1111-1111-111111111111")));
	Data.Account.Add(Catalogs.CashAccounts.GetRef(New UUID("22222222-2222-2222-2222-222222222222")));
	Data.Account.Add(Catalogs.CashAccounts.GetRef(New UUID("33333333-3333-3333-3333-333333333333")));
	
	Data.Insert("PriceType", New Array);
	Data.PriceType.Add(Catalogs.PriceTypes.GetRef(New UUID("11111111-1111-1111-1111-111111111111")));
	Data.PriceType.Add(Catalogs.PriceTypes.GetRef(New UUID("22222222-2222-2222-2222-222222222222")));
	Data.PriceType.Add(Catalogs.PriceTypes.GetRef(New UUID("33333333-3333-3333-3333-333333333333")));
	
	//@skip-check reading-attribute-from-database
	If Not IsBlankString(Data.AccessGroup.DataVersion) Then
		Return Data;
	EndIf;
	
	Company = Catalogs.Companies.CreateItem();
	Company.Description_en = "Company Read and Write Access";	
	Company.OurCompany = True;
	Company.DataExchange.Load = True;
	Company.SetNewObjectRef(Data.Company[0]);
	Company.Write();
	
	Company = Catalogs.Companies.CreateItem();
	Company.Description_en = "Company Only read access";
	Company.OurCompany = True;	
	Company.DataExchange.Load = True;
	Company.SetNewObjectRef(Data.Company[1]);
	Company.Write();
	
	Company = Catalogs.Companies.CreateItem();
	Company.Description_en = "Company access deny";
	Company.OurCompany = True;	
	Company.DataExchange.Load = True;
	Company.SetNewObjectRef(Data.Company[2]);
	Company.Write();

	Branch = Catalogs.BusinessUnits.CreateItem();
	//@skip-check unknown-method-property
	Branch.Description_en = "Branch Read and Write Access";	
	Branch.DataExchange.Load = True;
	Branch.SetNewObjectRef(Data.Branch[0]);
	Branch.Write();
	
	Branch = Catalogs.BusinessUnits.CreateItem();
	//@skip-check unknown-method-property
	Branch.Description_en = "Branch Only read access";	
	Branch.DataExchange.Load = True;
	Branch.SetNewObjectRef(Data.Branch[1]);
	Branch.Write();
	
	Branch = Catalogs.BusinessUnits.CreateItem();
	//@skip-check unknown-method-property
	Branch.Description_en = "Branch access deny";	
	Branch.DataExchange.Load = True;
	Branch.SetNewObjectRef(Data.Branch[2]);
	Branch.Write();	
		
	Store = Catalogs.Stores.CreateItem();
	Store.Description_en = "Store Read and Write Access";	
	Store.DataExchange.Load = True;
	Store.SetNewObjectRef(Data.Store[0]);
	Store.Write();
	
	Store = Catalogs.Stores.CreateItem();
	Store.Description_en = "Store Only read access";	
	Store.DataExchange.Load = True;
	Store.SetNewObjectRef(Data.Store[1]);
	Store.Write();
	
	Store = Catalogs.Stores.CreateItem();
	Store.Description_en = "Store access deny";	
	Store.DataExchange.Load = True;
	Store.SetNewObjectRef(Data.Store[2]);
	Store.Write();
	
	CashAccount = Catalogs.CashAccounts.CreateItem();
	CashAccount.Company = Data.Company[0];
	CashAccount.Description_en = "CashAccount Read and Write Access";	
	CashAccount.DataExchange.Load = True;
	CashAccount.SetNewObjectRef(Data.Account[0]);
	CashAccount.Write();
	
	CashAccount = Catalogs.CashAccounts.CreateItem();
	CashAccount.Company = Data.Company[1];
	CashAccount.Description_en = "CashAccount Only read access";	
	CashAccount.DataExchange.Load = True;
	CashAccount.SetNewObjectRef(Data.Account[1]);
	CashAccount.Write();
	
	CashAccount = Catalogs.CashAccounts.CreateItem();
	CashAccount.Company = Data.Company[2];
	CashAccount.Description_en = "CashAccount access deny";	
	CashAccount.DataExchange.Load = True;
	CashAccount.SetNewObjectRef(Data.Account[2]);
	CashAccount.Write();
	
	PriceType = Catalogs.PriceTypes.CreateItem();
	PriceType.Description_en = "PriceType Read and Write Access";	
	PriceType.DataExchange.Load = True;
	PriceType.SetNewObjectRef(Data.PriceType[0]);
	PriceType.Write();
	
	PriceType = Catalogs.PriceTypes.CreateItem();
	PriceType.Description_en = "PriceType Only read access";	
	PriceType.DataExchange.Load = True;
	PriceType.SetNewObjectRef(Data.PriceType[1]);
	PriceType.Write();
	
	PriceType = Catalogs.PriceTypes.CreateItem();
	PriceType.Description_en = "PriceType access deny";	
	PriceType.DataExchange.Load = True;
	PriceType.SetNewObjectRef(Data.PriceType[2]);
	PriceType.Write();
	
	AccessGroup = Catalogs.AccessGroups.CreateItem();
	AccessGroup.Description_en = "Unit access group";
	AccessGroup.SetNewObjectRef(Data.AccessGroup);
	AccessGroup.ObjectAccess.Clear();

	AddAccessRow(AccessGroup, "Company", Data.Company[0], True);
	AddAccessRow(AccessGroup, "Company", Data.Company[1], False);

	AddAccessRow(AccessGroup, "Branch", Data.Branch[0], True);
	AddAccessRow(AccessGroup, "Branch", Data.Branch[1], False);

	AddAccessRow(AccessGroup, "Store", Data.Store[0], True);
	AddAccessRow(AccessGroup, "Store", Data.Store[1], False);

	AddAccessRow(AccessGroup, "Account", Data.Account[0], True);
	AddAccessRow(AccessGroup, "Account", Data.Account[1], False);

	AddAccessRow(AccessGroup, "PriceType", Data.PriceType[0], True);
	AddAccessRow(AccessGroup, "PriceType", Data.PriceType[1], False);

	AccessGroup.Write();
	
	Return Data;
EndFunction

Procedure AddAccessRow(AccessGroup, Key, Ref, Modify)
	NewRow = AccessGroup.ObjectAccess.Add();
	NewRow.Key = Key;
	NewRow.ValueRef = Ref;
	NewRow.Modify = Modify;
EndProcedure

#EndRegion