
// Open job form.
// 
// Parameters:
//  JobDataSettings - See JobDataSettings
Procedure OpenJobForm(JobDataSettings, OwnerForm) Export
	
	If JobDataSettings.CallbackWhenAllJobsDone Then
		OpenMode = FormWindowOpeningMode.LockOwnerWindow;
	Else
		OpenMode = FormWindowOpeningMode.Independent;
	EndIf;
	
	OpenForm("CommonForm.BackgroundMultiJob", New Structure("JobDataSettings", JobDataSettings), OwnerForm, , , , , OpenMode);
	
EndProcedure
