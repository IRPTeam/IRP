
// @strict-types

Procedure OnWrite(Cancel)
	ScheduledJob = Metadata.ScheduledJobs.RunExternalFunctions;
	ServiceSystemServer.UpdateScheduledJob(ScheduledJob, Value);
EndProcedure
