&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	FillingValues = CommonFormActionsServer.RestoreFillingData(FillingData);

	Cancel = True;
	FormParameters = New Structure("FillingValues", FillingValues);
	If UseItemFilter Then
		FormParameters.Insert("Item", ItemFilter);
	EndIf;

	OpenForm("InformationRegister.Barcodes.Form.RecordForm", FormParameters);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Parameters.Property("Item", ItemFilter);
	Parameters.Property("ItemKey", ItemKey);
	Parameters.Property("UseItemFilter", UseItemFilter);

	FillingDataParameter = Undefined;
	If Parameters.Property("FillingData", FillingDataParameter) Then
		FillingData = CommonFunctionsServer.SerializeXMLUseXDTO(FillingDataParameter);
	EndIf;
EndProcedure