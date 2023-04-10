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
			XDTOPropertyStructure = GetXDTOProperty(XDTOType.Properties, ObjectData.Key);
			XDTOTypeStructure = XDTOPropertyStructure.Type;
			XDTOValue = PrepareObjectXDTO(ObjectData.Value, XDTOTypeStructure.Name, XDTOTypeStructure.NamespaceURI, WSName);
			If TypeOf(DataXDTO[XDTOPropertyStructure.Name]) = Type("XDTOList") Then
				DataXDTO[XDTOPropertyStructure.Name].Add(XDTOValue);
			Else
				DataXDTO[XDTOPropertyStructure.Name] = XDTOValue;
			EndIf;
		ElsIf TypeOf(ObjectData) = Type("KeyAndValue") 
			AND TypeOf(ObjectData.Value) = Type("Array") Then // List
			XDTOPropertyStructure = GetXDTOProperty(XDTOType.Properties, ObjectData.Key);
			If XDTOPropertyStructure = Undefined Then
				XDTOTypeRow = XDTOType;
			Else
 				XDTOTypeRow = XDTOPropertyStructure.Type;
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

					XDTOPropertyStructure = GetXDTOProperty(XDTOTypeRow.Properties, Str.Key);
					XDTOTypeStructure = XDTOPropertyStructure.Type;
					
					If TypeOf(XDTOTypeRow) = Type("XDTOValueType") Then
						If TypeOf(DataXDTO[XDTOPropertyStructure.Name]) =  Type("XDTOList") Then
							DataXDTO[XDTOPropertyStructure.Name].Add(Row[ObjectData.Key]);
						Else
							DataXDTO[XDTOPropertyStructure.Name] = Row[ObjectData.Key];
						EndIf;
					Else
						If TypeOf(DataXDTORow[XDTOPropertyStructure.Name]) =  Type("XDTOList") Then
							If TypeOf(Str.Value) = Type("Array") Then
								For Each StrArray In Str.Value Do
									DataXDTORow[XDTOPropertyStructure.Name].Add(PrepareObjectXDTO(StrArray, XDTOTypeStructure.Name, XDTOTypeStructure.NamespaceURI, WSName));
								EndDo;
							ElsIf TypeOf(Str.Value) = Type("String") Then
								SetObject(DataXDTORow, XDTOTypeStructure, Str.Key, Str.Value, WSName);
							Else
								DataXDTORow[XDTOPropertyStructure.Name].Add(PrepareObjectXDTO(Str.Value, XDTOTypeStructure.Name, XDTOTypeStructure.NamespaceURI, WSName));
							EndIf;
						ElsIf TypeOf(Str.Value) = Type("Structure") Then
							DataXDTORow[XDTOPropertyStructure.Name] = PrepareObjectXDTO(Str.Value, XDTOTypeStructure.Name, XDTOTypeStructure.NamespaceURI, WSName);
						Else 
							SetObject(DataXDTORow, XDTOTypeStructure, XDTOPropertyStructure.Name, Str.Value, WSName);
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
				
				XDTOPropertyStructure = GetXDTOProperty(XDTOType.Properties, ObjectDataKeyValue.Key);
				XDTOTypeStructure = XDTOPropertyStructure.Type;
				XDTOValue = PrepareObjectXDTO(ObjectDataKeyValue.Value, XDTOTypeStructure.Name, XDTOTypeStructure.NamespaceURI, WSName);
					
				If TypeOf(DataXDTO[XDTOTypeStructure.Name]) =  Type("XDTOList") Then
					DataXDTO[XDTOTypeStructure.Name].Add(XDTOValue);
				ElsIf TypeOf(XDTOTypeStructure.Name) = Type("Structure") Then
					DataXDTO[XDTOTypeStructure.Name] = XDTOValue;
				Else 
					SetObject(DataXDTO, XDTOTypeStructure, XDTOTypeStructure.Name, ObjectDataKeyValue.Value, WSName);
				EndIf;

			EndDo;
		Else // set attribute value
			SetObject(DataXDTO, XDTOType, ObjectData.Key, ObjectData.Value, WSName);
		EndIf; 
		
	EndDo;

	Return DataXDTO;
	
EndFunction

// Get XDTOType.
// 
// Parameters:
//  Properties - XDTOPropertyCollection - Properties
//  PropertyName - String - Property name
// 
// Returns:
//  XDTOProperty
Function GetXDTOProperty(Properties, PropertyName)
	
	PropertyInfo = Properties.Get(PropertyName);
	
	If PropertyInfo = Undefined Then
		For Each Pr In Properties Do
			If Pr.LocalName = PropertyName Then
				Return Pr;
			EndIf;
		EndDo;
	EndIf;
	Return PropertyInfo;
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

