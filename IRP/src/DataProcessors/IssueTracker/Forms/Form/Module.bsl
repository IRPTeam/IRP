
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	IssueList.Parameters.SetParameterValue("Employee", SessionParameters.CurrentUser.Partner);
EndProcedure

&AtClient
Procedure IssueListSelection(Item, SelectedRow, Field, StandardProcessing)
	StandardProcessing = False;                            
	
	CurrentData = Items.IssueList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	Params = New Structure;
	Params.Insert("Issue", CurrentData.Ref); 
	Params.Insert("WorkOrder", CurrentData.WorkOrder);
	OpenForm("DataProcessor.IssueTracker.Form.CheckInForm", Params, ThisObject, , , , , FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure IssueListRefreshRequestProcessing()
	Items.IssueList.Refresh();
EndProcedure
