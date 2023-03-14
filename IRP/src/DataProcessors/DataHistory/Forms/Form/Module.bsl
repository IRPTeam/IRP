&AtClient
Procedure SaveSettings(Command)
	SaveSettingsAtServer();
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	FillTree();
EndProcedure

&AtClient
Procedure UpdateDataHistory(Command)
	UpdateDataHistoryAtServer();
EndProcedure

#Region Privat

&AtServer
Procedure FillTree()
	Structure = FillMetadataStructure();
	MetadataTree.GetItems().Clear();
	For Each MetaRow In Structure Do
		If Not Metadata[MetaRow.Key].Count() Then
			Continue;
		EndIf;

		NewRow = MetadataTree.GetItems().Add();
		NewRow.Name = MetaRow.Key;

		For Each ObRow In Metadata[MetaRow.Key] Do
			AddRow = NewRow.GetItems().Add();
			AddRow.Name = ObRow.Name;
			Settings = DataHistory.GetSettings(ObRow);
			If Settings = Undefined Then
				AddRow.Use = ObRow.DataHistory = Metadata.ObjectProperties.DataHistoryUse.Use;
			Else
				AddRow.Use = Settings.Use;
			EndIf;
		EndDo;

	EndDo;
EndProcedure

&AtServer
Function FillMetadataStructure()
	Structure = New Structure();
	Structure.Insert("BusinessProcesses");
	Structure.Insert("CalculationRegisters");
	Structure.Insert("Catalogs");
	Structure.Insert("ChartsOfAccounts");
	Structure.Insert("ChartsOfCalculationTypes");
	Structure.Insert("ChartsOfCharacteristicTypes");
	Structure.Insert("Constants");
	Structure.Insert("Documents");
	Structure.Insert("ExchangePlans");
	Structure.Insert("InformationRegisters");
	Structure.Insert("Sequences");
	Structure.Insert("Tasks");
	Return Structure;
EndFunction

&AtServer
Procedure SaveSettingsAtServer()
	For Each Row In MetadataTree.GetItems() Do
		For Each MetaRow In Row.GetItems() Do
			If MetaRow.Use Then
				DataHistorySet = New DataHistorySettings();
				DataHistorySet.Use = MetaRow.Use;

				DataHistory.SetSettings(Metadata[Row.Name][MetaRow.Name], DataHistorySet);
			Else
				DataHistory.SetSettings(Metadata[Row.Name][MetaRow.Name], Undefined);
			EndIf;

		EndDo;
	EndDo;
	FillTree();
EndProcedure

&AtServerNoContext
Procedure UpdateDataHistoryAtServer()
	DataProcessors.DataHistory.UpdateDataHistory();
EndProcedure

#EndRegion