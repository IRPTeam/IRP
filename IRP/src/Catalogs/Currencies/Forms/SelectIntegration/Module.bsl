&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Query = New Query();
	Query.Text =
	"SELECT
	|	IntegrationSettings.Ref AS IntegrationSettings
	|FROM
	|	Catalog.IntegrationSettings AS IntegrationSettings
	|WHERE
	|	NOT IntegrationSettings.DeletionMark
	|	AND IntegrationSettings.IntegrationType = VALUE(Enum.IntegrationType.CurrencyRates)";

	QueryResult = Query.Execute();
	ThisObject.IntegrationTable.Load(QueryResult.Unload());
EndProcedure

&AtClient
Procedure IntegrationTableSelection(Item, RowSelected, Field, StandardProcessing)
	ReturnSelectedIntegrationSettings();
EndProcedure

&AtClient
Procedure ReturnSelectedIntegrationSettings()
	CurrentRow = Items.IntegrationTable.CurrentData;
	If CurrentDate() = Undefined Then
		Close(Undefined);
	Else
		Close(New Structure("IntegrationSettings", CurrentRow.IntegrationSettings));
	EndIf;
EndProcedure

&AtClient
Procedure Ok(Command)
	ReturnSelectedIntegrationSettings();
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure