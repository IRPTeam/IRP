
&AtClient
Procedure ShowCode(Command)
	CommonFunctionsClientServer.ShowUsersMessage(SendedSMSCode);
EndProcedure

&AtClient
Procedure RetryToSend(Command)
	RetryToSendAtServer();
EndProcedure

&AtServer
Procedure RetryToSendAtServer()
	
	TimeOut = GetTimeOut();
	If ValueIsFilled(SendedDate) Then
		Delay = CurrentSessionDate() - SendedDate - TimeOut;
		If Delay < 0 Then
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().SMS_WaitUntilNextSend, Delay));
			Return;
		EndIf;
	EndIf;
	
	RNG = New RandomNumberGenerator();
	SendedSMSCode = RNG.RandomNumber(1000, 9999);
	SendSMS = SMSServer.SendSMSParams();
	SendSMS.Text = Format(SendedSMSCode, "NGS=-; NG=2,0;");
	SendSMS.PredefinedText = PredefinedText;
	SendSMS.PhoneList.Add(PhoneNumber);
	Result = SMSServer.SMS(SendSMS, "SendSMS", IntegrationSettings); // See SMSServer.SendSMSResult
	If Not Result.Success Then
		//@skip-check property-return-type
		CommonFunctionsClientServer.ShowUsersMessage(R().SMS_SendIsError);
	EndIf;
	
	SendedDate = CurrentSessionDate();
EndProcedure

&AtServer
Function GetTimeOut()
	Return 10;
EndFunction

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If IsBlankString(Parameters.PhoneNumber) Then
		PhoneNumber = Parameters.RetailCustomer.Code;
	Else
		PhoneNumber = Parameters.PhoneNumber;
	EndIf;
	If IsBlankString(Parameters.PredefinedText) Then
		PredefinedText = "TextOnApproveAction";
	Else
		PredefinedText = Parameters.PredefinedText;
	EndIf;
	 
	IntegrationSettings = Parameters.IntegrationSettings;
	
	If IntegrationSettings.IsEmpty() Then
		IntegrationSettings = Constants.DefaultSMSProvider.Get();
	EndIf;
	
	If Parameters.SendOnOpen And Not IntegrationSettings.IsEmpty() Then
		RetryToSendAtServer();
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If IntegrationSettings.IsEmpty() Then
		ExecuteNotifyProcessing(OnCloseNotifyDescription, CloseOK());
	EndIf;
EndProcedure

&AtClient
Procedure CodeOnChange(Item)
	If SendedSMSCode > 0 And Code = SendedSMSCode Then
		CloseOK();
	Else
		CommonFunctionsClientServer.ShowUsersMessage(R().SMS_SMSCodeWrong);
	EndIf;
EndProcedure

&AtClient
Function CloseOK()
	Str = New Structure;
	Str.Insert("Success", True);
	Close(Str);
	Return Str;
EndFunction
