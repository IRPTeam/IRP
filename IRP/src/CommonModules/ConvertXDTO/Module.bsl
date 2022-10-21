#Region Prepare_Outgoing_eInvoice
Procedure FillStructureDataByObject(StructureData, Val Object, Val Attr, Val Value, MetadataObject, Table = False) Export
	
	NameList = StrSplit(Attr.Name, "_", False);
	If NameList.Count() <= 1 Then
		Return;
	ElsIf NOT NameList[0] = "I"   // Main attribute
		AND NOT NameList[0] = "A" // additional attribute to main
		AND NOT NameList[0] = "C" // common single attribute
		AND NOT NameList[0] = "R" // Ref to some table. Ref set after _M_
		AND NOT NameList[0] = "S" // Single value, ex. array of strings
		Then
		Return;
	EndIf;

	
	LastStructure = StructureData;
	For Index = 1 To NameList.UBound() Do
		
		If NameList[Index] = "M" Then
			TabName = New Array;
			For TIndex = Index To NameList.UBound() Do
		  		TabName.Add(NameList[TIndex]);
			EndDo;
			TabName = StrConcat(TabName, "_");
			FindRows = Object[TabName].FindRows(New Structure("Key", Value));
			
			For Each Row In FindRows Do
				Structure = New Structure;
				For Each RowData In MetadataObject.TabularSections[TabName].Attributes Do 
					FillStructureDataByObject(Structure, Object, RowData, Row[RowData.Name], MetadataObject, False);
				EndDo;
				LastStructure.Add(Structure);
			EndDo;
			Return;
		ElsIf Index = NameList.UBound() Then
			If Table Then
				Array = New Array;
				For Each Row In Value Do
					Structure = New Structure;
					For Each RowData In Attr.Attributes Do 
						FillStructureDataByObject(Structure, Object, RowData, Row[RowData.Name], MetadataObject, False);
					EndDo;
					Array.Add(Structure);
				EndDo;
				LastStructure.Insert(NameList[Index], Array);
			Else
				If NameList[0] = "C" Then
					Map = New Map;
					Map.Insert("__content", Value);
					LastStructure.Insert(NameList[Index], Map);
				Else
					LastStructure.Insert(NameList[Index], Value);
				EndIf;
			EndIf;
		Else
			If NOT LastStructure.Property(NameList[Index]) Then
				If NameList[0] = "R" Then
					LastStructure.Insert(NameList[Index], New Array);
				Else
					LastStructure.Insert(NameList[Index], New Structure);
				EndIf;
			EndIf;
			If TypeOf(LastStructure[NameList[Index]]) = Type("Array") 
				Or TypeOf(LastStructure[NameList[Index]]) = Type("Structure") Then
				LastStructure = LastStructure[NameList[Index]];
			Else
				Content = LastStructure[NameList[Index]];
				If TypeOf(Content) = Type("Map") Then
					LastStructure = LastStructure[NameList[Index]];
				Else
					Map = New Map;
					Map.Insert("__content", Content); 
					LastStructure[NameList[Index]] = Map;
					LastStructure = LastStructure[NameList[Index]];
				EndIf;
			EndIf;
			
		EndIf;
	EndDo;

EndProcedure

