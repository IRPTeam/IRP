Procedure SaveSettingsInInfoReg(SettingsTab) Export
	isProduct = ServiceSystemServer.isProduction();
	
	For Each Row In SettingsTab Do
	
		Reg = InformationRegisters.IntegrationInfo.CreateRecordSet();
		Reg.Filter.IntegrationSettings.Set(Row.IntegrationSettings);
		Reg.Filter.Key.Set(Row.Key);
		Reg.Filter.isProduct.Set(isProduct);
		If Not ValueIsFilled(Row.Value) And Row.SecondValue = Undefined Then
			Reg.Write();
			Continue;
		EndIf;
		NewRow = Reg.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.isProduct = isProduct;
		Reg.Write();

	EndDo;

EndProcedure

Procedure ClearSettingsInInfoReg(IntegrationSettings) Export
	
	If Not ValueIsFilled(IntegrationSettings) Then
		Raise IntegrationSettings;
	EndIf;
	
	isProduct = ServiceSystemServer.isProduction();
	Reg = InformationRegisters.IntegrationInfo.CreateRecordSet();
	Reg.Filter.IntegrationSettings.Set(IntegrationSettings);
	Reg.Filter.isProduct.Set(isProduct);
	Reg.Write();
	
EndProcedure

