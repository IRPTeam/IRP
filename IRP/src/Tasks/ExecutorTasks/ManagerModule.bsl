
Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	StandardProcessing = False;
	Presentation = StrTemplate("%1 (%2)", String(Data["Description_" + LocalizationReuse.GetLocalizationCode()]), Data.Number);
EndProcedure

Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields = New Array();
	Fields.Add("Number");
	For Each DescriptionName In LocalizationServer.AllDescription() Do
		Fields.Add(DescriptionName);
	EndDo;
EndProcedure
