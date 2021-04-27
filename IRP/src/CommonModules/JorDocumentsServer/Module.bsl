Procedure OnCreateAtServer(Cancel, StandardProcessing, Form, Parameters) Export
	CustomFilter = Undefined;
	If Parameters.Property("CustomFilter", CustomFilter) Then
		Form.List.CustomQuery = True;
		Form.List.QueryText = CustomFilter.QueryText;
		For Each QueryParameter In CustomFilter.QueryParameters Do
			If Form.List.Parameters.Items.Find(QueryParameter.Key) <> Undefined Then
				Form.List.Parameters.SetParameterValue(QueryParameter.Key, QueryParameter.Value);
			EndIf;
		EndDo;
//		Ref = CustomFilter.QueryParameters.Ref;
//		Period = EndOfDay(CurrentSessionDate());
//		If ValueIsFilled(Ref) Then 
//			If Ref.Posted Then
//				Period = New Boundary(Ref.PointInTime(), BoundaryType.Excluding);
//			Else
//				Period = EndOfDay(Ref.Date);
//			EndIf;
//		EndIf;
//		Form.List.Parameters.SetParameterValue("Period", Period);
	EndIf;
EndProcedure
