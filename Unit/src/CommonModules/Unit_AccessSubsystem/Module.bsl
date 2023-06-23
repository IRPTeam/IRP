
#Region Info

Function Tests() Export
	TestList = New Array;
	TestList.Add("CheckDocument");
	TestList.Add("AccumulationRegisters");	
	Return TestList;
EndFunction

#EndRegion

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
