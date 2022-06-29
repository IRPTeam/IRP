&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.DataMap = Undefined Then
		Cancel = True;
		Return;
	EndIf;
	TopLevel = Parameters.DataMap.TopLevel;
	For Each Path In Parameters.DataMap.DataToMap Do
		Row = DataMapping.GetItems().Add();
		Row.Info = Path.Key;

		For Each Info In Path.Value Do
			InfoRow = Row.GetItems().Add();
			Ref = Eval(Info.Type + ".EmptyRef()");

			InfoRow.Info = TypeOf(Ref);
			InfoRow.Value = Info.Value;
			InfoRow.Type = Info.Type;

			If Not ValueIsFilled(Info.Ref) Then
				InfoRow.Ref = Ref;
			Else
				InfoRow.Ref = Info.Ref;
			EndIf;
		EndDo;
	EndDo;
EndProcedure

&AtClient
Procedure SaveMapping(Command)
	SaveMappingAtServer();
EndProcedure

&AtServer
Procedure SaveMappingAtServer()
	For Each Row In DataMapping.GetItems() Do
		For Each ItemRow In Row.GetItems() Do
			If ItemRow.Ref.IsEmpty() Then
				Continue;
			EndIf;
			SettingsStructure = Catalogs.DataMappingItems.GetCreationStructure();
			SettingsStructure.Ref = ItemRow.Ref;
			SettingsStructure.TopLevel = TopLevel;
			SettingsStructure.Type = ItemRow.Type;
			SettingsStructure.Value = ItemRow.Value;

			Catalogs.DataMappingItems.GetOrCreateMappingItem(SettingsStructure);

		EndDo;
	EndDo;
EndProcedure