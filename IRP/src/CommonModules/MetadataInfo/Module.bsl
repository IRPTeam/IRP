#Region Internal

Function hasAttributes(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.Catalog);
	Array.Add(Enums.MetadataTypes.Document);
	Array.Add(Enums.MetadataTypes.Task);
	Array.Add(Enums.MetadataTypes.DataProcessor);
	Array.Add(Enums.MetadataTypes.Report);
	Array.Add(Enums.MetadataTypes.ChartOfCalculationTypes);
	Array.Add(Enums.MetadataTypes.ChartOfCharacteristicTypes);
	Array.Add(Enums.MetadataTypes.ExchangePlan);
	Array.Add(Enums.MetadataTypes.ChartOfAccounts);
	Array.Add(Enums.MetadataTypes.AccountingRegister);
	Array.Add(Enums.MetadataTypes.AccumulationRegister);
	Array.Add(Enums.MetadataTypes.CalculationRegister);
	Array.Add(Enums.MetadataTypes.InformationRegister);
	Array.Add(Enums.MetadataTypes.BusinessProcess);

	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasDimensions(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.AccountingRegister);
	Array.Add(Enums.MetadataTypes.AccumulationRegister);
	Array.Add(Enums.MetadataTypes.CalculationRegister);
	Array.Add(Enums.MetadataTypes.InformationRegister);
	Array.Add(Enums.MetadataTypes.Sequence);
	Array.Add(Enums.MetadataSubtype.Cube);

	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasStandardAttributes(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.Catalog);
	Array.Add(Enums.MetadataTypes.Document);
	Array.Add(Enums.MetadataTypes.DocumentJournal);
	Array.Add(Enums.MetadataTypes.Task);
	Array.Add(Enums.MetadataTypes.ChartOfCalculationTypes);
	Array.Add(Enums.MetadataTypes.ChartOfCharacteristicTypes);
	Array.Add(Enums.MetadataTypes.ExchangePlan);
	Array.Add(Enums.MetadataTypes.ChartOfAccounts);
	Array.Add(Enums.MetadataTypes.AccountingRegister);
	Array.Add(Enums.MetadataTypes.AccumulationRegister);
	Array.Add(Enums.MetadataTypes.CalculationRegister);
	Array.Add(Enums.MetadataTypes.InformationRegister);
	Array.Add(Enums.MetadataTypes.BusinessProcess);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasRecalculations(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.CalculationRegister);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function hasAccountingFlags(MetaName) Export
	Array = New Array();
	Array.Add(Enums.MetadataTypes.ChartOfAccounts);
	Return Not Array.Find(MetaName) = Undefined;
EndFunction

Function EnumNameByRef(RefData) Export
	RefNameType = RefData.Metadata().Name;
	ValueIndex = Enums[RefNameType].IndexOf(RefData);
	Return Metadata.Enums[RefNameType].EnumValues[ValueIndex].Name;
EndFunction

#EndRegion