Function PrepareObjectXDTO(ObjectStructure, TypeName, URI, WSName) Export
	
	// In every list first line we pass by, and start with second one. First line is a template one.
	
	XDTOType = CommonFunctionsServer.XDTOFactoryObject(WSName).Type(URI, TypeName);
	
	DataXDTO = CommonFunctionsServer.XDTOFactoryObject(WSName).Create(XDTOType);
	
	If ObjectStructure = Undefined Then
		Return DataXDTO;
	EndIf;
		
	For Each ObjectData In ObjectStructure Do
		
		If TypeOf(ObjectData) = Type("KeyAndValue") AND TypeOf(ObjectData.Value) = Type("Structure") Then //объект
			XDTOTypeStructure = XDTOType.Properties.Get(ObjectData.Key).Type;
			If TypeOf(DataXDTO[ObjectData.Key]) = Type("XDTOList") Then
				DataXDTO[ObjectData.Key].Add(PrepareObjectXDTO(ObjectData.Value, XDTOTypeStructure.Name, XDTOTypeStructure.NamespaceURI, WSName));
			Else
				DataXDTO[ObjectData.Key] = PrepareObjectXDTO(ObjectData.Value, XDTOTypeStructure.Name, XDTOTypeStructure.NamespaceURI, WSName);
			EndIf;
		ElsIf TypeOf(ObjectData) = Type("KeyAndValue") 
			AND TypeOf(ObjectData.Value) = Type("Array") Then // List
			
			If XDTOType.Properties.Get(ObjectData.Key) = Undefined Then
				XDTOTypeRow = XDTOType;
			Else
 				XDTOTypeRow = XDTOType.Properties.Get(ObjectData.Key).Type;
			EndIf;
			
			For Each Row In ObjectData.Value Do
				DataXDTORow = CommonFunctionsServer.XDTOFactoryObject(WSName).Create(XDTOTypeRow);
				For Each Str In Row Do
					If Str.Key = "__content" OR TypeOf(Str.Value) = Type("Map") Then
						SetObject(DataXDTORow, XDTOTypeRow, Str.Key, Str.Value, WSName);
					EndIf;
					If Str.Value = Undefined OR TypeOf(Str.Value) = Type("Map") Then
						Continue;
					EndIf; 
					
					// uyumsoft rename some tags like TaxTotal to TaxTotal1, and other
					If Not TypeOf(XDTOTypeRow) = Type("XDTOValueType") And XDTOTypeRow.Properties.Get(Str.Key) = Undefined Then
						If XDTOTypeRow.Properties.Get(Str.Key + "1") = Undefined Then
							Continue;
						Else
							StrKey = Str.Key + "1"; 
						EndIf;
					Else
						StrKey = Str.Key;
					EndIf;
					// uyumsoft
					
					If TypeOf(XDTOTypeRow) = Type("XDTOValueType") Then
						If TypeOf(DataXDTO[StrKey]) =  Type("XDTOList") Then
							DataXDTO[ObjectData.Key].Add(Row[ObjectData.Key]);
						Else
							DataXDTO[ObjectData.Key] = Row[ObjectData.Key];
						EndIf;
					Else
						XDTOTypeStructure = XDTOTypeRow.Properties.Get(StrKey).Type;
						
						If TypeOf(DataXDTORow[StrKey]) =  Type("XDTOList") Then
							If TypeOf(Str.Value) = Type("Array") Then
								For Each StrArray In Str.Value Do
									DataXDTORow[StrKey].Add(PrepareObjectXDTO(StrArray, XDTOTypeStructure.Name, XDTOTypeStructure.NamespaceURI, WSName));
								EndDo;	
							Else
								DataXDTORow[StrKey].Add(PrepareObjectXDTO(Str.Value, XDTOTypeStructure.Name, XDTOTypeStructure.NamespaceURI, WSName));
							EndIf;
						ElsIf TypeOf(Str.Value) = Type("Structure") Then
							DataXDTORow[StrKey] = PrepareObjectXDTO(Str.Value, XDTOTypeStructure.Name, XDTOTypeStructure.NamespaceURI, WSName);
						Else 
							SetObject(DataXDTORow, XDTOTypeStructure, StrKey, Str.Value, WSName);
						EndIf;
					EndIf;
				EndDo;
				If Not TypeOf(XDTOTypeRow) = Type("XDTOValueType") Then
					If DataXDTO[ObjectData.Key] = Undefined Then
						DataXDTO[ObjectData.Key] = DataXDTORow;
					Else
						DataXDTO[ObjectData.Key].Add(DataXDTORow);
					EndIf;
				EndIf;
			EndDo; 
		ElsIf TypeOf(ObjectData) = Type("Structure") Then
			For Each ObjectDataKeyValue In ObjectData Do
								
				If ObjectDataKeyValue.Key = "__content"  OR TypeOf(ObjectDataKeyValue.Value) = Type("Map") Then
					SetObject(DataXDTO, XDTOType, ObjectDataKeyValue.Key, ObjectDataKeyValue.Value, WSName);
				EndIf;
				If ObjectDataKeyValue.Value = Undefined  OR TypeOf(ObjectDataKeyValue.Value) = Type("Map") Then
					Continue;
				EndIf; 
				
				XDTOTypeStructure = XDTOType.Properties.Get(ObjectDataKeyValue.Key).Type;

				
				If TypeOf(DataXDTO[ObjectDataKeyValue.Key]) =  Type("XDTOList") Then
										
					DataXDTO[ObjectDataKeyValue.Key].Add(PrepareObjectXDTO(ObjectDataKeyValue.Value, XDTOTypeStructure.Name, XDTOTypeStructure.NamespaceURI, WSName));
				ElsIf TypeOf(ObjectDataKeyValue.Value) = Type("Structure") Then
					DataXDTO[ObjectDataKeyValue.Key] = PrepareObjectXDTO(ObjectDataKeyValue.Value, XDTOTypeStructure.Name, XDTOTypeStructure.NamespaceURI, WSName);
				Else 
					SetObject(DataXDTO, XDTOTypeStructure, ObjectDataKeyValue.Key, ObjectDataKeyValue.Value, WSName);
				EndIf;

			EndDo;
		
		Else                                               //уже сам реквизит
			SetObject(DataXDTO, XDTOType, ObjectData.Key, ObjectData.Value, WSName);
		EndIf; 
		
	EndDo;

	Return DataXDTO;
	
