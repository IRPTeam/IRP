
Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields.Add("Ref");	
EndProcedure

Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	StandardProcessing = False;
	InterfaceLocalizationCode = LocalizationReuse.GetInterfaceLocalizationCode();
	Presentation = LocalizationServer.RefDescription(Data.Ref, InterfaceLocalizationCode);
EndProcedure

Procedure UpdatePredefinedNames(PredefinedDataName) Export

	SystemAttribute = ChartsOfCharacteristicTypes.SystemAttributes[PredefinedDataName].GetObject();
	
	NeedSave = False;
	For Each Lang In LocalizationReuse.AllDescription() Do
		PredefinedName = R(StrSplit(Lang, "_")[1])["SystemAttribute_"+PredefinedDataName];
 		If SystemAttribute[Lang] <> PredefinedName Then
 			SystemAttribute[Lang] = PredefinedName;
 			NeedSave = True;
 		EndIf;
	EndDo;
	
	If NeedSave Then
		SystemAttribute.Write();
	EndIf;
	
EndProcedure

