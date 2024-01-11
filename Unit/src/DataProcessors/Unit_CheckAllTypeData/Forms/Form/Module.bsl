// @strict-types

&AtClient
Procedure Check(Command)
	CheckAtServer();
EndProcedure

&AtServer
Procedure CheckAtServer()
	Msg = New Array; // Array of String
	
	Meta = New Array; // Array Of MetadataObjectCollection
	Meta.Add(Metadata.Catalogs);   
	Meta.Add(Metadata.Documents);   
	Meta.Add(Metadata.ChartsOfAccounts);   
	Meta.Add(Metadata.ChartsOfCalculationTypes);   
	Meta.Add(Metadata.ChartsOfCharacteristicTypes);   
	Meta.Add(Metadata.InformationRegisters);   
	Meta.Add(Metadata.AccountingRegisters);   
	Meta.Add(Metadata.AccumulationRegisters);   
	
	AttributeForSplit = New Array; // Array Of String
	AttributeForSplit.Add("Type");
	AttributeForSplit.Add("TransactionType");
	AttributeForSplit.Add("EquipmentType");
	AttributeForSplit.Add("SpecialOfferType");
	AttributeForSplit.Add("DocumentType");
	AttributeForSplit.Add("OfferGroupType");
	
	For Each Metainfo In Meta Do
		Msg.Add("--------------------------------------------"); 
		For Each Doc In Metainfo Do // MetadataObjectDocument
			Query = New Query("SELECT DataInfo.* FROM " + Doc.FullName() + " AS DataInfo");
			Data = Query.Execute().Unload();
			Msg.Add(Doc.FullName() + ": " + Data.Count()); 
			MetadataType = Enums.MetadataTypes[StrSplit(Doc.FullName(), ".")[0]];
			For Each Row In AttributeForSplit Do
				If MetadataInfo.hasAttributes(MetadataType) Then
					If Not Doc.Attributes.Find(Row) = Undefined Then
						Type = Doc.Attributes[Row].Type.Types()[0];
						MetaType = Metadata.FindByType(Type);
						
						If MetaType = Undefined Then
							Continue;
						EndIf;
						If StrSplit(MetaType.FullName(), ".")[0] = "Enum" Then
							
							For Each EnumData In MetaType.EnumValues Do
							
								MetaValue = Enums[MetaType.Name][EnumData.Name];
								DataCount = Data.FindRows(New Structure(Row, MetaValue));
								Msg.Add("	" + Row + " - " + Type + " - " + MetaValue + ": " + DataCount.Count());
							
							EndDo;
						EndIf;
					EndIf; 
				EndIf
			EndDo;
			
		EndDo;
	ENdDo;
	
	Info = StrConcat(Msg, Chars.LF);
EndProcedure

