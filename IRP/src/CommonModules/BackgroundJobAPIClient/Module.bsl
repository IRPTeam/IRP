
// Open job form.
// 
// Parameters:
//  JobDataSettings - See JobDataSettings
Procedure OpenJobForm(JobDataSettings, OwnerForm) Export
	
	OpenForm("CommonForm.BackgroundMultiJob", New Structure("JobDataSettings", JobDataSettings), OwnerForm, , , , , FormWindowOpeningMode.LockOwnerWindow);
	
EndProcedure
