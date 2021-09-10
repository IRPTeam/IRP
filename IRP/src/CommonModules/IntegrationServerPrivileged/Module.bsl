Procedure SaveSettingsInInfoReg(SettingsTab) Export

	For Each Row In SettingsTab Do
		Reg = InformationRegisters.IntegrationInfo.CreateRecordSet();
		Reg.Filter.IntegrationSettings.Set(Row.IntegrationSettings);
		Reg.Filter.Key.Set(Row.Key);

		If Not ValueIsFilled(Row.Value) And Row.SecondValue = Undefined Then
			Reg.Write();
			Continue;
		EndIf;

		FillPropertyValues(Reg.Add(), Row);
		Reg.Write();

	EndDo;

EndProcedure