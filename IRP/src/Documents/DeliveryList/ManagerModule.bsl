Function PresentationAsTask(Ref) Export
	Return
	"№ " + String(Ref.Number)
	+ " " + Format(Ref.Date, "DLF=D")
	+ " " + String(Ref.Store)
	+ " " + String(Ref.Vehicle);
EndFunction