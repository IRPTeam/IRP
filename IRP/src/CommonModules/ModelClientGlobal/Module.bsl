
//Procedure ModelIdleHandler() Export
//	Message("Idle handler");
//	JobStatus = ModelServer_V2.GetJobStatus();
//	If JobStatus.JobKey = Undefined Then
//		DetachIdleHandler("ModelIdleHandler");
//		Message("detach Idle handler: undefined");
//		Return;
//	EndIf;
//	
//	If JobStatus.Status = "Canceled" Or JobStatus.Status = "Failed" Then
//		DetachIdleHandler("ModelIdleHandler");
//		Message("detach Idle handler: " + JobStatus.Status);
//		Return;
//	EndIf;
//	
//	If JobStatus.Status = "Active" Then
//		// wait
//		Return;
//	EndIf;
//	
//	// complete
//	DetachIdleHandler("ModelIdleHandler");
//	
//	JobResult = GetFromTempStorage(JobStatus.StorageAddress);
////	ModelClientServer_V2.TransferStructureToForm(SessionParameters.BackgroundJobTransfer.Get(), JobResult.Parameters);
//	ControllerClientServer_V2.OnChainComplete(JobResult.Parameters);
//	ModelClientServer_V2.DestroyEntryPoint(JobResult.Parameters);	
//EndProcedure	
