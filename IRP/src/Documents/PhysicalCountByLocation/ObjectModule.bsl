
Procedure OnWrite(Cancel)
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status, CurrentUniversalDate());
EndProcedure
