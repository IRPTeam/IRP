

Procedure BeforeWrite(Cancel)
	ThisObject.FullDescription = StrReplace(ThisObject.FullDescr(), "/", ", ");
EndProcedure