EndFunction

Procedure SetObject(XDTO, Type, Property, Val Value = Undefined, WSName = Undefined) Export
	If TypeOf(Value) = Type("Map") Then
		If NOT Type.Properties.Get("__content") = Undefined Then
			ContentData =  CommonFunctionsServer.XDTOFactoryObject(WSName).Create(Type);
			For Each Row In Value Do
				ContentData[Row.Key] = Row.Value;
			EndDo;
			XDTO = ContentData;
		Else
			ContentData =  CommonFunctionsServer.XDTOFactoryObject(WSName).Create(Type.Properties.Get(Property).Type);
			For Each Row In Value Do
				ContentData[Row.Key] = Row.Value;
			EndDo;
			If TypeOf(XDTO[Property]) = Type("XDTOList") Then
				XDTO[Property].Add(ContentData);
			Else
				XDTO[Property] = ContentData;
			EndIf;
		EndIf;
	ElsIf TypeOf(Type) = Type("XDTOValueType") Then	
		XDTO[Property] = Value;
	Else
		If Type.Properties.Get(Property) = Undefined Then
			ContentData =  CommonFunctionsServer.XDTOFactoryObject(WSName).Create(Type);
		Else
			ContentData =  CommonFunctionsServer.XDTOFactoryObject(WSName).Create(Type.Properties.Get(Property).Type);
		EndIf;
		If ContentData = Undefined Then
			ContentData = Value;
		Else
			ContentData.__content = Value;
		EndIf;
		
		If TypeOf(XDTO[Property]) = Type("XDTOList") Then
			XDTO[Property].Add(ContentData);
		Else
			XDTO[Property] = ContentData;
		EndIf;

	EndIf;
EndProcedure

