
&After("AfterWriteTransaction")
Procedure Unit_AfterWriteTransaction(DocRefsArray, Form) Export
	ClearMessages();
	For Each DocRef In DocRefsArray Do
		CommonFunctionsClientServer.ShowUsersMessage(CommonFunctionsServer.GetRefAttribute(DocRef, "Number"));
	EndDo;
EndProcedure
