Procedure OnWrite(Cancel)
	ScheduledJob = Metadata.ScheduledJobs.AreaUpdate;
	ServiceSystemServer.UpdateScheduledJob(ScheduledJob, ThisObject.Value);
EndProcedure