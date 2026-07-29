
&AtClient
Procedure ReplaceValuesOnStartEdit(Item, NewRow, Clone)
	If NewRow Then
		Item.CurrentData.Use = True;
	EndIf;
EndProcedure

&AtClient
Procedure ReferencesBeforeAddRow(Item, Cancel, Clone, Parent, Folder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure ReferencesBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure CheckAll(Command)
	For Each Row In ThisObject.References Do
		Row.Use = True;
	EndDo;
EndProcedure

&AtClient
Procedure UncheckAll(Command)
	For Each Row In ThisObject.References Do
		Row.Use = False;
	EndDo;
EndProcedure

&AtClient
Procedure FindValues(Command)
	ArrayForReplace = New Array();
	For Each Row In ThisObject.ReplaceValues Do
		If Row.Use Then
			ArrayForReplace.Add(Row.FindValue);
		EndIf;
	EndDo;
	
	If ArrayForReplace.Count() = 0 Then
		ShowMessageBox(,"Values not selected");
		Return;
	EndIf;
	
	FindValuesAtServer(ArrayForReplace);
EndProcedure


&AtServer
Procedure FindValuesAtServer(ArrayForReplace)
	RefTable = FindByRef(ArrayForReplace);
	RefTable.Columns.Add("Key");
	ThisObject.References.Clear();
	For Each Row In RefTable Do
		NewRow = ThisObject.References.Add();
		NewRow.Use = True;
		NewRow.Data = Row.Data;
		NewRow.Ref = Row.Ref;
		NewRow.Metadata = Row.Metadata.FullName();
		_Key = New UUID();
		NewRow.Key = _Key;
		Row.Key = _Key;
	EndDo;
	ThisObject.TableAddress = PutToTempStorage(RefTable, ThisObject.UUID);
EndProcedure

&AtClient
Procedure ReplaceValues(Command)	
	ReplaceValuesAtServer();
	FindValues(Undefined);
	Message = New UserMessage();
	Message.Text = "Completed";
	Message.Message();
EndProcedure

&AtServer
Procedure ShowErrorMessage(ErrorInfo)
	Cause = ?(ErrorInfo.Cause = Undefined, ErrorInfo, ErrorInfo.Cause);
	Message = New UserMessage();
	Message.Text = Cause.Description;
	Message.Message();
EndProcedure

&AtServer
Procedure ReplaceInAttributes(Row, Params, ValueMapping)
	For Each Attr In Row.Metadata.Attributes Do
		If Attr.Type.ContainsType(TypeOf(Row.Ref))
			And Params.Object[Attr.Name] = Row.Ref Then
				Params.Object[Attr.Name] = ValueMapping[Row.Ref];
		EndIf;
	EndDo;
	For Each TabSection In Row.Metadata.TabularSections Do
		For Each Attr In TabSection.Attributes Do
			If Attr.Type.ContainsType(TypeOf(Row.Ref)) Then
				TableRow = Params.Object[TabSection.Name].Find(Row.Ref, Attr.Name);
				While TableRow <> Undefined Do
					TableRow[Attr.Name] = ValueMapping[Row.Ref];
					TableRow = Params.Object[TabSection.Name].Find(Row.Ref, Attr.Name);
				EndDo;
			EndIf;
		EndDo;
	EndDo;
EndProcedure
	
&AtServer
Function ReplaceValuesAtServer(UseTransaction = True, UseDataExchangeLoad = True)
	HaveErrors = False;
	If UseTransaction Then
		BeginTransaction();
	EndIf;
	Params = New Structure("Object", Undefined);
	For Each Reg In Metadata.AccountingRegisters Do
		Params.Insert(Reg.Name+"ExtDimension", Reg.ChartOfAccounts.MaxExtDimensionCount);
		Params.Insert(Reg.Name+"Correspondence", Reg.Correspondence);
	EndDo
	;
	ValueMapping = New Map();
	For Each Row In ThisObject.ReplaceValues Do
		If Row.Use Then
			ValueMapping.Insert(Row.FindValue, Row.ReplaceValue);
		EndIf;
	EndDo;
	
	RefTable = GetFromTempStorage(ThisObject.TableAddress);
	ArrayForDelete = New Array();
	For Each Row In ThisObject.References Do
		If Not Row.Use Then
			ArrayOfRows = RefTable.FindRows(New Structure("Key", Row.Key));
			For Each ItemOfArray In ArrayOfRows Do
				ArrayForDelete.Add(ItemOfArray);
			EndDo;
		EndIf;
	EndDo;
	
	For Each ItemForDelete In ArrayForDelete Do
		RefTable.Delete(ItemForDelete);
	EndDo;
	
	ProcessedRef = Undefined;
	
	For Each Row In RefTable Do
		If ProcessedRef <> Row.Data Then
			If ProcessedRef <> Undefined And Params.Object <> Undefined Then
				If UseDataExchangeLoad Then
	            	Params.Object.DataExchange.Load = True;
				EndIf;
				Try
					Params.Object.Write();
				Except
					ShowErrorMessage(ErrorInfo());
					HaveErrors = True;
					If UseTransaction Then
						Goto ~REJECT;
					EndIf;
				EndTry;
				Params.Object = Undefined;  
			EndIf;
			ProcessedRef = Row.Data;
		EndIf;		
		
		If Metadata.Documents.Contains(Row.Metadata) Then 
			If Params.Object = Undefined Then
				Params.Object = Row.Data.GetObject();
			EndIf;
			
			ReplaceInAttributes(Row, Params, ValueMapping); 

			For Each Rec In Row.Metadata.RegisterRecords Do
			
				If Metadata.AccountingRegisters.Contains(Rec) Then
					Continue;
				EndIf;
				
				RecordSet = Params.Object.RegisterRecords[Rec.Name];
				RecordSet.Read();
				NeedWrite = False;
				RecordTable = RecordSet.Unload();
				
				If RecordTable.Count() = 0 Then
					Continue;
				EndIf;

				ArrayOfColumnNames = New Array();
				
				For Each Dim In Rec.Dimensions Do
					If Dim.Type.ContainsType(TypeOf(Row.Ref)) Then
						ArrayOfColumnNames.Add(Dim.Name);
					EndIf;
				EndDo;
				
				If Metadata.InformationRegisters.Contains(Rec) Then
					For Each Res In Rec.Resources Do 
						If Res.Type.ContainsType(TypeOf(Row.Ref)) Then
							ArrayOfColumnNames.Add(Res.Name);
						EndIf;
					EndDo;
				EndIf;
				
				For Each Attr In Rec.Attributes Do
					If Attr.Type.ContainsType(TypeOf(Row.Ref)) Then
						ArrayOfColumnNames.Add(Attr.Name);
					EndIf;
				EndDo;
				
				For Each ColumnName In ArrayOfColumnNames Do
                	TableRow = RecordTable.Find(Row.Ref, ColumnName);
					While TableRow <> Undefined Do
						TableRow[ColumnName] = ValueMapping[Row.Ref];
						NeedWrite = True;
						TableRow = RecordTable.Find(Row.Ref, ColumnName);
					EndDo;
				EndDo;	

				If NeedWrite Then
					RecordSet.Load(RecordTable);
					If UseDataExchangeLoad Then
						RecordSet.DataExchange.Load = True;
					EndIf;
					Try
						RecordSet.Write();
					Except
						ShowErrorMessage(ErrorInfo());
						HaveErrors = True;
						If UseTransaction Then
							Goto ~REJECT;
						EndIf;
					EndTry;
				EndIf;
			EndDo;
	
		ElsIf Metadata.Catalogs.Contains(Row.Metadata) Then
			If Params.Object = Undefined Then
				Params.Object = Row.Data.GetObject();
			EndIf;
			
			If Row.Metadata.Owners.Contains(Row.Ref.Metadata()) 
				And Params.Object.Owner = Row.Ref Then
				Params.Object.Owner = ValueMapping[Row.Ref];
			EndIf;
			
			If Row.Metadata.Hierarchical
				And Params.Object.Parent = Row.Ref Then 
				Params.Object.Parent = ValueMapping[Row.Ref];
			EndIf;
			
			ReplaceInAttributes(Row, Params, ValueMapping);
			
		ElsIf Metadata.ChartsOfCharacteristicTypes.Contains(Row.Metadata)
			  Or Metadata.ChartsOfAccounts.Contains(Row.Metadata)
			  Or Metadata.ChartsOfCalculationTypes.Contains(Row.Metadata)
			  Or Metadata.Tasks.Contains(Row.Metadata)
			  Or Metadata.BusinessProcesses.Contains(Row.Metadata) Then 
			  
			If Params.Object = Undefined Then
				Params.Object = Row.Data.GetObject();
			EndIf;
			
			ReplaceInAttributes(Row, Params, ValueMapping);
			
		ElsIf Metadata.Constants.Contains(Row.Metadata) Then
			Constants[Row.Metadata.Name].Set(ValueMapping[Row.Ref]);
		ElsIf Metadata.InformationRegisters.Contains(Row.Metadata) Then 

			Dimensions = New Structure();
			RecordSet = InformationRegisters[Row.Metadata.Name].CreateRecordSet();
			
			For Each Dim In Row.Metadata.Dimensions Do
				RecordSet.Filter[Dim.Name].Set(Row.Data[Dim.Name]);
				Dimensions.Insert(Dim.Name);
			EndDo;
			
			If Row.Metadata.InformationRegisterPeriodicity <> Metadata.ObjectProperties.InformationRegisterPeriodicity.Nonperiodical Then
				RecordSet.Filter.Period.Set(Row.Data.Period);
			EndIf;
			
			RecordSet.Read();
			
			If RecordSet.Count() = 0 Then
				Continue;
			EndIf;
			
			RecordTable = RecordSet.Unload();
			RecordSet.Clear();
			
			If UseDataExchangeLoad Then
				RecordSet.DataExchange.Load = True;
			EndIf;
			
			If Not UseTransaction Then
				BeginTransaction();
			EndIf;
			
			Try
				RecordSet.Write();
				For Each Column In RecordTable.Columns Do
					If RecordTable[0][Column.Name] = Row.Ref Then
						RecordTable[0][Column.Name] = ValueMapping[Row.Ref];
						If Dimensions.Property(Column.Name) Then
							RecordSet.Filter[Column.Name].Set(ValueMapping[Row.Ref]);
						EndIf;
					EndIf;
				EndDo;
				RecordSet.Load(RecordTable);
				RecordSet.Write();
				If Not UseTransaction Then
					CommitTransaction();
				EndIf;
			Except
				ShowErrorMessage(ErrorInfo());
				If UseTransaction Then
					HaveErrors = True;
					Goto ~REJECT;
				Else
					RollbackTransaction();
				EndIf;	
			EndTry;

		Else 
           Message = New UserMessage();
		   Message.Text = StrTemplate("%1: not supported", Row.Metadata);
		   Message.Message();
        EndIf;
	EndDo;

	If Params.Object <> Undefined Then
		If UseDataExchangeLoad Then
			Params.Object.DataExchange.Load = True;
		EndIf;
		Try
			Params.Object.Write();
		Except
			ShowErrorMessage(ErrorInfo());
			HaveErrors = True;
			If UseTransaction Then
				Goto ~REJECT;
			EndIf;
		EndTry;
	EndIf;

	~REJECT:     
	If UseTransaction Then
		If HaveErrors Then
			RollbackTransaction();
		Else
			CommitTransaction();
		EndIf;
	EndIf;
	Return Not HaveErrors;
EndFunction