Function ObjectXDTOStructure(XDTOType, Val ArrayList, WSName = Undefined, FillEmptyValues = True) Export
	
//	XDTOType = CommonFunctionsServer.XDTOFactoryObject(WSName).Type(URI, TypeName);
	XDTOStructure = New Structure;
	ArrayList.Add(XDTOType);
	
	For Each Property In XDTOType.Properties Do
		   
		If TypeOf(Property.Type) = Type("XDTOObjectType")
			AND Property.Type.Properties.Count() Then // not simpe type			
			
			If ArrayList.Find(Property.Type) = Undefined Then // if type repeated - save type with GUID and add to map, set GUID
			
				If Property.UpperBound < 0 Then
					Array = New Array;
					Array.Add(ObjectXDTOStructure(Property.Type, ArrayList, WSName));
					XDTOStructure.Insert(Property.Name, Array);
				Else
					XDTOStructure.Insert(Property.Name, ObjectXDTOStructure(Property.Type, ArrayList, WSName));
				EndIf;
			Else
				CheckCountLvl = 0;
				For Each Row In ArrayList Do
					If Row = Property.Type Then
						CheckCountLvl = CheckCountLvl + 1;
					EndIf;
				EndDo;
				
				If CheckCountLvl > 1 Then
					Break;
				Else
					If Property.UpperBound < 0 Then
						Array = New Array;
						Array.Add(ObjectXDTOStructure(Property.Type, ArrayList, WSName));
						XDTOStructure.Insert(Property.Name, Array);
					Else
						XDTOStructure.Insert(Property.Name, ObjectXDTOStructure(Property.Type, ArrayList, WSName));
					EndIf;
				EndIf;
			EndIf;
		ElsIf FillEmptyValues Then
			If Not Property.DefaultValue = Undefined Then
				XDTOStructure.Insert(Property.Name, Property.DefaultValue.Value);
			ElsIf Not StrCompare(Property.Type.Name, "uuid") Then
				XDTOStructure.Insert(Property.Name, String(New UUID));
			ElsIf Property.Type.Name = "string"
			 	Or Property.Type.Name = "normalizedString"
			 	Or Property.Type.Name = "ID"
			 	Or Property.Type.Name = "anyURI"
			 	Or Property.Type.Name = "language" Then
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
				XDTOStructure.Insert(Property.Name, CommonFunctionsServer.GetCurrentSessionDate());
			ElsIf Property.Type.Name = "time" Then
				XDTOStructure.Insert(Property.Name, CommonFunctionsServer.GetCurrentSessionDate());
			ElsIf Property.Type.Name = "dateTime" Then
				XDTOStructure.Insert(Property.Name, CommonFunctionsServer.GetCurrentSessionDate());
			ElsIf Property.Type.Name = "anyType" Then
				XDTOStructure.Insert(Property.Name, Property.Name);
			ElsIf Property.Type.Name = "base64Binary" Then
				Body = New MemoryStream();
				DataWriter = New DataWriter(Body, TextEncoding.UTF8);
				DataWriter.WriteLine(Property.Name);
				DataWriter.Close();
				BD = Body.CloseAndGetBinaryData();
				
				Value = Base64String(BD);
				XDTOStructure.Insert(Property.Name, Value);
			Else
				If Not Property.Type.Facets = Undefined And Not Property.Type.Facets.Enumerations = Undefined Then
					XDTOStructure.Insert(Property.Name, Property.Type.Facets.Enumerations[0].Value);
				Else
					XDTOStructure.Insert(Property.Name, Property.Name);
				EndIf;
			EndIf;
			
			If Property.UpperBound < 0 Then
				Array = New Array;
				Array.Add(XDTOStructure[Property.Name]);
				XDTOStructure.Insert(Property.Name, Array);
			EndIf;
		Else
			XDTOStructure.Insert(Property.Name);
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
				For Each Column In Object.Ref.Metadata().TabularSections[NameSlaveTable].Attributes Do
					FillAttribute(Row, Object, Column.Name, DocRow, ID);
				EndDo;
			EndDo;
			
			Return;
		ElsIf Names[0] = "C" Then	
			DocAttr[AttrName] = GetFirstElementInList(XDTO, "__content");
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