Function ObjectXDTOStructure(TypeName, URI, Val ArrayList, WSName = Undefined) Export
	
	XDTOType = CommonFunctionsServer.XDTOFactoryObject(WSName).Type(URI, TypeName);
	XDTOStructure = New Structure;
	ArrayList.Add(XDTOType);
	
	For Each Property In XDTOType.Properties Do
		   
		If TypeOf(Property.Type) = Type("XDTOObjectType")
			AND Property.Type.Properties.Count() // not simpe type			
			AND ArrayList.Find(Property.Type) = Undefined Then // if type repeated - save type with GUID and add to map, set GUID
			
			If Property.UpperBound < 0 Then
				Array = New Array;
				Array.Add(ObjectXDTOStructure(Property.Type.Name, Property.Type.NamespaceURI, ArrayList, WSName));
				XDTOStructure.Insert(Property.Name, Array);
			Else
				XDTOStructure.Insert(Property.Name, ObjectXDTOStructure(Property.Type.Name, Property.Type.NamespaceURI, ArrayList, WSName));
			EndIf;
		
		Else			
			If Property.Type.Name = "string" Then
				XDTOStructure.Insert(Property.Name, Property.Name);
			ElsIf Property.Type.Name = "boolean" Then
				XDTOStructure.Insert(Property.Name, True);
			ElsIf Property.Type.Name = "integer" 
				Or Property.Type.Name = "int" 
				Or Property.Type.Name = "double" 
				Or Property.Type.Name = "long" Then
					XDTOStructure.Insert(Property.Name, 1);
			ElsIf Property.Type.Name = "decimal" Then
				XDTOStructure.Insert(Property.Name, 1.1);
			ElsIf Property.Type.Name = "date" Then
				XDTOStructure.Insert(Property.Name, CurrentDate());
			ElsIf Property.Type.Name = "time" Then
				XDTOStructure.Insert(Property.Name, CurrentDate());
			ElsIf Property.Type.Name = "dateTime" Then
				XDTOStructure.Insert(Property.Name, CurrentDate());
			ElsIf Property.Type.Name = "anyType" Then
				XDTOStructure.Insert(Property.Name, Property.Name);
			EndIf;
			
			If Property.UpperBound < 0 Then
				Array = New Array;
				Array.Add(XDTOStructure[Property.Name]);
				XDTOStructure.Insert(Property.Name, Array);
			EndIf;
		EndIf
		
	EndDo;
	ArrayList.Delete(ArrayList.UBound());
	// if is it fist level, then change inside structure GUID by type 
	
	Return XDTOStructure;
	
EndFunction

#EndRegion

#Region FillObjectFromXDTO

Procedure FillAttribute(XDTO, Object, Val AttrName, DocAttr, ID = 0) Export
	 
	Names = StrSplit(AttrName, "_");
	
	If Not (Names[0] = "I" Or Names[0] = "A") Then
		If Names[0] = "R" Then
			DocAttr[AttrName] = ID;
			NameSlaveTable = "M";
			
			If XDTO.Properties().Get(Names[1]) = Undefined Then
				DataTag = XDTO[Names[1] + 1];
			Else
				DataTag = XDTO[Names[1]];
			EndIf;
				
			For Index = 2 To Names.UBound() Do
				If Names[Index] = "M" Then
					Break;
				EndIf;				
				
				DataTag = GetFirstElementInList(DataTag, Names[Index], True);
				
			EndDo;
			
			For Index = Index + 1 To Names.UBound() Do
				NameSlaveTable = NameSlaveTable + "_" + Names[Index];
			EndDo;
			
			For Each Row In DataTag Do
				DocRow = Object[NameSlaveTable].Add();
				DocRow.Key = ID;
				For Each Column In Object.Metadata().TabularSections[NameSlaveTable].Attributes Do
					FillAttribute(Row, Object, Column.Name, DocRow, ID);
				EndDo;
			EndDo;
			
			Return;
		Else	
			Return;
		EndIf;
	EndIf;
	
	DataTag = ChangeTagName(XDTO, Names);
	If DataTag = Undefined Then
		Return;
	EndIf;
	
	For Index = 2 To Names.UBound() Do
				
		DataTag = GetFirstElementInList(DataTag, Names[Index]);
		If DataTag = Undefined Then
			Return;
		EndIf;
	EndDo;
	If DataTag = Undefined Then
		Return;
	EndIf;
	If Names[0] = "I" Then
		DocAttr[AttrName] = GetFirstElementInList(DataTag, "__content");
	ElsIf Names[0] = "A" Then		
		DocAttr[AttrName] = GetFirstElementInList(DataTag);
	EndIf;
EndProcedure

Function ChangeTagName(XDTO, Val Names)
	DataTag = XDTO[Names[1]];
	Return DataTag
EndFunction

Function GetFirstElementInList(Tag, Attribute = "", isList = False)
	If TypeOf(Tag) = Type("XDTOList") Then
		If Tag.Count() Then
			If IsBlankString(Attribute) Then
				Return Tag[0];
			Else
				Return Tag[0][Attribute];
			EndIf;
		Else
			If isList Then
				Return Tag;
			Else
				Return Undefined;
			EndIf;
		EndIf;
	Else
		If IsBlankString(Attribute) Then
			Return Tag;
		Else
			Return Tag[Attribute];
		EndIf;
	EndIf;
EndFunction

#EndRegion

